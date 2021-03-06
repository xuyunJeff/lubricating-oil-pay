package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.common.utils.GsonUtil;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.biz.dao.BalanceProcurementMapper;
import com.bottle.pay.modules.biz.entity.BalanceProcurementEntity;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Service("balanceProcurementService")
@Slf4j
public class BalanceProcurementService extends BottleBaseService<BalanceProcurementMapper, BalanceProcurementEntity> {

    @Autowired
    private BankCardService bankCardService;

    private static final String LOCK_KEY = "proc";

    /**
     * 余额调度
     * 专员只能调度自己的银行卡
     * 机构管理员 可以调度 机构下所有专员银行卡
     * 冻结的卡不能参与调度
     * <p>
     * 1读取出款前的额度，减少出款卡额度，读取出款后的额度
     * 2读取入款前的额度，增加入款卡额度，读取入款后的额度
     * 3设置属性，插入余额调度记录
     */
    @Transactional
    public R balanceProcure(BalanceProcurementEntity procurement) {
        if(procurement.getOutBankCardNo().equals(procurement.getInBankCardNo())){
            throw new RRException("调度卡不能是同一张卡");
        }
        if(procurement.getPrice().compareTo(BigDecimal.ZERO)<=0){
            throw new RRException("调度金额不能小于0");
        }
        SysUserEntity user = super.getCurrentUser();
        BankCardEntity outBankCard = null;
        BankCardEntity inBankCard = null;
        RedisLock redisLock = new RedisLock(stringRedisTemplate, LOCK_KEY + user.getUserId());
        if (redisLock.lock()) {
            try {
                if (super.isOrgAdmin()) {
                    BankCardEntity query = new BankCardEntity();
                    query.setBusinessId(procurement.getOutBusinessId());
                    query.setBankCardNo(procurement.getOutBankCardNo());
//                    query.setOrgId(user.getOrgId());
                    outBankCard = bankCardService.selectOne(query);
                    if (outBankCard == null || outBankCard.getCardStatus() == 2 || !user.getOrgId().equals(outBankCard.getOrgId())) {
                        log.warn("出款专员:{}出款卡:{}没找到或者冻结了或者不不属于当前机构:{}", procurement.getOutBusinessId(), procurement.getOutBankCardNo(), user.getOrgId());
                        throw new RRException("出款卡没找到或者冻结了或者不不属于当前机构");
                    }
                    if (outBankCard.getBalance().compareTo(procurement.getPrice()) < 0) {
                        log.warn("专员:{}出款卡:{}余额:{}小于调度金额{}", outBankCard.getBusinessId(), outBankCard.getBankCardNo(), outBankCard.getBalance(), procurement.getPrice());
                        throw new RRException("专员出款卡余额小于调度金额");
                    }

                    query = new BankCardEntity();
                    query.setBankCardNo(procurement.getInBankCardNo());
                    query.setBusinessId(procurement.getInBusinessId());
//                    query.setOrgId(user.getOrgId());
                    inBankCard = bankCardService.selectOne(query);
                    if (inBankCard == null || inBankCard.getCardStatus() == 2 || !user.getOrgId().equals(inBankCard.getOrgId())) {
                        log.warn("入款专员:{}入款卡:{}没找到或者冻结了或者不不属于当前机构:{}", procurement.getInBusinessId(), procurement.getInBankCardNo(), user.getOrgId());
                        throw new RRException("入款卡没找到或者冻结了或者不不属于当前机构");
                    }
                } else {
                    //不是超级管理员时，只能是专员内部银行卡
                    if(!procurement.getOutBusinessId().equals(procurement.getInBusinessId()) ){
                        throw new RRException("不是管理员，只能自己内部转账!");
                    }
                    //普通的出款专员
                    List<BankCardEntity> list = bankCardService.getCardListByBusinessId(procurement.getOutBusinessId());
                    if (list == null || list.isEmpty()) {
                        log.warn("专员:{}调度失败，没有找到银行卡", user.getUserId());
                        throw new RRException("专员余额调度失败，没有找到银行卡");
                    }
                    outBankCard = list.stream()
                            .filter(bc -> bc.getBankCardNo().equals(procurement.getOutBankCardNo()))
                            .findFirst().get();
                    if(outBankCard == null){
                        throw new RRException("专员出款卡没找到");
                    }
                    log.info("专员调度出款卡:{}", GsonUtil.GsonString(outBankCard));
                    if(outBankCard.getCardStatus() == 2){
                        throw new RRException("出款卡被冻结不能调度");
                    }
                    if (outBankCard.getBalance().compareTo(procurement.getPrice()) < 0) {
                        log.warn("专员:{}出款卡:{}余额:{}小于调度金额{}", outBankCard.getBusinessId(), outBankCard.getBankCardNo(), outBankCard.getBalance(), procurement.getPrice());
                        throw new RRException("专员出款卡余额小于调度金额");
                    }

                    inBankCard = list.stream()
                            .filter(bc -> bc.getBankCardNo().equals(procurement.getInBankCardNo()))
                            .findFirst().get();
                    if(inBankCard == null){
                        throw new RRException("专员入款卡没找到");
                    }
                    if(inBankCard.getCardStatus() == 2){
                        throw new RRException("入款卡被冻结不能调度");
                    }
                    log.info("专员调度入款卡:{}", GsonUtil.GsonString(inBankCard));
                }

                //开始出款
                BigDecimal outBefore = outBankCard.getBalance();
                boolean result = bankCardService.minusBalance(outBankCard.getBusinessId(), outBankCard.getBankCardNo(), procurement.getPrice());
                if (!result) {
                    log.warn("调度出款失败");
                    throw new RRException("调度出款失败");
                }
                BankCardEntity query = new BankCardEntity();
                query.setId(outBankCard.getId());
                outBankCard = bankCardService.selectOne(query);
                BigDecimal outAfter = outBankCard.getBalance();

                //开始入款
                BigDecimal inBefore = inBankCard.getBalance();
                result = bankCardService.addBalance(inBankCard.getBusinessId(), inBankCard.getBankCardNo(), procurement.getPrice());
                if (!result) {
                    log.warn("调度入款失败");
                    throw new RRException("调度入款失败");
                }
                query.setId(inBankCard.getId());
                inBankCard = bankCardService.selectOne(query);
                BigDecimal inAfter = inBankCard.getBalance();

                //添加调度记录
                Date date = new Date();
                procurement.setCreateTime(date);
                procurement.setLastUpdate(date);
                procurement.setOutBusinessId(outBankCard.getBusinessId());
                procurement.setOutBusinessName(outBankCard.getBusinessName());
                procurement.setInBusinessName(inBankCard.getBusinessName());
                procurement.setInBusinessId(inBankCard.getBusinessId());
                procurement.setInBankCardNo(inBankCard.getBankCardNo());
                procurement.setInBankName(inBankCard.getBankName());
                procurement.setOutBankCardNo(outBankCard.getBankCardNo());
                procurement.setOutBankName(outBankCard.getBankName());
                procurement.setInBeforeBalance(inBefore);
                procurement.setOutBeforeBalance(outBefore);
                procurement.setInAfterBalance(inAfter);
                procurement.setOutAfterBalance(outAfter);
                procurement.setOrgId(user.getOrgId());
                procurement.setOrgName(user.getOrgName());
                mapper.save(procurement);
                log.info("专员:{}-{}资金调度成功:{},\n" +
                                "出款卡:{}，出款前余额:{}，出款后余额:{}，" +
                                "入款卡:{}，入款前余额:{}，入款后余额:{}",
                        user.getUserId(), WebUtils.getIpAddr(), procurement.getPrice(),
                        outBankCard.getBankCardNo(), outBefore, outAfter,
                        inBankCard.getBankCardNo(), inBefore, inAfter
                );
                return CommonUtils.msg(1);
            } catch (Exception e) {
                log.error("余额调度异常" + e.getMessage());
                throw e;
            } finally {
                redisLock.unLock();
            }
        }
        throw new RRException("余额调度异常，请稍后在操作");
    }


    /**
     * 查询资金调度记录
     *
     * @return
     */
    public Page<BalanceProcurementEntity> getProcureList(Map<String, Object> params) {
        /**
         * 普通专员只能查询自己调度记录
         * 机构管理员 查询当前机构下所有调度记录
         *
         *  专员查询时  查询自己出款 同时也查询自己的入款记录
         *
         *  时间倒序排序
         *
         * 分页显示
         */
        SysUserEntity userEntity = super.getCurrentUser();
        int pageNo = Integer.valueOf(params.get("pageNumber").toString());
        int pageSize = Integer.valueOf(params.get("pageSize").toString());
        Page<BalanceProcurementEntity> page = new Page<>(pageNo, pageSize);
        params.put("offSet", page.getOffset());
        params.put("orgId", userEntity.getOrgId());
        params.put("businessId", userEntity.getUserId());
        if (super.isOrgAdmin()) {
            params.put("businessId", null);
        }
        try {
            int count = mapper.selectCountPage(params);
            page.setTotal(count);
            if(count != 0) {
                List<BalanceProcurementEntity> list = mapper.selectPage(params);
                page.setRows(list);
            }else {
                page.setRows(Collections.emptyList());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return page;
    }
}

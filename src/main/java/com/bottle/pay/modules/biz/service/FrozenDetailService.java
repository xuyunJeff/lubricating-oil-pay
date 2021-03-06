package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.biz.dao.BankCardMapper;
import com.bottle.pay.modules.biz.dao.FrozenDetailMapper;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import com.bottle.pay.modules.biz.entity.FrozenDetailEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@Service("frozenDetailService")
@Slf4j
public class FrozenDetailService extends BottleBaseService<FrozenDetailMapper, FrozenDetailEntity> {

    @Autowired
    private BalanceMapper balanceMapper;
    @Autowired
    private BankCardMapper bankCardMapper;

    private static final String ADD_LOCK_KEY = "frozen:add";

    private static final String EDIT_LOCK_KEY = "frozen:edit";

    /**
     * 分页查询商户冻结记录
     *
     * @param params
     * @return
     */
    public Page<FrozenDetailEntity> pageList(Map<String, Object> params) {
        SysUserEntity sysUserEntity = super.getCurrentUser();
        if ( !(super.isOrgAdmin() || sysUserEntity.getRoleId() .equals(SystemConstant.RoleEnum.BillOutMerchant.getCode()))) {
            log.warn("userId:{}-{}不是机构管理无法查看机构商户冻结记录", ShiroUtils.getUserId(), WebUtils.getIpAddr());
            throw new RRException("不是机构管理或商户无法查看机构商户冻结记录");
        }

        int pageNo = Integer.valueOf(params.get("pageNumber").toString());
        int pageSize = Integer.valueOf(params.get("pageSize").toString());
        Page<FrozenDetailEntity> page = new Page<>(pageNo, pageSize);
        params.put("offSet", page.getOffset());
        params.put("orgId", sysUserEntity.getOrgId());
        if(sysUserEntity.getRoleId() .equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            params.put("merchantId", sysUserEntity.getUserId());
        }
        try {
            int count = mapper.selectCountForPage(params);
            List<FrozenDetailEntity> list = mapper.selectPage(params);
            page.setTotal(count);
            page.setRows(list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return page;
    }

    /**
     * 商户解冻
     *
     * @param id
     * @param unFrozen
     * @return
     */
    @Transactional
    public R unFrozenMerchant(Long id, BigDecimal unFrozen) {
        if(id == null || unFrozen == null||BigDecimal.ZERO.compareTo(unFrozen)>0 ){
            throw new RRException("id 和 解冻金额都不能为空");
        }
        FrozenDetailEntity frozenDetailEntity = mapper.getObjectById(id);

        if (frozenDetailEntity == null || frozenDetailEntity.getBalanceFrozen().compareTo(unFrozen) < 0) {
            log.warn("解冻记录:{}没找到或者解冻金额:{}大于冻结金额", id, unFrozen);
            throw new RRException("没有找到对应的冻结记录或者 解冻金额大于冻结金额");
        }
        BigDecimal total = unFrozen.add(Optional.ofNullable(frozenDetailEntity.getBalanceUnfrozen()).orElse(BigDecimal.ZERO));
        if(total.compareTo(frozenDetailEntity.getBalanceFrozen())>0){
            log.warn("解冻记录:冻结金额:{},已解冻金额:{},带解冻:{}",id,frozenDetailEntity.getBalanceFrozen(),frozenDetailEntity.getBalanceUnfrozen(),unFrozen);
            throw new RRException("解冻金额不能大于冻结金额");
        }
        if (!isOrgAdmin(frozenDetailEntity.getOrgId())) {
            log.warn("当前用户:{}-{}不是机构管理员不能解冻商户", ShiroUtils.getUserId(), WebUtils.getIpAddr());
            throw new RRException("不是机构管理员不能解冻商户");
        }
        RedisLock redisLock = new RedisLock(stringRedisTemplate,EDIT_LOCK_KEY + id);
        if(redisLock.lock()){
            try {
                //更新冻结记录解冻金额
                FrozenDetailEntity unFrozenEntity = new FrozenDetailEntity();
                unFrozenEntity.setId(id);
                unFrozenEntity.setBalanceUnfrozen(unFrozen);
                int num = mapper.unFrozenMoney(unFrozenEntity);
                log.info("管理员:{}-{}解冻商户:{},银行卡:{}金额:{},结果:{}", ShiroUtils.getUserId(), WebUtils.getIpAddr(),
                        frozenDetailEntity.getMerchantId(), frozenDetailEntity.getBankCardNo(), unFrozen,num>0);
                //更新商户余额表 可用金额 和 冻结金额
                num = balanceMapper.unFrozenMerchant(frozenDetailEntity.getMerchantId(), unFrozen);
                log.info("冻结商户:{},扣掉可用余额,增加冻结余额:{},执行结果:{}", frozenDetailEntity.getMerchantId(), unFrozen, num > 0);
                //判断冻结余额是否为0，为0则解冻专员银行卡
                frozenDetailEntity = mapper.getObjectById(id);
                if (frozenDetailEntity.getBalanceFrozen().compareTo(frozenDetailEntity.getBalanceUnfrozen()) == 0) {
                    BankCardEntity bankCardEntity = new BankCardEntity();
                    bankCardEntity.setBusinessId(frozenDetailEntity.getBusinessId());
                    bankCardEntity.setBankCardNo(frozenDetailEntity.getBankCardNo());
                    bankCardEntity.setCardStatus(1);
                    bankCardEntity.setLastUpdate(new Date());
                    num = bankCardMapper.updateCardStatus(bankCardEntity);
                    log.info("解冻专员:{}银行卡{} 结果:{}", frozenDetailEntity.getBusinessId(), frozenDetailEntity.getBankCardNo(), num > 0);
                }
                return CommonUtils.msg(num);
            }catch (Exception e){
                e.printStackTrace();
                log.warn("解冻金额时异常"+e.getMessage());
            }finally {
                redisLock.unLock();
            }
        }
       throw new RRException("服务繁忙，稍后再试");

    }

    /**
     * 商户冻结
     *
     * @return
     */
    @Transactional
    public R frozenMerchant(FrozenDetailEntity frozenDetail) {
        /**
         * 机构管理员才能冻结商户
         * 同时扣商户可用余额，增加商户冻结余额
         * 冻结业务员的银行卡
         * 账户余额可以为负，当为负余额时 机构可以垫钱 通过商户走充值流程但是不进行实际转账
         *
         */

        if (frozenDetail.getBalanceFrozen().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RRException("冻结金额大于0");
        }
        SysUserEntity merchant = super.getUserById(frozenDetail.getMerchantId());
        if (merchant == null || !SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(merchant.getRoleId())) {
            log.warn("商户:{}信息不存在或者不是商户", frozenDetail.getMerchantId());
            throw new RRException("商户信息不存在或者不是商户");
        }
        if (!super.isOrgAdmin(merchant.getOrgId())) {
            log.warn("当前用户:{}-{}不是机构管理员不能冻结商户", ShiroUtils.getUserId(), WebUtils.getIpAddr());
            throw new RRException("不是机构管理员不能冻结商户");
        }
        BankCardEntity query = new BankCardEntity();
        query.setBankCardNo(frozenDetail.getBankCardNo());
        query.setBusinessId(frozenDetail.getBusinessId());
        BankCardEntity inBankCard = bankCardMapper.selectOne(query);
        if(inBankCard == null || inBankCard.getCardStatus() == 2 || inBankCard.getOrgId() != merchant.getOrgId()){
            log.warn("商户:{}-{}-{},冻结的银行卡不存在或者是已冻结或者是不属于当前商户机构",merchant.getUserId(),merchant.getOrgId(),inBankCard.getBankCardNo());
            throw new RRException("冻结的银行卡不存在或者是已冻结或者是不属于当前商户机构");
        }
        RedisLock redisLock = new RedisLock(stringRedisTemplate, ADD_LOCK_KEY + inBankCard.getBankCardNo());
        if(redisLock.lock()){
            try {
                frozenDetail.setMerchantName(merchant.getUsername());
                frozenDetail.setBusinessName(inBankCard.getBusinessName());
                frozenDetail.setBusinessId(inBankCard.getBusinessId());
                frozenDetail.setBalanceUnfrozen(null);
                frozenDetail.setBankAccountName(inBankCard.getBankAccountName());
                frozenDetail.setBankName(inBankCard.getBankName());
                frozenDetail.setOrgId(merchant.getOrgId());
                frozenDetail.setOrgName(merchant.getOrgName());
                frozenDetail.setBalanceUnfrozen(BigDecimal.ZERO);
                frozenDetail.setCreateTime(new Date());
                frozenDetail.setLastUpdate(frozenDetail.getCreateTime());
                frozenDetail.setId(null);
                mapper.save(frozenDetail);
                log.info("管理员:{}-{}冻结{}:{}记录成功", ShiroUtils.getUserId(), WebUtils.getIpAddr(), frozenDetail.getBankCardNo(), frozenDetail.getBalanceFrozen());
                int num = balanceMapper.frozenMerchant(frozenDetail.getMerchantId(), frozenDetail.getBalanceFrozen());
                log.info("冻结商户:{},扣掉可用余额,增加冻结余额:{},执行结果:{}", frozenDetail.getMerchantId(), frozenDetail.getBalanceFrozen(), num > 0);
                //冻结专员的银行卡
                BankCardEntity bankCardEntity = new BankCardEntity();
                bankCardEntity.setBusinessId(frozenDetail.getBusinessId());
                bankCardEntity.setBankCardNo(frozenDetail.getBankCardNo());
                bankCardEntity.setCardStatus(2);
                bankCardEntity.setLastUpdate(new Date());
                num = bankCardMapper.updateCardStatus(bankCardEntity);
                log.info("冻结专员:{}银行卡{} 结果:{}", frozenDetail.getBusinessId(), frozenDetail.getBankCardNo(), num > 0);
                return CommonUtils.msg(num);
            }catch (Exception e){
                e.printStackTrace();
                log.warn("添加冻结记录异常"+e.getMessage());
            }finally {
                redisLock.unLock();
            }
        }
        throw new RRException("服务繁忙，请稍后再试！");
    }

}

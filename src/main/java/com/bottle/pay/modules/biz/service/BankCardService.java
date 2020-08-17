package com.bottle.pay.modules.biz.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.api.service.BalanceService;
import com.bottle.pay.modules.api.service.OnlineBusinessService;
import com.bottle.pay.modules.biz.dao.BankCardMapper;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.sys.dao.SysRoleMapper;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

@Service("bankCardService")
@Slf4j
public class BankCardService extends BottleBaseService<BankCardMapper, BankCardEntity> {

    @Autowired
    private SysUserMapper sysUserMapper;


    @Autowired
    private BalanceMapper balanceMapper;

    @Autowired
    private BalanceService balanceService;

    @Value("${merchant.billOutLimit:50000}")
    private BigDecimal billOutLimit;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private OnlineBusinessService onlineBusinessService;

    @Autowired
    private SysRoleMapper sysRoleMapper;

    /**
     * 根据专员Id获取对应银行卡列表
     *
     * @param userId
     * @return
     */
    public List<BankCardEntity> getCardListByBusinessId(Long userId) {
        BankCardEntity query = new BankCardEntity();
        query.setBusinessId(userId);
        return mapper.select(query);
    }


    /**
     * 获取专员当前启用的银行卡
     *
     * @param userId
     * @return
     */
    public BankCardEntity getCardOpenedListByBusinessId(Long userId) {
        BankCardEntity query = new BankCardEntity();
        query.setBusinessId(userId);
        List<BankCardEntity> bankCardEntities = mapper.select(query);
        Optional<BankCardEntity> cardEnable = bankCardEntities.stream().filter(it -> it.getEnable() == Boolean.TRUE).findFirst();
        if (cardEnable.isPresent()) return cardEnable.get();
        return null;
    }

    /**
     * 启用指定银行卡，则禁用其他银行卡
     *
     * @param userId
     * @param cardNo
     * @return
     */
    @Transactional
    public R enableCardByUserIdAndCardNo(Long userId, String cardNo) {
        log.info("启用银行卡，专员:{},银行卡:{}", userId, cardNo);
        if (userId == null || StringUtils.isEmpty(cardNo)) {
            return CommonUtils.msg(null);
        }
        BankCardEntity query = new BankCardEntity();
        query.setBusinessId(userId);
        query.setBankCardNo(cardNo);
        BankCardEntity entity = mapper.selectOne(query);
        if (entity == null) {
            log.warn("专员:{},银行卡:{} 没找到", userId, cardNo);
            return CommonUtils.msg(null);
        }
        if (entity.getCardStatus() == 2) {
            log.warn("专员:{},银行卡:{} 被冻结不能启用", userId, cardNo);
            return CommonUtils.msg("被冻结不能启用");
        }
        Date date = new Date();
        int num = 0;
        if (!entity.getEnable()) {
            entity.setEnable(Boolean.TRUE);
            entity.setLastUpdate(date);
            num = mapper.update(entity);
        }
        if (num > 0 || entity.getEnable()) {
            log.info("启用专员:{}银行卡:{}成功", userId, cardNo);
            //禁用其它卡
            List<BankCardEntity> list = getCardListByBusinessId(userId);
            list.stream()
                    .filter(c -> (!cardNo.equals(c.getBankCardNo())) && c.getEnable())
                    .forEach(c -> {
                        c.setEnable(false);
                        c.setLastUpdate(date);
                        int count = mapper.update(c);
                        log.info("禁用专员:{},银行卡:{},结果:{}", userId, c.getBankCardNo(), count > 0);
                    });
            //该专员上线
            onlineBusinessService.online(userId);
            return CommonUtils.msg(1);
        }
        log.warn("启用银行卡，专员:{},银行卡:{}失败", userId, cardNo);
        return CommonUtils.msg(0);

    }


    /**
     * 禁用指定专员的具体银行卡，如果没有启用银行卡则专员下线
     *
     * @param userId
     * @param cardNo
     * @return
     */
    @Transactional
    public R disableCardByUserIdAndCardNo(Long userId, String cardNo) {
        log.info("禁用银行卡，专员:{},银行卡:{}", userId, cardNo);
        BankCardEntity query = new BankCardEntity();
        query.setBusinessId(userId);
        query.setBankCardNo(cardNo);
        BankCardEntity entity = mapper.selectOne(query);
        if (entity == null) {
            log.warn("专员:{},银行卡:{} 没找到", userId, cardNo);
            return CommonUtils.msg(null);
        }
        Date date = new Date();
        int num = 0;
        if (entity.getEnable()) {
            entity.setEnable(Boolean.FALSE);
            entity.setLastUpdate(date);
            num = mapper.update(entity);
        }
        if (num > 0 || !entity.getEnable()) {
            log.info("禁用专员:{}银行卡:{}成功", userId, cardNo);
            List<BankCardEntity> list = getCardListByBusinessId(userId);
            boolean disabled = list.stream().allMatch(c -> !c.getEnable());
            //该专员下线
            if (disabled) {
                log.info("专员:{}所有银行卡都被禁用开始下线", userId);
                onlineBusinessService.offline(userId);
            }
            return CommonUtils.msg(1);
        }
        log.warn("禁用银行卡，专员:{},银行卡:{}失败", userId, cardNo);
        return CommonUtils.msg(0);
    }

    /**
     * 专员添加银行卡
     *
     * @param entity
     * @return
     */
    @Transactional
    public R bindCard(BankCardEntity entity) {
        //判断是否绑定过
        existBankCard(entity);
        int num = 0;
        RedisLock redisLock = new RedisLock(stringRedisTemplate, "card" + entity.getBusinessId());
        if (redisLock.lock()) {
            try {
                //查询有没有开通余额账户
                BalanceEntity balanceQuery = new BalanceEntity();
                balanceQuery.setUserId(entity.getBusinessId());
                BalanceEntity balanceEntity = balanceService.selectOne(balanceQuery);
                if (balanceEntity == null) {
                    balanceEntity = balanceService.createBalanceAccount(entity.getBusinessId());
                }
                long orgId = balanceEntity.getOrgId();
                entity.setOrgId(orgId);
                entity.setOrgName(balanceEntity.getOrgName());
                entity.setBalance(Optional.ofNullable(entity.getBalance()).orElse(BigDecimal.ZERO));
                entity.setCardStatus(Optional.ofNullable(entity.getCardStatus()).orElse(0));
                entity.setEnable(false);
                entity.setCreateTime(new Date());
                entity.setLastUpdate(entity.getCreateTime());
                num = mapper.save(entity);
                log.info("userId:{}绑定银行卡:{},结果:{}", entity.getBusinessId(), entity.getBankCardNo(),num>0);
                if (num > 0 && entity.getBalance().compareTo(BigDecimal.ZERO) > 0) {
                    log.info("userId:{}绑定银行卡成功开始更新对应余额:{}",entity.getBusinessId(),entity.getBalance());
                    BalanceEntity update = new BalanceEntity();
                    update.setUserId(entity.getBusinessId());
                    update.setId(balanceEntity.getId());
                    update.setLastUpdate(new Date());
                    //增加账户可用余额 或者 冻结余额
                    BigDecimal balance = null;
                    BigDecimal frozen = null;
                    if (entity.getCardStatus() == 1) {
                        //可用余额
                        balance = entity.getBalance();
                    } else {
                        //冻结余额
                        frozen = entity.getBalance();
                    }
                    boolean count = balanceService.updateBalance(balanceEntity.getId(), balanceEntity.getUserId(), balance, frozen, null);
                    log.info("userId:{}绑定银行卡成功更新对应余额:{}结果:{}",entity.getBusinessId(),entity.getBalance(),count);
                }
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("businessId:{},card:{}绑定银行卡异常,{}", entity.getBusinessId(), entity.getBankCardNo(), e.getMessage());
            } finally {
                redisLock.unLock();
            }
        }
        return CommonUtils.msg(num);
    }

    private void existBankCard(BankCardEntity entity) {
        BankCardEntity query = new BankCardEntity();
        query.setBankCardNo(entity.getBankCardNo());
        query.setBusinessId(entity.getBusinessId());
        query.setOrgId(entity.getOrgId());
        BankCardEntity queryEntity = mapper.selectOne(query);
        if (queryEntity != null) {
            log.warn("机构:{}专员:{}-{},已绑定银行卡:{}",
                    entity.orgId, entity.getBusinessId(), entity.getBusinessName(), entity.getBankCardNo());
            throw new RRException("专员:" + queryEntity.getBusinessName() + "已绑定过该银行卡" + entity.getBankCardNo());
        }
    }


    /**
     * 获取指定专员所有银行卡余额包含冻结余额
     *
     * @param userId
     * @return
     */
    public BigDecimal getAllCardsBalance(Long userId) {
        BigDecimal sum = BigDecimal.ZERO;
        List<BankCardEntity> cardList = getCardListByBusinessId(userId);
        if (cardList != null) {
            for (BankCardEntity bc : cardList) {
                sum = sum.add(bc.getBalance());
            }
        }
        return sum;
    }

    /**
     * 获取指定专员所有银行卡余额包不含冻结余额
     *
     * @return
     */
    public BigDecimal getAllCardsBalanceWithoutFrozen(Long userId) {
        BigDecimal sum = BigDecimal.ZERO;
        List<BankCardEntity> list = getCardListByBusinessId(userId);
        if (list != null) {
            for (BankCardEntity bc : list) {
                if (bc.getCardStatus() == 1) {
                    // 启用
                    sum = sum.add(bc.getBalance());
                }
            }
        }
        return sum;
    }

    /**
     * 批量删除银行卡
     * @param ids
     * @return
     */
    public R removeBankCard(Long[] ids){
        /**
         * 机构管理员 和 本人权限
         * 银行卡状态  可用
         * 银行卡余额 0
         * 银行卡没有启用
         */
        List<BankCardEntity> cardList = mapper.batchSelect(ids);
        if(cardList == null || cardList.isEmpty()){
            return CommonUtils.msg("删除失败-未找到银行卡");
        }
        cardList = cardList.stream().filter(c->c.getCardStatus()==1
                && c.getBalance().compareTo(BigDecimal.ZERO)==0
                && !c.getEnable()
        ).collect(Collectors.toList());
        if(cardList.isEmpty()){
            log.warn("userId:{},ip:{}删除失败-非冻结没有启用且余额为0才能删除",ShiroUtils.getUserId(), WebUtils.getIpAddr());
            return CommonUtils.msg("删除失败-非冻结没有启用且余额为0才能删除");
        }
        List<Long> idList = null;
        //判断是机构管理员
        Long roleId = ShiroUtils.getUserEntity().getRoleId();
        if(super.isOrgAdmin()){
            //银行卡是当前机构的
            idList = cardList.stream()
                    .filter(cd->cd.getOrgId().equals(ShiroUtils.getUserEntity().getOrgId()))
                    .map(cd->cd.getId()).collect(Collectors.toList());
        }else {
            //拿到当前用户所有银行卡
            idList = cardList.stream()
                    .filter(cd->cd.getBusinessId().equals(ShiroUtils.getUserId()))
                    .map(cd->cd.getId()).collect(Collectors.toList());
        }
        int num = 0;
        if(idList != null && !idList.isEmpty()){
            log.info("用户:{},角色:{},机构:{} 删除银行卡:{}",
                    ShiroUtils.getUserId(),ShiroUtils.getUserEntity().getRoleId(),ShiroUtils.getUserEntity().getOrgId(),idList);
            Long[] dd = idList.stream().toArray(Long[]::new);
            num = mapper.batchRemove(dd);
        }
        return CommonUtils.msg(num);
    }

    /**
     * 余额调度是 增加当前余额
     * @return
     */
    public boolean addBalance(Long userId,String bankCard,BigDecimal balance){
        BankCardEntity bankCardEntity = new BankCardEntity();
        bankCardEntity.setBusinessId(userId);
        bankCardEntity.setBankCardNo(bankCard);
        bankCardEntity.setBalance(balance);
        bankCardEntity.setLastUpdate(new Date());
        boolean result = mapper.addBalance(bankCardEntity)>0;
        log.info("专员:{},银行卡:{},增加的金额:{},结果:{}",userId,balance,balance,result);
        return result;
    }
    /**
     * 余额调度是 增加当前余额
     * @return
     */
    public boolean minusBalance(Long userId,String bankCard,BigDecimal balance){
        BankCardEntity bankCardEntity = new BankCardEntity();
        bankCardEntity.setBusinessId(userId);
        bankCardEntity.setBankCardNo(bankCard);
        bankCardEntity.setBalance(balance);
        bankCardEntity.setLastUpdate(new Date());
        boolean result = mapper.minusBalance(bankCardEntity)>0;
        log.info("专员:{},银行卡:{},增加的金额:{},结果:{}",userId,balance,balance,result);
        return result;
    }
}

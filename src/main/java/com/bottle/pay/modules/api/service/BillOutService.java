package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.modules.api.dao.BillOutMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Map;


@Service("billOutService")
@Slf4j
public class BillOutService extends BottleBaseService<BillOutMapper, BillOutEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;

    @Autowired
    private BalanceService balanceService;

    @Autowired
    private OnlineBusinessService onlineBusinessService;

    @Autowired
    private BankCardService bankCardService;


    @Transactional
    public BillOutEntity billsOutAgent(BillOutView billOutView, String ip, SysUserEntity userEntity) {
        //第一步保存订单
        BillOutEntity bill = saveNewBillOut(billOutView.getMerchantName(), billOutView.getMerchantId(),
                billOutView.getOrderNo(), ip, userEntity.getOrgId(), userEntity.getOrgName(), billOutView.getPrice(),
                billOutView.getBankCardNo(), billOutView.getBankName(), billOutView.getBankAccountName());
        // TODO 去查询商户的发过来的订单是否存在？@mighty
        // 第二步 增加商户代付中余额，扣除商户可用余额
        billsOutBalanceChangeMerchant(billOutView.getMerchantId(), billOutView.getPrice());
        return bill;
    }

    @Async
    public BillOutEntity billsOutBusiness(BillOutEntity entity) {
        Map<OnlineBusinessEntity, BigDecimal> businessOnline = null;
        OnlineBusinessEntity onlineBusinessEntity ;
        BigDecimal free ;
        do {
            businessOnline = getBusinessFreeBalance(entity);
            free = businessOnline.values().stream().findFirst().get();
            onlineBusinessEntity = businessOnline.keySet().stream().findFirst().get();
        } while (free.subtract(entity.getPrice()).compareTo(BigDecimal.ZERO) == -1);
        // 第三步派单给出款员(事务)，付款银行卡默认为当前开启的银行卡
        entity =  updateBillOutToBusiness(entity,onlineBusinessEntity);
        // 第四步增加出款员代付中余额，扣除可用余额
        incrBusinessBillOutBalanceRedis(onlineBusinessEntity.getBusinessId(),entity.getPrice());
        return entity;
    }

    @Transactional
    public BillOutEntity  updateBillOutToBusiness(BillOutEntity entity,OnlineBusinessEntity onlineBusinessEntity) {
        entity.setPosition(BillConstant.BillPostionEnum.Business.getCode());
        entity.setBusinessName(onlineBusinessEntity.getBusinessName());
        entity.setBusinessId(onlineBusinessEntity.getBusinessId());
        // TODO 获取在线出款员的开启的银行卡 @mighty
        entity.setBusinessBankAccountName("@mighty");
        entity.setBusinessBankCardNo("8888888888888888888");
        entity.setBusinessBankName("中国人民银行");
        int i = mapper.updateBusinessByBillId(entity);
        if (i == 0) {
            log.error("订单保存错误 {}", entity.toString());
            throw new RRException("订单保存错误");
        }
        return entity;
    }
    /**
     * 获取在线出款员的空余余额和对应的在线出款员数据
     * @param entity
     * @return
     */
    public Map<OnlineBusinessEntity, BigDecimal> getBusinessFreeBalance(BillOutEntity entity) {
        // 第一步获取在线的出款员
        OnlineBusinessEntity businessOnline = onlineBusinessService.getNextBusiness(entity.getOrgId());
        // 第二步判断出款员余额是否够出款
        // TODO 获取出款员银行卡的所有可以余额之和 @mighty
        BigDecimal businessTotalBalance = BigDecimal.valueOf(10000);
        BigDecimal businessFreeBalance = getBusinessFreeBalance(businessTotalBalance, businessOnline);
        return Collections.singletonMap(businessOnline, businessFreeBalance);
    }

    /**
     *
     * 计算在线出款员的空余余额
     * @param businessTotalBalance
     * @param businessOnline
     * @return
     */
    private BigDecimal getBusinessFreeBalance(BigDecimal businessTotalBalance, OnlineBusinessEntity businessOnline) {
        BigDecimal businessPayingBalance = getBusinessBillOutBalance(businessOnline.getBusinessId());
        return businessTotalBalance.subtract(businessPayingBalance);
    }

    /**
     * 增加商户代付中余额，扣除商户可用余额
     *
     * @param merchantId
     * @param amount
     */
    @Transactional
    public BalanceEntity billsOutBalanceChangeMerchant(Long merchantId, BigDecimal amount) {
        // step 1: 扣商户可用余额，增加商户代付中余额
        return balanceService.billOutMerchantBalance(amount.multiply(new BigDecimal(-1)), merchantId);
    }


    /**
     * Redis 出款员代付中余额变动，返回变动后余额
     *
     * 传入金额后，增加redis中的出款员余额
     * @param businessId
     * @param amount     最小1，分为单位
     */
    public synchronized BigDecimal incrBusinessBillOutBalanceRedis(Long businessId, BigDecimal amount) {
        amount = amount.multiply(BigDecimal.valueOf(100));
        String redisKey = BillConstant.BillRedisKey.billOutBusinessBalance(businessId.toString());
        BigDecimal balanceBefore = getBusinessBillOutBalance(businessId);
        BigDecimal balanceAfter = BigDecimal.valueOf(redisCacheManager.incr(redisKey, Double.valueOf(amount.toString())));
        log.info("代付余额变动，变动前余额：" + balanceBefore + "分,变动后余额：" + balanceAfter + "分,变动金额：" + amount + "分");
        return balanceAfter.divide(BigDecimal.valueOf(100));
    }

    /**
     * 获取出款员代付中余额
     *
     * @param businessId
     * @return
     */
    public BigDecimal getBusinessBillOutBalance(Long businessId) {
        String redisKey = BillConstant.BillRedisKey.billOutBusinessBalance(businessId.toString());
        Object balance = redisCacheManager.get(redisKey);
        if (ObjectUtils.isEmpty(balance)) {
            BigDecimal businessPaying = mapper.sumByBusinessId(businessId);
            redisCacheManager.set(redisKey, businessPaying);
            return businessPaying;
        }
        return new BigDecimal(String.valueOf(balance));
    }

    /**
     *
     * 生成订单并保存到机构
     *
     * @param merchantName
     * @param merchantId
     * @param thirdBillId
     * @param ip
     * @param agentId
     * @param agentName
     * @param price
     * @param bankCardNo
     * @param bankName
     * @param bankAccountName
     * @return
     */
    public BillOutEntity saveNewBillOut(String merchantName, Long merchantId, String thirdBillId, String ip, Long agentId, String agentName, BigDecimal price, String bankCardNo, String bankName, String bankAccountName) {
        BillOutEntity entity = new BillOutEntity();
        entity.setMerchantName(merchantName);
        entity.setMerchantId(merchantId);
        entity.setBillId(generateBillOutBillId(String.valueOf(merchantId)));
        entity.setThirdBillId(thirdBillId);
        entity.setIp(ip);
        // 第三方服务器派单第一步派单给机构
        entity.setBusinessId(agentId);
        entity.setBusinessName(agentName);
        entity.setBillStatus(BillConstant.BillStatusEnum.UnPay.getCode());
        entity.setNotice(BillConstant.BillNoticeEnum.NotNotice.getCode());
        entity.setPrice(price);
        entity.setBankAccountName(bankCardNo);
        entity.setBankName(bankName);
        entity.setBankAccountName(bankAccountName);
        entity.setBillType(setBillType(price, merchantId).getCode());
        entity.setOrgId(agentId);
        entity.setOrgName(agentName);
        entity.setPosition(BillConstant.BillPostionEnum.Agent.getCode());
        int i = mapper.insert(entity);
        if (i == 0) {
            log.error("订单保存错误 {}", entity.toString());
            throw new RRException("订单保存错误");
        }
        return entity;
    }

    /**
     * 判断该订单是自动还是手动：大额？
     *
     * @param price
     * @param merchantId
     * @return
     */
    private BillConstant.BillTypeEnum setBillType(BigDecimal price, Long merchantId) {
        BalanceEntity balance = new BalanceEntity();
        balance.setUserId(merchantId);
        balance = balanceService.selectOne(balance);
        if (balance == null) {
            // FIXME 根据业务在适当的地方添加分布式锁
            balanceService.createBalanceAccount(merchantId);
        }
        BigDecimal billOutLimit = balance.getBillOutLimit();
        if (price.compareTo(billOutLimit) == -1) {
            return BillConstant.BillTypeEnum.Auto;
        }
        return BillConstant.BillTypeEnum.HighPrice;
    }



    /**
     * 生成代付id
     * 订单号：商户id+ yyyyMMDD + 自增
     * 最长20位
     *
     * @return
     */
    public String generateBillOutBillId(String merchantId) {
        String today = DateUtils.format(new Date(), DateUtils.DATE_PATTERN_1);
        String redisKey = BillConstant.BillRedisKey.billOutId(merchantId, today);
        long incrId = redisCacheManager.incr(redisKey, 1L, 24L);
        log.info("redis自增" + incrId);
        DecimalFormat df = new DecimalFormat("00000");//五位序列号
        return merchantId + today + df.format(incrId);
    }

}

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
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;


@Service("billOutService")
@Slf4j
public class BillOutService  extends BottleBaseService<BillOutMapper,BillOutEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;

    @Autowired
    BalanceService balanceService;


    @Transactional
    public BillOutEntity billsOutAgent(BillOutView billOutView, String ip, SysUserEntity userEntity){
        //第一步保存订单
        BillOutEntity bill = saveNewBillOut(billOutView.getMerchantName(),billOutView.getMerchantId(),
                billOutView.getOrderNo(),ip,userEntity.getOrgId(),userEntity.getOrgName(),billOutView.getPrice(),
                billOutView.getBankCardNo(),billOutView.getBankName(),billOutView.getBankAccountName());
        // TODO 去查询商户的发过来的订单是否存在？@mighty
        // 第二步 增加商户代付中余额，扣除商户可用余额
        billsOutBalanceChangeMerchant(billOutView.getMerchantId(),billOutView.getPrice());
        return bill;
    }

    public BillOutEntity billsOutBusiness(){
        // 第一步获取在线的出款员
        // 第二步判断出款员余额是否够出款
        // 第三步派单给出款员事务，付款银行卡默认为当前开启的银行卡
        // 第四步增加出款员代付中余额，扣除可用余额
        return  null;
    }

    /**
     * 增加代付中余额，扣除商户可用余额
     * @param merchantId
     * @param amount
     */
    @Transactional
    public BalanceEntity billsOutBalanceChangeMerchant(Long merchantId,BigDecimal amount){
        // step 1: 扣商户可用余额，增加商户代付中余额
        return balanceService.billOutMerchantBalance(amount.multiply(new BigDecimal(-1)),merchantId);
    }



    /**
     *  Redis 出款员代付中余额
     * @param userId
     * @param amount 最小1，分为单位
     */
    public synchronized void incrBusinessBillOutBalance(Long userId, BigDecimal amount){
        amount = amount.multiply(BigDecimal.valueOf(100));
        String redisKey = BillConstant.BillRedisKey.billOutBalance(userId.toString());
        BigDecimal balanceBefore = getUserBillOutBalance(userId);
        BigDecimal balanceAfter =BigDecimal.valueOf(redisCacheManager.incr(redisKey,Double.valueOf(amount.toString())));
        log.info("代付余额变动，变动前余额："+balanceBefore+"分,变动后余额："+balanceAfter+"分,变动金额："+amount+"分");
    }

    public BigDecimal getUserBillOutBalance(Long userId){
        String redisKey = BillConstant.BillRedisKey.billOutBalance(userId.toString());
        Object balance = redisCacheManager.get(redisKey);
        if(ObjectUtils.isEmpty(balance)){
            // TODO 要去数据库合计一下代付中订单
            return BigDecimal.ZERO;
        }
        return new BigDecimal(String.valueOf(balance));
    }

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
        entity.setBillType(setBillType(price,merchantId).getCode());
        entity.setAgentId(agentId);
        entity.setAgentName(agentName);
        entity.setPosition(BillConstant.BillPostionEnum.Agent.getCode());
         int i =  mapper.insert(entity);
         if(i == 0 ) {
             log.error("订单保存错误 {}",entity.toString());
             throw new RRException("订单保存错误");
         }
        return entity;
    }

    private BillConstant.BillTypeEnum setBillType(BigDecimal price,Long merchantId) {
        BalanceEntity balance = new BalanceEntity();
        balance.setUserId(merchantId);
        balance = balanceService.selectOne(balance);
        if(balance == null) {
            // TODO 创建balance账户 @Mighty
        }
        BigDecimal billOutLimit = balance.getBillOutLimit();
        if(price.compareTo(billOutLimit) == -1) {
            return BillConstant.BillTypeEnum.Auto ;
        }
        return BillConstant.BillTypeEnum.HighPrice ;
    }



    /**
     *  生成代付id
     *  订单号：商户id+ yyyyMMDD + 自增
     *  最长20位
     * @return
     */
    public String generateBillOutBillId(String merchantId){
        String today = DateUtils.format(new Date(),DateUtils.DATE_PATTERN_1);
        String redisKey = BillConstant.BillRedisKey.billOutId(merchantId,today);
        long incrId  =redisCacheManager.incr(redisKey,1L,24L);
        log.info("redis自增"+incrId);
        DecimalFormat df=new DecimalFormat("00000");//五位序列号
       return merchantId+ today+df.format(incrId);
    }

}

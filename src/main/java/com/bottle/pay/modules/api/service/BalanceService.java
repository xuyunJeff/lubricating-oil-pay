package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("balanceService")
 @Slf4j
public class BalanceService  extends BottleBaseService<BalanceMapper,BalanceEntity> {


 /**
  * 此处必须事务才能生效
  * @param amount
  * @param userId
  * @return
  */
  @Transactional
  public BalanceEntity billOutMerchantBalance(BigDecimal amount , Long userId) {
   BalanceEntity balance = new BalanceEntity();
   balance.setUserId(userId);
   synchronized (this){
    balance = mapper.selectForUpdate(balance);
    mapper.billoutBalanceMerchantChange(amount,balance.getId());
   }
   BalanceEntity balanceAfter= mapper.selectOne(balance);
   log.info("商户余额变动, userId :"+userId+"，amount:"+amount+"beforeBalance:" + balance.getBalance() +"afterBalance:"+balanceAfter.getBalance());
   return balanceAfter;
  }

}

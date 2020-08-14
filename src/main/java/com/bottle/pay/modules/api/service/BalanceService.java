package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.biz.view.MerchantView;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.math.BigDecimal;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("balanceService")
 @Slf4j
public class BalanceService  extends BottleBaseService<BalanceMapper,BalanceEntity> {

     @Autowired
     private SysUserMapper sysUserMapper;

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

 /**
  * 根据userId 查询余额
  * @param userId
  * @return
  */
  private BalanceEntity getBalanceByUserId(Long userId){
   BalanceEntity query = new BalanceEntity();
   query.setUserId(userId);
   return mapper.getObject(query);
  }

  public MerchantView getMerchantBalance(Long userId){
      SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
      Assert.notNull(userEntity,userId+"商户不存在");
      BalanceEntity entity = getBalanceByUserId(userId);
      Assert.notNull(entity,userId+"商户不存在");
      MerchantView view = new MerchantView();
      BeanUtils.copyProperties(entity,view);
      BeanUtils.copyProperties(userEntity,view);
      //TODO 产品类型 后端密钥  密码是加密后的？
      return  view;
  }

}

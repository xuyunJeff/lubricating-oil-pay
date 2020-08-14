package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.sys.dao.SysRoleMapper;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysRoleEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("balanceService")
 @Slf4j
public class BalanceService  extends BottleBaseService<BalanceMapper,BalanceEntity> {

  @Value("${merchant.billOutLimit.daily:50000}")
   private BigDecimal dailyOutLimit;
  @Autowired
  private SysRoleMapper sysRoleMapper;

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
     * 创建商户余额账户
     * @return
     */
  public BalanceEntity createMerchantBalanceAccount(Long userId){
      SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
      if(userEntity == null ){
         log.warn("userId:{} 在 user表里没有找到",userId);
         throw new RRException("创建商户余额账户失败");
      }
      long roleId = userEntity.getRoleIdList().get(0);
      SysRoleEntity sysRoleEntity = sysRoleMapper.getObjectById(roleId);
      if(sysRoleEntity == null){
        log.warn("userId:{}对应角色roleId:{}在角色表里没有找到",userId,roleId);
        throw new RRException("创建商户余额账户失败");
      }
      Date date = new Date();
      BalanceEntity entity = new BalanceEntity();
      entity.setUserName(userEntity.getUsername());
      entity.setUserId(userEntity.getUserId());
      entity.setBalance(BigDecimal.ZERO);
      entity.setBalanceFrozen(BigDecimal.ZERO);
      entity.setBalancePaying(BigDecimal.ZERO);
      entity.setRoleId(roleId);
      entity.setRoleName(sysRoleEntity.getRoleName());
      entity.setBillOutLimit(dailyOutLimit);
      entity.setCreateTime(date);
      entity.setLastUpdate(date);
      entity.setOrgId(userEntity.getOrgId());
      entity.setOrgName(userEntity.getOrgName());
      mapper.save(entity);
      return entity;
  }

}

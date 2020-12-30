package com.bottle.pay.modules.api.service;

import java.math.BigDecimal;
import java.util.Map;

import com.bottle.pay.modules.api.entity.BalanceEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import com.bottle.pay.common.service.BottleBaseService;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BalanceChangeLogEntity;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.utils.CommonUtils;
import lombok.extern.slf4j.Slf4j;
import com.bottle.pay.modules.api.dao.BalanceChangeLogMapper;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("balanceChangeLogService")
 @Slf4j
public class BalanceChangeLogService  extends BottleBaseService<BalanceChangeLogMapper,BalanceChangeLogEntity> {

  @Async
  public void saveBanlanceChangeLog(BalanceEntity balance, BigDecimal balanceAfter,BigDecimal amount,String billId,String message){
      mapper.save(new BalanceChangeLogEntity(balance.getUserName(),balance.getUserId(),balanceAfter,amount,balance.getOrgId(),balance.getOrgName(),balance.getRoleId(),balance.getRoleName(), balance.getBalance(),billId,message));
  }
	
}

package com.bottle.pay.modules.biz.service;
import java.math.BigDecimal;
import java.util.Date;

import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.dao.BankCardMapper;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.sys.dao.SysOrgMapper;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysOrgEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("bankCardService")
 @Slf4j
public class BankCardService  extends BottleBaseService<BankCardMapper,BankCardEntity> {

     @Autowired
     private SysUserMapper sysUserMapper;
     @Autowired
     private SysOrgMapper sysOrgMapper;
 /**
  * 专员添加银行卡
  * @param entity
  * @return
  */
 public R bindCard(BankCardEntity entity){
     SysUserEntity bizUser = sysUserMapper.getObjectById(entity.getBusinessId());
     if(bizUser == null){
         log.warn("绑定银行卡时没找到bizUser:{}专员",entity.getBusinessId());
         throw new RRException("未找到业务员信息");
     }
     entity.setBusinessName(bizUser.getUsername());
     long orgId = bizUser.getOrgId();
     SysOrgEntity orgEntity = sysOrgMapper.getObjectById(orgId);
     if(orgEntity == null){
         log.warn("绑定银行卡时没找到专员:{}对应机构:{}",entity.getBusinessId(),orgId);
         throw new RRException("未找到业务员的机构信息");
     }
     entity.setOrgId(orgId);
     entity.setOrgName(orgEntity.getName());
     entity.setBalance(new BigDecimal("0"));
     entity.setCardStatus(0);
     entity.setEnable(0);
     entity.setBalanceDailyLimit(new BigDecimal("0"));
     entity.setCreateTime(new Date());
     entity.setLastUpdate(entity.getCreateTime());
     int num = mapper.save(entity);
     log.info("绑定银行卡结果:{},信息:{}",num,entity);
     return CommonUtils.msg(num);
 }
}

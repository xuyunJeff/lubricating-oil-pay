package com.bottle.pay.modules.biz.service;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.bottle.pay.common.entity.Query;
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
import com.google.common.collect.Maps;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

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
     * 根据专员Id获取对应银行卡列表
     * @param userId
     * @return
     */
     public List<BankCardEntity> getCardListByBusinessId(Long userId){
         BankCardEntity query = new BankCardEntity();
         query.setBusinessId(userId);
         return mapper.select(query);
     }

    /**
     * 启用指定银行卡，则禁用其他银行卡
     * @param userId
     * @param cardNo
     * @return
     */
    @Transactional
     public R enableCardByUserIdAndCardNo(Long userId,String cardNo){
         log.info("启用银行卡，专员:{},银行卡:{}",userId,cardNo);
         if(userId == null || StringUtils.isEmpty(cardNo)){
             return CommonUtils.msg(null);
         }
         BankCardEntity query = new BankCardEntity();
         query.setBusinessId(userId);
         query.setBankCardNo(cardNo);
         BankCardEntity entity = mapper.selectOne(query);
         if(entity == null){
             log.warn("专员:{},银行卡:{} 没找到",userId,cardNo);
             return CommonUtils.msg(null);
         }
         if(entity.getCardStatus() == 2 ){
             log.warn("专员:{},银行卡:{} 被冻结不能启用",userId,cardNo);
             return CommonUtils.msg("被冻结不能启用");
         }
         Date  date = new Date();
         int num = 0;
         if(!entity.getEnable()){
             entity.setEnable(Boolean.TRUE);
             entity.setLastUpdate(date);
             num = mapper.update(entity);
         }
         if(num > 0 || entity.getEnable()){
             log.info("启用专员:{}银行卡:{}成功",userId,cardNo);
             //禁用其它卡
             List<BankCardEntity> list = getCardListByBusinessId(userId);
             list.stream()
                     .filter(c->(!cardNo.equals(c.getBankCardNo()))&& c.getEnable())
                     .forEach(c->{
                         c.setEnable(false);
                         c.setLastUpdate(date);
                         int count = mapper.update(c);
                         log.info("禁用专员:{},银行卡:{},结果:{}",userId,c.getBankCardNo(),count>0);
                     });
             //TODO 该专员上线
             return CommonUtils.msg(1);
         }
         log.warn("启用银行卡，专员:{},银行卡:{}失败",userId,cardNo);
         return CommonUtils.msg(0);

     }


    /**
     * 禁用指定专员的具体银行卡，如果没有启用银行卡则专员下线
     * @param userId
     * @param cardNo
     * @return
     */
    @Transactional
     public R disableCardByUserIdAndCardNo(Long userId,String cardNo){
         log.info("禁用银行卡，专员:{},银行卡:{}",userId,cardNo);
         BankCardEntity query = new BankCardEntity();
         query.setBusinessId(userId);
         query.setBankCardNo(cardNo);
         BankCardEntity entity = mapper.selectOne(query);
         if(entity == null){
             log.warn("专员:{},银行卡:{} 没找到",userId,cardNo);
             return CommonUtils.msg(null);
         }
         Date  date = new Date();
         int num = 0;
         if(entity.getEnable()){
             entity.setEnable(Boolean.FALSE);
             entity.setLastUpdate(date);
             num = mapper.update(entity);
         }
         if(num>0 || !entity.getEnable()){
             log.info("禁用专员:{}银行卡:{}成功",userId,cardNo);
             List<BankCardEntity> list = getCardListByBusinessId(userId);
             boolean enabled = list.stream().allMatch(c->!c.getEnable());
             //TODO 该专员下线
             return CommonUtils.msg(1);
         }
        log.warn("禁用银行卡，专员:{},银行卡:{}失败",userId,cardNo);
        return CommonUtils.msg(0);


    }
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
     entity.setEnable(false);
     entity.setBalanceDailyLimit(new BigDecimal("0"));
     entity.setCreateTime(new Date());
     entity.setLastUpdate(entity.getCreateTime());
     int num = mapper.save(entity);
     log.info("绑定银行卡结果:{},信息:{}",num,entity);
     return CommonUtils.msg(num);
 }
}

package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BusinessConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.modules.api.dao.OnlineBusinessMapper;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author ZhouChenglin
 */
@Service("onlineBusinessService")
@Slf4j
public class OnlineBusinessService extends BottleBaseService<OnlineBusinessMapper, OnlineBusinessEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;
    @Autowired
    private SysUserMapper sysUserMapper;

    public OnlineBusinessEntity getNextBusiness(Long orgId) {
        String redisKey = BusinessConstant.BusinessRedisKey.onlinePosition(orgId);
        OnlineBusinessEntity currentBusiness =  (OnlineBusinessEntity) redisCacheManager.get(redisKey);
        if (null != currentBusiness) {
            OnlineBusinessEntity nextOnlineBusiness = mapper.nextOnlineBusiness(orgId, currentBusiness.getPosition());
            if (nextOnlineBusiness != null) {
                redisCacheManager.set(redisKey,nextOnlineBusiness);
                return nextOnlineBusiness;
            }
        }
        // 为空时返回第一个
        OnlineBusinessEntity firstOnlineBusiness = mapper.firstOnlineBusiness(orgId);
        if(firstOnlineBusiness != null) {
            redisCacheManager.set(redisKey,firstOnlineBusiness);
            return firstOnlineBusiness;
        }
        throw new RRException("无在线出款员，请联系管理员");
    }

    public OnlineBusinessEntity getOnlineBusiness(Long businessId,Long orgId){
        OnlineBusinessEntity entity = new OnlineBusinessEntity();
        entity.setBusinessId(businessId);
        entity.setOrgId(orgId);
        List<OnlineBusinessEntity> onlineBusinessEntityList = mapper.select(entity);
        if(!onlineBusinessEntityList.isEmpty()){
           return onlineBusinessEntityList.get(0);
        }
        return null;
    }

    /**
     * 专员上线,向专员上线表里添加一条记录
     * @param userId
     */
    public boolean online(Long userId) {
        if(userId == null){
            throw new RRException("专员ID不能为空");
        }
        SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
        if(userEntity == null || userEntity.getStatus() == 0){
            log.warn("专员:{}未找到或者被禁用了",userId);
            throw new RRException("专员被禁用或者不存在无法上线");
        }
        OnlineBusinessEntity entity = new OnlineBusinessEntity();
        entity.setBusinessName(userEntity.getUsername());
        entity.setBusinessId(userId);
        entity.setOrgId(userEntity.getOrgId());
        entity.setOrgName(userEntity.getOrgName());
        int num = mapper.online(entity);
        log.info("专员:{}-{},上线结果:{}",userId,userEntity.getUsername(),num>0);
        if(num>0){
            return true;
        }
        return false;
    }

    /**
     * 专员下线
     * @param userId
     */
    public boolean offline(Long userId){
        int num = mapper.offline(userId);
        log.info("专员:{},下线结果",userId,num>0);
        if(num > 0){
            return true;
        }
        return false;
    }
}

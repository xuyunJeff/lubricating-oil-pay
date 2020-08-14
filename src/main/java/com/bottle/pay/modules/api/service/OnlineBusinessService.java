package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BusinessConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.modules.api.dao.OnlineBusinessMapper;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author ZhouChenglin
 */
@Service("onlineBusinessService")
@Slf4j
public class OnlineBusinessService extends BottleBaseService<OnlineBusinessMapper, OnlineBusinessEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;

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

}

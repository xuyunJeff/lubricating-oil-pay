package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BusinessConstant;
import com.bottle.pay.common.exception.NoOnlineBusinessException;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.modules.api.dao.BusinessMerchantMapper;
import com.bottle.pay.modules.api.dao.OnlineBusinessMapper;
import com.bottle.pay.modules.api.entity.BusinessMerchantEntity;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
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

    @Autowired
    private BusinessMerchantMapper businessMerchantMapper;

    @Autowired
    private GlobalProperties globalProperties;


    public OnlineBusinessEntity getNextBusiness( Long merchantId) {
        String redisKey = BusinessConstant.BusinessRedisKey.onlinePosition(merchantId);
        OnlineBusinessEntity currentBusiness = null;
        if(globalProperties.isRedisSessionDao()) {
            currentBusiness = redisCacheManager.getBean(redisKey, OnlineBusinessEntity.class);
        }
        if (null != currentBusiness) {
            OnlineBusinessEntity nextOnlineBusiness = mapper.nextOnlineBusiness(merchantId ,currentBusiness.getPosition());
            if (nextOnlineBusiness != null) {
                redisCacheManager.set(redisKey, nextOnlineBusiness);
                return nextOnlineBusiness;
            }
        }
        // ????????????????????????
        OnlineBusinessEntity firstOnlineBusiness = mapper.firstOnlineBusiness(merchantId);
        if (firstOnlineBusiness != null) {
            if(globalProperties.isRedisSessionDao()) {
                redisCacheManager.set(redisKey, firstOnlineBusiness);
            }
            return firstOnlineBusiness;
        }
        throw new NoOnlineBusinessException("???????????????????????????????????????");
    }




    public OnlineBusinessEntity getOnlineBusiness(Long businessId, Long orgId) {
        OnlineBusinessEntity entity = new OnlineBusinessEntity();
        entity.setBusinessId(businessId);
        entity.setOrgId(orgId);
        List<OnlineBusinessEntity> onlineBusinessEntityList = mapper.select(entity);
        if (!onlineBusinessEntityList.isEmpty()) {
            return onlineBusinessEntityList.get(0);
        }
        return null;
    }

    /**
     * ????????????,???????????????????????????????????????
     *
     * @param userId
     */
    public boolean online(Long userId) {
        if (userId == null) {
            throw new RRException("??????ID????????????");
        }
        SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
        if (userEntity == null || userEntity.getStatus() == 0) {
            log.warn("??????:{}???????????????????????????", userId);
            throw new RRException("??????????????????????????????????????????");
        }
        OnlineBusinessEntity entity = new OnlineBusinessEntity();
        entity.setBusinessName(userEntity.getUsername());
        entity.setBusinessId(userId);
        entity.setOrgId(userEntity.getOrgId());
        entity.setOrgName(userEntity.getOrgName());
        // ???????????????????????????
        List<BusinessMerchantEntity> bmeList =  businessMerchantMapper.select(new BusinessMerchantEntity(userId));
        if(bmeList.isEmpty()){
            throw new RRException("????????????????????????????????????????????????");
        }
        if(bmeList.size() >1 ) {
            throw new RRException("???????????????????????????,???????????????????????????????????????");
        }
        BusinessMerchantEntity bem = bmeList.get(0);
        entity.setMerchantId(bem.getMerchantId());
        entity.setMerchantName(bem.getMerchantName());
        int num = mapper.online(entity);
        log.info("??????:{}-{},????????????:{}", userId, userEntity.getUsername(), num > 0);
        return num > 0;
    }

    /**
     * ????????????
     *
     * @param userId
     */
    public boolean offline(Long userId) {
        int num = mapper.offline(userId);
        log.info("??????:{},????????????", userId, num > 0);
        return num > 0;
    }

    public int count() {
        return mapper.selectCount(null);
    }
}

package com.bottle.pay.modules.biz.service;


import com.bottle.pay.common.constant.IPConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.dao.IpLimitMapper;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Slf4j
@Service("ipLimitService")
public class IpLimitService extends BottleBaseService<IpLimitMapper, IpLimitEntity> {


    @Autowired
    private RedisCacheManager redisCacheManager;

    /**
     * 商户 或者 机构管理员查看 ip列表
     * @param ipLimitEntity
     * @return
     */
    public List<IpLimitEntity> ipList(IpLimitEntity ipLimitEntity){
        if( ipLimitEntity.getOrgId() == null){
            throw new RRException("机构ID不能为空");
        }
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimitEntity.getOrgId().equals(userEntity.getOrgId());

        if(super.isOrgAdmin(ipLimitEntity.getOrgId()) || isMerchant){
            return mapper.select(ipLimitEntity);
        }
        throw new RRException("不是机构管理或者不是当前商户");
    }

    /**
     * 商户添加IP百名单
     * @param ipLimit
     * @return
     */
    public R addIP(IpLimitEntity ipLimit){
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimit.getOrgId().equals(userEntity.getOrgId());
        int num = 0;
        if(isMerchant){
            ipLimit.setOrgId(userEntity.getOrgId());
            ipLimit.setOrgName(userEntity.getOrgName());
            num = mapper.save(ipLimit);
            log.info("商户白名单添加成功");
            String ipList = ipLimit.getIpList();
            String key = IPConstant.getIpWhiteListCacheKey(userEntity.getUserId(), ipLimit.getType());
            redisCacheManager.lSet(key, Arrays.asList(ipList.split("#")));
        }
        return CommonUtils.msg(num);
    }

    public R updateIp(IpLimitEntity ipLimit){
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimit.getOrgId().equals(userEntity.getOrgId());
        int num = 0;
        if(isMerchant){
            num = mapper.update(ipLimit);
            log.info("商户:{}修改Ip:{}",userEntity.getUserId(),ipLimit.getIpList());
            String key = IPConstant.getIpWhiteListCacheKey(userEntity.getUserId(), ipLimit.getType());
            redisCacheManager.lSet(key, Arrays.asList(ipLimit.getIpList().split("#")));
        }

        return CommonUtils.msg(num);
    }
}

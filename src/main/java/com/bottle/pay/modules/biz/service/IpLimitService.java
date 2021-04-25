package com.bottle.pay.modules.biz.service;


import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.dao.IpLimitMapper;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service("ipLimitService")
public class IpLimitService extends BottleBaseService<IpLimitMapper, IpLimitEntity> {



    /**
     *
     * @param ip
     * @param merchantId
     * @param orgId
     * @param type 1 商户对应服务器 2 商户登录后台的电脑
     *
     * @return
     */
    public Boolean isWhiteIp(String ip,Long merchantId,Long orgId,Integer type){
        IpLimitEntity ipLimitEntity = new IpLimitEntity();
        ipLimitEntity.setMerchantId(merchantId);
        ipLimitEntity.setOrgId(orgId);
        ipLimitEntity.setType(type);
        List<IpLimitEntity> ipList=mapper.select(ipLimitEntity);
        if(ipList.isEmpty()) return false;
        for(IpLimitEntity ipEntity : ipList){
            if(ipEntity.getIpList().contains(ip)){
                return true;
            }
        }
        return false;
    }
    /**
     * 商户 或者 机构管理员查看 ip列表
     *
     * @param ipLimitEntity
     * @return
     */
    public List<IpLimitEntity> ipList(IpLimitEntity ipLimitEntity) {
        if (ipLimitEntity.getOrgId() == null) {
            throw new RRException("机构ID不能为空");
        }
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimitEntity.getOrgId().equals(userEntity.getOrgId());

        if (super.isOrgAdmin(ipLimitEntity.getOrgId()) || isMerchant) {
            return mapper.select(ipLimitEntity);
        }
        throw new RRException("不是机构管理或者不是当前商户");
    }

    /**
     * 商户添加IP百名单
     *
     * @param ipLimit
     * @return
     */
    public R addIP(IpLimitEntity ipLimit) {
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimit.getOrgId().equals(userEntity.getOrgId());
        int num = 0;
        if (isMerchant) {
            ipLimit.setOrgId(userEntity.getOrgId());
            ipLimit.setOrgName(userEntity.getOrgName());
            num = mapper.save(ipLimit);
            log.info("商户白名单添加成功");
        }
        return CommonUtils.msg(num);
    }

    public R updateIp(IpLimitEntity ipLimit) {
        SysUserEntity userEntity = super.getCurrentUser();
        boolean isMerchant = SystemConstant.RoleEnum.BillOutMerchant.getCode().equals(userEntity.getRoleId())
                && ipLimit.getOrgId().equals(userEntity.getOrgId());
        if (!isMerchant) {
            throw new RRException("不是商户不能修改ip");
        }
        IpLimitEntity update = new IpLimitEntity();
        update.setId(ipLimit.getId());
        int num = 0;

        if(StringUtils.isNotEmpty(ipLimit.getServerIp())){
            update.setType(1);
            update.setIpList(ipLimit.getServerIp());
            int count = mapper.update(ipLimit);
            log.info("商户:{},修改type=1的Ip:{},结果:{}", userEntity.getUserId(), ipLimit.getServerIp(),count>0);

        }

        if(StringUtils.isNotEmpty(ipLimit.getClientIp())){
            update.setType(2);
            update.setIpList(ipLimit.getClientIp());
            int count = mapper.update(ipLimit);
            log.info("商户:{},修改type=2的Ip:{},结果:{}", userEntity.getUserId(), ipLimit.getServerIp(),count>0);

        }
        return CommonUtils.msg(num);
    }
}

package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.biz.view.MerchantView;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Service
public class MerchantService {

    @Autowired
    private BalanceMapper balanceMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private IpLimitService ipLimitService;



    /**
     * 机构管理员分页查看商户
     *
     * @return
     */
    public Page<MerchantView> merchantList(Map<String, Object> params){
        SysUserEntity userEntity = ShiroUtils.getUserEntity();
        if(SystemConstant.RoleEnum.Organization.getCode() != userEntity.getRoleId()){
            log.warn("userId:{}-{},不是机构管理员无权限查看此页面",userEntity.getUserId(), WebUtils.getIpAddr());
            throw new RRException("不是机构管理员无权限查看此页面");
        }
        Query query = new Query(params);
        Page<BalanceEntity> page = new Page<>(query);
        balanceMapper.listForPage(page,query);
        Page<MerchantView> result = new Page<>(query);
        List<BalanceEntity> list = page.getRows();
        if(list != null){
            for(BalanceEntity balance : list){
                MerchantView view = new MerchantView();
                view.setBizType(balance.getRoleName());
                SysUserEntity user = sysUserMapper.getObjectById(balance.getUserId());
                BeanUtils.copyProperties(balance, view);
                BeanUtils.copyProperties(user, view);

                IpLimitEntity ipLimitEntity = new IpLimitEntity();
                ipLimitEntity.setUserId(balance.getUserId());
                Optional.ofNullable(ipLimitService.select(ipLimitEntity))
                        .ifPresent(ips->view.setIpList(ips));
                result.getRows().add(view);
            }
        }
        return result;
    }

    /**
     * 根据userId 查询余额
     *
     * @param userId
     * @return
     */
    private BalanceEntity getBalanceByUserId(Long userId) {
        BalanceEntity query = new BalanceEntity();
        query.setUserId(userId);
        return balanceMapper.getObject(query);
    }

    /**
     * 查询商户账户相关信息
     *
     * @param userId
     * @return
     */
    public MerchantView getMerchantBalance(Long userId) {
        SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
        Assert.notNull(userEntity, userId + "商户不存在");
        BalanceEntity balance = getBalanceByUserId(userId);
        Assert.notNull(balance, userId + "商户不存在");
        MerchantView view = new MerchantView();
        view.setBizType(balance.getRoleName());
        BeanUtils.copyProperties(balance, view);
        BeanUtils.copyProperties(userEntity, view);
        return view;
    }
}

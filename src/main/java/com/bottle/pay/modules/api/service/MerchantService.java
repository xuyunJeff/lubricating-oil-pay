package com.bottle.pay.modules.api.service;

import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.biz.view.MerchantView;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

@Service
public class MerchantService {

    @Autowired
    private BalanceMapper balanceMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

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

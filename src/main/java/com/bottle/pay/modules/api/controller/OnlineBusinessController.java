package com.bottle.pay.modules.api.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bottle.pay.modules.api.service.BillOutService;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.api.service.OnlineBusinessService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@RestController
@RequestMapping("/apiV1/onlineBusiness")
@Slf4j
public class OnlineBusinessController extends AbstractController {

    @Autowired
    private OnlineBusinessService onlineBusinessService;

    @Autowired
    private BillOutService billOutService;

    @Autowired
    private BankCardService bankCardService;
    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<OnlineBusinessEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        params.put("orgId",userEntity.getOrgId());
        Page<OnlineBusinessEntity>  page = onlineBusinessService.listEntity(params);
        List<OnlineBusinessEntity> entities = page.getRows();
        List<OnlineBusinessEntity> onlineBusinessEntities = new ArrayList<>();
        entities.forEach(it->{
            it.setPayingBalance(billOutService.getBusinessBillOutBalance(it.getBusinessId()));
            BigDecimal businessTotalBalance = bankCardService.getAllCardsBalanceWithoutFrozen(it.getBusinessId());
            BankCardEntity enableBankCard =bankCardService.getCardOpenedListByBusinessId(it.getBusinessId());
            it.setBalance(businessTotalBalance);
            if(enableBankCard != null) {
                it.setBankAccountName(enableBankCard.getBankAccountName());
                it.setBankName(enableBankCard.getBankName());
                it.setBankName(enableBankCard.getBankName());
            }
            onlineBusinessEntities.add(it);
        });
        page.setRows(onlineBusinessEntities);
        return page;
    }
    /**
     * 删除
     *
     * @param businessId
     * @return
     */
    @SysLog("删除")
    @RequestMapping("/offline")
    public R offline(Long businessId) {
        return R.ok().put("success",onlineBusinessService.offline(businessId));
    }

}

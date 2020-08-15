package com.bottle.pay.modules.external.service;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

/**
 * 出款成功回调接口
 */
@Service
public class BillOutNotifySercice {

    @Autowired
    BillOutService billOutService;

    @Autowired
    RestTemplate restTemplate;

    /**
     * 出款成功通知第三方
     * @param entity
     * @return
     */
    public BillOutEntity billsOutPaidSuccessNotify(BillOutEntity entity){
        return entity;
    }

    /**
     * 出款失败通知第三方
     * @param entity
     * @return
     */
    public BillOutEntity billsOutPaidFailedNotify(BillOutEntity entity){
        return entity;
    }


}

package com.bottle.pay.modules.external.service;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;

/**
 * 出款成功回调接口
 */
public abstract class BillOutNotifySercice {

    BillOutService billOutService;

    /**
     * 出款成功通知第三方
     * @param entity
     * @return
     */
    public BillOutEntity billsOutPaidSuccessNotify(BillOutEntity entity){
        return null;
    }

    /**
     * 出款失败通知第三方
     * @param entity
     * @return
     */
    public BillOutEntity billsOutPaidFailedNotify(BillOutEntity entity){
        return null;
    }
}

package com.bottle.pay.modules.external.impl;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.external.service.BillOutNotifyService;
import org.springframework.stereotype.Service;

@Service("DefaultBillOutNotifySercice")
public class DefaultBillOutNotifySerciceImpl extends BillOutNotifyService {


    @Override
    public BillOutEntity billsOutPaidSuccessNotify(BillOutEntity entity) {
        return entity;
    }

    @Override
    public BillOutEntity billsOutPaidFailedNotify(BillOutEntity entity) {
        return entity;
    }
}

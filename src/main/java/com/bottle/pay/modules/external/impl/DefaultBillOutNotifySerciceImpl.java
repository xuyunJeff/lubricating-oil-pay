package com.bottle.pay.modules.external.impl;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;
import com.bottle.pay.modules.external.service.BillOutNotifySercice;
import org.springframework.stereotype.Service;

@Service("DefaultBillOutNotifySercice")
public class DefaultBillOutNotifySerciceImpl extends BillOutNotifySercice {


    @Override
    public BillOutEntity billsOutPaidSuccessNotify(BillOutEntity entity) {
        return entity;
    }

    @Override
    public BillOutEntity billsOutPaidFailedNotify(BillOutEntity entity) {
        return entity;
    }
}

package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.api.dao.BillOutMapper;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import org.springframework.stereotype.Service;


@Service("billOutService")
public class BillOutService  extends BottleBaseService<BillOutMapper,BillOutEntity> {
    /**
     *  生成代付id
     *  订单号：商户id+时间戳 + 4位自增
     * @return
     */
//    public String generateBillOutBillId(String merchantId){
//       return merchantId+ System.currentTimeMillis()+
//    }

}

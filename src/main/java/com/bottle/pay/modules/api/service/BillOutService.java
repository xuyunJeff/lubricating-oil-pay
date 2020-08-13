package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.modules.api.dao.BillOutMapper;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;


@Service("billOutService")
@Slf4j
public class BillOutService  extends BottleBaseService<BillOutMapper,BillOutEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;
    /**
     *  生成代付id
     *  订单号：商户id+ yyyyMMDD + 自增
     *  最长20位
     * @return
     */
    public String generateBillOutBillId(String merchantId){
        String today = DateUtils.format(new Date(),DateUtils.DATE_PATTERN_1);
        String redisKey = BillConstant.BILL_OUT_ID + ":" +merchantId+":"+ today;
        long incrId  =redisCacheManager.incr(redisKey,1L);
       return merchantId+ today+incrId;
    }

}

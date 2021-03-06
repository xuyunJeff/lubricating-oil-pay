package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;


@Mapper
public interface BillOutMapper extends BottleBaseMapper<BillOutEntity> {

    BigDecimal sumByBusinessId(Long businessId);

    int updateBillOutByBillId(BillOutEntity entity);

    int updateBillOutByBillIdForSuccess(BillOutEntity entity);

    int  updateByBillOutToLock(BillOutEntity entity);

    int updateBillOutByBillIdForFailed(BillOutEntity entity);

    int updateByBillOutId(BillOutEntity entity);

    int lastNewOrder(@Param("id") Long id, @Param("orgId") Long orgId, @Param("businessId") Long businessId);
}

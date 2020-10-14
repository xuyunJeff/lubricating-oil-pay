package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.api.entity.BillOutEntity;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;


@Mapper
public interface BillOutMapper extends BottleBaseMapper<BillOutEntity> {

    public BigDecimal sumByBusinessId(Long businessId);

    public int updateBillOutByBillId(BillOutEntity entity);

    public int updateBillOutByBillIdForFailed(BillOutEntity entity);

    public int updateByBillOutId(BillOutEntity entity);

    public int lastNewOrder(@Param("id") Long id, @Param("orgId")  Long orgId, @Param("businessId")  Long businessId);
}

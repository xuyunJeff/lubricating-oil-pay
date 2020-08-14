package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.api.entity.BillOutEntity ;

import java.math.BigDecimal;


@Mapper
public interface BillOutMapper extends BottleBaseMapper<BillOutEntity> {

    public BigDecimal sumByBusinessId(Long businessId);

    public int updateBusinessByBillId(BillOutEntity entity);
}

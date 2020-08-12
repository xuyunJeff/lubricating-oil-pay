package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.api.entity.BillOutEntity ;


@Mapper
public interface BillOutMapper extends BottleBaseMapper<BillOutEntity> {
	
}

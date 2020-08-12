package com.bottle.pay.modules.api.dao;

import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.api.entity.BillOutEntity ;
import com.bottle.pay.modules.sys.dao.BaseMapper;


@Mapper
public interface BillOutMapper extends BaseMapper<BillOutEntity> {
	
}

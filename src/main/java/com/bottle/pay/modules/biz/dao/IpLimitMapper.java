package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.common.mapper.BottleBaseMapper;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface IpLimitMapper extends BottleBaseMapper<IpLimitEntity> {
	
}

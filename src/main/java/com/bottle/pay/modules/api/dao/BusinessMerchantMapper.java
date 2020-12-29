package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.api.entity.BusinessMerchantEntity;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
@Component
public interface BusinessMerchantMapper extends BottleBaseMapper<BusinessMerchantEntity> {
	
}

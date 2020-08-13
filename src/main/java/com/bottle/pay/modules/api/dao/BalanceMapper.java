package com.bottle.pay.modules.api.dao;

import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;


/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface BalanceMapper extends BottleBaseMapper<BalanceEntity> {

   public BalanceEntity selectForUpdate(BalanceEntity e);

    public int billoutBalanceMerchantChange(@Param("amount") BigDecimal amount,@Param("id") Long id);
	
}

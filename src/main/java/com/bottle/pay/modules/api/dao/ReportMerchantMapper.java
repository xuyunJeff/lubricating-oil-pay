package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.api.entity.ReportBusinessEntity;
import com.bottle.pay.modules.api.entity.ReportMerchantEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface ReportMerchantMapper extends BottleBaseMapper<ReportMerchantEntity> {

    ReportBusinessEntity selectForUpdate(@Param("merchantId") Long merchantId,@Param("resultDate")  String resultDate);

    int increase(@Param("merchantId")Long merchantId, @Param("resultDate")String resultDate, @Param("price") BigDecimal price, @Param("totalPaySum")BigDecimal totalPaySum);

}

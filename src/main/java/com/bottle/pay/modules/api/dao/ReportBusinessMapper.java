package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.api.entity.ReportBusinessEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;


@Mapper
public interface ReportBusinessMapper extends BottleBaseMapper<ReportBusinessEntity> {

   int increase(@Param("businessId")Long businessId, @Param("resultDate")String resultDate,@Param("price") BigDecimal price,@Param("totalPaySum")BigDecimal totalPaySum);

   ReportBusinessEntity selectForUpdate(@Param("businessId") Long businessId,@Param("resultDate") String resultDate);

   List<ReportBusinessEntity> selectForSum(@Param("createTime") String createTime);
}

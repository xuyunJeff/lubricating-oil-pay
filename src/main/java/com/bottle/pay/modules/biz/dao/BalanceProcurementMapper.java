package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.biz.entity.BalanceProcurementEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface BalanceProcurementMapper extends BottleBaseMapper<BalanceProcurementEntity> {
    /**
     * 分页总条数
     *
     * @param params
     * @return
     */
    int selectCountPage(Map<String, Object> params);

    /**
     * 分页总条数
     *
     * @param params
     * @return
     */
    List<BalanceProcurementEntity> selectPage(Map<String, Object> params);
}

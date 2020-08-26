package com.bottle.pay.modules.api.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface OnlineBusinessMapper extends BottleBaseMapper<OnlineBusinessEntity> {

    public OnlineBusinessEntity nextOnlineBusiness(@Param("orgId") Long orgId, @Param("position") Integer position);

    public OnlineBusinessEntity firstOnlineBusiness(@Param("orgId") Long orgId);

    int online(OnlineBusinessEntity entity);

    int offline(Long userId);

    @Override
    List<OnlineBusinessEntity> select(OnlineBusinessEntity entity);
}

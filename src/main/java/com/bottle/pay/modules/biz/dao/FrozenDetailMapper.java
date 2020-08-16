package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.biz.entity.FrozenDetailEntity;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface FrozenDetailMapper extends BottleBaseMapper<FrozenDetailEntity> {

    /**
     * 解冻金额 累计解冻的
     * @return
     */
    int unFrozenMoney(FrozenDetailEntity frozenDetailEntity);

}

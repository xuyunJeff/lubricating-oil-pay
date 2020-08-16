package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface BlockBankCardMapper extends BottleBaseMapper<BlockBankCardEntity> {

    @Override
  public   BlockBankCardEntity selectOne(BlockBankCardEntity e);
}

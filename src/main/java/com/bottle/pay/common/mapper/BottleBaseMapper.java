package com.bottle.pay.common.mapper;

import com.bottle.pay.common.entity.BottleBaseEntity;
import com.bottle.pay.modules.sys.dao.BaseMapper;
import tk.mybatis.mapper.common.Mapper;

public interface BottleBaseMapper<E extends BottleBaseEntity>  extends BaseMapper<E>,Mapper<E>{

}

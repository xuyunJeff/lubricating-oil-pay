package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Mapper
public interface BankCardMapper extends BottleBaseMapper<BankCardEntity> {

    List<BankCardEntity> batchSelect(Long[] ids);


    /**
     * 根据专员Id 和 银行卡 更新状态 冻结 或者 可用
     * @param entity
     * @return
     */
    int updateCardStatus(BankCardEntity entity);

}

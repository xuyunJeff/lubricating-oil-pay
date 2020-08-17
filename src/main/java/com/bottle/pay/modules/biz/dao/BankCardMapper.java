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
     *
     * @param entity
     * @return
     */
    int updateCardStatus(BankCardEntity entity);

    /**
     * 余额调度时：增加余额
     */
    int addBalance(BankCardEntity entity);

    /**
     * 余额调度时：减少金额并判断减少前金额大于待减金额
     */
    int minusBalance(BankCardEntity entity);
}

package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;

import java.util.Map;

/**
 * Created by zhy on 2020/8/13.
 */
public interface IBlockBankCardService {
    /**
     * 分页查询
     * @param params
     * @return
     */
    Page<BlockBankCardEntity> listBlockBankCard(Map<String, Object> params);

    /**
     * 新增
     * @param blockBankCard
     * @return
     */
    R saveBlockBankCard(BlockBankCardEntity blockBankCard);

    /**
     * 根据id查询
     * @param id
     * @return
     */
    R getBlockBankCardById(Long id);

    /**
     * 修改
     * @param blockBankCard
     * @return
     */
    R updateBlockBankCard(BlockBankCardEntity blockBankCard);

    /**
     * 删除
     * @param id
     * @return
     */
    int batchRemove(Long id);
}

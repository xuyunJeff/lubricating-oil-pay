package com.bottle.pay.modules.biz.service.impl;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.dao.BlockBankCardMapper;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.IBlockBankCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Created by zhy on 2020/8/13.
 */
@Service
public class BlockBankCardServiceImpl implements IBlockBankCardService {

    @Autowired
    private BlockBankCardMapper blockBankCardMapper;

    /**
     * 分页查询
     * @param params
     * @return
     */
    @Override
    public Page<BlockBankCardEntity> listBlockBankCard(Map<String, Object> params) {
        Query query = new Query(params);
        Page<BlockBankCardEntity> page = new Page<>(query);
        blockBankCardMapper.listForPage(page, query);
        return page;
    }

    /**
     * 新增
     * @param blockBankCard
     * @return
     */
    @Override
    public R saveBlockBankCard(BlockBankCardEntity blockBankCard) {
        int count = blockBankCardMapper.insert(blockBankCard);
        return CommonUtils.msg(count);
    }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    @Override
    public R getBlockBankCardById(Long id) {
        BlockBankCardEntity blockBankCard = blockBankCardMapper.selectByPrimaryKey(id);
        return CommonUtils.msg(blockBankCard);
    }

    /**
     * 修改
     * @param blockBankCard
     * @return
     */
    @Override
    public R updateBlockBankCard(BlockBankCardEntity blockBankCard) {
        int count = blockBankCardMapper.updateByPrimaryKeySelective(blockBankCard);
        return CommonUtils.msg(count);
    }

    @Override
    public int batchRemove(Long id){
        return blockBankCardMapper.deleteByPrimaryKey(id);
    }


}

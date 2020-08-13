package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.dao.BlockBankCardMapper;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Created by zhy on 2020/8/13.
 */
@Service
public class BlockBankCardService  extends BottleBaseService<BlockBankCardMapper,BlockBankCardEntity>{



    /**
     * 分页查询
     * @param params
     * @return
     */
    public Page<BlockBankCardEntity> listBlockBankCard(Map<String, Object> params) {
        Query query = new Query(params);
        Page<BlockBankCardEntity> page = new Page<>(query);
        mapper.listForPage(page, query);
        return page;
    }

    /**
     * 新增
     * @param blockBankCard
     * @return
     */
    public R saveBlockBankCard(BlockBankCardEntity blockBankCard) {
        int count = mapper.insert(blockBankCard);
        return CommonUtils.msg(count);
    }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    public R getBlockBankCardById(Long id) {
        BlockBankCardEntity blockBankCard = mapper.selectByPrimaryKey(id);
        return CommonUtils.msg(blockBankCard);
    }

    /**
     * 修改
     * @param blockBankCard
     * @return
     */
    public R updateBlockBankCard(BlockBankCardEntity blockBankCard) {
        int count = mapper.updateByPrimaryKeySelective(blockBankCard);
        return CommonUtils.msg(count);
    }

    public R batchRemove(Long[] ids){
        int count =  mapper.batchRemove(ids);
        return CommonUtils.msg(count);
    }


}

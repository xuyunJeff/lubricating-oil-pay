package com.bottle.pay.common.service;

import com.bottle.pay.common.entity.BottleBaseEntity;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.common.utils.CommonUtils;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Map;

/**
 * Created by zhy on 2020/8/13.
 */
public abstract class BottleBaseService<M extends BottleBaseMapper,E extends BottleBaseEntity> {

    @Autowired
    protected M mapper;

    /**
     * 分页查询
     * @param params
     * @return
     */
    public Page<E> listEntity(Map<String, Object> params) {
        Query query = new Query(params);
        Page<E> page = new Page<>(query);
        mapper.listForPage(page, query);
        return page;
    }

    /**
     * 新增
     * @param blockBankCard
     * @return
     */
    public R saveEntity(E blockBankCard) {
        int count = mapper.insert(blockBankCard);
        return CommonUtils.msg(count);
    }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    public R getEntityById(Long id) {
        Object blockBankCard = mapper.selectByPrimaryKey(id);
        return CommonUtils.msg(blockBankCard);
    }

    /**
     * 修改
     * @param
     * @return
     */
    public R updateEntity(E e) {
        int count = mapper.updateByPrimaryKeySelective(e);
        return CommonUtils.msg(count);
    }

    public R batchRemove(Long[] ids){
        int count =  mapper.batchRemove(ids);
        return CommonUtils.msg(count);
    }

}

package com.bottle.pay.modules.api.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.api.dao.BillOutMapper;


@Service("billOutService")
public class BillOutService {

    @Autowired
    private BillOutMapper billOutMapper;

    /**
     * 分页查询
     * @param params
     * @return
     */
    public Page<BillOutEntity> listBillOut(Map<String, Object> params){

        Query query = new Query(params);
        Page<BillOutEntity> page = new Page<>(query);
        billOutMapper.listForPage(page, query);
        return page;
        }

    /**
     * 新增
     * @param billOut
     * @return
     */
    public R saveBillOut(BillOutEntity billOut){
        int count = billOutMapper.insert(billOut);
        return CommonUtils.msg(count);
        }

    /**
     * 根据id查询
     * @param id
     * @return
     */
    public R getBillOutById(Long id){
        BillOutEntity billOut = billOutMapper.selectByPrimaryKey(id);
        return CommonUtils.msg(billOut);
        }

    /**
     * 修改
     * @param billOut
     * @return
     */
    public R updateBillOut(BillOutEntity billOut){
        int count = billOutMapper.updateByPrimaryKey(billOut);
        return CommonUtils.msg(count);
        }

    /**
     * 删除
     * @param id
     * @return
     */
    public R batchRemove(Long[] id){
        int count = billOutMapper.deleteByPrimaryKey(id);
        return CommonUtils.msg(id, count);
        }
	
}

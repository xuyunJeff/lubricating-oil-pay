package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@RestController
@RequestMapping("/bankCard/block")
@Slf4j
public class BlockBankCardController extends AbstractController {

    @Autowired
    private BlockBankCardService blockBankCardService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BlockBankCardEntity> list(@RequestBody Map<String, Object> params) {
        return blockBankCardService.listEntity(params);
    }

    /**
     * 新增
     *
     * @param blockBankCard
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BlockBankCardEntity blockBankCard) {
        return blockBankCardService.saveEntity(blockBankCard);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public R getById(Long id) {
        return blockBankCardService.getEntityById(id);
    }

    /**
     * 修改
     *
     * @param blockBankCard
     * @return
     */
    @SysLog("修改")
    @RequestMapping("/update")
    public R update(@RequestBody BlockBankCardEntity blockBankCard) {
        return blockBankCardService.updateEntity(blockBankCard);
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @SysLog("删除")
    @RequestMapping("/remove")
    public R batchRemove(@RequestBody Long[] id) {
        return blockBankCardService.batchRemove(id);
    }

}

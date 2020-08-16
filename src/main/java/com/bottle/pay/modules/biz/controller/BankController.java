package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.biz.entity.BankEntity;
import com.bottle.pay.modules.biz.service.BankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@RestController
@RequestMapping("/sys/bank")
@Slf4j
public class BankController extends AbstractController {

    @Autowired
    private BankService bankService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BankEntity> list(@RequestBody Map<String, Object> params) {
        return bankService.listEntity(params);
    }

    /**
     * 新增
     *
     * @param bank
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BankEntity bank) {
        return bankService.saveEntity(bank);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public R getById(Long id) {
        return bankService.getEntityById(id);
    }

    /**
     * 修改
     *
     * @param bank
     * @return
     */
    @SysLog("修改")
    @RequestMapping("/update")
    public R update(@RequestBody BankEntity bank) {
        return bankService.updateEntity(bank);
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
        return bankService.batchRemove(id);
    }

}

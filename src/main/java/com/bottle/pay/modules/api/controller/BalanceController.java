package com.bottle.pay.modules.api.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.api.service.BalanceService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@RestController
@RequestMapping("/apiV1/balance")
@Slf4j
public class BalanceController extends AbstractController {

    @Autowired
    private BalanceService balanceService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BalanceEntity> list(@RequestBody Map<String, Object> params) {
        return balanceService.listEntity(params);
    }

    /**
     * 新增
     *
     * @param balance
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BalanceEntity balance) {
        return balanceService.saveEntity(balance);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public R getById(@RequestBody Long id) {
        return balanceService.getEntityById(id);
    }

    /**
     * 修改
     *
     * @param balance
     * @return
     */
    @SysLog("修改")
    @RequestMapping("/update")
    public R update(@RequestBody BalanceEntity balance) {
        return balanceService.updateEntity(balance);
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
        return balanceService.batchRemove(id);
    }

}

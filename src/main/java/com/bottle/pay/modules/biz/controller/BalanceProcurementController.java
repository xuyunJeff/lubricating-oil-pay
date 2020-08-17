package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.modules.biz.entity.BalanceProcurementEntity;
import com.bottle.pay.modules.biz.service.BalanceProcurementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("//balance/procurement")
@Slf4j
public class BalanceProcurementController extends AbstractController {

    @Autowired
    private BalanceProcurementService balanceProcurementService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BalanceProcurementEntity> list(@RequestBody Map<String, Object> params) {
        return balanceProcurementService.getProcureList(params);
    }

    /**
     * 新增
     *
     * @param balanceProcurement
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BalanceProcurementEntity balanceProcurement) {
        return balanceProcurementService.balanceProcure(balanceProcurement);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
//    @RequestMapping("/info")
//    public R getById(@RequestBody Long id) {
//        return balanceProcurementService.getEntityById(id);
//    }

    /**
     * 修改
     *
     * @param balanceProcurement
     * @return
     */
//    @SysLog("修改")
//    @RequestMapping("/update")
//    public R update(@RequestBody BalanceProcurementEntity balanceProcurement) {
//        return balanceProcurementService.updateEntity(balanceProcurement);
//    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
//    @SysLog("删除")
//    @RequestMapping("/remove")
//    public R batchRemove(@RequestBody Long[] id) {
//        return balanceProcurementService.batchRemove(id);
//    }

}

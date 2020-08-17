package com.bottle.pay.modules.biz.controller;

import java.math.BigDecimal;
import java.util.Map;

import com.bottle.pay.modules.biz.entity.FrozenDetailEntity;
import com.bottle.pay.modules.biz.service.FrozenDetailService;
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
@RequestMapping("/merchant")
@Slf4j
public class FrozenDetailController extends AbstractController {

    @Autowired
    private FrozenDetailService frozenDetailService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/frozen/list")
    public Page<FrozenDetailEntity> list(@RequestBody Map<String, Object> params) {
        return frozenDetailService.pageList(params);
    }

    /**
     * 新增
     *
     * @param frozenDetail
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/frozen/add")
    public R save(@RequestBody FrozenDetailEntity frozenDetail) {
        return frozenDetailService.frozenMerchant(frozenDetail);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
    @RequestMapping("/frozen/info")
    public R getById(Long id) {
        return frozenDetailService.getEntityById(id);
    }

    /**
     * 解冻
     *
     * @return
     */
    @SysLog("解冻")
    @RequestMapping("/unFrozen")
    public R update(Long id, BigDecimal unFrozen) {
        return frozenDetailService.unFrozenMerchant(id, unFrozen);
    }

//    /**
//     * 删除
//     *
//     * @param id
//     * @return
//     */
//    @SysLog("删除")
//    @RequestMapping("/remove")
//    public R batchRemove(@RequestBody Long[] id) {
//        return frozenDetailService.batchRemove(id);
//    }

}

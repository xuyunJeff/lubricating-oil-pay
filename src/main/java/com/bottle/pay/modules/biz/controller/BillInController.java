package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import com.bottle.pay.modules.biz.service.BillInService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;

/**
 *
 */
@RestController
@RequestMapping("/merchant/charge")
@Slf4j
public class BillInController extends AbstractController {

    @Autowired
    private BillInService billInService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BillInEntity> list(@RequestBody  Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            // 机构管理员查询机构下的所有数据
            params.put("orgId",userEntity.getOrgId());
            return billInService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            params.put("orgId",userEntity.getOrgId());
            params.put("merchantId",userEntity.getUserId());
            return billInService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员查看自己的数据的所有数据
            params.put("orgId",userEntity.getOrgId());
            params.put("businessId",userEntity.getUserId());
            return billInService.listEntity(params);
        }
        return new Page<>();
    }

    /**
     * 新增
     *
     * @param billIn
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BillInEntity billIn) {
        return billInService.addBillIn(billIn);
    }

    @SysLog("确认成功")
    @RequestMapping("/success")
    public R confirmSuccess(String billId,String comment){
        return billInService.confirmBillIn(billId,comment, BillConstant.BillStatusEnum.Success);
    }

    @SysLog("确认失败")
    @RequestMapping("/fail")
    public R confirmFail(String billId,String comment){
        return billInService.confirmBillIn(billId,comment, BillConstant.BillStatusEnum.Failed);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
//    @RequestMapping("/info")
//    public R getById(Long id) {
//        return billInService.getEntityById(id);
//    }

    /**
     * 修改
     *
     * @param billIn
     * @return
     */
//    @SysLog("修改")
//    @RequestMapping("/update")
//    public R update(@RequestBody BillInEntity billIn) {
//        return billInService.updateEntity(billIn);
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
//        return billInService.batchRemove(id);
//    }

}

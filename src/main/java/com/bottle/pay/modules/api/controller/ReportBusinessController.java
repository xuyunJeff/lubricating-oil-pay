package com.bottle.pay.modules.api.controller;

import java.util.Map;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.api.entity.ReportBusinessEntity;
import com.bottle.pay.modules.api.service.ReportBusinessService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn   @   1   6   3   .   com>
 */
@RestController
@RequestMapping("/report/business")
@Slf4j
public class ReportBusinessController extends AbstractController {

    @Autowired
    private ReportBusinessService reportBusinessService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<ReportBusinessEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())) {
            // 机构管理员查询机构下的所有数据
            params.put("orgId", userEntity.getOrgId());
            return reportBusinessService.listEntity(params);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
            // 出款员查看自己的数据的所有数据
            params.put("orgId", userEntity.getOrgId());
            params.put("businessId", userEntity.getUserId());
            return reportBusinessService.listEntity(params);
        }
        return new Page<>();
    }


}

package com.bottle.pay.modules.sys.controller;

import java.util.List;
import java.util.stream.Collectors;

import com.bottle.pay.modules.sys.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.sys.entity.SysOrgEntity;
import com.bottle.pay.modules.sys.service.SysOrgService;

/**
 * 组织机构
 *
 * @author zcl<yczclcn@163.com>
 */
@RestController
@RequestMapping("/sys/org")
public class SysOrgController extends AbstractController {

    @Autowired
    private SysOrgService sysOrgService;

    @Autowired
    private SysUserService sysUserService;

    /**
     * 机构列表
     *
     * @return
     */
    @RequestMapping("/list")
    public List<SysOrgEntity> list() {
        // TODO :  修改为只能查看自己所属机构及下属机构的数据
        //sysUserService.getUserById(getUserId())
        return sysOrgService.listOrg();
    }

    /**
     * 树形机构列表，机构新增、编辑
     *
     * @return
     */
    @RequestMapping("/select")
    public List<SysOrgEntity> select() {
        return sysOrgService.listOrgTree();
    }

    /**
     * 新增机构
     *
     * @param org
     * @return
     */
    @SysLog("新增机构")
    @RequestMapping("/save")
    public R save(@RequestBody SysOrgEntity org) {
        return sysOrgService.saveOrg(org);
    }

    /**
     * 根据id查询机构详情
     *
     * @param orgId
     * @return
     */
    @RequestMapping("/info")
    public R info(@RequestBody Long orgId) {
        return sysOrgService.getOrg(orgId);
    }

    /**
     * 修改机构
     *
     * @param org
     * @return
     */
    @SysLog("修改机构")
    @RequestMapping("/update")
    public R update(@RequestBody SysOrgEntity org) {
        return sysOrgService.updateOrg(org);
    }

    /**
     * 删除机构
     *
     * @param id
     * @return
     */
    @SysLog("删除机构")
    @RequestMapping("/remove")
    public R batchRemove(@RequestBody Long[] id) {
        return sysOrgService.bactchRemoveOrg(id);
    }

}

package com.bottle.pay.modules.sys.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.bottle.pay.common.utils.CommonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;

/**
 * 系统用户
 *
 * @author zcl<yczclcn@163.com>
 */
@RestController
@RequestMapping("/sys/user")
public class SysUserController extends AbstractController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用户列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<SysUserEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity user = getUser();
        if (user.getUserId() != SystemConstant.SUPER_ADMIN) {
            params.put("orgId", user.getOrgId());
        }
        return sysUserService.listUser(params);
    }

    @RequestMapping("/listBusiness")
    public R listBusiness(@RequestBody Map<String, Object> params) {
        SysUserEntity user = getUser();
        if (getUserId() != SystemConstant.SUPER_ADMIN) {
            params.put("orgId", user.getOrgId());
        }
        params.put("roleId",SystemConstant.RoleEnum.CustomerService.getCode());
        return R.ok().put("rows",sysUserService.list(params));
    }

    @RequestMapping("/listMerchant")
    public R listMerchant(@RequestBody Map<String, Object> params) {
        SysUserEntity user = getUser();
        if (getUserId() != SystemConstant.SUPER_ADMIN) {
            params.put("orgId", user.getOrgId());
        }
        params.put("roleId",SystemConstant.RoleEnum.BillOutMerchant.getCode());
        return R.ok().put("rows",sysUserService.list(params));
    }

    /**
     * 获取登录的用户信息
     */
    @RequestMapping("/info")
    public R info() {
        return R.ok().put("user", getUser());
    }

    /**
     * 用户权限
     *
     * @return
     */
    @RequestMapping("/perms")
    public R listUserPerms() {
        return CommonUtils.msgNotCheckNull(sysUserService.listUserPerms(getUserId()));
    }

    /**
     * 新增用户
     *
     * @param user
     * @return
     */
    @SysLog("新增用户")
    @RequestMapping("/save")
    public R save(@RequestBody SysUserEntity user) {
        user.setUserIdCreate(getUserId());
        return sysUserService.saveUser(user);
    }

    /**
     * 根据id查询详情
     *
     * @param userId
     * @return
     */
    @RequestMapping("/infoUser")
    public R getById(@RequestBody Long userId) {
        return sysUserService.getUserById(userId);
    }

    /**
     * 修改用户
     *
     * @param user
     * @return
     */
    @SysLog("修改用户")
    @RequestMapping("/update")
    public R update(@RequestBody SysUserEntity user) {
        return sysUserService.updateUser(user);
    }



    @SysLog("绑定Googley验证码")
    @RequestMapping("/updateGoogleKaptcha")
    public R updateGoogleKaptcha(@RequestParam("kaptcha") long kaptcha,@RequestParam("timeMsec")  long timeMsec) {
        SysUserEntity user = getUser();
        return sysUserService.updateGoogleKaptcha(user.getUserId(),user.getUsername(),kaptcha,timeMsec);
    }

    @SysLog("获取Googley验证二维码")
    @RequestMapping("/getGoogleKaptcha")
    public R getGoogleKaptcha() {
        SysUserEntity user = getUser();
        return sysUserService.getGoogleKaptcha(user.getUserId(),user.getUsername());
    }

    @SysLog("删除用户")
    @RequestMapping("/remove")
    public R batchRemove(@RequestBody Long[] id) {
        return sysUserService.batchRemove(id);
    }

    /**
     * 用户修改密码
     *
     * @param pswd
     * @param newPswd
     * @return
     */
    @SysLog("修改密码")
    @RequestMapping("/updatePswd")
    public R updatePswdByUser(String pswd, String newPswd) {
        SysUserEntity user = getUser();
        user.setPassword(pswd);//原密码
        user.setEmail(newPswd);//邮箱临时存储新密码
        return sysUserService.updatePswdByUser(user);
    }

    /**
     * 启用账户
     *
     * @param id
     * @return
     */
    @SysLog("启用账户")
    @RequestMapping("/enable")
    public R updateUserEnable(@RequestBody Long[] id) {
        return sysUserService.updateUserEnable(id);
    }

    /**
     * 禁用账户
     *
     * @param id
     * @return
     */
    @SysLog("禁用账户")
    @RequestMapping("/disable")
    public R updateUserDisable(@RequestBody Long[] id) {
        return sysUserService.updateUserDisable(id);
    }

    /**
     * 重置密码
     *
     * @param user
     * @return
     */
    @SysLog("重置密码")
    @RequestMapping("/reset")
    public R updatePswd(@RequestBody SysUserEntity user) {
        return sysUserService.updatePswd(user);
    }
}

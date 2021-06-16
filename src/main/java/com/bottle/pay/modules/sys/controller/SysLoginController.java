package com.bottle.pay.modules.sys.controller;

import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.utils.GoogleAuthenticator;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.entity.dto.LoginDto;
import com.google.code.kaptcha.Constants;
import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.utils.MD5Utils;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.modules.sys.service.SysUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * 用户controller
 *
 * @author zcl<yczclcn@163.com>
 */
@Slf4j
@Controller
public class SysLoginController extends AbstractController {

    @Autowired
    private SysUserService sysUserService;

    @Autowired
    private GlobalProperties globalProperties;

    @Autowired
    protected StringRedisTemplate stringRedisTemplate;

    /**
     * 跳转登录页面
     *
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String toLogin() {
        if (ShiroUtils.isLogin() || ShiroUtils.getUserEntity() != null) {
            return redirect("/");
        }
        return html("/login");
    }

    /**
     * 登录
     */
    @SysLog("登录")
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(Model model) {

        try {
            String username = getParam("username").trim();
            String password = getParam("password").trim();
            String code = getParam("code").trim();
            // 用户名验证
            if (StringUtils.isBlank(username)) {
                model.addAttribute("errorMsg", "用户名不能为空");
                return html("/login");
            }
            // 密码验证
            if (StringUtils.isBlank(password)) {
                model.addAttribute("errorMsg", "密码不能为空");
                return html("/login");
            }

            SysUserEntity user  = sysUserService.getByUserName(username);
            if( user.getEnableGoogleKaptcha() != null && user.getEnableGoogleKaptcha().equals(1)){
                // 开启验证码
                if (globalProperties.isKaptchaEnable()) {
                    if (StringUtils.isBlank(code) || !sysUserService.checkGoogleKaptcha(username,Long.valueOf(code))) {
                        model.addAttribute("errorMsg", "谷歌验证码错误");
                        return html("/login");
                    }
                }
            }
            UsernamePasswordToken token = new UsernamePasswordToken(username, MD5Utils.encrypt(username, password));
            ShiroUtils.getSubject().login(token);
            SecurityUtils.getSubject().getSession().setAttribute("sessionFlag", true);
            return redirect("/");
        } catch (UnknownAccountException | IncorrectCredentialsException | LockedAccountException e) {
            model.addAttribute("errorMsg", e.getMessage());
        } catch (AuthenticationException e) {
            model.addAttribute("errorMsg", "登录服务异常");
        }
        return html("/login");
    }


    /**
     * 登录
     */
    @SysLog("登录")
    @RequestMapping(value = "/wap/login", method = RequestMethod.POST)
    @ResponseBody
    public R wapLogin(@RequestBody LoginDto loginDto) {
        try {
            String username = loginDto.getUsername().trim();
            String password = loginDto.getPassword().trim();
            // 开启验证码
            SysUserEntity user  = sysUserService.getByUserName(username);
            if( user.getEnableGoogleKaptcha() != null && user.getEnableGoogleKaptcha().equals(1)){
                String code = loginDto.getCode().trim();
                // 开启验证码
                if (globalProperties.isKaptchaEnable()) {
                    if (StringUtils.isBlank(code) || !sysUserService.checkGoogleKaptcha(username,Long.valueOf(code))) {
                        return R.error("验证码错误");
                    }
                }
            }
            // 用户名验证
            if (StringUtils.isBlank(username)) {
                return R.error("用户名不能为空");
            }
            // 密码验证
            if (StringUtils.isBlank(password)) {
                return R.error("密码不能为空");
            }
            UsernamePasswordToken token = new UsernamePasswordToken(username, MD5Utils.encrypt(username, password));
            ShiroUtils.getSubject().login(token);
            SecurityUtils.getSubject().getSession().setAttribute("sessionFlag", true);
            return R.ok("登录成功").put("token",SecurityUtils.getSubject().getSession().getId().toString());
        } catch (UnknownAccountException | IncorrectCredentialsException | LockedAccountException e) {
            return R.error( -1,e.getMessage());
        } catch (AuthenticationException e) {
            return R.error( "登录服务异常");
        } catch (Exception e){
            return R.error( -1,"请重新登录");
        }
    }
    /**
     * 跳转后台控制台
     *
     * @return
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index() {
        return html("/index");
    }

    /**
     * 退出
     */
    @SysLog("退出系统")
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout() {
        ShiroUtils.logout();
        return html("/login");
    }

}

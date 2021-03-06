package com.bottle.pay.modules.sys.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.sys.entity.SysLogEntity;
import com.bottle.pay.modules.sys.service.SysLogService;

/**
 * 系统日志
 *
 * @author zcl<yczclcn@163.com>
 */
@RestController
@RequestMapping("/sys/log")
public class SysLogController extends AbstractController {

    @Autowired
    private SysLogService sysLogService;

    /**
     * 日志列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<SysLogEntity> listLog(@RequestBody Map<String, Object> params) {
        return sysLogService.listLog(params);
    }

    /**
     * 删除日志
     *
     * @param id
     * @return
     */
    @SysLog("删除日志")
    @RequestMapping("/remove")
    public R batchRemove(@RequestBody Long[] id) {
        return sysLogService.batchRemove(id);
    }

    /**
     * 清空日志
     *
     * @return
     */
    @SysLog("清空日志")
    @RequestMapping("/clear")
    public R batchRemoveAll() {
        return sysLogService.batchRemoveAll();
    }

}

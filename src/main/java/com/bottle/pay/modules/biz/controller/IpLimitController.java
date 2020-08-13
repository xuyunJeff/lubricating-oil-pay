package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.biz.service.IpLimitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;

/**
 * 
 * @author Zhy
 */
@RestController
@RequestMapping("/merchant/ip")
public class IpLimitController extends AbstractController {
	
	@Autowired
	private IpLimitService ipLimitService;
	
	/**
	 * 列表
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<IpLimitEntity> list(@RequestBody Map<String, Object> params) {
		return ipLimitService.listEntity(params);
	}
		
	/**
	 * 新增
	 * @param ipLimit
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody IpLimitEntity ipLimit) {
		return ipLimitService.saveEntity(ipLimit);
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return ipLimitService.getEntityById(id);
	}
	
	/**
	 * 修改
	 * @param ipLimit
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/update")
	public R update(@RequestBody IpLimitEntity ipLimit) {
		return ipLimitService.updateEntity(ipLimit);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SysLog("删除")
	@RequestMapping("/remove")
	public R batchRemove(@RequestBody Long[] id) {
		return ipLimitService.batchRemove(id);
	}
	
}

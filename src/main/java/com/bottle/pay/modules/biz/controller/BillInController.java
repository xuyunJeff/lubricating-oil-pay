package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import com.bottle.pay.modules.biz.service.BillInService;
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
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<BillInEntity> list( Map<String, Object> params) {
		return billInService.listEntity(params);
	}
		
	/**
	 * 新增
	 * @param billIn
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody BillInEntity billIn) {
		return billInService.saveEntity(billIn);
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(Long id) {
		return billInService.getEntityById(id);
	}
	
	/**
	 * 修改
	 * @param billIn
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/update")
	public R update(@RequestBody BillInEntity billIn) {
		return billInService.updateEntity(billIn);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SysLog("删除")
	@RequestMapping("/remove")
	public R batchRemove(@RequestBody Long[] id) {
		return billInService.batchRemove(id);
	}
	
}

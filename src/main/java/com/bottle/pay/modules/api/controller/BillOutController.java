package com.bottle.pay.modules.api.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;


@RestController
@RequestMapping("/apiV1/BillOut")
public class BillOutController extends AbstractController {
	
	@Autowired
	private BillOutService billOutService;
	
	/**
	 * 列表
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<BillOutEntity> list(@RequestBody Map<String, Object> params) {
		return billOutService.listBillOut(params);
	}
		
	/**
	 * 新增
	 * @param billOut
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody BillOutEntity billOut) {
		return billOutService.saveBillOut(billOut);
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return billOutService.getBillOutById(id);
	}
	
	/**
	 * 修改
	 * @param billOut
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/update")
	public R update(@RequestBody BillOutEntity billOut) {
		return billOutService.updateBillOut(billOut);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SysLog("删除")
	@RequestMapping("/remove")
	public R batchRemove(@RequestBody Long[] id) {
		return billOutService.batchRemove(id);
	}
	
}

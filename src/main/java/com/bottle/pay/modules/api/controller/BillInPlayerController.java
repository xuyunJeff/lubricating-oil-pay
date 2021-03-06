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
import com.bottle.pay.modules.api.entity.BillInPlayerEntity;
import com.bottle.pay.modules.api.service.BillInPlayerService;
import lombok.extern.slf4j.Slf4j;

/**
 * 
 * @author Ryan<>
 */
@RestController
@RequestMapping("/billInPlayer")
@Slf4j
public class BillInPlayerController extends AbstractController {
	
	@Autowired
	private BillInPlayerService billInPlayerService;
	
	/**
	 * 列表
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<BillInPlayerEntity> list(@RequestBody Map<String, Object> params) {
		return billInPlayerService.listEntity(params);
	}
		
	/**
	 * 新增
	 * @param billInPlayer
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody BillInPlayerEntity billInPlayer) {
		return billInPlayerService.saveEntity(billInPlayer);
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return billInPlayerService.getEntityById(id);
	}
	
	/**
	 * 修改
	 * @param billInPlayer
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/update")
	public R update(@RequestBody BillInPlayerEntity billInPlayer) {
		return billInPlayerService.updateEntity(billInPlayer);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SysLog("删除")
	@RequestMapping("/remove")
	public R batchRemove(@RequestBody Long[] id) {
		return billInPlayerService.batchRemove(id);
	}
	
}

package com.bottle.pay.modules.api.controller;

import java.util.Map;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;

import javax.servlet.http.HttpServletRequest;


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
		return billOutService.listEntity(params);
	}
		
	/**
	 * 新增
	 * @param billOut
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody BillOutEntity billOut) {
		return billOutService.saveEntity(billOut);
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return billOutService.getEntityById(id);
	}
	
	/**
	 * 修改
	 * @param billOut
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/update")
	public R update(@RequestBody BillOutEntity billOut) {
		return billOutService.updateEntity(billOut);
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

	@SysLog("后端派单")
	@PostMapping("/push/order")
	public R pushOrder(@RequestBody BillOutView billOutView, HttpServletRequest request){
		SysUserEntity userEntity =	getUser();
		String ip =request.getRemoteAddr();
		// 第一步保存订单,派单给机构
		BillOutEntity bill =billOutService.billsOutAgent(billOutView,ip,userEntity);
		// TODO 判断银行卡是否在黑名单内 @mighty
		if(bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())){
			// 自动派单给出款员
		}

		return R.ok();
	}
}

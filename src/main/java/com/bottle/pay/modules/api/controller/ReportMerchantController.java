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
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.ReportMerchantEntity;
import com.bottle.pay.modules.api.service.ReportMerchantService;
import lombok.extern.slf4j.Slf4j;




@RestController
@RequestMapping("/apiV1/reportMerchant")
@Slf4j
public class ReportMerchantController extends AbstractController {
	
	@Autowired
	private ReportMerchantService reportMerchantService;
	
	/**
	 * 列表
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<ReportMerchantEntity> list(@RequestBody Map<String, Object> params) {
		SysUserEntity userEntity = getUser();
		if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode()) || userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
			// 机构管理员查询机构下的所有数据
			params.put("orgId", userEntity.getOrgId());
			return reportMerchantService.listEntity(params);
		}
		if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) {
			// 出款员查看自己的数据的所有数据
			params.put("orgId", userEntity.getOrgId());
			params.put("merchantId", userEntity.getUserId());
			return reportMerchantService.listEntity(params);
		}
		return reportMerchantService.listEntity(params);
	}

	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return reportMerchantService.getEntityById(id);
	}

}

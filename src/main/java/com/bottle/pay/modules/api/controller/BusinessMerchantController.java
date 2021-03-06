package com.bottle.pay.modules.api.controller;

import java.util.Date;
import java.util.Map;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BusinessMerchantEntity;
import com.bottle.pay.modules.api.service.BusinessMerchantService;
import lombok.extern.slf4j.Slf4j;


@RestController
@RequestMapping("/apiV1/businessMerchant")
@Slf4j
public class BusinessMerchantController extends AbstractController {
	
	@Autowired
	private BusinessMerchantService businessMerchantService;

	@Autowired
	private SysUserService userService;
	
	/**
	 * 列表
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<BusinessMerchantEntity> list(@RequestBody Map<String, Object> params) {
		SysUserEntity userEntity = getUser();
		if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
			params.put("orgId",userEntity.getOrgId());
			// 机构管理员查询机构下的所有数据
			return businessMerchantService.listEntity(params);
		}
		if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
			// 出款员查看自己的数据的所有数据
			params.put("orgId",userEntity.getOrgId());
			params.put("businessId",userEntity.getUserId());
			return businessMerchantService.listEntity(params);
		}
		if (getUserId() == SystemConstant.SUPER_ADMIN) {
			return businessMerchantService.listEntity(params);
		}
		return new Page<>();
	}
		
	/**
	 * 新增
	 * @param businessMerchant
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
	public R save(@RequestBody BusinessMerchantEntity businessMerchant) {
		SysUserEntity userEntity = getUser();
		if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
			SysUserEntity merchant = userService.getUserEntityById(businessMerchant.getMerchantId());
			businessMerchant.setMerchantName(merchant.getUsername());
			SysUserEntity business = userService.getUserEntityById(businessMerchant.getBusinessId());
			businessMerchant.setBusinessName(business.getUsername());
			businessMerchant.setOrgId(business.getOrgId());
			businessMerchant.setOrgName(business.getOrgName());
			businessMerchant.setCreateTime(new Date());
			businessMerchant.setLastUpdate(new Date());
			// 机构管理员查询机构下的所有数据
			return businessMerchantService.saveEntity(businessMerchant);
		}
		return R.error("只有机构管理员才能绑定出款员和商户的关系");
	}
	
	/**
	 * 根据id查询详情
	 * @param id
	 * @return
	 */
	@RequestMapping("/info")
	public R getById(@RequestBody Long id) {
		return businessMerchantService.getEntityById(id);
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SysLog("删除")
	@RequestMapping("/remove")
	public R batchRemove(@RequestBody Long[] id) {
		return businessMerchantService.batchRemove(id);
	}
	
}

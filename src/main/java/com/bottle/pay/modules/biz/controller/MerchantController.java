package com.bottle.pay.modules.biz.controller;

import java.util.Arrays;
import java.util.List;

import com.bottle.pay.common.constant.IPConstant;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.api.service.BalanceService;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.biz.view.MerchantView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;

@RestController
@RequestMapping("/merchant")
public class MerchantController extends AbstractController {
	
	@Autowired
	private IpLimitService ipLimitService;

	@Autowired
	private RedisCacheManager redisCacheManager;

	@Autowired
	private BalanceService balanceService;
	
	/**
	 * 列表 商户查询自己登陆ip 黑/白名单
	 * 一般最多只有两条记录
	 * 			一条是商户后台IP白名单
	 * 			另一条是商户服务器调用我们派单接口是的IP白名单
	 * @param ipLimit
	 * @return
	 */
	@RequestMapping("/ip/list")
	public List<IpLimitEntity> list(@RequestBody IpLimitEntity ipLimit) {
		return ipLimitService.select(ipLimit);
	}
		
	/**
	 * 新增
	 * @param ipLimit
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/ip/save")
	public R save(@RequestBody IpLimitEntity ipLimit) {
		ipLimit.setOrgId(super.getUser().getOrgId());
		ipLimit.setOrgName(super.getUser().getOrgName());
		R  r = ipLimitService.saveEntity(ipLimit);
		if(r.isOk()){
			String ipList = ipLimit.getIpList();
			String key = IPConstant.getIpWhiteListCacheKey(super.getUser().getUserId(),ipLimit.getType());
			redisCacheManager.lSet(key,Arrays.asList(ipList.split("#")));
		}
		return r;
	}

	
	/**
	 * 修改
	 * @param ipLimit
	 * @return
	 */
	@SysLog("修改")
	@RequestMapping("/ip/update")
	public R update(@RequestBody IpLimitEntity ipLimit) {
		R r = ipLimitService.updateEntity(ipLimit);
		if(r.isOk()){
			String key = IPConstant.getIpWhiteListCacheKey(super.getUser().getUserId(),ipLimit.getType());
			redisCacheManager.lSet(key,Arrays.asList(ipLimit.getIpList().split("#")));
		}
		return r;
	}


	/**
	 * 获取商户信息
	 * @return
	 */
	@RequestMapping("/info")
	public R getMerchantInfo(){
		MerchantView view = balanceService.getMerchantBalance(super.getUserId());
		return CommonUtils.msg(view);
	}
	
}

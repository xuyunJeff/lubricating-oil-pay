package com.bottle.pay.modules.biz.controller;

import java.util.Arrays;
import java.util.List;

import com.bottle.pay.common.constant.IPConstant;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.biz.service.IpLimitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;

@RestController
@RequestMapping("/merchant/ip")
public class IpLimitController extends AbstractController {
	
	@Autowired
	private IpLimitService ipLimitService;

	@Autowired
	private RedisCacheManager redisCacheManager;
	
	/**
	 * 列表 商户查询自己登陆ip 黑/白名单
	 * @param ipLimit
	 * @return
	 */
	@RequestMapping("/list")
	public List<IpLimitEntity> list(@RequestBody IpLimitEntity ipLimit) {
		//TODO 商户服务器IP白名单
		return ipLimitService.select(ipLimit);
	}
		
	/**
	 * 新增
	 * @param ipLimit
	 * @return
	 */
	@SysLog("新增")
	@RequestMapping("/save")
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
	@RequestMapping("/update")
	public R update(@RequestBody IpLimitEntity ipLimit) {
		R r = ipLimitService.updateEntity(ipLimit);
		if(r.isOk()){
			String key = IPConstant.getIpWhiteListCacheKey(super.getUser().getUserId(),ipLimit.getType());
			redisCacheManager.lSet(key,Arrays.asList(ipLimit.getIpList().split("#")));
		}
		return r;
	}
	
}

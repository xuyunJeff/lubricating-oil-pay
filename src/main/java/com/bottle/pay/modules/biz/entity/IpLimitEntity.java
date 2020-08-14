package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import com.mchange.util.AssertException;
import lombok.Data;
import org.apache.commons.lang.ObjectUtils;
import org.springframework.util.Assert;

import javax.persistence.Table;



/**
 * 
 * @author zhy
 */

@Data
@Table(name = "ip_limit")
public class IpLimitEntity extends BottleBaseEntity {

	/**
	 * 
	 */
	private String ipList;
	
	/**
	 * 1: 白名单 ； 0：黑名单
	 */
	private Integer isWhite;

	
	/**
	 * 1:商户对应服务器 2 商户登录后台的电脑
	 */
	private Integer type;

	public static String getRedisKey(Integer type,Long orgId){
		Assert.isTrue(type!=null||orgId!=null,"type或者orgId不能为空");
		StringBuilder sBd = new StringBuilder("ip:");
		sBd.append(type).append(":").append(orgId);
		return sBd.toString();
	}

}

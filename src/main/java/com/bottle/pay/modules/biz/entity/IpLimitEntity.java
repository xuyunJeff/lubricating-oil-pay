package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.Data;

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

}

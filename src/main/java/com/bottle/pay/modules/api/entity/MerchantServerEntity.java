package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.Date;
import javax.persistence.Table;
import lombok.ToString;
import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@Table(name = "merchant_server")
@ToString
@NoArgsConstructor
public class MerchantServerEntity extends BottleBaseEntity {
	
	/**
	 * 
	 */
	private Long id;
	
	/**
	 * 
	 */
	private Date createTime;
	
	/**
	 * 
	 */
	private Date lastUpdate;
	
	/**
	 * 代理商id
	 */
	private Long orgId;
	
	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 代理商姓名
	 */
	private String orgName;
	
	/**
	 * 商户服务器账号
	 */
	private String severName;
	
	/**
	 * 商户服务器账号ID
	 */
	private Long serverId;
	

}

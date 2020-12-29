package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.Date;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.ToString;
import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@Table(name = "business_merchant")
@ToString
@NoArgsConstructor
public class BusinessMerchantEntity extends BottleBaseEntity {


	public BusinessMerchantEntity(Long businessId) {
		this.businessId = businessId;
	}

	
	/**
	 * 
	 */
	private Date createTime;
	
	/**
	 * 
	 */
	private Date lastUpdate;
	
	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 付款专员姓名
	 */
	private String businessName;
	
	/**
	 * 付款专员ID
	 */
	private Long businessId;
	
	/**
	 * 代理商id
	 */
	private Long orgId;
	
	/**
	 * 代理商姓名
	 */
	private String orgName;
	

}

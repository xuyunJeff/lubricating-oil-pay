package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.Date;
import javax.persistence.Table;
import lombok.ToString;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;


@Data
@AllArgsConstructor
@Table(name = "report_merchant")
@ToString
@NoArgsConstructor
public class ReportMerchantEntity extends BottleBaseEntity {


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
	 * 代理商姓名
	 */
	private String orgName;
	
	/**
	 * 
	 */
	private String resultDate;
	
	/**
	 * 出款总笔数
	 */
	private Integer totalPayCount;
	
	/**
	 * 出款总计
	 */
	private BigDecimal totalPaySum;
	
	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 商户总充值
	 */
	private BigDecimal totalTopupSum;
	

}

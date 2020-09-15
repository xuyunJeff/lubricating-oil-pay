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
@Table(name = "report_business")
@ToString
@NoArgsConstructor
public class ReportBusinessEntity extends BottleBaseEntity {
	
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
	 * 代理商姓名
	 */
	private String orgName;
	
	/**
	 * 
	 */
	private String resultDate;
	
	/**
	 * 付款专员姓名
	 */
	private String businessName;
	
	/**
	 * 付款专员ID
	 */
	private Long businessId;
	
	/**
	 * 出款总笔数
	 */
	private Integer totalPayCount;
	
	/**
	 * 出款总计
	 */
	private BigDecimal totalPaySum;
	

}

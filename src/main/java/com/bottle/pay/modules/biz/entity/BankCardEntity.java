package com.bottle.pay.modules.biz.entity;

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
@Table(name = "bank_card")
@ToString
@NoArgsConstructor
public class BankCardEntity extends BottleBaseEntity {

	/**
	 * 付款专员姓名
	 */
	private String businessName;
	
	/**
	 * 付款专员ID
	 */
	private Long businessId;
	
	/**
	 * 付款会员的卡号
	 */
	private String bankCardNo;
	
	/**
	 * 银行名称
	 */
	private String bankName;
	
	/**
	 * 付款用户名
	 */
	private String bankAccountName;
	
	/**
	 * 可用余额
	 */
	private BigDecimal balance;
	
	/**
	 * 1 可用 2 冻结 
	 */
	private Integer cardStatus;
	
	/**
	 * 0 禁用 1 启用
	 */
	private Integer enable;
	
	/**
	 * 
	 */
	private BigDecimal balanceDailyLimit;



}

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
@Table(name = "balance_change_log")
@ToString
@NoArgsConstructor
public class BalanceChangeLogEntity extends BottleBaseEntity {

	public BalanceChangeLogEntity(String userName, Long userId, BigDecimal balanceAfter, BigDecimal balance, Long orgId, String orgName, Long roleId, String roleName, BigDecimal balanceBefore, String billId, String message) {
		this.userName = userName;
		this.userId = userId;
		this.balanceAfter = balanceAfter;
		this.balance = balance;
		this.orgId = orgId;
		this.orgName = orgName;
		this.roleId = roleId;
		this.roleName = roleName;
		this.balanceBefore = balanceBefore;
		this.billId = billId;
		this.message = message;
	}

	/**
	 * 用户名
	 */
	private String userName;
	
	/**
	 * 用户ID
	 */
	private Long userId;
	
	/**
	 * 账变后
	 */
	private BigDecimal balanceAfter;

	/**
	 * 账变金额
	 */
	private BigDecimal balance;
	
	/**
	 * 代理商id
	 */
	private Long orgId;
	
	/**
	 * 代理商姓名
	 */
	private String orgName;
	
	/**
	 * 角色id
	 */
	private Long roleId;
	
	/**
	 * 角色名称
	 */
	private String roleName;
	
	/**
	 * 账变前
	 */
	private BigDecimal balanceBefore;
	
	/**
	 * 
	 */
	private String billId;
	
	/**
	 * 
	 */
	private String message;
	

}

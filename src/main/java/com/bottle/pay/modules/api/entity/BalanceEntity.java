package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;
import javax.persistence.Table;

import java.math.BigDecimal;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "balance")
@ToString
public class BalanceEntity extends BottleBaseEntity {

	
	/**
	 * 用户名
	 */
	private String userName;
	
	/**
	 * 用户ID
	 */
	private Long userId;
	
	/**
	 * 可用余额
	 */
	private BigDecimal balance;
	
	/**
	 * 冻结余额
	 */
	private BigDecimal balanceFrozen;
	
	/**
	 * 
	 */
	private BigDecimal balancePaying;

	
	/**
	 * 角色id
	 */
	private Long roleId;
	
	/**
	 * 角色名称
	 */
	private String roleName;
	
	/**
	 * 自动出款上线额度，超出额度要手动派单
	 */
	private BigDecimal billOutLimit;

    /**
     * BalanceEntity.toString()
     */
    @Override
    public String toString() {
        return "BalanceEntity{" +
                              "id='" + id + '\'' +
                              ", userName='" + userName + '\'' +
                              ", userId='" + userId + '\'' +
                              ", balance='" + balance + '\'' +
                              ", balanceFrozen='" + balanceFrozen + '\'' +
                              ", balancePaying='" + balancePaying + '\'' +
                              ", createTime='" + createTime + '\'' +
                              ", lastUpdate='" + lastUpdate + '\'' +
                              ", agentId='" + agentId + '\'' +
                              ", agentName='" + agentName + '\'' +
                              ", roleId='" + roleId + '\'' +
                              ", roleName='" + roleName + '\'' +
                              ", billOutLimit='" + billOutLimit + '\'' +
                              '}';
    }

}

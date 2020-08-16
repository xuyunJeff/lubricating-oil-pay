package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import javax.persistence.Table;

import lombok.ToString;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;


/**
 * 余额调度表
 */
@Data
@AllArgsConstructor
@Table(name = "balance_procurement")
@ToString
@NoArgsConstructor
public class BalanceProcurementEntity extends BottleBaseEntity {


    /**
     *
     */
    private Long outBusinessId;

    /**
     *
     */
    private String outBusinessName;

    /**
     * 付款专员姓名
     */
    private String inBusinessName;

    /**
     * 付款专员ID
     */
    private Long inBusinessId;

    /**
     * 账单金额
     */
    private BigDecimal price;

    /**
     * 付款会员的卡号
     */
    private String inBankCardNo;

    /**
     * 银行名称
     */
    private String inBankName;

    /**
     * 付款会员的卡号
     */
    private String outBankCardNo;

    /**
     * 银行名称
     */
    private String outBankName;

    /**
     *
     */
    private BigDecimal inBeforeBalance;

    /**
     *
     */
    private BigDecimal outBeforeBalance;

    /**
     *
     */
    private BigDecimal inAfterBalance;

    /**
     *
     */
    private BigDecimal outAfterBalance;


}

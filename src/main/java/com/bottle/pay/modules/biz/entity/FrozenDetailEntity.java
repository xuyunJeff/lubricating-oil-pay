package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import javax.persistence.Table;

import lombok.ToString;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;


/**
 * 商户冻结详情
 */
@Data
@AllArgsConstructor
@Table(name = "frozen_detail")
@ToString
@NoArgsConstructor
public class FrozenDetailEntity extends BottleBaseEntity {

    /**
     * 商户名
     */
    private String merchantName;

    /**
     * 商户ID
     */
    private Long merchantId;

    /**
     * 冻结余额
     */
    private BigDecimal balanceFrozen;

    /**
     * 解冻余额
     */
    private BigDecimal balanceUnfrozen;

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
     * 付款专员姓名
     */
    private String businessName;

    /**
     * 付款专员ID
     */
    private Long businessId;


}

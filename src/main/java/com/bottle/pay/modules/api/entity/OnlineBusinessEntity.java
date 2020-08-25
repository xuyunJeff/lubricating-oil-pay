package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.Table;
import javax.persistence.Transient;

import lombok.ToString;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@Table(name = "online_business")
@ToString
@NoArgsConstructor
public class OnlineBusinessEntity extends BottleBaseEntity {

    /**
     * 付款专员姓名
     */
    private String businessName;

    /**
     * 付款专员ID
     */
    private Long businessId;

    /**
     *
     */
    private Integer position;

    @Transient
    private BigDecimal payingBalance;

    @Transient
    private BigDecimal balance;


    /**
     * 付款会员的卡号
     */
    @Transient
    private String bankCardNo;

    /**
     * 银行名称
     */
    @Transient
    private String bankName;

    /**
     * 付款用户名
     */
    @Transient
    private String bankAccountName;

    @Transient
    public Date createTime;

    @Transient
    public Date lastUpdate;

    public OnlineBusinessEntity(Long businessId) {
        this.businessId = businessId;
    }
}

package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import javax.persistence.Table;

import lombok.ToString;
import lombok.NoArgsConstructor;


/**
 * 银行列表
 */
@Data
@AllArgsConstructor
@Table(name = "bank")
@ToString
@NoArgsConstructor
public class BankEntity extends BottleBaseEntity {

    /**
     *
     */
    private String bankName;

    /**
     *
     */
    private String bankCode;

    /**
     *
     */
    private String bankLog;

    /**
     * 是否支持取款(1,是，0否)
     */
    private Boolean wdenable;


}

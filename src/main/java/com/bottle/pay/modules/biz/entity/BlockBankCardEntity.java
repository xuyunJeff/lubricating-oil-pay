package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import javax.persistence.Table;

import lombok.ToString;
import lombok.NoArgsConstructor;


/**
 * 银行卡黑名单
 */

@Data
@AllArgsConstructor
@Table(name = "block_bank_card")
@ToString
@NoArgsConstructor
public class BlockBankCardEntity extends BottleBaseEntity {

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

}

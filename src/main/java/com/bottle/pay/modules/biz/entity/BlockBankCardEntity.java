package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.Data;

import javax.persistence.Table;

/**
 * Created by zhy on 2020/8/13.
 */

@Data
@Table(name = "block_bank_card")
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

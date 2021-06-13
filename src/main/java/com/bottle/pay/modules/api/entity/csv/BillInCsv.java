package com.bottle.pay.modules.api.entity.csv;

import lombok.Data;
import lombok.ToString;

import java.math.BigDecimal;


@Data
@ToString
public class BillInCsv {

    /**
     * 商户名
     */
    private String merchantName;
    /**
     *
     */
    public String createTime;


    /**
     * 订单号：商户id+时间戳 + 4位自增
     */
    private String billId;

    /**
     * 第三方订单号
     */
    private String thirdBillId;


    /**
     * 付款专员姓名
     */
    private String businessName;


    /**
     * 订单状态：  1未支付 2 成功 3 失败
     */
    private String billStatus;

    /**
     * 账单金额
     */
    private BigDecimal price;

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

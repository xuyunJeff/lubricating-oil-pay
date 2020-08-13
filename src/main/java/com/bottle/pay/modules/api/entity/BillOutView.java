package com.bottle.pay.modules.api.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BillOutView {
    private String merchantName;
    private Long merchantId;
    private String orderNo;
    private  Integer agentId;
    private  String agentName;
    private   BigDecimal price;
    private   String bankCardNo;
    private   String bankName;
    private  String bankAccountName;

    @Override
    public String toString() {
        return "{" +
                "merchantName='" + merchantName + '\'' +
                ", merchantId=" + merchantId +
                ", orderNo='" + orderNo + '\'' +
                ", agentId=" + agentId +
                ", agentName='" + agentName + '\'' +
                ", price=" + price +
                ", bankCardNo='" + bankCardNo + '\'' +
                ", bankName='" + bankName + '\'' +
                ", bankAccountName='" + bankAccountName + '\'' +
                '}';
    }
}

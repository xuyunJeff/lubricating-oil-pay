package com.bottle.pay.modules.api.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BillOutView2 implements Cloneable{
    @NotNull(message = "merchantName 不能为空")
    private String merchantName;
    @NotNull(message = "merchantId 不能为空")
    private Long merchantId;
    @NotNull(message = "orderNo 不能为空")
    private String orderNo;
    @NotNull(message = "price 不能为空")
    private BigDecimal price;
    @NotNull(message = "bankCardNo 不能为空")
    private String bankCardNo;
    @NotNull(message = "bankName不能为空")
    private String bankName;
    @NotNull(message = "bankAccountName不能为空")
    private String bankAccountName;

    @NotNull(message = "timestamp")
    private long timestamp ;

    @NotNull(message = "sign不能为空")
    private String sign;

    @Override
    public String toString() {
        return "{" +
                "merchantName='" + merchantName + '\'' +
                ", merchantId=" + merchantId +
                ", orderNo='" + orderNo + '\'' +
                ", price=" + price +
                ", bankCardNo='" + bankCardNo + '\'' +
                ", bankName='" + bankName + '\'' +
                ", bankAccountName='" + bankAccountName + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }

    @Override
    public BillOutView2 clone() throws CloneNotSupportedException {
        return (BillOutView2)super.clone();
    }
}

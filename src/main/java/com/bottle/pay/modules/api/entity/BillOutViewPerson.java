package com.bottle.pay.modules.api.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class BillOutViewPerson {

    private String orderNo;
    @NotNull(message = "price 不能为空")
    private BigDecimal price;
    @NotNull(message = "bankCardNo 不能为空")
    private String bankCardNo;
    @NotNull(message = " bankName不能为空")
    private String bankName;
    @NotNull(message = " bankAccountName不能为空")
    private String bankAccountName;
}

package com.bottle.pay.modules.biz.view;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class MerchantView {
    /**
     * 机构ID
     */
    private Long orgId;
    /**
     * 商户ID
     */
    private Long userId;
    /**
     * 商户名称
     */
    private String userName;

    /**
     * 商户类型  代付
     */
    private String bizType;

    /**
     * 状态(0：禁用   1：正常)
     */
    private Integer status;
    /**
     * Ip白名单
     */
    private List<String> ipList;
    /**
     * 手机
     */
    private String mobile;
    /**
     * 邮箱
     */
    private String email;

    /**
     * 自动出款上线额度，超出额度要手动派单
     */
    private BigDecimal billOutLimit;
    /**
     * 可用余额
     */
    private BigDecimal balance;

    /**
     * 冻结余额
     */
    private BigDecimal balanceFrozen;

    /**
     * 支付中余额
     */
    private BigDecimal balancePaying;
}

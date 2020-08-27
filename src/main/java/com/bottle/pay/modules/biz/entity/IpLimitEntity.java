package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.Data;

import javax.persistence.Table;
import javax.persistence.Transient;


/**
 * IP黑名单
 */
@Data
@Table(name = "ip_limit")
public class IpLimitEntity extends BottleBaseEntity {

    /**
     * 商户ID
     */
    @Transient
    private Long userId;

    /**
     *
     */
    private String ipList;

    /**
     * 1: 白名单 ； 0：黑名单
     */
    private Integer isWhite;


    /**
     * 1:商户对应服务器 2 商户登录后台的电脑
     */
    private Integer type;

    /**
     * 商户对应服务器
     */
    @Transient
    private String serverIp;

    /**
     * 商户登录后台的电脑
     */
    @Transient
    private String clientIp;

    private Long merchantId;

    private String merchantName;

}

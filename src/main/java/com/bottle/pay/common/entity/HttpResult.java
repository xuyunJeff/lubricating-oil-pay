package com.bottle.pay.common.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class HttpResult {
    // 响应码
    private Integer code;

    // 响应体
    private String body;
}

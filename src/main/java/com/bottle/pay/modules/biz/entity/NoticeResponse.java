package com.bottle.pay.modules.biz.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoticeResponse {
    // code = 0 :成功， code=-1 订单不存在， code = 500 订单存在但金额不匹配
    private Integer code;
    // 存你要返回的提示内容
    private String msg;
}

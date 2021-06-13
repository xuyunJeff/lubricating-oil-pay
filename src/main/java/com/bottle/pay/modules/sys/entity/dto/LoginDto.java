package com.bottle.pay.modules.sys.entity.dto;

import lombok.Data;

@Data
public class LoginDto {
    private String username;
    private String password;
    private String code;
}

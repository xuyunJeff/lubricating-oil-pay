package com.bottle.pay.modules.api.entity;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import javax.validation.constraints.NotNull;

import java.util.List;

@Slf4j
@Data
public class BillOutBatchVo {

    @NotNull(message = " 谷歌验证码不能为空")
    private Long googleCode;

    private List<BillOutViewPerson> billOutViewPersonList;
}

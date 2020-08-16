package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.biz.dao.BankMapper;
import com.bottle.pay.modules.biz.entity.BankEntity;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Service("bankService")
@Slf4j
public class BankService extends BottleBaseService<BankMapper, BankEntity> {


}

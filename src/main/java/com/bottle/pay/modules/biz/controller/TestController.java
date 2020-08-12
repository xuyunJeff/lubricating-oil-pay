package com.bottle.pay.modules.biz.controller;

import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.IBlockBankCardService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

/**
 * Created by zhy on 2020/8/13.
 */
@Slf4j
@RestController
@RequestMapping("/test")
public class TestController {

    @Autowired
    private IBlockBankCardService blockBankCardService;

    @RequestMapping("/bank/add")
    public void addBank(){
        BlockBankCardEntity entity = new BlockBankCardEntity();
        entity.setAgentId(1);
        entity.setAgentName("we");
        entity.setBankAccountName("wefq");
        entity.setBankCardNo("ewqe");
        entity.setBankName("qwe");
        entity.setCreateTime(new Date());
        blockBankCardService.saveBlockBankCard(entity);
    }
}

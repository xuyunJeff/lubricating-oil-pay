package com.bottle.pay.modules.biz.controller;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zhy on 2020/8/13.
 */
@Slf4j
@RestController
@RequestMapping("/test")
public class TestController {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;


    @Autowired
    private BlockBankCardService blockBankCardService;

    @RequestMapping("/bank/add")
    public void addBank(){
        BlockBankCardEntity entity = new BlockBankCardEntity();
        entity.setAgentId(1L);
        entity.setAgentName("we");
        entity.setBankAccountName("wefq");
        entity.setBankCardNo("ewqe");
        entity.setBankName("qwe");
        entity.setCreateTime(new Date());
        blockBankCardService.saveBlockBankCard(entity);
    }

    @RequestMapping("/bank/list")
    public Page listBank(){
        Map m = new HashMap();
        m.put("pageNumber",1);
        m.put("pageSize","1");
       return blockBankCardService.listBlockBankCard(m);
    }

    @RequestMapping("/redis/set")
    public String setRedis(String key,String value){
        stringRedisTemplate.opsForValue().set(key,value);
        return stringRedisTemplate.opsForValue().get(key);
    }
}

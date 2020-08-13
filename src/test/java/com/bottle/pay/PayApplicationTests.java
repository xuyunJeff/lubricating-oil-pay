package com.bottle.pay;

import com.bottle.pay.modules.api.service.BillOutService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;

@SpringBootTest
@Slf4j
class PayApplicationTests {

    @Autowired
    BillOutService service;

    @Test
    void contextLoads() {

            for (int i = 0; i < 1000; i++) {
//            service.incrUserBillOutBalance(106L, BigDecimal.valueOf(0.01));
//            service.incrUserBillOutBalance(104L, BigDecimal.valueOf(0.01));
//            service.incrUserBillOutBalance(103L, BigDecimal.valueOf(0.01));
//            service.incrUserBillOutBalance(102L, BigDecimal.valueOf(0.01));
        }

    }

}

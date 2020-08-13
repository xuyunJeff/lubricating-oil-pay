package com.bottle.pay;

import com.bottle.pay.modules.api.service.BillOutService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class PayApplicationTests {

    @Autowired
    BillOutService service;
    @Test
    void contextLoads() {
       String value = service.generateBillOutBillId("106");
    }

}

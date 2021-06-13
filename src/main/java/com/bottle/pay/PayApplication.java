package com.bottle.pay;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.TimeZone;

@Slf4j
@SpringBootApplication
public class PayApplication {

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(PayApplication.class);
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Shanghai"));
        application.setBannerMode(Banner.Mode.OFF);
        application.run(args);
        log.info("The bottle_pay application has been started successfully!");
    }

}

package com.bottle.pay.modules.sys.controller;

import com.bottle.pay.modules.sys.service.IMailService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.mail.MessagingException;

/**
 * Created by zhy on 2020/8/13.
 */

//@Slf4j
//@RestController
//@RequestMapping("/test")
public class TestController {

    @Autowired
    private IMailService mailService;


    @RequestMapping("/mail")
    public void  sendMail(String to,String subject,String content){
        try {
            mailService.sendAttachmentMail(to,subject,content,"");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}



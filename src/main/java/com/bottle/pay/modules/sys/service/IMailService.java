package com.bottle.pay.modules.sys.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;

/**
 * Created by zhy on 2020/8/12.
 */

@Component
public class IMailService {

    @Value("${spring.mail.username}")
    private  String from;

    @Autowired
    JavaMailSender javaMailSender;

    public void sendAttachmentMail(String to ,String subject,String content,String filePath)throws MessagingException {
//        MimeMessage mimeMessage=javaMailSender.createMimeMessage();
//        MimeMessageHelper mimeMessageHelper=new MimeMessageHelper(mimeMessage,true);
//        mimeMessageHelper.setFrom(from);
//        mimeMessageHelper.setTo(to);
//        mimeMessageHelper.setSubject(subject);
//        mimeMessageHelper.setText(content,true);
//        FileSystemResource fileSystemResource=new FileSystemResource(new File(filePath));
//        String fileName=fileSystemResource.getFilename();
//        mimeMessageHelper.addAttachment(fileName,fileSystemResource);
//        javaMailSender.send(mimeMessage);


        SimpleMailMessage simpleMailMessage=new SimpleMailMessage();
        simpleMailMessage.setFrom(from);
        simpleMailMessage.setTo(to);
        simpleMailMessage.setSubject(subject);
        simpleMailMessage.setText(content);
        javaMailSender.send(simpleMailMessage);
    }
}

package com.bottle.pay.common.utils;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.modules.api.entity.BillOutView;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Date;

/**
 * Created by William on 2018/3/19.
 */
@Component
@Slf4j
public class AESUtil {

    private final static int OUT_TIME = 1;

    /**
     * 加密
     *
     * @param content  需要加密的内容
     * @param password 加密密码 ,时间
     * @return
     */
    public static byte[] encrypt(String content, String password) throws Exception {
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
        random.setSeed(password.getBytes());
        kgen.init(128, random);
        SecretKey secretKey = kgen.generateKey();
        byte[] enCodeFormat = secretKey.getEncoded();
        SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
        Cipher cipher = Cipher.getInstance("AES");// 创建密码器
        cipher.init(Cipher.ENCRYPT_MODE, key);// 初始化
        byte[] byteContent = content.getBytes("utf-8");
        return cipher.doFinal(byteContent);
    }




    /**
     * 当前时间戳为密码进行编码AES
     * @param content
     * @return
     * @throws Exception
     */
    public static String encrypt2(String content) throws Exception {
        String time =String.valueOf(new Date().getTime());
        byte[] code =encrypt(content+time,time);
        return parseByte2HexStr(code)+time;
    }

    public static String encrypt1(String content , String pwd) throws Exception {
        byte[] code =encrypt(content,pwd);
        return parseByte2HexStr(code);
    }

    public static  String decrypt2(String content) {
        try {
            String pwd =content.substring(content.length()-13,content.length());
            byte[] codes =parseHexStr2Byte(content.substring(0,content.length()-13));
            //获取密码器
            byte[] schemaByte = AESUtil.decrypt(codes,pwd);
            String schema = new String(schemaByte);
            /*if(new Date().getTime() - Long.valueOf(pwd) > OUT_TIME*3600000){
                return "201";
            }*/
            return  schema.substring(0,schema.length()-13) ;
        }catch (Exception e){
            log.info(e.getMessage());
            log.error("schemaName error");
            throw new RRException("schemaName error");
        }
    }

    public static  String decrypt1(String content,String pwd ) {
        try {
            byte[] codes =parseHexStr2Byte(content);
            //获取密码器
            byte[] schemaByte = AESUtil.decrypt(codes,pwd);
            return  new String(schemaByte);
        }catch (Exception e){
            log.info(e.getMessage());
            log.error("schemaName error");
            throw new RRException("schemaName error");
        }
    }



    public static void main(String[] args) throws Exception{
//        String content =AESUtil.encrypt2("test");
        //System.out.println(content);
//        System.out.println(AESUtil.decrypt("B96390CDE4496DF913118AF5A5E4BD328DB33185CF7A6F7237FF2A865A57A03B1521785338526"));
        BillOutView billOutView = new BillOutView();
        billOutView.setMerchantName("106");
        billOutView.setMerchantId(4L);
        billOutView.setOrderNo("12316545233");
        billOutView.setPrice(SystemConstant.BIG_DECIMAL_HUNDRED);
        billOutView.setBankAccountName("1233");
        billOutView.setBankCardNo("1234566344333");
        billOutView.setBankName("中国银行");
        String pwd = "bb4ab7fd864d900a33906049dfba77de";
        // 第一步加密用数据库密码
        String value = AESUtil.encrypt1(GsonUtil.GsonString(billOutView),pwd)+"&"+pwd;
        // 第二步加密用时间，并把时间放在结尾
        String value2 = AESUtil.encrypt2(value);
        System.out.println("value2 ======  "+value2);
        System.out.println(value.equals(AESUtil.decrypt2(value2)));
//        System.out.println(value);
//        String[] valueMap = value.split("&");
//        System.out.println(Arrays.toString(valueMap));
//        BillOutView billOut =GsonUtil.GsonToBean(AESUtil.decrypt1(valueMap[0],valueMap[1]),BillOutView.class);
//        System.out.println(billOut);
    }
    /**
     * 解密
     *
     * @param content  待解密内容
     * @param password 解密密钥
     * @return
     */
    public static byte[] decrypt(byte[] content, String password) throws Exception {
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
        random.setSeed(password.getBytes());
        kgen.init(128, random);
        SecretKey secretKey = kgen.generateKey();
        byte[] enCodeFormat = secretKey.getEncoded();
        SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
        Cipher cipher = Cipher.getInstance("AES");// 创建密码器
        cipher.init(Cipher.DECRYPT_MODE, key);// 初始化
        byte[] result = cipher.doFinal(content);
        return result; // 解密
    }

    /**将二进制转换成16进制
     * @param buf
     * @return
     */
    public static String parseByte2HexStr(byte buf[]) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < buf.length; i++) {
            String hex = Integer.toHexString(buf[i] & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            sb.append(hex.toUpperCase());
        }
        return sb.toString();
    }

    /**将16进制转换为二进制
     * @param hexStr
     * @return
     */
    public static byte[] parseHexStr2Byte(String hexStr) {
        if (hexStr.length() < 1)
            return null;
        byte[] result = new byte[hexStr.length()/2];
        for (int i = 0;i< hexStr.length()/2; i++) {
            int high = Integer.parseInt(hexStr.substring(i*2, i*2+1), 16);
            int low = Integer.parseInt(hexStr.substring(i*2+1, i*2+2), 16);
            result[i] = (byte) (high * 16 + low);
        }
        return result;
    }
}

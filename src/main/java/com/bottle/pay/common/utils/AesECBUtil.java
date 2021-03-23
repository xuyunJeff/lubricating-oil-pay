package com.bottle.pay.common.utils;

import com.bottle.pay.modules.api.entity.BillOutView2;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.codec.binary.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.security.Key;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.Random;

@Slf4j
public class AesECBUtil {


    private static final String AESTYPE ="AES/ECB/PKCS5Padding";

    public static String encrypt(String keyStr, String plainText) {
        byte[] encrypt = null;
        try{
            Key key = generateKey(keyStr);
            Cipher cipher = Cipher.getInstance(AESTYPE);
            cipher.init(Cipher.ENCRYPT_MODE, key);
            encrypt = cipher.doFinal(plainText.getBytes());
        }catch(Exception e){
            e.printStackTrace();
        }
        return new String(Base64.encodeBase64(encrypt));
    }


    public static String decrypt(String keyStr, String encryptData) {
        byte[] decrypt = null;
        try{
            Key key = generateKey(keyStr);
            Cipher cipher = Cipher.getInstance(AESTYPE);
            cipher.init(Cipher.DECRYPT_MODE, key);
            decrypt = cipher.doFinal(Base64.decodeBase64(encryptData));
        }catch(Exception e){
            e.printStackTrace();
        }
        return new String(decrypt).trim();
    }

    private static Key generateKey(String key)throws Exception{
        try{
            SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
            return keySpec;
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }

    }

    public static BillOutView2 generateBill(String orderNo) {
        BillOutView2 billOutView = new BillOutView2();
        billOutView.setMerchantName("106");
        billOutView.setMerchantId(4L);
        billOutView.setOrderNo(orderNo);
        billOutView.setPrice(BigDecimal.ONE);
        billOutView.setBankAccountName("服务器派单测试");
        billOutView.setBankCardNo("1234566344333");
        billOutView.setBankName("中国银行");
        billOutView.setTimestamp(new Date().getTime());
        return billOutView;
    }

    public static String generateorderNo(int incrId) {
        String today = DateUtils.format(new Date(), DateUtils.DATE_PATTERN_1);
        Random random =new  Random();
        return random.nextInt( 99) + today + new DecimalFormat("00000").format(incrId) + random.nextInt( 99);
    }

    public static void main(String[] args) {

        String keyStr = "UITN25LMUQC436IM";
        BillOutView2 billOutView = generateBill(generateorderNo(1));
        String plainText = GsonUtil.GsonString(billOutView);
        String encText = encrypt(keyStr, plainText);
        String decString = decrypt(keyStr,encText);

        System.out.println(encText);
        System.out.println(decString);

    }
}

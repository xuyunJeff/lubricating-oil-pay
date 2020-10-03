package com.bottle.pay.common.utils;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.modules.api.entity.BillOutView;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigInteger;
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
     *
     * @param content
     * @return
     * @throws Exception
     */
    public static String encrypt2(String content) throws Exception {
        String time = String.valueOf(new Date().getTime());
        byte[] code = encrypt(content + time, time);
        return parseByte2HexStr(code) + time;
    }

    public static String encrypt1(String content, String pwd) throws Exception {
        byte[] code = encrypt(content, pwd);
        return parseByte2HexStr(code);
    }

    public static String decrypt2(String content) {
        try {
            String pwd = content.substring(content.length() - 13, content.length());
            byte[] codes = parseHexStr2Byte(content.substring(0, content.length() - 13));
            byte[] schemaByte = AESUtil.decrypt(codes, pwd);
            String schema = new String(schemaByte);
            return schema.substring(0, schema.length() - 13);
        } catch (Exception e) {
            log.info(e.getStackTrace().toString());
            log.error("时间解密错误");
            throw new RRException("时间解密错误");
        }
    }

    public static String decrypt1(String content, String pwd) {
        try {
            byte[] codes = parseHexStr2Byte(content);
            //获取密码器
            byte[] schemaByte = AESUtil.decrypt(codes, pwd);
            return new String(schemaByte);
        } catch (Exception e) {
            log.info(e.getStackTrace().toString());
            log.error("密钥解密错误");
            throw new RRException("密钥解密错误");
        }
    }

    public static String encryptBillOutView(BillOutView billOutView, String pwd, String username) throws Exception {
        String value = AESUtil.encrypt1(GsonUtil.GsonString(billOutView), pwd) + "&" + username;
        return AESUtil.encrypt2(value);
    }


    public static void main(String[] args) throws Exception {
//        String content =AESUtil.encrypt2("test");
        //System.out.println(content);
        System.out.println(AESUtil.decrypt2("915881C3B53BF7E6B8DBD8489F156272F9EBD0118C053B75AD02B46F3CF6A8F2475A18E6A22B80772AFB8A90FD1BC03730F191E079FBA64C34D3EFD37827CF4987C5D14A7F3844FE84E86CE2C1F2355FC22C876A6F172EA6C53EA5F04D7CCE416F85120AAD9A679FA6808A0398D7ECB09AE33B0ED08767AD0635F2B40FC6065C3E443766C6E26F88E61BC8B872DE98B6655F4180B938A756BE097AA721BCEC9A57E5EAA0D6CA1B173544A42C9FEBE40AE41D0D2F6858071F1A074A904CD698F6EB6F53C056DD35D1DB067A4204B13EFF1E04D07ED5E121FAECA04F214CBDC2C1F0D257CA7C4435B48BC0DD9D74D5EE3DDBD59C373F34D6F4DEC87AAFCCB1CF2643D39A49F8741710AB99AC940722C77F40825B5EC5A01BD2303F3D9B6E7998E0AF638CB03CADBB86AEE9E84201FC5DEB012DDCE132DD414E1858E7E6ABF5E54B95F399F3CC042B88BC55878B78D664BEDF9E718DEDCDC40115C33A0AEFA5DB6C99B15D67AC624E102EF435FE529015144EFDB4032CC715C8502B832F2C2D32C5231EDBA71F519924836884D3A5A536DD0DE26A17A6DB3D656A859793502EBB301601655676231"));
//        BillOutView billOutView = new BillOutView();
//        billOutView.setMerchantName("106");
//        billOutView.setMerchantId(4L);
//        billOutView.setOrderNo("12316545233");
//        billOutView.setPrice(SystemConstant.BIG_DECIMAL_HUNDRED);
//        billOutView.setBankAccountName("服务器派单测试");
//        billOutView.setBankCardNo("1234566344333");
//        billOutView.setBankName("中国银行");
//        String pwd = "bb4ab7fd864d900a33906049dfba77de";
//        // 第一步加密用数据库密码
//        String value = AESUtil.encrypt1(GsonUtil.GsonString(billOutView),pwd)+"&"+pwd;
//        System.out.println("value ======  "+value);
//        // 第二步加密用时间，并把时间放在结尾
//        String value2 = AESUtil.encrypt2(value);
//        System.out.println("value2 ======  "+value2);
//        System.out.println(value.equals(AESUtil.decrypt2(value2)));
//        String[] valueMap = AESUtil.decrypt2(value2).split("&");
//        System.out.println(Arrays.toString(valueMap));
//        BillOutView billOut =GsonUtil.GsonToBean(AESUtil.decrypt1(valueMap[0],valueMap[1]),BillOutView.class);
//        System.out.println(billOut);
//         String param =AESUtil.encryptBillOutView(billOutView,"0fc87f4157c67bbe47dd596d9ac63355","106Server");
//        System.out.println(param);
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

    /**
     * 将二进制转换成16进制
     *
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

    /**
     * 将16进制转换为二进制
     *
     * @param hexStr
     * @return
     */
    public static byte[] parseHexStr2Byte(String hexStr) throws Exception{
        try {
            if (hexStr.length() < 1)
                return null;
            byte[] result = new byte[hexStr.length() / 2];
            for (int i = 0; i < hexStr.length() / 2; i++) {
                int high = Integer.parseInt(hexStr.substring(i * 2, i * 2 + 1), 16);
                int low = Integer.parseInt(hexStr.substring(i * 2 + 1, i * 2 + 2), 16);
                result[i] = (byte) (high * 16 + low);
            }
            return result;
        }catch (Exception e){
            log.error("hexStr:"+hexStr);
            log.error(e.getStackTrace().toString());
            log.error("将16进制转换为二进制错误");
        }
        throw new Exception("将16进制转换为二进制错误");
    }
}

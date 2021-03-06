package com.bottle.pay.common.utils;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Base32;
import org.apache.commons.codec.binary.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;


@Slf4j
public class GoogleGenerator {

    public static final int SECRET_SIZE = 10;

    public static final String SEED = "fooabrbalabala";

    public static String generateSecretKey() {
        SecureRandom sr = null;
        try {
            sr = SecureRandom.getInstance("SHA1PRNG");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        sr.setSeed(Base64.decodeBase64(SEED));
        byte[] buffer = sr.generateSeed(SECRET_SIZE);
        Base32 codec = new Base32();
        byte[] bEncodedKey = codec.encode(buffer);
        return new String(bEncodedKey);
    }

    public static String getQRBarcode(String user, String secret) {
         String format = "otpauth://totp/%s?secret=%s";
         return String.format(format, user, secret);
    }

    /**
     * 核对输入的验证码
     * @param key
     * @param t
     * @return
     * @throws NoSuchAlgorithmException
     * @throws InvalidKeyException
     */
    public static int generateCode(byte[] key, long t) throws NoSuchAlgorithmException, InvalidKeyException {
        byte[] data = new byte[8];
        long value = t;
        for (int i = 8; i-- > 0; value >>>= 8) {
            data[i] = (byte) value;
        }
        SecretKeySpec signKey = new SecretKeySpec(key, "HmacSHA1");
        Mac mac = Mac.getInstance("HmacSHA1");
        mac.init(signKey);
        byte[] hash = mac.doFinal(data);
        int offset = hash[20 - 1] & 0xF;
        // We're using a long because Java hasn't got unsigned int.
        long truncatedHash = 0;
        for (int i = 0; i < 4; ++i) {
            truncatedHash <<= 8;
            // We are dealing with signed bytes:
            // we just keep the first byte.
            truncatedHash |= (hash[offset + i] & 0xFF);
        }
        truncatedHash &= 0x7FFFFFFF;
        truncatedHash %= 1000000;
        return (int) truncatedHash;
    }

    /**
     * 最多可偏移的时间
     * default 3 - max 17
     */
   private static final int window_size = 2;

    public static boolean check_code(String secret, long code, long timeMsec) {
        Base32 codec = new Base32();
        byte[] decodedKey = codec.decode(secret);
        long t = (timeMsec / 1000L) / 30L;
        for (int i = -window_size; i <= window_size+1; ++i) {
            long hash;
            try {
                hash = generateCode(decodedKey, t + i);
                log.info(String.valueOf(hash));
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException(e.getMessage());
            }
            if (hash == code) {
                return true;
            }
        }
        return false;
    }


    public static void main(String[] args) {
//        byte[] key = new Base32().decode("H3GKOORXVD76URAB");
        String sercure = generateSecretKey();
        byte[] key = new Base32().decode(sercure);
//        1614962495000;
//        1614962805890
        long millies = System.currentTimeMillis();
        System.out.println(millies);
        long t = (millies / 1000L) / 30L;
        int code = 0;
        try {
            code = GoogleGenerator.generateCode(key, t);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        }
        boolean checked=check_code(sercure,code,millies);
        System.out.println(checked);
    }

}

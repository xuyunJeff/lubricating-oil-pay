package com.bottle.pay.common.constant;

public class BusinessConstant {

    public static final String BUSINESS_ONLINE_POSITION = "business:online:position";

    public interface BusinessRedisKey {
        static String onlinePosition(Long merchantId) {
            return BUSINESS_ONLINE_POSITION +":"+merchantId;
        }
    }
}

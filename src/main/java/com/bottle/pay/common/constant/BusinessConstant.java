package com.bottle.pay.common.constant;

public class BusinessConstant {

    public static final String BUSINESS_ONLINE_POSITION = "business:online:position";

    public interface BusinessRedisKey {
        public static String onlinePosition(Long orgId) {
            return BUSINESS_ONLINE_POSITION + ":" + orgId;
        }
    }
}

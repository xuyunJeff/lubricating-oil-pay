package com.bottle.pay.common.constant;

import lombok.Getter;

/**
 * Created by zhy on 2020/8/14.
 */
public class IPConstant {

    private static final String C_IP_KEY = "ip:c:%s:%s";
    private static final String S_IP_KEY = "ip:s:%s:%s";


    /**
     * 根据商户ID,以及IP类型获取商户管理登陆白名单
     *
     * @param merchantId
     * @param type
     * @return
     */
    public static String getClientIpWhiteListCacheKey(long merchantId, int type) {
        return String.format(C_IP_KEY, merchantId, type);
    }

    /**
     *  根据商户ID,以及IP类型获取商户服务器白名单
     *
     * @param merchantId
     * @param type
     * @return
             */
    public static String getServerIpWhiteListCacheKey(long merchantId, int type) {
        return String.format(S_IP_KEY, merchantId, type);
    }

    @Getter
    public enum MerchantIPEnum {
        SERVER(1, "商户服务器"),
        ADMIN(2, "商户后台");
        int code;
        String desc;

        MerchantIPEnum(int code, String desc) {
            this.code = code;
            this.desc = desc;
        }
    }

}

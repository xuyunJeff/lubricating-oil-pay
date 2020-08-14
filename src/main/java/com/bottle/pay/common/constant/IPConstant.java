package com.bottle.pay.common.constant;

import lombok.Getter;

/**
 * Created by zhy on 2020/8/14.
 */
public class IPConstant {

    public static final String IP_KEY = "ip:%s:%s";


    /**
     * 根据商户ID,以及IP类型获取商户白名单
     * @param merchantId
     * @param type
     * @return
     */
    public static String getIpWhiteListCacheKey(long merchantId,int type){
        return String.format(IP_KEY,merchantId,type);
    }

    @Getter
    public enum MerchantIPEnum{
        SERVER(1,"商户服务器"),
        ADMIN(2,"商户后台");
        int code;
        String desc;
        MerchantIPEnum(int code,String desc){
            this.code = code;
            this.desc = desc;
        }
    }

}

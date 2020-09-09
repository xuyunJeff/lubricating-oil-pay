package com.bottle.pay.common.constant;

import lombok.AllArgsConstructor;

public class BillConstant {

    public static final String BILL_OUT_ID = "bill:out";

    public static final String BILL_IN_ID = "bill:in";
    // 代付中余额
    public static final String BILL_OUT_BUSINESS_BALANCE = "bill:out:balance";

    public static final String BILL_OUT_MERCHANT_BALANCE_LOCAK ="bill:out:merchant:balanc:lock";

    public static final String BILL_OUT_BUSINESS_BALANCE_LOCAK ="bill:out:business:balanc:lock";

    public static final Integer WHITE_IP_TYPE_SERVER  =1;

    public static final Integer WHITE_IP_TYPE_ADMIN  =2;

    public interface BillRedisKey {
        static String billOutBusinessBalance(String businessId) {
            return BILL_OUT_BUSINESS_BALANCE + ":" + businessId;
        }

        static String billOutId(String merchantId, String today) {
            return BILL_OUT_ID + ":" + today + ":" + merchantId;
        }

        static String billInId(String merchantId, String today) {
            return BILL_IN_ID + ":" + today + ":" + merchantId;
        }
    }


    @AllArgsConstructor
    public enum BillStatusEnum {
        UnPay(1, "未支付"), Success(2, "成功"), Failed(3, "失败");

        private final Integer code;
        private final String msg;

        public Integer getCode() {
            return code;
        }

        public String getMsg() {
            return msg;
        }

    }

    @AllArgsConstructor
    public enum BillNoticeEnum {
        NotNotice(1, "未通知"), Noticed(2, "已通知"), NoticeFailed(3, "通知失败");

        private final Integer code;
        private final String msg;

        public Integer getCode() {
            return code;
        }

        public String getMsg() {
            return msg;
        }

    }

    @AllArgsConstructor
    public enum BillTypeEnum {
        ByHuman(1, "手动"), Auto(2, "自动"), HighPrice(3, "大额"), GoBackAgent(4, "订单退回机构");

        private final Integer code;
        private final String msg;

        public Integer getCode() {
            return code;
        }

        public String getMsg() {
            return msg;
        }

    }

    @AllArgsConstructor
    public enum BillPostionEnum {
        Agent(1, "机构"), Business(2, "出款员");

        private final Integer code;
        private final String msg;

        public Integer getCode() {
            return code;
        }

        public String getMsg() {
            return msg;
        }

    }

}


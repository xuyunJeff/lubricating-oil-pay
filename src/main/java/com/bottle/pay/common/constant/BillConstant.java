package com.bottle.pay.common.constant;

import lombok.AllArgsConstructor;

public class BillConstant {

    public static final String BILL_OUT_ID = "bill:out";

    public static final String BILL_IN_ID = "bill:in";
    // 代付中余额
    public static final String BILL_OUT_BUSINESS_BALANCE = "bill:out:balance";

    public static final String BILL_OUT_MERCHANT_BALANCE_LOCK ="bill:out:merchant:balance:lock";

    public static final String BILL_BUSINESS_BALANCE_LOCK ="bill:business:balance:lock";

    public static final String BILL_OUT_BUSINESS_BANK_BALANCE_LOCK ="bill:out:business:bank:balance:lock";

    public static final String BILL_OUT_BUSINESS_CHANGE_TO_SUCCESS_LOCK ="bill:out:business:chang:success:lock";

    public static final String REPORT_BUSINESS ="report:business:lock";

    public static final String LAST_NEW_ORDER ="bill:out:lastNewOrder";

    public static final Integer WHITE_IP_TYPE_SERVER  = 1;

    public static final Integer WHITE_IP_TYPE_ADMIN  = 2;

    public interface BillRedisKey {
        static String billOutBusinessBalance(String businessId) {
            return BILL_OUT_BUSINESS_BALANCE + ":" + businessId;
        }

        static String billOutId(String merchantId, String today) {
            return BILL_OUT_ID + ":" + today + ":" + merchantId;
        }

        static String billOutLastOrder( Long id,Long orgId, Long businessId) {
            return LAST_NEW_ORDER +":"+ id + ":" + orgId + ":" + businessId;
        }

        static String billInId(String merchantId, String today) {
            return BILL_IN_ID + ":" + today + ":" + merchantId;
        }
    }


    @AllArgsConstructor
    public enum BillStatusEnum {
        UnPay(1, "未支付"), Success(2, "成功"), Failed(3, "失败"),BALANCE_ZERO(4,"账户余额不足");

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

    @AllArgsConstructor
    public enum BillNoticeResponse {
        NotExists(-1, "订单不存在"), Success(0, "成功,已作废订单"), NoMtch(-2, "订单存在但金额不匹配"), Failed(500, "未知异常"),SuccessPaid(0, "成功,已确认出款");

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
    public enum BillInPlayerType {
        Alipay(1, "支付宝转账"),
        AlipayQR(2, "支付宝扫码"),
        BankCard(3, "银行卡转账"),
        WeChatQR(4, "微信扫码"),
        WeChat(5, "微信好友转账"),
        BankCardQR(6,"银联扫码");

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


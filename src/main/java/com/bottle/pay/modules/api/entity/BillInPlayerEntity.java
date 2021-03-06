package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import java.util.Date;
import javax.persistence.Table;
import lombok.ToString;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;


@Data
@AllArgsConstructor
@Table(name = "bill_in_player")
@ToString
@NoArgsConstructor
public class BillInPlayerEntity extends BottleBaseEntity {

	
	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 订单号：商户id+时间戳 + 4位自增
	 */
	private String billId;
	
	/**
	 * 第三方订单号
	 */
	private String thirdBillId;
	
	/**
	 * 第三方订单派发服务器ip
	 */
	private String ip;
	
	/**
	 * 收款专员姓名
	 */
	private String businessName;
	
	/**
	 * 收款专员ID
	 */
	private Integer businessId;
	
	/**
	 * 收款的卡号(或二维码地址)
	 */
	private String businessBankCardNo;
	
	/**
	 * 银行名称(Alipay,WechatPay)
	 */
	private String businessBankName;
	
	/**
	 * 订单状态：  1未支付 2 成功 3 失败
	 */
	private Integer billStatus;
	
	/**
	 * 账单金额
	 */
	private BigDecimal price;
	
	/**
	 * 付款用户名
	 */
	private String playerAccountName;
	
	/**
	 * 
	 */
	private String comment;
	
	/**
	 * 支付方式
	 */
	private BillConstant.BillInPlayerType billInPlayerType;
	

}

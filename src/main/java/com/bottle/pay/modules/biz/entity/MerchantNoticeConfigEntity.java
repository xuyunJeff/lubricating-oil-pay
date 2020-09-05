package com.bottle.pay.modules.biz.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import javax.persistence.Table;
import lombok.ToString;
import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@Table(name = "merchant_notice_config")
@ToString
@NoArgsConstructor
public class MerchantNoticeConfigEntity extends BottleBaseEntity {

	public static final String[] DEFAULT_PARAMS = {"billId","price","billStatus","merchantId"};

	public static final String SPLIT_CHAR = ",";
	
	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 回调地址
	 */
	private String noticeUrl;
	
	/**bill_out
	 * 回调参数，多个用逗号隔开
	 */
	private String noticeParams;
	

}

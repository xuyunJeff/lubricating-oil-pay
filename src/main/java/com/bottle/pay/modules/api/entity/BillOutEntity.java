package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Table;
import java.math.BigDecimal;



@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "bill_out")
public class BillOutEntity extends BottleBaseEntity {

	/**
	 *
	 * @param billId 订单号：商户id+时间戳 + 5位自增
	 */
	public BillOutEntity(String billId) {
		this.billId = billId;
	}

	/**
	 * 商户名
	 */
	private String merchantName;
	
	/**
	 * 商户ID
	 */
	private Long merchantId;
	
	/**
	 * 订单号：商户id+时间戳 + 5位自增
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
	 * 付款专员姓名
	 */
	private String businessName;
	
	/**
	 * 付款专员ID
	 */
	private Long businessId;
	
	/**
	 * 订单状态：  1未支付 2 成功 3 失败
	 */
	private Integer billStatus;
	
	/**
	 * 回调：1未通知 2 已通知 3 失败
	 */
	private Integer notice;
	
	/**
	 * 账单金额
	 */
	private BigDecimal price;
	
	/**
	 * 付款会员的卡号
	 */
	private String bankCardNo;
	
	/**
	 * 银行名称
	 */
	private String bankName;
	
	/**
	 * 付款用户名
	 */
	private String bankAccountName;
	
	/**
	 * 1 手动 2 自动 3 大额 4 订单退回机构
	 */
	private Integer billType;

	/**
	 * 1: 机构 2：出款员
	 */
	private Integer position;

	/**
	 * 出款员的当前开启卡号
	 */
	private String businessBankCardNo;

	/**
	 * 出款员的当前开启银行名称
	 */
	private String businessBankName;

	/**
	 * 出款员的当前开启银行卡用户名
	 */
	private String businessBankAccountName;



    /**
     * BillOutEntity.toString()
     */
    @Override
    public String toString() {
        return "BillOutEntity{" +
               "id='" + id + '\'' +
               ", createTime='" + createTime + '\'' +
               ", lastUpdate='" + lastUpdate + '\'' +
               ", merchantName='" + merchantName + '\'' +
               ", merchantId='" + merchantId + '\'' +
               ", billId='" + billId + '\'' +
               ", thirdBillId='" + thirdBillId + '\'' +
               ", ip='" + ip + '\'' +
               ", businessName='" + businessName + '\'' +
               ", businessId='" + businessId + '\'' +
               ", billStatus='" + billStatus + '\'' +
               ", notice='" + notice + '\'' +
               ", price='" + price + '\'' +
               ", bankCardNo='" + bankCardNo + '\'' +
               ", bankName='" + bankName + '\'' +
               ", bankAccountName='" + bankAccountName + '\'' +
               ", billType='" + billType + '\'' +
               ", orgId='" + orgId + '\'' +
               ", orgName='" + orgName + '\'' +
				", position='" + position + '\'' +
               '}';
    }

}

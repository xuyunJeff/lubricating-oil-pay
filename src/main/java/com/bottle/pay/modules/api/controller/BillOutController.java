package com.bottle.pay.modules.api.controller;

import java.util.Map;
import java.util.Optional;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.api.service.OnlineBusinessService;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;

import javax.servlet.http.HttpServletRequest;


@RestController
@RequestMapping("/apiV1/billOut")
public class BillOutController extends AbstractController {
	
	@Autowired
	private BillOutService billOutService;

	@Autowired
	private OnlineBusinessService onlineBusinessService;

	@Autowired
	private BlockBankCardService blockBankCardService;

	/**
	 * 列表
	 * TODO 查询时要判断角色还有机构 @rmi
	 * @param params
	 * @return
	 */
	@RequestMapping("/list")
	public Page<BillOutEntity> list(@RequestBody Map<String, Object> params) {
		return billOutService.listEntity(params);
	}


	@SysLog("后端派单")
	@PostMapping("/push/order")
	public R pushOrder(@RequestBody BillOutView billOutView, HttpServletRequest request){
		SysUserEntity userEntity =	getUser();
		//FIXME 使用系统的  WebUtils.getIpAddr()
		String ip =request.getRemoteAddr();
		// 第一步保存订单,派单给机构
		BillOutEntity bill =billOutService.billsOutAgent(billOutView,ip,userEntity);
		// FIXME 判断银行卡是否在黑名单内 @mighty
		if(existBlockCard(billOutView.getBankCardNo(),userEntity.getOrgId())){
			return R.error("银行卡已被拉黑");
		}
		if(bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())){
			// 自动派单给出款员
			billOutService.billsOutBusiness(bill);
		}
		return R.ok().put("price",bill.getPrice()).put("orderNo",bill.getThirdBillId()).put("billOutId",bill.getBillId());
	}

	@SysLog("人工派单接口")
	@GetMapping("/appoint/human")
	public R arrangeBillsOutBusinessByHuman(Long businessId,String billId ){
		SysUserEntity userEntity =	getUser();
		if(!SystemConstant.RoleEnum.Organization.getCode().equals(userEntity.getRoleId())) return R.error("必须的机构管理员才能派单");
		BillOutEntity bill = billOutService.selectOne (new BillOutEntity(billId));
		if( !userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
		// 判断出款员是否在线
		OnlineBusinessEntity onlineBusinessEntity =onlineBusinessService.getOnlineBusiness(businessId,userEntity.getOrgId());
		if(null == onlineBusinessEntity) return R.error("所选出款员不在线");
		billOutService.billsOutBusinessByHuman(bill,onlineBusinessEntity);
		return R.ok("人工派单成功->"+onlineBusinessEntity.getBusinessName());
	}

	@SysLog("出款员订单回退到机构")
	@GetMapping("/bill/goBackOrg")
	public R billsOutBusinessGoBack(String billId){
		SysUserEntity userEntity =	getUser();
		BillOutEntity bill = billOutService.selectOne (new BillOutEntity(billId));
		if( !userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
		if(! bill.getPosition().equals(BillConstant.BillPostionEnum.Business.getCode()))  return R.error("订单无需退回");
		bill = billOutService.billsOutBusinessGoBack(bill);
		return R.ok("订单回退成功，机构："+ bill.getOrgName());
	}

	@SysLog("出款员订单确认出款成功")
	@GetMapping("/bill/success")
	public R billsOutSuccess(String billId){
		SysUserEntity userEntity =	getUser();
		BillOutEntity bill = billOutService.selectOne (new BillOutEntity(billId));
		if( !userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
		if(! bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode()))  return R.error("订单无需确认");
		bill =billOutService.billsOutPaidSuccess(bill);
		return R.ok("订单确认成功，会员银行卡名："+ bill.getBankAccountName());
	}

	@SysLog("出款员作废订单")
	@GetMapping("/bill/failed")
	public R billsOutFailed(String billId){
		SysUserEntity userEntity =	getUser();
		BillOutEntity bill = billOutService.selectOne (new BillOutEntity(billId));
		if( !userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
		if(! bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode()))  return R.error("订单无需作废");
		billOutService.billsOutPaidFailed(bill);
		return R.ok("订单作废，会员银行卡名："+ bill.getBankAccountName());
	}

	/**
	 * 判断是否存在银行卡黑名单
	 * @param bankCardNo
	 * @param orgId
	 * @return
	 */
	private boolean existBlockCard(String bankCardNo, Long orgId) {
		// TODO @mighty  SELECT id,create_time,last_update,org_id,org_name,bank_card_no,bank_name,bank_account_name  FROM block_bank_card  WHERE  org_id = ? AND bank_card_no = ?
		//### Cause: java.sql.SQLSyntaxErrorException: Unknown column 'last_update' in 'field list'
		//; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column 'last_update' in 'field list'
		BlockBankCardEntity query = new BlockBankCardEntity();
		query.setOrgId(orgId);
		query.setBankCardNo(bankCardNo);
		BlockBankCardEntity card =blockBankCardService.selectOne(query);
		return null != card;
	}
}

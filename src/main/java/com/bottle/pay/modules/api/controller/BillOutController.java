package com.bottle.pay.modules.api.controller;

import java.util.Map;
import java.util.Optional;

import com.bottle.pay.common.annotation.BillOut;
import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.api.service.OnlineBusinessService;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.service.BillOutService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;


@RestController
@RequestMapping("/apiV1/billOut")
public class BillOutController extends AbstractController {

    @Autowired
    private BillOutService billOutService;

    @Autowired
    private OnlineBusinessService onlineBusinessService;

    @Autowired
    private BlockBankCardService blockBankCardService;

    @Autowired
    private IpLimitService ipLimitService;

    @Autowired
    private SysUserService userService;
    /**
     * 列表
     * TODO 查询时要判断角色还有机构 @rmi
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BillOutEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            // 机构管理员查询机构下的所有数据
            params.put("orgId",userEntity.getOrgId());
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员查看自己的数据的所有数据
            params.put("orgId",userEntity.getOrgId());
            params.put("businessId",userEntity.getUserId());
        }
        return billOutService.listEntity(params);
    }


    @SysLog("后台管端派单")
    @RequestMapping("/push/order")
    public R pushOrder(@RequestBody BillOutView billOutView, HttpServletRequest request) {
        SysUserEntity userEntity = getUser();
        String ip = WebUtils.getIpAddr();
        if(!userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) return R.error("角色越权");
        // 第一步保存订单,派单给机构
        BillOutEntity bill = billOutService.billsOutAgent(billOutView, ip, userEntity);
        if (existBlockCard(billOutView.getBankCardNo(), userEntity.getOrgId())) {
            return R.error("银行卡已被拉黑");
        }
        if (bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())) {
            // 自动派单给出款员
            billOutService.billsOutBusiness(bill);
        }
        return R.ok().put("price", bill.getPrice()).put("orderNo", bill.getThirdBillId()).put("billOutId", bill.getBillId());
    }


    @SysLog("商户服务器管端派单")
    @RequestMapping("/push/order/server")
    public R pushOrderServer(@BillOut BillOutView billOutView) {
        String ip = WebUtils.getIpAddr();
        SysUserEntity merchant = userService.getUserEntityById(billOutView.getMerchantId());
        Boolean isWhite = ipLimitService.isWhiteIp(ip,billOutView.getMerchantId(),merchant.getOrgId(),BillConstant.WHITE_IP_TYPE_SERVER);
        if(!isWhite) return R.error("ip未加白");
        // 第一步保存订单,派单给机构
        BillOutEntity bill = billOutService.billsOutAgent(billOutView, ip, merchant);
        if (existBlockCard(billOutView.getBankCardNo(), merchant.getOrgId())) {
            return R.error("银行卡已被拉黑");
        }
        if (bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())) {
            // 自动派单给出款员
            billOutService.billsOutBusiness(bill);
        }
        return R.ok().put("price", bill.getPrice()).put("orderNo", bill.getThirdBillId()).put("billOutId", bill.getBillId());
    }


    @SysLog("人工派单接口")
    @RequestMapping("/appoint/human")
    public R arrangeBillsOutBusinessByHuman(@NotNull(message = "businessId 不能为空") Long businessId, @NotNull(message = "billId 不能为空")String billId) {
        SysUserEntity userEntity = getUser();
        if (!SystemConstant.RoleEnum.Organization.getCode().equals(userEntity.getRoleId()))
            return R.error("必须的机构管理员才能派单");
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if(bill.getPosition().equals(BillConstant.BillPostionEnum.Business.getCode())) return R.error("此订单已经派单");
        if(bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())) return R.error("此订单无需人工派单");
        // 判断出款员是否在线
        OnlineBusinessEntity onlineBusinessEntity = onlineBusinessService.getOnlineBusiness(businessId, userEntity.getOrgId());
        if (null == onlineBusinessEntity) return R.error("所选出款员不在线");

        billOutService.billsOutBusinessByHuman(bill, onlineBusinessEntity);
        return R.ok("人工派单成功->" + onlineBusinessEntity.getBusinessName());
    }

    @SysLog("出款员订单回退到机构")
    @RequestMapping("/bill/goBackOrg")
    public R billsOutBusinessGoBack(@NotNull(message = "billId 不能为空")String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getPosition().equals(BillConstant.BillPostionEnum.Business.getCode())) return R.error("订单无需退回");
        bill = billOutService.billsOutBusinessGoBack(bill);
        return R.ok("订单回退成功，机构：" + bill.getOrgName());
    }

    @SysLog("出款员订单确认出款成功")
    @RequestMapping("/bill/success")
    public R billsOutSuccess(@NotNull(message = "billId 不能为空")String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("订单无需确认");
        bill = billOutService.billsOutPaidSuccess(bill);
        // @TODO 通知商户 @mighty

        return R.ok("订单确认成功，会员银行卡名：" + bill.getBankAccountName());
    }

    @SysLog("出款员作废订单")
    @RequestMapping("/bill/failed")
    public R billsOutFailed(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("订单无需作废");
        billOutService.billsOutPaidFailed(bill);
        // @TODO 通知商户 @mighty
        return R.ok("订单作废，会员银行卡名：" + bill.getBankAccountName());
    }

    /**
     * 判断是否存在银行卡黑名单
     *
     * @param bankCardNo
     * @param orgId
     * @return
     */
    private boolean existBlockCard(String bankCardNo, Long orgId) {
        BlockBankCardEntity query = new BlockBankCardEntity();
        query.setOrgId(orgId);
        query.setBankCardNo(bankCardNo);
        BlockBankCardEntity card = blockBankCardService.selectOne(query);
        return null != card;
    }
}

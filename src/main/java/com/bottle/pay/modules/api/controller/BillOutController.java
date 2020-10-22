package com.bottle.pay.modules.api.controller;

import java.util.Map;

import com.bottle.pay.common.annotation.BillOut;
import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.modules.api.service.OnlineBusinessService;
import com.bottle.pay.modules.api.service.ReportBusinessService;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.biz.service.MerchantNoticeConfigService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import io.swagger.annotations.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
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
@Api(value = "出款页面", description = "出款页面")
@Slf4j
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

    @Autowired
    MerchantNoticeConfigService merchantNoticeConfigService;

    @Autowired
    ReportBusinessService reportBusinessService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping(value = "/list",method = {RequestMethod.GET,RequestMethod.POST})
    @ApiOperation(value = "出款订单列表")
    public Page<BillOutEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            // 机构管理员查询机构下的所有数据
            params.put("orgId",userEntity.getOrgId());
            return billOutService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员查看自己的数据的所有数据
            params.put("orgId",userEntity.getOrgId());
            params.put("businessId",userEntity.getUserId());
            params.put("position",BillConstant.BillPostionEnum.Business.getCode());
            return billOutService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            // 代付商户查看自己的数据的所有数据
            params.put("orgId",userEntity.getOrgId());
            params.put("merchantId",userEntity.getUserId());
            return billOutService.listEntity(params);
        }
        return new Page<>();
    }

    @RequestMapping("/lastNewOrder")
    public R lastNewOrder(@RequestParam(name = "id")  Long id ){
        SysUserEntity userEntity = getUser();
        Long lastId  = 0L ;
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            // 机构管理员查询机构下的所有数据
            lastId = billOutService.lastNewOrder(id,userEntity.getOrgId(),null);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员查看自己的数据的所有数据
            lastId = billOutService.lastNewOrder(id,userEntity.getOrgId(),userEntity.getUserId());
        }
        return R.ok().put("lastId",lastId);
    }

    @SysLog("商户服务器查询订单")
    @RequestMapping("/get/order")
    public R getOrder(@RequestParam(name = "orderNo",required = false) String orderNo,@RequestParam(name = "merchantId",required = false) Long merchantId) {
        if(StringUtils.isEmpty(orderNo)) return R.error(400,"orderNo不可为空");
        if(StringUtils.isEmpty(merchantId)) return R.error(400,"merchantId不可为空");
        BillOutEntity e = new BillOutEntity();
        e.setThirdBillId(orderNo);
        e.setMerchantId(merchantId);
        e = billOutService.selectOne(e);
        if(e == null ) return R.error(-1,"订单不存在");
        return R.ok().put("price", e.getPrice()).put("orderNo", e.getThirdBillId()).put("billOutId", e.getBillId()).put("billStatus",e.getBillStatus());
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
        if(!isWhite) {
            log.error("ip未加白:ip:"+ip);
            return R.error("ip未加白");
        }
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
        if (bill.getPosition().equals(BillConstant.BillPostionEnum.Agent.getCode())) return R.error("订单无需退回,该订单已经在机构");
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
        try {
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(),bill.getMerchantId(),billId);
        }catch (Exception e) {
            log.error("通知订单回调异常，BillOutEntity {}",bill);
        }
        try {
            reportBusinessService.calculateReportBusiness(bill);
        }catch (Exception e) {
            log.error("出款员汇总异常，BillOutEntity {}",bill);
        }
        BillOutEntity billFinal = billOutService.selectOne(new BillOutEntity(billId));
        return R.ok().put("bill",billFinal);
    }

    @SysLog("出款员作废订单")
    @RequestMapping("/bill/failed")
    public R billsOutFailed(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getNotice().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("该订单支付状态已经是最终状态不可作废");
        billOutService.billsOutPaidFailed(bill);
        try {
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(),bill.getMerchantId(),billId);
        }catch (Exception e) {
            log.error("出款员作废订单回调异常，BillOutEntity {}",bill);
        }
        return R.ok("订单作废，会员银行卡名：" + bill.getBankAccountName());
    }

    @SysLog("通知订单")
    @RequestMapping("/bill/notice")
    public R billsOutNotice(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("该订单未支付");
        if (bill.getNotice().equals(BillConstant.BillNoticeEnum.Noticed.getCode())) return R.error("该订单已通知");
        try {
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(),bill.getMerchantId(),billId);
        }catch (Exception e) {
            log.error("通知订单回调异常，BillOutEntity {}",bill);
        }
        return R.ok("已经重新发起通知,结果以表格为准,<div style='color:red'>一直失败请联系客户人工处理</div>;会员银行卡名：" + bill.getBankAccountName());
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

package com.bottle.pay.modules.api.controller;

import com.bottle.pay.common.annotation.BillOut;
import com.bottle.pay.common.annotation.BillOut2;
import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.support.config.Md5Util;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.common.utils.ExcelUtil;
import com.bottle.pay.common.utils.JSONUtils;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.entity.*;
import com.bottle.pay.modules.api.entity.csv.BillOutCsv;
import com.bottle.pay.modules.api.service.*;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.biz.service.MerchantNoticeConfigService;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import com.google.common.collect.Lists;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.supercsv.io.CsvBeanWriter;
import org.supercsv.io.ICsvBeanWriter;
import org.supercsv.prefs.CsvPreference;

import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

import static com.bottle.pay.common.utils.DateUtils.DATE_TIME_PATTERN;
import static java.util.Objects.nonNull;


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

    @Autowired
    ReportMerchantService reportMerchantService;

    @Autowired
    MerchantServerService merchantServerService;

    @Value("${excel.path.billout}")
    private String excelPath;
    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping(value = "/list", method = {RequestMethod.GET, RequestMethod.POST})
    @ApiOperation(value = "出款订单列表")
    public Page<BillOutEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())) {
            // 机构管理员查询机构下的所有数据
            params.put("orgId", userEntity.getOrgId());
            return billOutService.listEntity(params);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
            // 出款员查看自己的数据的所有数据
            params.put("orgId", userEntity.getOrgId());
            params.put("businessId", userEntity.getUserId());
            params.put("position", BillConstant.BillPostionEnum.Business.getCode());
            return billOutService.listEntity(params);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) {
            // 代付商户查看自己的数据的所有数据
            params.put("orgId", userEntity.getOrgId());
            params.put("merchantId", userEntity.getUserId());
            return billOutService.listEntity(params);
        }
        return new Page<>();
    }


    @RequestMapping(value = "/wap/list", method = {RequestMethod.GET, RequestMethod.POST})
    @ApiOperation(value = "出款订单列表")
    @ResponseBody
    public Page<BillOutEntity> listWap(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())) {
            // 机构管理员查询机构下的所有数据
            params.put("orgId", userEntity.getOrgId());
            return billOutService.listEntity(params);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
            // 出款员查看自己的数据的所有数据
            params.put("orgId", userEntity.getOrgId());
            params.put("businessId", userEntity.getUserId());
            params.put("position", BillConstant.BillPostionEnum.Business.getCode());
            return billOutService.listEntity(params);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) {
            // 代付商户查看自己的数据的所有数据
            params.put("orgId", userEntity.getOrgId());
            params.put("merchantId", userEntity.getUserId());
            return billOutService.listEntity(params);
        }
        return new Page<>();
    }

  /*  @RequestMapping(value = "/csv", method = RequestMethod.POST)
    public void bootPercentage(@RequestBody Map<String, Object> params, HttpServletResponse response) throws IOException {
        SysUserEntity userEntity = getUser();
        if (!userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode()))  throw new RRException("机构管理员才能下载报表");
        String current = DateUtils.format(new Date(),DateUtils.DATE_TIME_PATTERN_1);
        String fileName = URLEncoder.encode("统计表-" + current + ".csv", "UTF-8");
        params.put("pageSize",1000);
        List<BillOutEntity> bootPercentageList = this.list(params).getRows(); // 这是一个业务代码 返回我要导出去的数据
        List<Map<String, Object>> list = Lists.newArrayList();
        bootPercentageList.stream().forEach(it->{
            Map<String, Object> paramr = new HashMap<>();
            paramr.put("merchantName", it.getMerchantName());
            paramr.put("createTime", it.getCreateTime());
            paramr.put("businessId", it.getBusinessId());
            paramr.put("billStatus", it.getBillStatus() == 1 ?"未支付": it.getBillStatus() == 2?"成功":"失败");
            paramr.put("notice", it.getNotice() == 1?"未通知":it.getNotice() == 2?"已通知":"通知失败");
            paramr.put("price", it.getPrice());
            paramr.put("bankAccountName", it.getBankAccountName());
            paramr.put("bankCardNo", it.getBankCardNo());
            paramr.put("bankName", it.getBankName());
            paramr.put("businessName", it.getBusinessName());
            paramr.put("businessBank", it.getBusinessBankAccountName()+"-"+it.getBusinessBankCardNo()+"-"+it.getBusinessBankName());
            paramr.put("thirdBillId", it.getThirdBillId());
            paramr.put("billId", it.getBillId());
            list.add(paramr);
        });
        Workbook workbook = ExcelUtil.commonExcelExportList("mapList", excelPath, list);
        try {
            ExcelUtil.writeExcel(response, workbook, fileName);
        } catch (IOException e) {
            throw new RRException(e.getMessage());
        }
    }
*/
    @RequestMapping(value = "/csv", method = RequestMethod.GET)
    public void bootPercentage(@RequestParam Map<String, Object> params, HttpServletResponse response) throws IOException {
        params = JSONUtils.mapNoEmpty(params);
        SysUserEntity userEntity = getUser();
//        if (!userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode()))  throw new RRException("机构管理员才能下载报表");
        String current = DateUtils.format(new Date(),DateUtils.DATE_TIME_PATTERN_1);
        String filename = URLEncoder.encode("出款统计表-" + current + ".csv", "UTF-8");
        params.put("pageSize",1000);
        List<BillOutEntity> bootPercentageList = this.list(params).getRows(); // 这是一个业务代码 返回我要导出去的数据
        List<BillOutCsv> list = Lists.newArrayList();
        bootPercentageList.stream().forEach(it->{
            BillOutCsv csv = new BillOutCsv();
            csv.setMerchantName(it.getMerchantName());
            csv.setCreateTime(DateUtils.format(it.getCreateTime(),DATE_TIME_PATTERN));
            csv.setBillStatus(it.getBillStatus() == 1 ?"未支付": it.getBillStatus() == 2?"成功":"失败");
            csv.setNotice( it.getNotice() == 1?"未通知":it.getNotice() == 2?"已通知":"通知失败");
            csv.setPrice( it.getPrice());
            csv.setBankAccountName( it.getBankAccountName());
            csv.setBankCardNo("NO: "+ it.getBankCardNo());
            csv.setBankName( it.getBankName());
            csv.setBusinessName( it.getBusinessName());
            csv.setBusinessBank( (it.getBusinessBankAccountName()==null?"":it.getBusinessBankAccountName())+"-"+(it.getBusinessBankCardNo()==null?"":it.getBusinessBankCardNo())+"-"+(it.getBusinessBankName()==null?"":it.getBusinessBankName()));
            csv.setThirdBillId( "ThirdBillId:"+it.getThirdBillId());
            csv.setBillId( "BillId:"+it.getBillId());
            list.add(csv);
        });
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        // 防止乱码出现
        Writer writer = new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8);
        // 写入字节流，让文档以UTF-8编码
        writer.write('\uFEFF');
        ICsvBeanWriter csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE);
//        String[] header = {"商户名", "时间", "付款专员ID","订单状态","通知","账单金额","会员名","会员银行卡号","银行名称","付款专员姓名","付款银行卡","第三方订单号","订单号"};
        String[] header = {"merchantName","businessName", "createTime","billStatus","notice","price","bankAccountName","bankCardNo","bankName","businessBank","thirdBillId","billId"};
        csvWriter.writeHeader(header);

        for (BillOutCsv it : list) {
            csvWriter.write(it, header);
        }
        csvWriter.close();
    }

    @RequestMapping("/lastNewOrder")
    public R lastNewOrder(@RequestParam(name = "id") Long id) {
        SysUserEntity userEntity = getUser();
        Long lastId = 0L;
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())) {
            // 机构管理员查询机构下的所有数据
            lastId = billOutService.lastNewOrder(id, userEntity.getOrgId(), null);
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
            // 出款员查看自己的数据的所有数据
            lastId = billOutService.lastNewOrder(id, userEntity.getOrgId(), userEntity.getUserId());
        }
        return R.ok().put("lastId", lastId);
    }

    @SysLog("商户服务器查询订单")
    @RequestMapping("/get/order")
    public R getOrder(@RequestParam(name = "orderNo", required = false) String orderNo, @RequestParam(name = "merchantId", required = false) Long merchantId) {
        if (StringUtils.isEmpty(orderNo)) return R.error(400, "orderNo不可为空");
        if (StringUtils.isEmpty(merchantId)) return R.error(400, "merchantId不可为空");
        BillOutEntity e = new BillOutEntity();
        e.setThirdBillId(orderNo);
        e.setMerchantId(merchantId);
        e = billOutService.selectOne(e);
        if (e == null) return R.error(-1, "订单不存在");
        return R.ok().put("price", e.getPrice()).put("orderNo", e.getThirdBillId()).put("billOutId", e.getBillId()).put("billStatus", e.getBillStatus());
    }


    @SysLog("后台批量管端派单")
    @RequestMapping("/push/order/batch")
    public R pushOrderBatch(@RequestBody BillOutBatchVo billOutBatchVo) {
        SysUserEntity userEntity = getUser();
        String ip = WebUtils.getIpAddr();
        Boolean isWhite = ipLimitService.isWhiteIp(ip, userEntity.getUserId(), userEntity.getOrgId(), BillConstant.WHITE_IP_TYPE_SERVER);
        if (!isWhite) {
            log.error("ip未加白:ip:" + ip);
            return R.error("ip未加白");
        }
        if (!userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) return R.error("角色越权");
        if (StringUtils.isEmpty(userEntity.getBillAuto()) || userEntity.getBillAuto().equals(1)) {
            return R.error("该商户未开启手动出款");
        }
        if (getUser().getEnableGoogleKaptcha() == null && getUser().getEnableGoogleKaptcha().equals(0)) {
            return R.error("请开启谷歌验证码后再派发订单");
        }
        if (!userService.checkGoogleKaptcha(userEntity.getUsername(), billOutBatchVo.getGoogleCode())) {
            log.error("谷歌验证码错误,username: {}, code: {} ", userEntity.getUsername(), billOutBatchVo.getGoogleCode());
            return R.error("谷歌验证码错误");
        }
        billOutService.billOutBatchAgentByPerson(billOutBatchVo.getBillOutViewPersonList(), ip, userEntity);
        return R.ok("成功,已经接受订单.实际请查询页面");
    }

    @SysLog("商户服务器管端派单")
    @RequestMapping("/push/order/server")
    public R pushOrderServer(@BillOut BillOutView billOutView) {
        String ip = WebUtils.getIpAddr();
        SysUserEntity merchant = userService.getUserEntityById(billOutView.getMerchantId());
        Boolean isWhite = ipLimitService.isWhiteIp(ip, billOutView.getMerchantId(), merchant.getOrgId(), BillConstant.WHITE_IP_TYPE_SERVER);
        if (!isWhite) {
            log.error("ip未加白:ip:" + ip);
            return R.error("ip未加白");
        }
        if (StringUtils.isEmpty(billOutView.getOrderNo())) return R.error("订单号不存在");
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


    @SysLog("商户服务器管端派单")
    @RequestMapping("/push2/order/server")
    public R push2OrderServer2(@RequestBody BillOutView2 billOutView) {
        String ip = WebUtils.getIpAddr();
        SysUserEntity merchant = userService.getUserEntityById(billOutView.getMerchantId());
        Boolean isWhite = ipLimitService.isWhiteIp(ip, billOutView.getMerchantId(), merchant.getOrgId(), BillConstant.WHITE_IP_TYPE_SERVER);
        if (!isWhite) {
            log.error("ip未加白:ip:" + ip);
            return R.error("ip未加白");
        }
        if (!checkMd5Auth(billOutView)) return R.error("加解密错误, request params : " + billOutView.toString());
        if (StringUtils.isEmpty(billOutView.getOrderNo())) return R.error("订单号不存在");
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


    @SysLog("机构指定订单给出款员")
    @RequestMapping("/appoint/human")
    public R arrangeBillsOutBusinessByHuman(@NotNull(message = "businessId 不能为空") Long businessId, @NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        if (!SystemConstant.RoleEnum.Organization.getCode().equals(userEntity.getRoleId()))
            return R.error("必须的机构管理员才能派单");
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (bill.getPosition().equals(BillConstant.BillPostionEnum.Business.getCode())) return R.error("此订单已经派单");
        if (bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())) return R.error("此订单无需人工派单");
        // 判断出款员是否在线
        OnlineBusinessEntity onlineBusinessEntity = onlineBusinessService.getOnlineBusiness(businessId, userEntity.getOrgId());
        if (null == onlineBusinessEntity) return R.error("所选出款员不在线");
        billOutService.billsOutBusinessByHuman(bill, onlineBusinessEntity);
        return R.ok("人工派单成功->" + onlineBusinessEntity.getBusinessName());
    }

    @SysLog("出款员订单回退到机构")
    @RequestMapping("/bill/goBackOrg")
    public R billsOutBusinessGoBack(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (bill.getPosition().equals(BillConstant.BillPostionEnum.Agent.getCode())) return R.error("订单无需退回,该订单已经在机构");
        bill = billOutService.billsOutBusinessGoBack(bill);
        return R.ok("订单回退成功，机构：" + bill.getOrgName());
    }

    @SysLog("出款员订单确认出款成功")
    @RequestMapping("/bill/success")
    public R billsOutSuccess(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("订单无需确认");
        if (bill.getIsLock().equals(0)) return R.error("此订单未锁定,请锁定后出款");
        bill = billOutService.billsOutPaidSuccess(bill);
        try {
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(), bill.getMerchantId(), billId);
        } catch (Exception e) {
            log.error("通知订单回调异常，BillOutEntity {}", bill);
        }
        try {
            reportBusinessService.calculateReportBusiness(bill);
        } catch (Exception e) {
            log.error("出款员汇总异常，BillOutEntity {}", bill);
        }
        try {
            reportMerchantService.calculateReportMerchant(bill);
        } catch (Exception e) {
            log.error("商户汇总异常，BillOutEntity {}", bill);
        }
        BillOutEntity billFinal = billOutService.selectOne(new BillOutEntity(billId));
        return R.ok().put("bill", billFinal);
    }

    @SysLog("出款员作废订单")
    @RequestMapping("/bill/failed")
    public R billsOutFailed(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (!userEntity.getOrgId().equals(bill.getOrgId())) return R.error("订单不属于该机构");
        if (!bill.getNotice().equals(BillConstant.BillStatusEnum.UnPay.getCode())) return R.error("该订单支付状态已经是最终状态不可作废");
        if (bill.getIsLock().equals(0)) return R.error("此订单未锁定,请锁定后做法");
        billOutService.billsOutPaidFailed(bill);
        try {
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(), bill.getMerchantId(), billId);
        } catch (Exception e) {
            log.error("出款员作废订单回调异常，BillOutEntity {}", bill);
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
            merchantNoticeConfigService.sendNotice(userEntity.getOrgId(), bill.getMerchantId(), billId);
        } catch (Exception e) {
            log.error("通知订单回调异常，BillOutEntity {}", bill);
        }
        return R.ok("已经重新发起通知,结果以表格为准,<div style='color:red'>一直失败请联系客户人工处理</div>;会员银行卡名：" + bill.getBankAccountName());
    }

    @SysLog("锁定订单")
    @RequestMapping("/bill/lock")
    public R billsOutLock(@NotNull(message = "billId 不能为空") String billId) {
        SysUserEntity userEntity = getUser();
        BillOutEntity bill = billOutService.selectOne(new BillOutEntity(billId));
        if (bill.getIsLock().equals(1)) {
            return R.error("此订单已经锁定,请刷新列表");
        }
        if (!bill.getBillStatus().equals(BillConstant.BillStatusEnum.UnPay.getCode())) {
            return R.error("此订单已经出款成功或失败,请勿出款");
        }

        int i = billOutService.updateByBillOutToLock(new BillOutEntity(billId));
        if (i == 1) {
            bill = billOutService.selectOne(new BillOutEntity(billId));
            return R.ok("锁定成功").put("bill", bill);
        }
        if (i == 0) {
            return R.error("锁定失败,确认是否有人已经锁定");
        }
        return R.error("异常请联系技术");
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

    private boolean checkMd5Auth(BillOutView2 billOutView) {

        MerchantServerEntity merchantServerEntity = merchantServerService.billMerchangtServerByMerchantName(billOutView.getMerchantName(), billOutView.getMerchantId());
        SysUserEntity merchantServer = userService.getByUserName(merchantServerEntity.getSeverName());
        try {
            BillOutView2 billOutView2 = billOutView.clone();
            billOutView2.setSign(null);
            try {
                SortedMap<String, Object> parameters = new TreeMap<>(JSONUtils.beanToMap(billOutView));
                log.info("parameters : {}", parameters);
                String sign = Md5Util.createSign(parameters, merchantServer.getPassword());
                if (sign.equals(billOutView.getSign())) {
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        throw new RRException("加解密错误,sign不一致");
    }

}

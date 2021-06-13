package com.bottle.pay.modules.biz.controller;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.common.utils.JSONUtils;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.entity.csv.BillInCsv;
import com.bottle.pay.modules.api.entity.csv.BillOutCsv;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import com.bottle.pay.modules.biz.service.BillInService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;
import org.supercsv.io.CsvBeanWriter;
import org.supercsv.io.ICsvBeanWriter;
import org.supercsv.prefs.CsvPreference;

import javax.servlet.http.HttpServletResponse;

import static com.bottle.pay.common.utils.DateUtils.DATE_TIME_PATTERN;

/**
 *
 */
@RestController
@RequestMapping("/merchant/charge")
@Slf4j
public class BillInController extends AbstractController {

    @Autowired
    private BillInService billInService;

    /**
     * 列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BillInEntity> list(@RequestBody  Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            // 机构管理员查询机构下的所有数据
            params.put("orgId",userEntity.getOrgId());
            return billInService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            params.put("orgId",userEntity.getOrgId());
            params.put("merchantId",userEntity.getUserId());
            return billInService.listEntity(params);
        }
        if(userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员查看自己的数据的所有数据
            params.put("orgId",userEntity.getOrgId());
            params.put("businessId",userEntity.getUserId());
            return billInService.listEntity(params);
        }
        return new Page<>();
    }

    /**
     * 新增
     *
     * @param billIn
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BillInEntity billIn) {
        return billInService.addBillIn(billIn);
    }

    @SysLog("确认成功")
    @RequestMapping("/success")
    public R confirmSuccess(String billId,String comment){
        return billInService.confirmBillIn(billId,comment, BillConstant.BillStatusEnum.Success);
    }

    @SysLog("确认失败")
    @RequestMapping("/fail")
    public R confirmFail(String billId,String comment){
        return billInService.confirmBillIn(billId,comment, BillConstant.BillStatusEnum.Failed);
    }

    @RequestMapping(value = "/csv", method = RequestMethod.GET)
    public void bootPercentage(@RequestParam Map<String, Object> params, HttpServletResponse response) throws IOException {
        params = JSONUtils.mapNoEmpty(params);
        SysUserEntity userEntity = getUser();
//        if (!userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode()))  throw new RRException("机构管理员才能下载报表");
        String current = DateUtils.format(new Date(),DateUtils.DATE_TIME_PATTERN_1);
        String filename = URLEncoder.encode("充值统计表-" + current + ".csv", "UTF-8");
        params.put("pageSize",1000);
        List<BillInEntity> bootPercentageList = this.list(params).getRows(); // 这是一个业务代码 返回我要导出去的数据
        List<BillInCsv> list = Lists.newArrayList();
        bootPercentageList.stream().forEach(it->{
            BillInCsv csv = new BillInCsv();
            csv.setMerchantName(it.getMerchantName());
            csv.setCreateTime(DateUtils.format(it.getCreateTime(),DATE_TIME_PATTERN));
            csv.setBillStatus(it.getBillStatus() == 1 ?"未支付": it.getBillStatus() == 2?"成功":"失败");
            csv.setPrice( it.getPrice());
            csv.setBankAccountName( it.getBankAccountName());
            csv.setBankCardNo("NO: "+ it.getBankCardNo());
            csv.setBankName( it.getBankName());
            csv.setBusinessName( it.getBusinessName());
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
        String[] header = {"merchantName","businessName", "createTime","billStatus","price","bankAccountName","bankCardNo","bankName","thirdBillId","billId"};
        csvWriter.writeHeader(header);

        for (BillInCsv it : list) {
            csvWriter.write(it, header);
        }
        csvWriter.close();
    }

}

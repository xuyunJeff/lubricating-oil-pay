package com.bottle.pay.modules.biz.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.api.entity.BusinessMerchantEntity;
import com.bottle.pay.modules.api.service.BusinessMerchantService;
import com.bottle.pay.modules.api.service.MerchantService;
import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import com.bottle.pay.modules.biz.service.IpLimitService;
import com.bottle.pay.modules.biz.view.MerchantView;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;

@RestController
@RequestMapping("/merchant")
public class MerchantController extends AbstractController {

    @Autowired
    private IpLimitService ipLimitService;


    @Autowired
    private MerchantService merchantService;

    @Autowired
    private BusinessMerchantService businessMerchantService;

    @RequestMapping("/list")
    public Page<MerchantView> merchantList(@RequestBody Map<String, Object> params) {
        SysUserEntity userEntity = getUser();
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())) {
            params.put("orgId", userEntity.getOrgId());
            Page<MerchantView> p = merchantService.merchantList(params);
            List<MerchantView> merchantViewMerchant = p.getRows().stream().filter(it -> it.getUserId().equals(userEntity.getUserId())).collect(Collectors.toList());
            BusinessMerchantEntity bm = new BusinessMerchantEntity();
            bm.setMerchantId(userEntity.getUserId());
            List<Long> businessList = businessMerchantService.select(bm).stream().map(it -> it.getBusinessId()).collect(Collectors.toList());
            List<MerchantView> MerchantViewBusiness = p.getRows().stream().filter(it -> businessList.contains(it.getUserId())).collect(Collectors.toList());
            merchantViewMerchant.addAll(MerchantViewBusiness);
            p.setRows(merchantViewMerchant);
            return p;
        }
        if (userEntity.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode()) || userEntity.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())) {
            params.put("orgId", userEntity.getOrgId());
            return merchantService.merchantList(params);
        }

        return new Page<>();
    }

    /**
     * 列表 商户查询自己登陆ip 黑/白名单
     * 一般最多只有两条记录:
     * 一条是商户后台IP白名单
     * 另一条是商户服务器调用我们派单接口是的IP白名单
     *
     * @param ipLimit
     * @return
     */
    @RequestMapping("/ip/list")
    public List<IpLimitEntity> list(IpLimitEntity ipLimit) {
        return ipLimitService.ipList(ipLimit);
    }

    /**
     * 新增
     *
     * @param ipLimit
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/ip/save")
    public R save(@RequestBody IpLimitEntity ipLimit) {
        return ipLimitService.addIP(ipLimit);
    }


    /**
     * 修改
     *
     * @param ipLimit
     * @return
     */
    @SysLog("修改")
    @RequestMapping("/ip/update")
    public R update(@RequestBody IpLimitEntity ipLimit) {
        return ipLimitService.updateIp(ipLimit);
    }


    /**
     * 商户自己查看商户信息商户信息
     *
     * @return
     */
    @RequestMapping("/info")
    public R getMerchantInfo() {
        return CommonUtils.msg(merchantService.getMerchantBalance(super.getUserId()));
    }

}

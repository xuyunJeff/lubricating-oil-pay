package com.bottle.pay.modules.biz.controller;

import java.util.Map;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.support.httpclient.HttpAPIService;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.modules.biz.entity.MerchantNoticeConfigEntity;
import com.bottle.pay.modules.biz.service.MerchantNoticeConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@RestController
@RequestMapping("test/bill/notice")
@Slf4j
public class MerchantNoticeConfigController extends AbstractController {

    @Autowired
    private MerchantNoticeConfigService merchantNoticeConfigService;

    @Autowired
    private HttpAPIService httpAPIService;

    @RequestMapping("/send")
    public R sendNotice(String url, Map<String, Object> param) throws Exception {
        if (param.isEmpty()) {
            return CommonUtils.msg(httpAPIService.doPost(url));
        }
        return CommonUtils.msg(httpAPIService.doPost(url, param));

    }

//	/**
//	 * 列表
//	 * @param params
//	 * @return
//	 */
//	@RequestMapping("/list")
//	public Page<MerchantNoticeConfigEntity> list(@RequestBody Map<String, Object> params) {
//		return merchantNoticeConfigService.listEntity(params);
//	}
//
//	/**
//	 * 新增
//	 * @param merchantNoticeConfig
//	 * @return
//	 */
//	@SysLog("新增")
//	@RequestMapping("/save")
//	public R save(@RequestBody MerchantNoticeConfigEntity merchantNoticeConfig) {
//		return merchantNoticeConfigService.saveEntity(merchantNoticeConfig);
//	}
//
//	/**
//	 * 根据id查询详情
//	 * @param id
//	 * @return
//	 */
//	@RequestMapping("/info")
//	public R getById(@RequestBody Long id) {
//		return merchantNoticeConfigService.getEntityById(id);
//	}
//
//	/**
//	 * 修改
//	 * @param merchantNoticeConfig
//	 * @return
//	 */
//	@SysLog("修改")
//	@RequestMapping("/update")
//	public R update(@RequestBody MerchantNoticeConfigEntity merchantNoticeConfig) {
//		return merchantNoticeConfigService.updateEntity(merchantNoticeConfig);
//	}
//
//	/**
//	 * 删除
//	 * @param id
//	 * @return
//	 */
//	@SysLog("删除")
//	@RequestMapping("/remove")
//	public R batchRemove(@RequestBody Long[] id) {
//		return merchantNoticeConfigService.batchRemove(id);
//	}
//
}

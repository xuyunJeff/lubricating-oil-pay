package com.bottle.pay.modules.api.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.api.entity.ReportBusinessEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import com.bottle.pay.common.service.BottleBaseService;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.ReportMerchantEntity;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.utils.CommonUtils;
import lombok.extern.slf4j.Slf4j;
import com.bottle.pay.modules.api.dao.ReportMerchantMapper;
import org.springframework.transaction.annotation.Transactional;


@Service("reportMerchantService")
@Slf4j
public class ReportMerchantService extends BottleBaseService<ReportMerchantMapper, ReportMerchantEntity> {


    @Autowired
    private BillOutService billOutService;

    @Autowired
    private GlobalProperties globalProperties;

    @Async
    @Transactional
    public void calculateReportMerchant(BillOutEntity bill) {
        String keyLock = BillConstant.REPORT_MERCHANT + ":" + bill.getMerchantId();
        if(globalProperties.isRedisSessionDao()) {
            RedisLock redisLock = new RedisLock(stringRedisTemplate, keyLock);
            if (redisLock.lock()) {
                try {
                    executeMinus(bill);
                } catch (Exception e) {
                    e.printStackTrace();
                    log.warn("商户汇总异常" + e.getMessage());
                } finally {
                    redisLock.unLock();
                }
            }
        }else {
            synchronized (keyLock.intern()){
                try {
                    executeMinus(bill);
                } catch (Exception e) {
                    e.printStackTrace();
                    log.warn("商户汇总异常" + e.getMessage());
                }
            }
        }
    }

    private void executeMinus(BillOutEntity bill) {
        log.info("商户汇总,订单：{}", bill);
        ReportMerchantEntity reportMerchantEveryDay = this.createReportMerchantEveryDay(bill);
        ReportBusinessEntity forUpdate = mapper.selectForUpdate(bill.getMerchantId(), reportMerchantEveryDay.getResultDate());
        mapper.increase(bill.getMerchantId(), reportMerchantEveryDay.getResultDate(), bill.getPrice(), forUpdate.getTotalPaySum());
        log.info("商户汇总成功，账变前：{}, 订单：{}", forUpdate, bill);
    }

    public ReportMerchantEntity createReportMerchantEveryDay(BillOutEntity bill) {
        BillOutEntity billPaid = billOutService.selectOne(new BillOutEntity(bill.getBillId()));
        String resultDate = DateUtils.formatUAT(billPaid.getLastUpdate(), DateUtils.DATE_PATTERN);
        log.info("时间格式化{} -> ,{}", billPaid.getLastUpdate(), resultDate);
        ReportMerchantEntity entity = new ReportMerchantEntity();
        entity.setMerchantId(billPaid.getMerchantId());
        entity.setResultDate(resultDate);
        ReportMerchantEntity reportMerchantEntity = mapper.selectOne(entity);
        if (reportMerchantEntity == null) {
            entity.setMerchantName(billPaid.getMerchantName());
            entity.setCreateTime(new Date());
            entity.setOrgId(billPaid.getOrgId());
            entity.setOrgName(billPaid.getOrgName());
            entity.setTotalPayCount(0);
            entity.setTotalPaySum(BigDecimal.ZERO);
            entity.setLastUpdate(new Date());
            entity.setTotalTopupSum(BigDecimal.ZERO);
            log.info("商户报表，无用户数据----创建：{}", entity);
            int i = mapper.save(entity);
            if (i == 1) {
                return entity;
            }
        }
        return reportMerchantEntity;
    }
}

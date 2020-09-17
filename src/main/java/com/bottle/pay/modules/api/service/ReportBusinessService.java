package com.bottle.pay.modules.api.service;

import java.math.BigDecimal;
import java.util.Date;
import com.bottle.pay.common.utils.DateUtils;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.api.entity.ReportBusinessEntity;
import lombok.extern.slf4j.Slf4j;
import com.bottle.pay.modules.api.dao.ReportBusinessMapper;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author ZhouChenglin<yczclcn       @       1       6       3       .       com>
 */
@Service("reportBusinessService")
@Slf4j
public class ReportBusinessService extends BottleBaseService<ReportBusinessMapper, ReportBusinessEntity> {

    @Autowired
    private BillOutService billOutService;

    @Async
    @Transactional
    public void calculateReportBusiness(BillOutEntity bill) {
        RedisLock redisLock = new RedisLock(stringRedisTemplate, BillConstant.REPORT_BUSINESS + ":" + bill.getBusinessId());
        if (redisLock.lock()) {
            try {
                log.info("出款员汇总,订单：{}",bill);
                ReportBusinessEntity reportBusinessEveryDay =   this.createReportBusinessEveryDay(bill);
                ReportBusinessEntity forUpdate  =  mapper.selectForUpdate(bill.getBusinessId(),reportBusinessEveryDay.getResultDate());
                mapper.increase(bill.getBusinessId(),reportBusinessEveryDay.getResultDate(),bill.getPrice(),forUpdate.getTotalPaySum());
                log.info("出款员汇总成功，账变前：{}, 订单：{}",forUpdate,bill);
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("出款员汇总异常"+e.getMessage());
            } finally {
                redisLock.unLock();
            }
        }
    }

    public ReportBusinessEntity createReportBusinessEveryDay(BillOutEntity bill) {
        BillOutEntity billPaid = billOutService.selectOne(new BillOutEntity(bill.getBillId()));
        String resultDate = DateUtils.formatUAT(billPaid.getLastUpdate(),DateUtils.DATE_PATTERN );
        log.info("时间格式化{} -> ,{}",billPaid.getLastUpdate(),resultDate);
        ReportBusinessEntity entity = new ReportBusinessEntity();
        entity.setBusinessId(billPaid.getBusinessId());
        entity.setResultDate(resultDate);
        ReportBusinessEntity reportBusinessEntity = mapper.selectOne(entity);
        if (reportBusinessEntity == null ) {
            entity.setBusinessName(billPaid.getBusinessName());
            entity.setCreateTime(new Date());
            entity.setOrgId(billPaid.getOrgId());
            entity.setOrgName(billPaid.getOrgName());
            entity.setTotalPayCount(0);
            entity.setTotalPaySum(BigDecimal.ZERO);
            entity.setLastUpdate(new Date());
            log.info("出款员报表，无用户数据----创建：{}",entity);
           int i = mapper.save(entity);
           if (i == 1){
               return entity;
           }
        }
        return reportBusinessEntity;
    }


}

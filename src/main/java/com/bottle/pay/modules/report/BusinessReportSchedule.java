package com.bottle.pay.modules.report;


import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.service.ReportBusinessService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("BusinessReportSchedule")
@Slf4j
public class BusinessReportSchedule {

    @Autowired
    ReportBusinessService reportBusinessService;

    public R init(String params){
        log.info("params =" +params);
        return R.ok().put("params",params);
    }
}

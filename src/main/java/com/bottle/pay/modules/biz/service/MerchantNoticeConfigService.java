package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.entity.HttpResult;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.httpclient.HttpAPIService;
import com.bottle.pay.modules.api.dao.BillOutMapper;
import com.bottle.pay.modules.api.entity.BillOutEntity;
import com.bottle.pay.modules.biz.dao.MerchantNoticeConfigMapper;
import com.bottle.pay.modules.biz.entity.MerchantNoticeConfigEntity;
import com.google.common.collect.Maps;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpStatus;
import org.apache.http.conn.ConnectionPoolTimeoutException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.client.RestTemplate;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;


@EnableAsync
@Service("merchantNoticeConfigService")
@Slf4j
public class MerchantNoticeConfigService extends BottleBaseService<MerchantNoticeConfigMapper, MerchantNoticeConfigEntity> {

    @Autowired
    private BillOutMapper billOutMapper;

    @Autowired
    private HttpAPIService httpAPIService;

//    @Autowired
//    private RestTemplate restTemplate;

//    @Async
    public boolean sendNotice(Long orgId, Long merchantId,String billId) {
        /**
         * 1。根据机构Id和商户ID拿到商户的回调配置  还有出款订单
         * 2。根据配置请求回调保存日志
         */

        BillOutEntity query = new BillOutEntity();
        query.setOrgId(orgId);
        query.setMerchantId(merchantId);
        query.setBillId(billId);
        BillOutEntity billOutEntity = billOutMapper.selectOne(query);
        if(billOutEntity == null){
            log.warn("orgId:{},merchantId:{},订单ID:{} 没有找到出款订单",orgId,merchantId,billId);
            throw new RRException("没有找到出款订单");
        }
        if(billOutEntity.getBillStatus() != BillConstant.BillStatusEnum.Success.getCode()){
            log.warn("orgId:{},merchantId:{},订单ID:{} 出款订单没有支付成功不能回调",orgId,merchantId,billId);
            throw new RRException("出款订单没有支付成功不能回调");
        }
        if(billOutEntity.getNotice() == BillConstant.BillNoticeEnum.Noticed.getCode()){
            log.warn("orgId:{},merchantId:{},订单ID:{} 出款订单已通知不能重复通知",orgId,merchantId,billId);
            throw new RRException("出款订单已回调成功不能重复回调");
        }
        //查询商户配置
        MerchantNoticeConfigEntity entity = new MerchantNoticeConfigEntity();
        entity.setMerchantId(merchantId);
        entity.setOrgId(orgId);
        entity.setCreateTime(null);
        MerchantNoticeConfigEntity config = mapper.selectOne(entity);
        if(config == null){
            log.warn("orgId:{},merchantId:{} 没有找到回调配置",orgId,merchantId);
            throw new RRException("没有找到回调配置");
        }
        String[] param = MerchantNoticeConfigEntity.DEFAULT_PARAMS;
        if(StringUtils.isNotEmpty(config.getNoticeParams())){
            param = StringUtils.split(config.getNoticeParams(),MerchantNoticeConfigEntity.SPLIT_CHAR);
        }
        Map<String,Object> map = Maps.newHashMap();
        for(int i=0; i<param.length; i++){
            try {
                Field field = ReflectionUtils.findField(billOutEntity.getClass(),param[i]);
                Method m = billOutEntity.getClass().getMethod("get" + field.getName().substring(0,1).toUpperCase()+field.getName().substring(1,field.getName().length()));
                Object val =  m.invoke(billOutEntity);
                map.put(param[i],val);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        map.put("orderNo",billOutEntity.getThirdBillId());
        int times =3;
        BillOutEntity update = new BillOutEntity();
        update.setId(billOutEntity.getId());
        do{
            try {
                HttpResult result = httpAPIService.doPost(config.getNoticeUrl(),map);
                log.info("回调请求{},参数{},结果:{}",config.getNoticeUrl(),map,result.getBody());
                if(result.getCode() == HttpStatus.SC_OK){
                    update.setNotice(BillConstant.BillNoticeEnum.Noticed.getCode());
                    int num = billOutMapper.updateByPrimaryKeySelective(update);
                    log.info("出款订单:{}通知结果:{}",billOutEntity.getId(),num>0);
                    times=-1;
                    return true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("回调请求:{}异常:{}",config.getNoticeUrl(),e.getMessage());
                if(e instanceof ConnectionPoolTimeoutException){
                    log.warn("连接超时异常，重复请求");
                    times--;
                }else {
                    times=-1;
                }
            }
        }while (times<=0);
        update.setNotice(BillConstant.BillNoticeEnum.NoticeFailed.getCode());
        int num = billOutMapper.updateByPrimaryKeySelective(update);
        log.info("出款订单:{}通知结果:{}",billOutEntity.getId(),num>0);
        return false;
    }

}

package com.bottle.pay.modules.api.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.bottle.pay.common.service.BottleBaseService;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.MerchantServerEntity;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.utils.CommonUtils;
import lombok.extern.slf4j.Slf4j;
import com.bottle.pay.modules.api.dao.MerchantServerMapper;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("merchantServerService")
 @Slf4j
public class MerchantServerService  extends BottleBaseService<MerchantServerMapper,MerchantServerEntity> {

 /**
  * 订单号里的商户号和商户服务器是否一致
  * @return
  */
 public Boolean billMerchangtAccordanceMerchant(Long merchangtId,String merchantName,Long serverId){
     MerchantServerEntity entity = new MerchantServerEntity();
     entity.setMerchantId(merchangtId);
     entity.setMerchantName(merchantName);
     entity.setServerId(serverId);
     int n =mapper.selectCount(entity);
     return n == 1;
    }
}

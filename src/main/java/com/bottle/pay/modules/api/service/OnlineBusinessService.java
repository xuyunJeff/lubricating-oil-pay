package com.bottle.pay.modules.api.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.bottle.pay.common.service.BottleBaseService;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.api.entity.OnlineBusinessEntity;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.common.utils.CommonUtils;
import lombok.extern.slf4j.Slf4j;
import com.bottle.pay.modules.api.dao.OnlineBusinessMapper;

/**
 * 
 * @author ZhouChenglin<yczclcn@163.com>
 */
 @Service("onlineBusinessService")
 @Slf4j
public class OnlineBusinessService  extends BottleBaseService<OnlineBusinessMapper,OnlineBusinessEntity> {

	
}

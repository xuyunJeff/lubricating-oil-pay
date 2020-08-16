package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.modules.biz.dao.BlockBankCardMapper;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

/**
 * @author ZhouChenglin<yczclcn@163.com>
 */
@Service("blockBankCardService")
@Slf4j
public class BlockBankCardService extends BottleBaseService<BlockBankCardMapper, BlockBankCardEntity> {

}

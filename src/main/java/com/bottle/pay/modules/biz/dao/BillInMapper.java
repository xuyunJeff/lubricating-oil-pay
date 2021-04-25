package com.bottle.pay.modules.biz.dao;

import com.bottle.pay.common.mapper.BottleBaseMapper;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;


@Mapper
public interface BillInMapper extends BottleBaseMapper<BillInEntity> {

    /**
     * 分页总条数
     *
     * @param params
     * @return
     */
    int selectCountForPage(Map<String, Object> params);

    /**
     * 分页数据
     *
     * @param params
     * @return
     */
    List<BillInEntity> selectPage(Map<String, Object> params);


    int updateForPay(@Param("id") Long id, @Param("orgId") Long orgId, @Param("merchantId") Long merchantId);

    int updateForUnPay(@Param("id") Long id, @Param("orgId") Long orgId, @Param("merchantId") Long merchantId);

    Long lastMerchantNewOrder(@Param("merchantId") String merchantId);
}

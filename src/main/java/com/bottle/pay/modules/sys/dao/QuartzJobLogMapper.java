package com.bottle.pay.modules.sys.dao;

import com.bottle.pay.modules.sys.entity.QuartzJobLogEntity;
import org.apache.ibatis.annotations.Mapper;

/**
 * 定时任务日志
 *
 * @author zcl<yczclcn@163.com>
 */
@Mapper
public interface QuartzJobLogMapper extends BaseMapper<QuartzJobLogEntity> {

    /**
     * 批量删除
     *
     * @return
     */
    int batchRemoveAll();

}

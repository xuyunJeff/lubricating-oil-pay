package com.bottle.pay.modules.sys.dao;

import org.apache.ibatis.annotations.Mapper;

import com.bottle.pay.modules.sys.entity.SysLogEntity;

/**
 * 系统日志
 * @author zcl<yczclcn@163.com>
 */
@Mapper
public interface SysLogMapper extends BaseMapper<SysLogEntity> {

	/**
	 * 批量删除
	 * @return
	 */
	int batchRemoveAll();
	
}

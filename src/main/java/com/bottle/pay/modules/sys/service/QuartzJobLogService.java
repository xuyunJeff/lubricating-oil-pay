package com.bottle.pay.modules.sys.service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.modules.sys.entity.QuartzJobLogEntity;

import java.util.Map;

/**
 * 定时任务日志
 * @author zcl<yczclcn@163.com>
 */
public interface QuartzJobLogService {

	/**
	 * 分页查询任务日志
	 * @param params
	 * @return
	 */
	Page<QuartzJobLogEntity> listForPage(Map<String, Object> params);

	/**
	 * 批量删除日志
	 * @param id
	 * @return
	 */
	R batchRemove(Long[] id);

	/**
	 * 清空日志
	 * @return
	 */
	R batchRemoveAll();
	
}

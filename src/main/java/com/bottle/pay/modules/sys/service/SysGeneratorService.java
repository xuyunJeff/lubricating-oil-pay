package com.bottle.pay.modules.sys.service;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.modules.sys.entity.GeneratorParamEntity;
import com.bottle.pay.modules.sys.entity.TableEntity;

import java.util.Map;

/**
 * 代码生成器
 * @author zcl<yczclcn@163.com>
 */
public interface SysGeneratorService {

	/**
	 * 分页查询表格
	 * @param params
	 * @return
	 */
	Page<TableEntity> listTable(Map<String, Object> params);

	/**
	 * 生成代码
	 * @param params
	 * @return
	 */
	byte[] generator(GeneratorParamEntity params);
	
}

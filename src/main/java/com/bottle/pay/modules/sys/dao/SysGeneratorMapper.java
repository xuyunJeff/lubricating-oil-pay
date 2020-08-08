package com.bottle.pay.modules.sys.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.modules.sys.entity.ColumnEntity;
import com.bottle.pay.modules.sys.entity.TableEntity;

/**
 * 代码生成器
 * @author zcl<yczclcn@163.com>
 */
@Mapper
public interface SysGeneratorMapper {

	/**
	 * 查询所有表格
	 * @param page
	 * @param query
	 * @return
	 */
	List<TableEntity> listTable(Page<TableEntity> page, Query query);

	/**
	 * 根据名称查询
	 * @param tableName
	 * @return
	 */
	TableEntity getTableByName(String tableName);

	/**
	 * 查询所有列
	 * @param tableName
	 * @return
	 */
	List<ColumnEntity> listColumn(String tableName);
	
}

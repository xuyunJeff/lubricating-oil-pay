package com.bottle.pay.modules.sys.service.impl;

import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.Query;
import com.bottle.pay.modules.sys.dao.SysGeneratorMapper;
import com.bottle.pay.modules.sys.entity.ColumnEntity;
import com.bottle.pay.modules.sys.entity.GeneratorParamEntity;
import com.bottle.pay.modules.sys.entity.TableEntity;
import com.bottle.pay.modules.sys.generator.GenUtils;
import com.bottle.pay.modules.sys.service.SysGeneratorService;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipOutputStream;

/**
 * 代码生成器
 * @author zcl<yczclcn@163.com>
 */
@Service("sysGeneratorService")
public class SysGeneratorServiceImpl implements SysGeneratorService {

	@Autowired
	private SysGeneratorMapper sysGeneratorMapper;

	/**
	 * 查询所有表格
	 * @param params
	 * @return
	 */
	@Override
	public Page<TableEntity> listTable(Map<String, Object> params) {
		Query query = new Query(params);
		Page<TableEntity> page = new Page<>(query);
		sysGeneratorMapper.listTable(page, query);
		return page;
	}

	/**
	 * 生成代码
	 * @param params
	 * @return
	 */
	@Override
	public byte[] generator(GeneratorParamEntity params) {
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		ZipOutputStream zip = new ZipOutputStream(out);
		for(String table : params.getTables()) {
			TableEntity tableEntity = sysGeneratorMapper.getTableByName(table);
			List<ColumnEntity> columns = sysGeneratorMapper.listColumn(table);
			GenUtils.generatorCode(tableEntity, columns, params, zip);
		}
		IOUtils.closeQuietly(zip);
		return out.toByteArray();
	}

}

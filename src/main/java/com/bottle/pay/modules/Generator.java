package com.bottle.pay.modules;

import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.modules.sys.generator.JdbcGenUtils;

/**
 * 代码生成器
 * @author zcl<yczclcn@163.com>
 */
public class Generator {

    public static void main(String[] args) throws Exception {

//        String jdbcDriver = "com.mysql.jdbc.Driver";
//        String jdbcUrl = "jdbc:mysql://127.0.0.1:3306/dp-lte-boot?useUnicode=true&characterEncoding=utf-8";
//        String jdbcUsername = "root";
//        String jdbcPassword = "root";
//
//        String tablePrefix = "gen_";
//
//        String javaModule = "test";
//        String webModule = "test";
//
//        JdbcGenUtils.generatorCode(jdbcDriver, jdbcUrl, jdbcUsername, jdbcPassword, tablePrefix, javaModule, webModule);
        try{
            throw new RuntimeException("xxx");
        }catch (Exception e){
            System.out.println("exception");
            throw new RRException("throw" + e.getMessage());
        }finally {
            System.out.println("finally-------");
        }

    }

}

/*
Navicat MySQL Data Transfer

Source Server         : LocalHost
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : bottle_pay

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-08-20 16:54:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `org_id` bigint(255) DEFAULT NULL COMMENT '所属机构',
  `role_name` varchar(100) DEFAULT NULL COMMENT '角色名称',
  `role_sign` varchar(100) DEFAULT NULL COMMENT '角色标识',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `user_id_create` bigint(255) DEFAULT NULL COMMENT '创建用户id',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='系统角色';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '1', '超级管理员', 'admin', '【系统内置】', '2', '2017-08-12 00:43:52', '2017-09-05 14:02:04');
INSERT INTO `sys_role` VALUES ('2', '1', '出款员', 'customer service', null, '1', '2020-08-09 20:17:18', '2020-08-09 20:36:07');
INSERT INTO `sys_role` VALUES ('3', '1', '代付商户', 'bill out merchant', null, '1', '2020-08-09 20:34:35', '2020-08-14 17:26:18');
INSERT INTO `sys_role` VALUES ('4', '1', '机构管理员', 'organization', null, '1', '2020-08-14 17:12:01', '2020-08-14 17:12:46');
INSERT INTO `sys_role` VALUES ('5', '1', '代收商户', 'bill in merchant', null, '1', '2020-08-14 17:26:09', null);

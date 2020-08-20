/*
Navicat MySQL Data Transfer

Source Server         : LocalHost
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : bottle_pay

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-08-20 16:54:35
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `org_id` bigint(255) DEFAULT NULL COMMENT '所属机构',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(100) DEFAULT NULL COMMENT '手机号',
  `status` tinyint(255) DEFAULT NULL COMMENT '状态 0:禁用，1:正常',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `user_id_create` bigint(255) DEFAULT NULL COMMENT '创建用户id',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uniq_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='系统用户';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', '1', 'admin', '33808479d49ca8a3cdc93d4f976d1e3d', 'admin@example.com', '123456', '1', null, '1', '2017-08-15 21:40:39', '2017-08-15 21:41:00');
INSERT INTO `sys_user` VALUES ('2', '2', 'xiaoxiong', 'dd5052330db4909cd017bc47f14ea990', null, null, '0', null, '1', '2020-08-09 20:18:12', '2020-08-09 20:35:48');
INSERT INTO `sys_user` VALUES ('3', '3', 'lynn', '88f6abf53883a2a640202bfca985b75e', null, null, '1', null, '1', '2020-08-09 20:41:52', null);
INSERT INTO `sys_user` VALUES ('4', '2', '106', '7463cb8010e452217859ec619236c397', null, null, '1', null, '1', '2020-08-13 23:16:39', null);
INSERT INTO `sys_user` VALUES ('5', '3', 'Becky', 'a32e9f38514e6db10b4298608c6d9939', null, null, '1', null, '1', '2020-08-19 01:10:00', null);
INSERT INTO `sys_user` VALUES ('6', '3', 'Allen', 'f1ab5d145e018210e7aaa036e08b0112', null, null, '1', null, '1', '2020-08-19 01:14:43', null);

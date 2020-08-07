/*
Navicat MySQL Data Transfer

Source Server         : LocalHost
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : bottle_pay

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-08-07 22:26:12
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for bank
-- ----------------------------
DROP TABLE IF EXISTS `bank`;
CREATE TABLE `bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bankName` varchar(40) DEFAULT NULL,
  `bankCode` varchar(20) DEFAULT NULL,
  `bankLog` varchar(80) DEFAULT NULL,
  `wDEnable` tinyint(4) DEFAULT NULL COMMENT '是否支持取款(1,是，0否)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bank
-- ----------------------------
INSERT INTO `bank` VALUES ('1', '中国银行', 'BOC', '/temppic/bank/BOC.png', '1');
INSERT INTO `bank` VALUES ('3', '中国农业银行', 'ABC', '/temppic/bank/ABC.png', '1');
INSERT INTO `bank` VALUES ('4', '中国工商银行', 'ICBC', '/temppic/bank/ICBC.png', '1');
INSERT INTO `bank` VALUES ('5', '民生银行', 'CMBC', '/temppic/bank/CMBC.png', '1');
INSERT INTO `bank` VALUES ('6', '招商银行', 'CMB', '/temppic/bank/CMB.png', '1');
INSERT INTO `bank` VALUES ('7', '兴业银行', 'CIB', '/temppic/bank/CIB.png', '1');
INSERT INTO `bank` VALUES ('8', '交通银行', 'BOCOM', '/temppic/bank/BOCOM.png', '1');
INSERT INTO `bank` VALUES ('9', '中信银行', 'CITIC', '/temppic/bank/CITIC.png', '1');
INSERT INTO `bank` VALUES ('10', '中国光大银行', 'CEB', '/temppic/bank/CEB.png', '1');
INSERT INTO `bank` VALUES ('11', '华夏银行', 'HXBC', '/temppic/bank/HXBC.png', '1');
INSERT INTO `bank` VALUES ('12', '广发银行', 'CGB', '/temppic/bank/CGB.png', '1');
INSERT INTO `bank` VALUES ('14', '浦发银行', 'SPDB', '/temppic/bank/SPDB.png', '1');
INSERT INTO `bank` VALUES ('15', '平安银行', 'PAB', '/temppic/bank/PAB.png', '1');
INSERT INTO `bank` VALUES ('16', '东亚银行', 'BEA', '/temppic/bank/BEA.png', '0');
INSERT INTO `bank` VALUES ('17', '渤海银行', 'CBHB', '/temppic/bank/CBHB.png', '0');
INSERT INTO `bank` VALUES ('18', '北京农商银行', 'BJNSB', '/temppic/bank/BJNSB.png', '0');
INSERT INTO `bank` VALUES ('19', '北京银行', 'BOB', '/temppic/bank/BOB.png', '0');
INSERT INTO `bank` VALUES ('20', '中国建设银行', 'CCB', '/temppic/bank/CCB.png', '0');
INSERT INTO `bank` VALUES ('21', '宁波银行', 'NBCB', '/temppic/bank/NBCB.png', '0');
INSERT INTO `bank` VALUES ('22', '南京银行', 'NJCB', '/temppic/bank/NJCB.png', '0');
INSERT INTO `bank` VALUES ('23', '在线支付', 'PAY', '/temppic/bank/PAY.png', '0');
INSERT INTO `bank` VALUES ('24', '中国邮政储蓄银行', 'PSBC', '/temppic/bank/PSBC.png', '0');
INSERT INTO `bank` VALUES ('25', '支付宝', 'ZFB', '/temppic/bank/ZFB.png', '0');
INSERT INTO `bank` VALUES ('26', '深圳发展银行', 'SFB', '/temppic/bank/SFB.png', '0');
INSERT INTO `bank` VALUES ('27', '微信支付', 'WCP', '/temppic/bank/WCP.png', '0');
INSERT INTO `bank` VALUES ('28', '上海农商行', 'SRCB', '/temppic/bank/SRCB.png', '0');
INSERT INTO `bank` VALUES ('29', '上海银行', 'BOSC', '/temppic/bank/BOSC.png', '0');

-- ----------------------------
-- Table structure for bank_card
-- ----------------------------
DROP TABLE IF EXISTS `bank_card`;
CREATE TABLE `bank_card` (
  `id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` int(11) NOT NULL COMMENT '付款专员ID',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `agent_id` int(11) NOT NULL COMMENT '代理商id',
  `agent_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `balance` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '可用余额',
  `card_status` tinyint(4) NOT NULL COMMENT '1 可用 2 冻结 ',
  `enable` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 禁用 1 启用',
  `balance_daily_limit` decimal(13,4) NOT NULL DEFAULT '50000.0000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bank_card
-- ----------------------------

-- ----------------------------
-- Table structure for bill_in
-- ----------------------------
DROP TABLE IF EXISTS `bill_in`;
CREATE TABLE `bill_in` (
  `id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `bill_id` varchar(20) NOT NULL COMMENT '订单号：商户id+时间戳 + 4位自增',
  `third_bill_id` varchar(64) NOT NULL COMMENT '第三方订单号',
  `ip` varchar(20) NOT NULL COMMENT '第三方订单派发服务器ip',
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` int(11) NOT NULL COMMENT '付款专员ID',
  `bill_status` tinyint(4) NOT NULL COMMENT '订单状态：  1未支付 2 成功 3 失败',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `agent_id` int(11) NOT NULL COMMENT '代理商id',
  `agent_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `comment` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_agent` (`agent_id`,`create_time`,`last_update`) USING BTREE,
  KEY `index_merchant` (`create_time`,`last_update`,`merchant_name`,`agent_id`),
  KEY `index_type` (`bank_card_no`,`bank_account_name`,`agent_id`),
  KEY `index_business` (`create_time`,`last_update`,`business_name`,`business_id`,`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill_in
-- ----------------------------

-- ----------------------------
-- Table structure for bill_out
-- ----------------------------
DROP TABLE IF EXISTS `bill_out`;
CREATE TABLE `bill_out` (
  `id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `bill_id` varchar(20) NOT NULL COMMENT '订单号：商户id+时间戳 + 4位自增',
  `third_bill_id` varchar(64) NOT NULL COMMENT '第三方订单号',
  `ip` varchar(20) NOT NULL COMMENT '第三方订单派发服务器ip',
  `business_name` varchar(32) DEFAULT NULL COMMENT '付款专员姓名',
  `business_id` int(11) DEFAULT NULL COMMENT '付款专员ID',
  `bill_status` tinyint(4) NOT NULL COMMENT '订单状态：  1未支付 2 成功 3 失败',
  `notice` tinyint(4) NOT NULL COMMENT '回调：1未通知 2 已通知 3 失败',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `bill_type` tinyint(4) NOT NULL COMMENT '1 手动 2 自动 3 大额 4 订单退回机构',
  `agent_id` int(11) NOT NULL COMMENT '代理商id',
  `agent_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  PRIMARY KEY (`id`),
  KEY `index_agent` (`agent_id`,`create_time`,`last_update`) USING BTREE,
  KEY `index_merchant` (`create_time`,`last_update`,`merchant_name`,`agent_id`),
  KEY `index_type` (`bank_card_no`,`bank_account_name`,`bill_type`,`agent_id`),
  KEY `index_business` (`create_time`,`last_update`,`business_name`,`business_id`,`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill_out
-- ----------------------------

-- ----------------------------
-- Table structure for fund_procurement
-- ----------------------------
DROP TABLE IF EXISTS `fund_procurement`;
CREATE TABLE `fund_procurement` (
  `id` int(11) NOT NULL,
  `out_business_id` int(11) NOT NULL,
  `out_business_name` varchar(32) NOT NULL,
  `in_business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `in_business_id` int(11) NOT NULL COMMENT '付款专员ID',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `agent_id` int(11) NOT NULL COMMENT '代理商id',
  `in_bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `in_bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `out_bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `out_bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `in_before_balance` decimal(13,4) DEFAULT NULL,
  `out_before_balance` decimal(13,4) DEFAULT NULL,
  `in_after_balance` decimal(13,4) DEFAULT NULL,
  `out_after_balance` decimal(13,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index` (`out_business_id`,`out_business_name`,`in_business_name`,`in_business_id`,`create_time`,`agent_id`,`in_bank_card_no`,`in_bank_name`,`out_bank_card_no`,`out_bank_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fund_procurement
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_balance
-- ----------------------------
DROP TABLE IF EXISTS `merchant_balance`;
CREATE TABLE `merchant_balance` (
  `id` int(11) NOT NULL,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `balance` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '可用余额',
  `balance_frozen` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '冻结余额',
  `balance_paying` decimal(13,4) NOT NULL DEFAULT '0.0000',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `agent_id` int(11) NOT NULL COMMENT '代理商id',
  `agent_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  PRIMARY KEY (`id`),
  KEY `index_agent` (`merchant_name`,`merchant_id`,`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of merchant_balance
-- ----------------------------

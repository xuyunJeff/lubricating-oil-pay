/*
 Navicat Premium Data Transfer

 Source Server         : bottle-pay
 Source Server Type    : MySQL
 Source Server Version : 50731
 Source Host           : 47.114.41.69:13245
 Source Schema         : bottle_pay

 Target Server Type    : MySQL
 Target Server Version : 50731
 File Encoding         : 65001

 Date: 14/05/2021 23:45:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for balance
-- ----------------------------
DROP TABLE IF EXISTS `balance`;
CREATE TABLE `balance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) NOT NULL COMMENT '用户名',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `balance` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '可用余额',
  `balance_frozen` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '冻结余额',
  `balance_paying` decimal(13,4) NOT NULL DEFAULT '0.0000',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `role_id` bigint(20) NOT NULL COMMENT '角色id',
  `role_name` varchar(100) NOT NULL COMMENT '角色名称',
  `bill_out_limit` decimal(13,4) NOT NULL DEFAULT '3000.0000' COMMENT '自动出款上线额度，超出额度要手动派单',
  PRIMARY KEY (`id`),
  UNIQUE KEY `undex_userId` (`user_id`),
  KEY `index_agent` (`user_name`,`user_id`,`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of balance
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for balance_change_log
-- ----------------------------
DROP TABLE IF EXISTS `balance_change_log`;
CREATE TABLE `balance_change_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) NOT NULL COMMENT '用户名',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `balance_after` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '账变后余额',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `role_id` bigint(20) NOT NULL COMMENT '角色id',
  `role_name` varchar(100) NOT NULL COMMENT '角色名称',
  `balance_before` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '账变前余额',
  `bill_id` varchar(20) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `balance` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '账变金额',
  PRIMARY KEY (`id`),
  KEY `index_bill` (`bill_id`) USING BTREE,
  KEY `index_user` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of balance_change_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for balance_procurement
-- ----------------------------
DROP TABLE IF EXISTS `balance_procurement`;
CREATE TABLE `balance_procurement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `out_business_id` bigint(20) NOT NULL,
  `out_business_name` varchar(32) NOT NULL,
  `in_business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `in_business_id` bigint(20) NOT NULL COMMENT '付款专员ID',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `in_bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `in_bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `out_bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `out_bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `in_before_balance` decimal(13,4) DEFAULT NULL,
  `out_before_balance` decimal(13,4) DEFAULT NULL,
  `in_after_balance` decimal(13,4) DEFAULT NULL,
  `out_after_balance` decimal(13,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index` (`out_business_id`,`out_business_name`,`in_business_name`,`in_business_id`,`create_time`,`org_id`,`in_bank_card_no`,`in_bank_name`,`out_bank_card_no`,`out_bank_name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of balance_procurement
-- ----------------------------
BEGIN;
INSERT INTO `balance_procurement` VALUES (3, 16, 'wushang01', 'wushang02', 17, 22410.0000, '2020-09-12 09:17:22', '2020-09-12 09:17:22', 4, '12345123412312321', '中国银行', '7894562132', '工商银行', 9804.0000, 22410.0000, 32214.0000, 0.0000);
INSERT INTO `balance_procurement` VALUES (4, 17, 'wushang02', 'wushang01', 16, 10000.0000, '2020-09-12 09:17:46', '2020-09-12 09:17:46', 4, '4214123123', '中国银行', '12345123412312321', '中国银行', 15341.0000, 32214.0000, 25341.0000, 22214.0000);
INSERT INTO `balance_procurement` VALUES (5, 16, 'wushang01', 'wushang02', 17, 20000.0000, '2020-09-12 09:58:44', '2020-09-12 09:58:44', 4, '12345123412312321', '中国银行', '7894562132', '工商银行', 4216.0000, 30000.0000, 24216.0000, 10000.0000);
INSERT INTO `balance_procurement` VALUES (6, 16, 'wushang01', 'wushang01', 16, 10000.0000, '2020-09-12 09:59:09', '2020-09-12 09:59:09', 4, '4214123123', '中国银行', '7894562132', '工商银行', 18620.0000, 10000.0000, 28620.0000, 0.0000);
INSERT INTO `balance_procurement` VALUES (7, 16, 'wushang01', 'wushang02', 17, 40000.0000, '2020-09-12 11:33:33', '2020-09-12 11:33:33', 4, '12345123412312321', '中国银行', '7894562132', '工商银行', 441.0000, 65000.0000, 40441.0000, 25000.0000);
INSERT INTO `balance_procurement` VALUES (8, 16, 'wushang01', 'wushang01', 16, 25000.0000, '2020-09-12 11:34:05', '2020-09-12 11:34:05', 4, '4214123123', '中国银行', '7894562132', '工商银行', 185.0000, 25000.0000, 25185.0000, 0.0000);
INSERT INTO `balance_procurement` VALUES (9, 16, 'wushang01', 'wushang02', 17, 20000.0000, '2020-09-12 13:33:15', '2020-09-12 13:33:15', 4, '12345123412312321', '中国银行', '7894562132', '工商银行', 2576.0000, 60000.0000, 22576.0000, 40000.0000);
INSERT INTO `balance_procurement` VALUES (10, 16, 'wushang01', 'wushang01', 16, 40000.0000, '2020-09-12 13:33:34', '2020-09-12 13:33:34', 4, '4214123123', '中国银行', '7894562132', '工商银行', 2458.0000, 40000.0000, 42458.0000, 0.0000);
INSERT INTO `balance_procurement` VALUES (11, 16, 'wushang01', 'wushang01', 16, 10000.0000, '2020-09-12 14:08:33', '2020-09-12 14:08:33', 4, '4214123123', '中国银行', '7894562132', '工商银行', 30988.0000, 10000.0000, 40988.0000, 0.0000);
INSERT INTO `balance_procurement` VALUES (12, 17, 'wushang02', 'wushang01', 16, 10000.0000, '2020-09-12 15:15:22', '2020-09-12 15:15:22', 4, '4214123123', '中国银行', '12345123412312321', '中国银行', 47175.0000, 13247.0000, 57175.0000, 3247.0000);
INSERT INTO `balance_procurement` VALUES (13, 16, 'wushang01', 'wushang02', 17, 15000.0000, '2020-09-12 15:15:50', '2020-09-12 15:15:50', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 3247.0000, 57175.0000, 18247.0000, 42175.0000);
INSERT INTO `balance_procurement` VALUES (14, 16, 'wushang01', 'wushang02', 17, 150000.0000, '2020-09-16 05:40:01', '2020-09-16 05:40:01', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 234.0000, 272701.0000, 150234.0000, 122701.0000);
INSERT INTO `balance_procurement` VALUES (15, 16, 'wushang01', 'wushang02', 17, 100000.0000, '2020-09-16 05:40:31', '2020-09-16 05:40:31', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 150234.0000, 122701.0000, 250234.0000, 22701.0000);
INSERT INTO `balance_procurement` VALUES (16, 16, 'wushang01', 'wushang02', 17, 100000.0000, '2020-09-16 11:08:55', '2020-09-16 11:08:55', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 143099.0000, 153052.0000, 243099.0000, 53052.0000);
INSERT INTO `balance_procurement` VALUES (17, 16, 'wushang01', 'wushang02', 17, 100000.0000, '2020-09-17 05:12:38', '2020-09-17 05:12:38', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 126341.0000, 128862.0000, 226341.0000, 28862.0000);
INSERT INTO `balance_procurement` VALUES (18, 16, 'wushang01', 'wushang02', 17, 50000.0000, '2020-09-17 13:17:37', '2020-09-17 13:17:37', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 226341.0000, 64306.0000, 276341.0000, 14306.0000);
INSERT INTO `balance_procurement` VALUES (19, 16, 'wushang01', 'wushang02', 17, 150000.0000, '2020-09-18 08:13:34', '2020-09-18 08:13:34', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 86293.0000, 204601.0000, 236293.0000, 54601.0000);
INSERT INTO `balance_procurement` VALUES (20, 16, 'wushang01', 'wushang02', 17, 130000.0000, '2020-09-20 02:35:10', '2020-09-20 02:35:10', 4, '12345123412312321', '中国银行', '4214123123', '中国银行', 145645.0000, 188312.0000, 275645.0000, 58312.0000);
INSERT INTO `balance_procurement` VALUES (21, 17, 'wushang02', 'wushang01', 16, 30000.0000, '2020-09-25 11:32:26', '2020-09-25 11:32:26', 4, '12123123213123', '中国银行', '12345123412312321', '中国银行', 0.0000, 332102.0000, 30000.0000, 302102.0000);
INSERT INTO `balance_procurement` VALUES (22, 17, 'wushang02', 'wushang01', 16, 40000.0000, '2020-09-25 12:24:14', '2020-09-25 12:24:14', 4, '12123123213123', '中国银行', '12345123412312321', '中国银行', 201.0000, 361830.0000, 40201.0000, 321830.0000);
INSERT INTO `balance_procurement` VALUES (23, 17, 'wushang02', 'wushang01', 16, 90000.0000, '2020-09-26 05:25:28', '2020-09-26 05:25:28', 4, '12123123213123', '中国银行', '12345123412312321', '中国银行', 94662.0000, 296029.0000, 184662.0000, 206029.0000);
INSERT INTO `balance_procurement` VALUES (24, 17, 'wushang02', 'wushang01', 16, 200000.0000, '2020-09-28 01:45:55', '2020-09-28 01:45:55', 4, '12123123213123', '中国银行', '12345123412312321', '中国银行', 14401.0000, 528237.0000, 214401.0000, 328237.0000);
INSERT INTO `balance_procurement` VALUES (25, 17, 'wushang02', 'wushang03', 22, 150000.0000, '2020-09-28 01:46:27', '2020-09-28 01:46:27', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 0.0000, 328237.0000, 150000.0000, 178237.0000);
INSERT INTO `balance_procurement` VALUES (26, 17, 'wushang02', 'wushang03', 22, 29000.0000, '2020-09-28 07:49:31', '2020-09-28 07:49:31', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 271000.0000, 268067.0000, 300000.0000, 239067.0000);
INSERT INTO `balance_procurement` VALUES (27, 17, 'wushang02', 'wushang01', 16, 150000.0000, '2020-09-28 10:55:56', '2020-09-28 10:55:56', 4, '888888888888', '中国银行', '12345123412312321', '中国银行', 0.0000, 349667.0000, 150000.0000, 199667.0000);
INSERT INTO `balance_procurement` VALUES (28, 17, 'wushang02', 'wushang03', 22, 200000.0000, '2020-09-29 03:39:28', '2020-09-29 03:39:28', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 60790.0000, 304230.0000, 260790.0000, 104230.0000);
INSERT INTO `balance_procurement` VALUES (29, 16, 'wushang01', 'wushang03', 22, 39210.0000, '2020-09-29 03:40:25', '2020-09-29 03:40:25', 4, '4234234234234', '中国银行', '888888888888', '中国银行', 260790.0000, 229987.0000, 300000.0000, 190777.0000);
INSERT INTO `balance_procurement` VALUES (30, 17, 'wushang02', 'wushang03', 22, 400000.0000, '2020-09-30 05:25:54', '2020-09-30 05:25:54', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 9887.0000, 559281.0000, 409887.0000, 159281.0000);
INSERT INTO `balance_procurement` VALUES (31, 17, 'wushang02', 'wushang03', 22, 200000.0000, '2020-10-01 02:20:16', '2020-10-01 02:20:16', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 244186.0000, 314281.0000, 444186.0000, 114281.0000);
INSERT INTO `balance_procurement` VALUES (32, 17, 'wushang02', 'wushang03', 22, 250000.0000, '2020-10-02 03:07:44', '2020-10-02 03:07:44', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 235940.0000, 315281.0000, 485940.0000, 65281.0000);
INSERT INTO `balance_procurement` VALUES (33, 17, 'wushang02', 'wushang03', 22, 200000.0000, '2020-10-03 02:29:48', '2020-10-03 02:29:48', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 239925.0000, 360226.0000, 439925.0000, 160226.0000);
INSERT INTO `balance_procurement` VALUES (34, 17, 'wushang02', 'wushang03', 22, 400000.0000, '2020-10-04 07:28:40', '2020-10-04 07:28:40', 4, '4234234234234', '中国银行', '12345123412312321', '中国银行', 99688.0000, 565426.0000, 499688.0000, 165426.0000);
INSERT INTO `balance_procurement` VALUES (35, 17, 'wushang02', 'wushang01', 16, 150000.0000, '2020-10-05 01:16:20', '2020-10-05 01:16:20', 4, '888888888888', '中国银行', '12345123412312321', '中国银行', 1142.0000, 340526.0000, 151142.0000, 190526.0000);
INSERT INTO `balance_procurement` VALUES (36, 22, 'wushang03', 'wushang01', 16, 700000.0000, '2020-10-06 03:47:40', '2020-10-06 03:47:40', 4, '888888888888', '中国银行', '4234234234234', '中国银行', 183.0000, 817039.0000, 700183.0000, 117039.0000);
COMMIT;

-- ----------------------------
-- Table structure for bank
-- ----------------------------
DROP TABLE IF EXISTS `bank`;
CREATE TABLE `bank` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bankName` varchar(40) DEFAULT NULL,
  `bankCode` varchar(20) DEFAULT NULL,
  `bankLog` varchar(80) DEFAULT NULL,
  `wDEnable` tinyint(4) DEFAULT NULL COMMENT '是否支持取款(1,是，0否)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bank
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for bank_card
-- ----------------------------
DROP TABLE IF EXISTS `bank_card`;
CREATE TABLE `bank_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` bigint(20) NOT NULL COMMENT '付款专员ID',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `balance` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '可用余额',
  `card_status` tinyint(4) NOT NULL COMMENT '1 可用 2 冻结 ',
  `enable` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 禁用 1 启用',
  `balance_daily_limit` decimal(13,4) NOT NULL DEFAULT '50000.0000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bank_card
-- ----------------------------
BEGIN;
INSERT INTO `bank_card` VALUES (6, '2020-09-25 16:27:55', '2020-09-25 08:33:41', 'wushang01', 16, '4214123123', '中国银行', '李六', 4, '天龙01', 160455.0000, 2, 0, 1000000.0000);
INSERT INTO `bank_card` VALUES (7, '2020-10-05 15:20:11', '2020-10-05 07:20:11', 'wushang02', 17, '12345123412312321', '中国银行', '李四', 4, '天龙01', 360126.0000, 1, 0, 1000000.0000);
INSERT INTO `bank_card` VALUES (8, '2021-04-26 18:26:35', '2021-04-26 10:26:36', 'adrian', 9, '88888888888888', '测试银行', '张小北', 2, 'DaXiong', 17531.0000, 1, 1, 1000000.0000);
INSERT INTO `bank_card` VALUES (9, '2020-10-01 11:34:50', '2020-10-01 03:34:51', 'wushang01', 16, '12123123213123', '中国银行', '老酒', 4, '天龙01', 79924.0000, 1, 0, 500000.0000);
INSERT INTO `bank_card` VALUES (10, '2020-10-06 21:29:59', '2020-10-06 13:30:00', 'wushang03', 22, '4234234234234', '中国银行', '曹操', 4, '天龙01', 299132.0000, 1, 1, 888888.0000);
INSERT INTO `bank_card` VALUES (11, '2020-10-06 21:13:13', '2020-10-06 13:13:14', 'wushang01', 16, '888888888888', '中国银行', '石头', 4, '天龙01', 492148.0000, 1, 1, 777777.0000);
INSERT INTO `bank_card` VALUES (12, '2020-10-04 14:53:46', '2020-10-04 06:53:46', 'wushang03', 22, '669887098609', '中国银行', '冻结1', 4, '天龙01', 0.0000, 1, 0, 1000000.0000);
INSERT INTO `bank_card` VALUES (13, '2020-09-30 18:04:15', '2020-09-30 10:04:16', 'wushang03', 22, '689689709-08-0', '中国银行', '冻结2', 4, '天龙01', 0.0000, 2, 0, 1000000.0000);
INSERT INTO `bank_card` VALUES (14, '2021-01-05 05:19:36', '2021-01-05 05:19:36', 'mighty', 8, '11111', '1111', '11111', 2, 'DaXiong', 0.0000, 1, 0, 1111.0000);
COMMIT;

-- ----------------------------
-- Table structure for bill_in
-- ----------------------------
DROP TABLE IF EXISTS `bill_in`;
CREATE TABLE `bill_in` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
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
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `comment` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_agent` (`org_id`,`create_time`,`last_update`) USING BTREE,
  KEY `index_merchant` (`create_time`,`last_update`,`merchant_name`,`org_id`),
  KEY `index_type` (`bank_card_no`,`bank_account_name`,`org_id`),
  KEY `index_business` (`create_time`,`last_update`,`business_name`,`business_id`,`org_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill_in
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for bill_in_player
-- ----------------------------
DROP TABLE IF EXISTS `bill_in_player`;
CREATE TABLE `bill_in_player` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `bill_id` varchar(20) NOT NULL COMMENT '订单号：商户id+时间戳 + 4位自增',
  `third_bill_id` varchar(64) NOT NULL COMMENT '第三方订单号',
  `ip` varchar(20) NOT NULL COMMENT '第三方订单派发服务器ip',
  `business_name` varchar(32) NOT NULL COMMENT '收款专员姓名',
  `business_id` int(11) NOT NULL COMMENT '收款专员ID',
  `business_bank_card_no` varchar(19) NOT NULL COMMENT '收款的卡号(或二维码地址)',
  `business_bank_name` varchar(20) NOT NULL COMMENT '银行名称(Alipay,WechatPay)',
  `bill_status` tinyint(4) NOT NULL COMMENT '订单状态：  1未支付 2 成功 3 失败',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `player_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `comment` varchar(128) DEFAULT NULL,
  `bill_in_player_type` varchar(20) NOT NULL COMMENT '支付方式',
  PRIMARY KEY (`id`),
  KEY `index_agent` (`org_id`,`create_time`,`last_update`) USING BTREE,
  KEY `index_merchant` (`create_time`,`last_update`,`merchant_name`,`org_id`),
  KEY `index_type` (`business_bank_card_no`,`player_account_name`,`org_id`),
  KEY `index_business` (`create_time`,`last_update`,`business_name`,`business_id`,`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=789 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill_in_player
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for bill_out
-- ----------------------------
DROP TABLE IF EXISTS `bill_out`;
CREATE TABLE `bill_out` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `bill_id` varchar(20) NOT NULL COMMENT '订单号：商户id+时间戳 + 4位自增',
  `third_bill_id` varchar(64) NOT NULL COMMENT '第三方订单号',
  `ip` varchar(20) NOT NULL COMMENT '第三方订单派发服务器ip',
  `business_name` varchar(32) DEFAULT NULL COMMENT '付款专员姓名',
  `business_id` bigint(20) DEFAULT NULL COMMENT '付款专员ID',
  `bill_status` tinyint(4) NOT NULL COMMENT '订单状态：  1未支付 2 成功 3 失败',
  `notice` tinyint(4) NOT NULL COMMENT '回调：1未通知 2 已通知 3 失败',
  `price` decimal(13,4) NOT NULL COMMENT '账单金额',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `bill_type` tinyint(4) NOT NULL COMMENT '1 手动 2 自动 3 大额 4 订单退回机构',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `position` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1: 机构 2：出款员',
  `business_bank_card_no` varchar(19) DEFAULT NULL COMMENT '出款员的当前开启卡号',
  `business_bank_name` varchar(20) DEFAULT NULL COMMENT '出款员的当前开启银行名称',
  `business_bank_account_name` varchar(32) DEFAULT NULL COMMENT '出款员的当前开启银行卡用户名',
  `notice_msg` varchar(32) DEFAULT NULL,
  `is_lock` tinyint(4) unsigned zerofill NOT NULL DEFAULT '0000' COMMENT '锁定:1 , 未锁定:0',
  PRIMARY KEY (`id`),
  KEY `index_agent` (`org_id`,`create_time`,`last_update`) USING BTREE,
  KEY `index_merchant` (`create_time`,`last_update`,`merchant_name`,`org_id`),
  KEY `index_type` (`bank_card_no`,`bank_account_name`,`bill_type`,`org_id`),
  KEY `index_business` (`create_time`,`last_update`,`business_name`,`business_id`,`org_id`),
  KEY `index_postion` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill_out
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for block_bank_card
-- ----------------------------
DROP TABLE IF EXISTS `block_bank_card`;
CREATE TABLE `block_bank_card` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  PRIMARY KEY (`id`),
  KEY `index_bankcard` (`bank_card_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of block_bank_card
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for business_merchant
-- ----------------------------
DROP TABLE IF EXISTS `business_merchant`;
CREATE TABLE `business_merchant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` int(11) NOT NULL COMMENT '付款专员ID',
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `undex_merchant_business` (`merchant_id`,`business_id`) USING BTREE,
  KEY `index_merchant_org` (`merchant_id`,`org_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of business_merchant
-- ----------------------------
BEGIN;
INSERT INTO `business_merchant` VALUES (5, '2020-12-28 18:50:12', '2020-12-28 18:50:12', '106', 4, 'ketty', 10, 2, 'DaXiong');
INSERT INTO `business_merchant` VALUES (6, '2020-12-28 19:03:16', '2020-12-28 19:03:16', '355yuleS02', 71, 'zihao', 77, 12, 'beike');
INSERT INTO `business_merchant` VALUES (8, '2020-12-29 02:38:56', '2020-12-29 02:38:56', '888S03', 56, '哪吒', 52, 10, 'tianlong04');
INSERT INTO `business_merchant` VALUES (9, '2020-12-29 02:41:41', '2020-12-29 02:41:41', 'qqcp', 68, 'bawan', 35, 7, 'tianlong02');
INSERT INTO `business_merchant` VALUES (10, '2021-01-01 09:07:15', '2021-01-01 09:07:15', 'xingkong', 26, '田丰', 82, 13, 'tianlong05');
INSERT INTO `business_merchant` VALUES (12, '2021-01-05 03:28:57', '2021-01-05 03:28:57', '888S03', 56, '杨戬', 53, 10, 'tianlong04');
INSERT INTO `business_merchant` VALUES (13, '2021-01-06 06:12:44', '2021-01-06 06:12:44', '977', 87, '刘备', 89, 14, 'DaPeng');
INSERT INTO `business_merchant` VALUES (18, '2021-01-14 12:39:41', '2021-01-14 12:39:41', 'scw', 90, 'ershao', 16, 5, 'caocao');
INSERT INTO `business_merchant` VALUES (19, '2021-01-16 02:41:42', '2021-01-16 02:41:42', 'scw', 90, 'liangzai', 92, 5, 'caocao');
INSERT INTO `business_merchant` VALUES (21, '2021-02-21 09:19:15', '2021-02-21 09:19:15', '8523', 93, '李白', 96, 15, 'xiaoqiu');
COMMIT;

-- ----------------------------
-- Table structure for frozen_detail
-- ----------------------------
DROP TABLE IF EXISTS `frozen_detail`;
CREATE TABLE `frozen_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `balance_frozen` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '冻结余额',
  `balance_unfrozen` decimal(13,4) NOT NULL DEFAULT '0.0000' COMMENT '解冻余额',
  `bank_card_no` varchar(19) NOT NULL COMMENT '付款会员的卡号',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `bank_account_name` varchar(32) NOT NULL COMMENT '付款用户名',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` bigint(20) NOT NULL COMMENT '付款专员ID',
  PRIMARY KEY (`id`),
  KEY `index_agent` (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of frozen_detail
-- ----------------------------
BEGIN;
INSERT INTO `frozen_detail` VALUES (2, '888Merchant', 12, 22410.0000, 22410.0000, '7894562132', '工商银行', '张三', '2020-09-12 17:02:53', '2020-09-12 17:02:53', 4, '天龙01', 'wushang01', 16);
INSERT INTO `frozen_detail` VALUES (3, '888Merchant', 12, 8250.0000, 0.0000, '4214123123', '中国银行', '李六', '2020-09-25 03:36:48', '2020-09-25 03:36:48', 4, '天龙01', 'wushang01', 16);
INSERT INTO `frozen_detail` VALUES (4, '888Merchant', 12, 4800.8000, 4800.8000, '12123123213123', '中国银行', '老酒', '2020-10-01 11:34:50', '2020-10-01 11:34:50', 4, '天龙01', 'wushang01', 16);
INSERT INTO `frozen_detail` VALUES (5, '888Merchant', 12, 1127.0000, 1127.0000, '669887098609', '中国银行', '冻结1', '2020-10-04 14:53:46', '2020-10-04 14:53:46', 4, '天龙01', 'wushang03', 22);
INSERT INTO `frozen_detail` VALUES (6, 'Earth', 18, 1254.0000, 0.0000, '689689709-08-0', '中国银行', '冻结2', '2020-09-30 10:04:16', '2020-09-30 10:04:16', 4, '天龙01', 'wushang03', 22);
COMMIT;

-- ----------------------------
-- Table structure for ip_limit
-- ----------------------------
DROP TABLE IF EXISTS `ip_limit`;
CREATE TABLE `ip_limit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ip_list` varchar(255) NOT NULL,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `is_white` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1: 白名单 ； 0：黑名单',
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1:商户对应服务器 2 商户登录后台的电脑',
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_merchant` (`merchant_id`),
  KEY `index_create` (`create_time`),
  KEY `index_org` (`org_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ip_limit
-- ----------------------------
BEGIN;
INSERT INTO `ip_limit` VALUES (1, '127.0.0.1,103.143.80.89,113.119.132.187', 2, 'DaXiong', 1, '2021-01-05 13:23:51', '2021-01-05 13:23:51', 1, '106', 4);
INSERT INTO `ip_limit` VALUES (2, '3.1.241.243,18.136.9.152,52.74.91.126', 4, 'TianLong01', 1, '2020-09-12 16:26:40', '2020-09-12 16:26:42', 1, '888Merchant', 12);
INSERT INTO `ip_limit` VALUES (3, '13.229.86.64,52.76.31.129,52.74.119.101', 4, 'TianLong01', 1, '2020-09-14 15:40:40', '2020-09-14 15:40:42', 1, 'Earth', 18);
COMMIT;

-- ----------------------------
-- Table structure for merchant_notice_config
-- ----------------------------
DROP TABLE IF EXISTS `merchant_notice_config`;
CREATE TABLE `merchant_notice_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `notice_url` varchar(255) NOT NULL COMMENT '回调地址',
  `notice_params` varchar(64) DEFAULT NULL COMMENT '回调参数，多个用逗号隔开',
  `org_name` varchar(32) DEFAULT NULL COMMENT '代理商姓名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_merchant` (`merchant_id`,`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of merchant_notice_config
-- ----------------------------
BEGIN;
INSERT INTO `merchant_notice_config` VALUES (1, '2020-09-12 17:15:27', '2020-09-12 17:15:27', 4, '888Merchant', 12, 'https://pay.122817.com/api/v1/cashmgt/admin/paymentDFBack/shuiping/888cp', '', '天龙01');
INSERT INTO `merchant_notice_config` VALUES (2, '2020-09-14 16:28:51', '2020-09-14 16:28:53', 4, 'Earth', 18, 'http://pay.888paopao.com/api/v1/cashmgt/admin/paymentDFBack/shuiping/qqcp', NULL, '天龙01');
COMMIT;

-- ----------------------------
-- Table structure for merchant_server
-- ----------------------------
DROP TABLE IF EXISTS `merchant_server`;
CREATE TABLE `merchant_server` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `sever_name` varchar(32) NOT NULL COMMENT '商户服务器账号',
  `server_id` bigint(20) NOT NULL COMMENT '商户服务器账号ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `merchant_server_merchant_id_uindex` (`merchant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of merchant_server
-- ----------------------------
BEGIN;
INSERT INTO `merchant_server` VALUES (1, '2020-09-13 06:20:18', '2020-09-13 06:20:21', 2, '106', 4, 'DaXiong', '106Server', 11);
INSERT INTO `merchant_server` VALUES (2, '2020-09-13 06:21:38', '2020-09-13 06:21:41', 4, '888Merchant', 12, '天龙01', '888Server', 13);
INSERT INTO `merchant_server` VALUES (4, '2020-09-13 15:34:33', '2020-09-13 15:34:36', 4, 'Earth', 18, '天龙01', 'EarthServer', 19);
COMMIT;

-- ----------------------------
-- Table structure for online_business
-- ----------------------------
DROP TABLE IF EXISTS `online_business`;
CREATE TABLE `online_business` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` bigint(20) NOT NULL COMMENT '付款专员ID',
  `position` int(11) NOT NULL,
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `undex_business` (`merchant_id`,`business_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of online_business
-- ----------------------------
BEGIN;
INSERT INTO `online_business` VALUES (25, 2, 'DaXiong', 'adrian', 9, 1, '106', 4);
COMMIT;

-- ----------------------------
-- Table structure for report_business
-- ----------------------------
DROP TABLE IF EXISTS `report_business`;
CREATE TABLE `report_business` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `result_date` varchar(20) NOT NULL,
  `business_name` varchar(32) NOT NULL COMMENT '付款专员姓名',
  `business_id` bigint(20) NOT NULL COMMENT '付款专员ID',
  `total_pay_count` int(5) NOT NULL COMMENT '出款总笔数',
  `total_pay_sum` decimal(13,4) NOT NULL COMMENT '出款总计',
  PRIMARY KEY (`id`),
  UNIQUE KEY `undex_resultDate_business` (`result_date`,`business_id`) USING BTREE,
  KEY `index_business` (`business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report_business
-- ----------------------------
BEGIN;
INSERT INTO `report_business` VALUES (16, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-12', 'wushang01', 16, 114, 156725.0000);
INSERT INTO `report_business` VALUES (17, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-13', 'wushang01', 16, 126, 118159.0000);
INSERT INTO `report_business` VALUES (18, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-14', 'wushang01', 16, 462, 334024.0000);
INSERT INTO `report_business` VALUES (19, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-15', 'wushang01', 16, 487, 445047.0000);
INSERT INTO `report_business` VALUES (20, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-16', 'wushang01', 16, 303, 303404.0000);
INSERT INTO `report_business` VALUES (21, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-12', 'wushang02', 17, 87, 121625.0000);
INSERT INTO `report_business` VALUES (22, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-15', 'wushang02', 17, 76, 93576.0000);
INSERT INTO `report_business` VALUES (23, '2020-09-17 00:35:59', '2020-09-17 00:34:21', 4, '天龙01', '2020-09-16', 'wushang02', 17, 289, 255139.0000);
INSERT INTO `report_business` VALUES (24, '2020-09-17 00:36:00', '2020-09-17 23:56:51', 4, '天龙01', '2020-09-17', 'wushang02', 17, 96, 92823.0000);
INSERT INTO `report_business` VALUES (25, '2020-09-17 05:22:05', '2020-09-17 21:23:29', 4, '天龙01', '2020-09-17', 'wushang01', 16, 302, 322827.0000);
INSERT INTO `report_business` VALUES (26, '2020-09-17 16:06:07', '2020-09-18 20:11:20', 4, '天龙01', '2020-09-18', 'wushang02', 17, 95, 160842.0000);
INSERT INTO `report_business` VALUES (27, '2020-09-18 02:19:53', '2020-09-18 23:21:04', 4, '天龙01', '2020-09-18', 'wushang01', 16, 204, 352257.0000);
INSERT INTO `report_business` VALUES (28, '2020-09-19 02:25:45', '2020-09-19 23:03:47', 4, '天龙01', '2020-09-19', 'wushang01', 16, 269, 375426.0000);
INSERT INTO `report_business` VALUES (29, '2020-09-19 08:30:09', '2020-09-19 23:25:01', 4, '天龙01', '2020-09-19', 'wushang02', 17, 141, 169223.0000);
INSERT INTO `report_business` VALUES (30, '2020-09-20 02:30:32', '2020-09-20 23:10:42', 4, '天龙01', '2020-09-20', 'wushang01', 16, 332, 403795.0000);
INSERT INTO `report_business` VALUES (31, '2020-09-20 06:58:29', '2020-09-20 22:05:02', 4, '天龙01', '2020-09-20', 'wushang02', 17, 150, 183104.0000);
INSERT INTO `report_business` VALUES (32, '2020-09-21 05:24:45', '2020-09-21 22:39:54', 4, '天龙01', '2020-09-21', 'wushang01', 16, 293, 430414.0000);
INSERT INTO `report_business` VALUES (33, '2020-09-22 02:33:49', '2020-09-22 23:39:10', 4, '天龙01', '2020-09-22', 'wushang01', 16, 252, 401748.0000);
INSERT INTO `report_business` VALUES (34, '2020-09-23 09:06:36', '2020-09-23 23:40:23', 4, '天龙01', '2020-09-23', 'wushang01', 16, 166, 283866.0000);
INSERT INTO `report_business` VALUES (35, '2020-09-24 02:47:01', '2020-09-24 22:25:02', 4, '天龙01', '2020-09-24', 'wushang01', 16, 230, 413229.0000);
INSERT INTO `report_business` VALUES (36, '2020-09-24 10:48:31', '2020-09-24 22:53:07', 4, '天龙01', '2020-09-24', 'wushang02', 17, 105, 183431.0000);
INSERT INTO `report_business` VALUES (37, '2020-09-25 03:04:08', '2020-09-25 23:31:05', 4, '天龙01', '2020-09-25', 'wushang01', 16, 108, 144990.0000);
INSERT INTO `report_business` VALUES (38, '2020-09-25 08:43:21', '2020-09-25 23:16:47', 4, '天龙01', '2020-09-25', 'wushang02', 17, 162, 226649.0000);
INSERT INTO `report_business` VALUES (39, '2020-09-26 00:04:45', '2020-09-26 13:03:32', 4, '天龙01', '2020-09-26', 'wushang02', 17, 96, 199513.0000);
INSERT INTO `report_business` VALUES (40, '2020-09-26 04:47:20', '2020-09-26 15:32:47', 4, '天龙01', '2020-09-26', 'wushang01', 16, 84, 185694.0000);
INSERT INTO `report_business` VALUES (41, '2020-09-27 02:43:07', '2020-09-27 15:13:27', 4, '天龙01', '2020-09-27', 'wushang02', 17, 111, 234360.0000);
INSERT INTO `report_business` VALUES (42, '2020-09-27 06:12:53', '2020-09-27 19:40:42', 4, '天龙01', '2020-09-27', 'wushang01', 16, 128, 273696.0000);
INSERT INTO `report_business` VALUES (43, '2020-09-28 01:33:12', '2020-09-28 23:07:22', 4, '天龙01', '2020-09-28', 'wushang01', 16, 109, 334258.0000);
INSERT INTO `report_business` VALUES (44, '2020-09-28 03:37:03', '2020-09-28 15:13:26', 4, '天龙01', '2020-09-28', 'wushang02', 17, 68, 244894.0000);
INSERT INTO `report_business` VALUES (45, '2020-09-28 08:10:16', '2020-09-28 23:15:03', 4, '天龙01', '2020-09-28', 'wushang03', 22, 109, 263958.0000);
INSERT INTO `report_business` VALUES (46, '2020-09-29 02:10:23', '2020-09-29 21:12:06', 4, '天龙01', '2020-09-29', 'wushang01', 16, 113, 218241.0000);
INSERT INTO `report_business` VALUES (47, '2020-09-29 03:19:41', '2020-09-29 14:52:29', 4, '天龙01', '2020-09-29', 'wushang02', 17, 78, 170709.0000);
INSERT INTO `report_business` VALUES (48, '2020-09-29 07:48:21', '2020-09-29 22:57:54', 4, '天龙01', '2020-09-29', 'wushang03', 22, 149, 274289.0000);
INSERT INTO `report_business` VALUES (49, '2020-09-30 02:49:39', '2020-09-30 10:49:39', 4, '天龙01', '2020-09-30', '天龙01', 4, 1, 1120.0000);
INSERT INTO `report_business` VALUES (50, '2020-09-30 02:53:35', '2020-09-30 21:35:42', 4, '天龙01', '2020-09-30', 'wushang01', 16, 106, 275336.0000);
INSERT INTO `report_business` VALUES (51, '2020-09-30 04:52:29', '2020-09-30 17:56:06', 4, '天龙01', '2020-09-30', 'wushang03', 22, 76, 228996.0000);
INSERT INTO `report_business` VALUES (52, '2020-10-01 02:19:21', '2020-10-01 16:28:47', 4, '天龙01', '2020-10-01', 'wushang03', 22, 102, 181510.0000);
INSERT INTO `report_business` VALUES (53, '2020-10-01 02:40:53', '2020-10-01 17:32:59', 4, '天龙01', '2020-10-01', 'wushang01', 16, 129, 253108.0000);
INSERT INTO `report_business` VALUES (54, '2020-10-02 02:02:09', '2020-10-02 22:06:27', 4, '天龙01', '2020-10-02', 'wushang03', 22, 185, 293171.0000);
INSERT INTO `report_business` VALUES (55, '2020-10-02 03:13:33', '2020-10-02 22:15:25', 4, '天龙01', '2020-10-02', 'wushang01', 16, 245, 408136.0000);
INSERT INTO `report_business` VALUES (56, '2020-10-03 02:01:57', '2020-10-03 22:35:45', 4, '天龙01', '2020-10-03', 'wushang01', 16, 258, 430701.0000);
INSERT INTO `report_business` VALUES (57, '2020-10-03 02:18:58', '2020-10-03 22:01:03', 4, '天龙01', '2020-10-03', 'wushang03', 22, 218, 267944.0000);
INSERT INTO `report_business` VALUES (58, '2020-10-04 01:51:47', '2020-10-04 17:28:23', 4, '天龙01', '2020-10-04', 'wushang03', 22, 118, 154990.0000);
INSERT INTO `report_business` VALUES (59, '2020-10-04 02:32:19', '2020-10-04 22:57:29', 4, '天龙01', '2020-10-04', 'wushang01', 16, 275, 470958.0000);
INSERT INTO `report_business` VALUES (60, '2020-10-05 03:35:11', '2020-10-05 23:10:59', 4, '天龙01', '2020-10-05', 'wushang01', 16, 187, 459926.0000);
INSERT INTO `report_business` VALUES (61, '2020-10-05 06:10:43', '2020-10-05 22:24:58', 4, '天龙01', '2020-10-05', 'wushang03', 22, 146, 324214.0000);
INSERT INTO `report_business` VALUES (62, '2020-10-06 02:23:07', '2020-10-06 21:13:13', 4, '天龙01', '2020-10-06', 'wushang01', 16, 119, 309842.0000);
INSERT INTO `report_business` VALUES (63, '2020-10-06 07:15:01', '2020-10-06 21:29:59', 4, '天龙01', '2020-10-06', 'wushang03', 22, 146, 264007.0000);
INSERT INTO `report_business` VALUES (64, '2021-03-06 12:36:23', '2021-03-06 20:41:42', 2, 'DaXiong', '2021-03-06', 'adrian', 9, 2, 2462.0000);
INSERT INTO `report_business` VALUES (65, '2021-04-25 17:09:15', '2021-04-26 18:26:36', 2, 'DaXiong', '2021-04-26', 'adrian', 9, 4, 4.0000);
COMMIT;

-- ----------------------------
-- Table structure for report_merchant
-- ----------------------------
DROP TABLE IF EXISTS `report_merchant`;
CREATE TABLE `report_merchant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `org_id` bigint(20) NOT NULL COMMENT '代理商id',
  `org_name` varchar(32) NOT NULL COMMENT '代理商姓名',
  `result_date` varchar(20) NOT NULL,
  `total_pay_count` int(5) NOT NULL COMMENT '出款总笔数',
  `total_pay_sum` decimal(13,4) NOT NULL COMMENT '出款总计',
  `merchant_name` varchar(64) NOT NULL COMMENT '商户名',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `total_topup_sum` decimal(13,4) NOT NULL COMMENT '商户总充值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of report_merchant
-- ----------------------------
BEGIN;
INSERT INTO `report_merchant` VALUES (185, '2021-04-25 17:12:41', '2021-04-26 18:26:36', 2, 'DaXiong', '2021-04-26', 3, 3.0000, '106', 4, 0.0000);
COMMIT;

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area` (
  `area_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '区域id',
  `area_code` varchar(50) NOT NULL COMMENT '行政区划代码',
  `parent_code` varchar(50) NOT NULL COMMENT '父级id',
  `name` varchar(20) DEFAULT NULL COMMENT '地区名称',
  `layer` int(11) DEFAULT NULL COMMENT '层级',
  `order_num` int(11) DEFAULT NULL COMMENT '排序号,1:省级,2:地市,3:区县',
  `status` tinyint(4) DEFAULT NULL COMMENT '显示,1:显示,0:隐藏',
  `remark` varchar(50) DEFAULT NULL COMMENT '备注',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3509 DEFAULT CHARSET=utf8 COMMENT='行政区划';

-- ----------------------------
-- Records of sys_area
-- ----------------------------
BEGIN;
INSERT INTO `sys_area` VALUES (1, '110000', '0', '北京市', 1, 1, 1, '', '2017-04-24 15:54:31', '2017-08-19 00:29:54');
INSERT INTO `sys_area` VALUES (2, '110100', '110000', '市辖区', 2, 1, 1, NULL, '2017-04-24 15:54:31', '2017-08-19 00:03:43');
INSERT INTO `sys_area` VALUES (3, '110101', '110100', '东城区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (4, '110102', '110100', '西城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (5, '110105', '110100', '朝阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (6, '110106', '110100', '丰台区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (7, '110107', '110100', '石景山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (8, '110108', '110100', '海淀区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (9, '110109', '110100', '门头沟区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (10, '110111', '110100', '房山区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (11, '110112', '110100', '通州区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (12, '110113', '110100', '顺义区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (13, '110114', '110100', '昌平区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (14, '110115', '110100', '大兴区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (15, '110116', '110100', '怀柔区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (16, '110117', '110100', '平谷区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (17, '110118', '110100', '密云区', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (18, '110119', '110100', '延庆区', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (19, '120000', '0', '天津市', 1, 2, 1, '', '2017-04-24 15:54:31', '2017-05-06 17:01:08');
INSERT INTO `sys_area` VALUES (20, '120100', '120000', '市辖区', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (21, '120101', '120100', '和平区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (22, '120102', '120100', '河东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (23, '120103', '120100', '河西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (24, '120104', '120100', '南开区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (25, '120105', '120100', '河北区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (26, '120106', '120100', '红桥区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (27, '120110', '120100', '东丽区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (28, '120111', '120100', '西青区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (29, '120112', '120100', '津南区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (30, '120113', '120100', '北辰区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (31, '120114', '120100', '武清区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (32, '120115', '120100', '宝坻区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (33, '120116', '120100', '滨海新区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (34, '120117', '120100', '宁河区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (35, '120118', '120100', '静海区', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (36, '120119', '120100', '蓟州区', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (37, '130000', '0', '河北省', 1, 3, 1, NULL, '2017-04-24 15:54:31', '2017-09-12 11:14:10');
INSERT INTO `sys_area` VALUES (38, '130100', '130000', '石家庄市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (39, '130101', '130100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (40, '130102', '130100', '长安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (41, '130104', '130100', '桥西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (42, '130105', '130100', '新华区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (43, '130107', '130100', '井陉矿区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (44, '130108', '130100', '裕华区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (45, '130109', '130100', '藁城区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (46, '130110', '130100', '鹿泉区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (47, '130111', '130100', '栾城区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (48, '130121', '130100', '井陉县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (49, '130123', '130100', '正定县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (50, '130125', '130100', '行唐县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (51, '130126', '130100', '灵寿县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (52, '130127', '130100', '高邑县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (53, '130128', '130100', '深泽县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (54, '130129', '130100', '赞皇县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (55, '130130', '130100', '无极县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (56, '130131', '130100', '平山县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (57, '130132', '130100', '元氏县', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (58, '130133', '130100', '赵县', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (59, '130183', '130100', '晋州市', 3, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (60, '130184', '130100', '新乐市', 3, 22, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (61, '130200', '130000', '唐山市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (62, '130201', '130200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (63, '130202', '130200', '路南区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (64, '130203', '130200', '路北区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (65, '130204', '130200', '古冶区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (66, '130205', '130200', '开平区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (67, '130207', '130200', '丰南区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (68, '130208', '130200', '丰润区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (69, '130209', '130200', '曹妃甸区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (70, '130223', '130200', '滦县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (71, '130224', '130200', '滦南县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (72, '130225', '130200', '乐亭县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (73, '130227', '130200', '迁西县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (74, '130229', '130200', '玉田县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (75, '130281', '130200', '遵化市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (76, '130283', '130200', '迁安市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (77, '130300', '130000', '秦皇岛市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (78, '130301', '130300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (79, '130302', '130300', '海港区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (80, '130303', '130300', '山海关区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (81, '130304', '130300', '北戴河区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (82, '130306', '130300', '抚宁区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (83, '130321', '130300', '青龙满族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (84, '130322', '130300', '昌黎县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (85, '130324', '130300', '卢龙县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (86, '130400', '130000', '邯郸市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (87, '130401', '130400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (88, '130402', '130400', '邯山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (89, '130403', '130400', '丛台区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (90, '130404', '130400', '复兴区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (91, '130406', '130400', '峰峰矿区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (92, '130421', '130400', '邯郸县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (93, '130423', '130400', '临漳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (94, '130424', '130400', '成安县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (95, '130425', '130400', '大名县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (96, '130426', '130400', '涉县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (97, '130427', '130400', '磁县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (98, '130428', '130400', '肥乡县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (99, '130429', '130400', '永年县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (100, '130430', '130400', '邱县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (101, '130431', '130400', '鸡泽县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (102, '130432', '130400', '广平县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (103, '130433', '130400', '馆陶县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (104, '130434', '130400', '魏县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (105, '130435', '130400', '曲周县', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (106, '130481', '130400', '武安市', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (107, '130500', '130000', '邢台市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (108, '130501', '130500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (109, '130502', '130500', '桥东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (110, '130503', '130500', '桥西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (111, '130521', '130500', '邢台县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (112, '130522', '130500', '临城县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (113, '130523', '130500', '内丘县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (114, '130524', '130500', '柏乡县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (115, '130525', '130500', '隆尧县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (116, '130526', '130500', '任县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (117, '130527', '130500', '南和县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (118, '130528', '130500', '宁晋县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (119, '130529', '130500', '巨鹿县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (120, '130530', '130500', '新河县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (121, '130531', '130500', '广宗县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (122, '130532', '130500', '平乡县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (123, '130533', '130500', '威县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (124, '130534', '130500', '清河县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (125, '130535', '130500', '临西县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (126, '130581', '130500', '南宫市', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (127, '130582', '130500', '沙河市', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (128, '130600', '130000', '保定市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (129, '130601', '130600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (130, '130602', '130600', '竞秀区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (131, '130606', '130600', '莲池区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (132, '130607', '130600', '满城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (133, '130608', '130600', '清苑区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (134, '130609', '130600', '徐水区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (135, '130623', '130600', '涞水县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (136, '130624', '130600', '阜平县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (137, '130626', '130600', '定兴县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (138, '130627', '130600', '唐县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (139, '130628', '130600', '高阳县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (140, '130629', '130600', '容城县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (141, '130630', '130600', '涞源县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (142, '130631', '130600', '望都县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (143, '130632', '130600', '安新县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (144, '130633', '130600', '易县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (145, '130634', '130600', '曲阳县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (146, '130635', '130600', '蠡县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (147, '130636', '130600', '顺平县', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (148, '130637', '130600', '博野县', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (149, '130638', '130600', '雄县', 3, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (150, '130681', '130600', '涿州市', 3, 22, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (151, '130683', '130600', '安国市', 3, 23, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (152, '130684', '130600', '高碑店市', 3, 24, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (153, '130700', '130000', '张家口市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (154, '130701', '130700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (155, '130702', '130700', '桥东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (156, '130703', '130700', '桥西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (157, '130705', '130700', '宣化区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (158, '130706', '130700', '下花园区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (159, '130708', '130700', '万全区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (160, '130709', '130700', '崇礼区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (161, '130722', '130700', '张北县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (162, '130723', '130700', '康保县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (163, '130724', '130700', '沽源县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (164, '130725', '130700', '尚义县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (165, '130726', '130700', '蔚县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (166, '130727', '130700', '阳原县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (167, '130728', '130700', '怀安县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (168, '130730', '130700', '怀来县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (169, '130731', '130700', '涿鹿县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (170, '130732', '130700', '赤城县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (171, '130800', '130000', '承德市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (172, '130801', '130800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (173, '130802', '130800', '双桥区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (174, '130803', '130800', '双滦区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (175, '130804', '130800', '鹰手营子矿区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (176, '130821', '130800', '承德县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (177, '130822', '130800', '兴隆县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (178, '130823', '130800', '平泉县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (179, '130824', '130800', '滦平县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (180, '130825', '130800', '隆化县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (181, '130826', '130800', '丰宁满族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (182, '130827', '130800', '宽城满族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (183, '130828', '130800', '围场满族蒙古族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (184, '130900', '130000', '沧州市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (185, '130901', '130900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (186, '130902', '130900', '新华区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (187, '130903', '130900', '运河区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (188, '130921', '130900', '沧县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (189, '130922', '130900', '青县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (190, '130923', '130900', '东光县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (191, '130924', '130900', '海兴县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (192, '130925', '130900', '盐山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (193, '130926', '130900', '肃宁县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (194, '130927', '130900', '南皮县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (195, '130928', '130900', '吴桥县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (196, '130929', '130900', '献县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (197, '130930', '130900', '孟村回族自治县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (198, '130981', '130900', '泊头市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (199, '130982', '130900', '任丘市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (200, '130983', '130900', '黄骅市', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (201, '130984', '130900', '河间市', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (202, '131000', '130000', '廊坊市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (203, '131001', '131000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (204, '131002', '131000', '安次区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (205, '131003', '131000', '广阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (206, '131022', '131000', '固安县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (207, '131023', '131000', '永清县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (208, '131024', '131000', '香河县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (209, '131025', '131000', '大城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (210, '131026', '131000', '文安县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (211, '131028', '131000', '大厂回族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (212, '131081', '131000', '霸州市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (213, '131082', '131000', '三河市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (214, '131100', '130000', '衡水市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (215, '131101', '131100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (216, '131102', '131100', '桃城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (217, '131103', '131100', '冀州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (218, '131121', '131100', '枣强县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (219, '131122', '131100', '武邑县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (220, '131123', '131100', '武强县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (221, '131124', '131100', '饶阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (222, '131125', '131100', '安平县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (223, '131126', '131100', '故城县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (224, '131127', '131100', '景县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (225, '131128', '131100', '阜城县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (226, '131182', '131100', '深州市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (227, '139000', '130000', '省直辖县级行政区划', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (228, '139001', '139000', '定州市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (229, '139002', '139000', '辛集市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (230, '140000', '0', '山西省', 1, 4, 1, '', '2017-04-24 15:54:31', '2017-05-08 16:23:30');
INSERT INTO `sys_area` VALUES (231, '140100', '140000', '太原市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (232, '140101', '140100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (233, '140105', '140100', '小店区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (234, '140106', '140100', '迎泽区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (235, '140107', '140100', '杏花岭区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (236, '140108', '140100', '尖草坪区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (237, '140109', '140100', '万柏林区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (238, '140110', '140100', '晋源区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (239, '140121', '140100', '清徐县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (240, '140122', '140100', '阳曲县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (241, '140123', '140100', '娄烦县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (242, '140181', '140100', '古交市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (243, '140200', '140000', '大同市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (244, '140201', '140200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (245, '140202', '140200', '城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (246, '140203', '140200', '矿区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (247, '140211', '140200', '南郊区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (248, '140212', '140200', '新荣区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (249, '140221', '140200', '阳高县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (250, '140222', '140200', '天镇县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (251, '140223', '140200', '广灵县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (252, '140224', '140200', '灵丘县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (253, '140225', '140200', '浑源县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (254, '140226', '140200', '左云县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (255, '140227', '140200', '大同县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (256, '140300', '140000', '阳泉市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (257, '140301', '140300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (258, '140302', '140300', '城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (259, '140303', '140300', '矿区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (260, '140311', '140300', '郊区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (261, '140321', '140300', '平定县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (262, '140322', '140300', '盂县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (263, '140400', '140000', '长治市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (264, '140401', '140400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (265, '140402', '140400', '城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (266, '140411', '140400', '郊区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (267, '140421', '140400', '长治县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (268, '140423', '140400', '襄垣县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (269, '140424', '140400', '屯留县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (270, '140425', '140400', '平顺县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (271, '140426', '140400', '黎城县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (272, '140427', '140400', '壶关县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (273, '140428', '140400', '长子县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (274, '140429', '140400', '武乡县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (275, '140430', '140400', '沁县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (276, '140431', '140400', '沁源县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (277, '140481', '140400', '潞城市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (278, '140500', '140000', '晋城市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (279, '140501', '140500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (280, '140502', '140500', '城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (281, '140521', '140500', '沁水县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (282, '140522', '140500', '阳城县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (283, '140524', '140500', '陵川县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (284, '140525', '140500', '泽州县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (285, '140581', '140500', '高平市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (286, '140600', '140000', '朔州市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (287, '140601', '140600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (288, '140602', '140600', '朔城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (289, '140603', '140600', '平鲁区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (290, '140621', '140600', '山阴县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (291, '140622', '140600', '应县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (292, '140623', '140600', '右玉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (293, '140624', '140600', '怀仁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (294, '140700', '140000', '晋中市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (295, '140701', '140700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (296, '140702', '140700', '榆次区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (297, '140721', '140700', '榆社县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (298, '140722', '140700', '左权县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (299, '140723', '140700', '和顺县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (300, '140724', '140700', '昔阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (301, '140725', '140700', '寿阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (302, '140726', '140700', '太谷县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (303, '140727', '140700', '祁县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (304, '140728', '140700', '平遥县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (305, '140729', '140700', '灵石县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (306, '140781', '140700', '介休市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (307, '140800', '140000', '运城市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (308, '140801', '140800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (309, '140802', '140800', '盐湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (310, '140821', '140800', '临猗县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (311, '140822', '140800', '万荣县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (312, '140823', '140800', '闻喜县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (313, '140824', '140800', '稷山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (314, '140825', '140800', '新绛县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (315, '140826', '140800', '绛县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (316, '140827', '140800', '垣曲县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (317, '140828', '140800', '夏县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (318, '140829', '140800', '平陆县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (319, '140830', '140800', '芮城县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (320, '140881', '140800', '永济市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (321, '140882', '140800', '河津市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (322, '140900', '140000', '忻州市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (323, '140901', '140900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (324, '140902', '140900', '忻府区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (325, '140921', '140900', '定襄县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (326, '140922', '140900', '五台县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (327, '140923', '140900', '代县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (328, '140924', '140900', '繁峙县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (329, '140925', '140900', '宁武县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (330, '140926', '140900', '静乐县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (331, '140927', '140900', '神池县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (332, '140928', '140900', '五寨县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (333, '140929', '140900', '岢岚县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (334, '140930', '140900', '河曲县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (335, '140931', '140900', '保德县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (336, '140932', '140900', '偏关县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (337, '140981', '140900', '原平市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (338, '141000', '140000', '临汾市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (339, '141001', '141000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (340, '141002', '141000', '尧都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (341, '141021', '141000', '曲沃县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (342, '141022', '141000', '翼城县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (343, '141023', '141000', '襄汾县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (344, '141024', '141000', '洪洞县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (345, '141025', '141000', '古县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (346, '141026', '141000', '安泽县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (347, '141027', '141000', '浮山县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (348, '141028', '141000', '吉县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (349, '141029', '141000', '乡宁县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (350, '141030', '141000', '大宁县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (351, '141031', '141000', '隰县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (352, '141032', '141000', '永和县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (353, '141033', '141000', '蒲县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (354, '141034', '141000', '汾西县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (355, '141081', '141000', '侯马市', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (356, '141082', '141000', '霍州市', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (357, '141100', '140000', '吕梁市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (358, '141101', '141100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (359, '141102', '141100', '离石区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (360, '141121', '141100', '文水县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (361, '141122', '141100', '交城县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (362, '141123', '141100', '兴县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (363, '141124', '141100', '临县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (364, '141125', '141100', '柳林县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (365, '141126', '141100', '石楼县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (366, '141127', '141100', '岚县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (367, '141128', '141100', '方山县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (368, '141129', '141100', '中阳县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (369, '141130', '141100', '交口县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (370, '141181', '141100', '孝义市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (371, '141182', '141100', '汾阳市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (372, '150000', '0', '内蒙古自治区', 1, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (373, '150100', '150000', '呼和浩特市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (374, '150101', '150100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (375, '150102', '150100', '新城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (376, '150103', '150100', '回民区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (377, '150104', '150100', '玉泉区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (378, '150105', '150100', '赛罕区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (379, '150121', '150100', '土默特左旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (380, '150122', '150100', '托克托县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (381, '150123', '150100', '和林格尔县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (382, '150124', '150100', '清水河县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (383, '150125', '150100', '武川县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (384, '150200', '150000', '包头市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (385, '150201', '150200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (386, '150202', '150200', '东河区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (387, '150203', '150200', '昆都仑区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (388, '150204', '150200', '青山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (389, '150205', '150200', '石拐区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (390, '150206', '150200', '白云鄂博矿区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (391, '150207', '150200', '九原区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (392, '150221', '150200', '土默特右旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (393, '150222', '150200', '固阳县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (394, '150223', '150200', '达尔罕茂明安联合旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (395, '150300', '150000', '乌海市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (396, '150301', '150300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (397, '150302', '150300', '海勃湾区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (398, '150303', '150300', '海南区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (399, '150304', '150300', '乌达区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (400, '150400', '150000', '赤峰市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (401, '150401', '150400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (402, '150402', '150400', '红山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (403, '150403', '150400', '元宝山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (404, '150404', '150400', '松山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (405, '150421', '150400', '阿鲁科尔沁旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (406, '150422', '150400', '巴林左旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (407, '150423', '150400', '巴林右旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (408, '150424', '150400', '林西县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (409, '150425', '150400', '克什克腾旗', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (410, '150426', '150400', '翁牛特旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (411, '150428', '150400', '喀喇沁旗', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (412, '150429', '150400', '宁城县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (413, '150430', '150400', '敖汉旗', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (414, '150500', '150000', '通辽市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (415, '150501', '150500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (416, '150502', '150500', '科尔沁区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (417, '150521', '150500', '科尔沁左翼中旗', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (418, '150522', '150500', '科尔沁左翼后旗', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (419, '150523', '150500', '开鲁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (420, '150524', '150500', '库伦旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (421, '150525', '150500', '奈曼旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (422, '150526', '150500', '扎鲁特旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (423, '150581', '150500', '霍林郭勒市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (424, '150600', '150000', '鄂尔多斯市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (425, '150601', '150600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (426, '150602', '150600', '东胜区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (427, '150603', '150600', '康巴什区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (428, '150621', '150600', '达拉特旗', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (429, '150622', '150600', '准格尔旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (430, '150623', '150600', '鄂托克前旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (431, '150624', '150600', '鄂托克旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (432, '150625', '150600', '杭锦旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (433, '150626', '150600', '乌审旗', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (434, '150627', '150600', '伊金霍洛旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (435, '150700', '150000', '呼伦贝尔市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (436, '150701', '150700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (437, '150702', '150700', '海拉尔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (438, '150703', '150700', '扎赉诺尔区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (439, '150721', '150700', '阿荣旗', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (440, '150722', '150700', '莫力达瓦达斡尔族自治旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (441, '150723', '150700', '鄂伦春自治旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (442, '150724', '150700', '鄂温克族自治旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (443, '150725', '150700', '陈巴尔虎旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (444, '150726', '150700', '新巴尔虎左旗', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (445, '150727', '150700', '新巴尔虎右旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (446, '150781', '150700', '满洲里市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (447, '150782', '150700', '牙克石市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (448, '150783', '150700', '扎兰屯市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (449, '150784', '150700', '额尔古纳市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (450, '150785', '150700', '根河市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (451, '150800', '150000', '巴彦淖尔市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (452, '150801', '150800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (453, '150802', '150800', '临河区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (454, '150821', '150800', '五原县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (455, '150822', '150800', '磴口县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (456, '150823', '150800', '乌拉特前旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (457, '150824', '150800', '乌拉特中旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (458, '150825', '150800', '乌拉特后旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (459, '150826', '150800', '杭锦后旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (460, '150900', '150000', '乌兰察布市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (461, '150901', '150900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (462, '150902', '150900', '集宁区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (463, '150921', '150900', '卓资县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (464, '150922', '150900', '化德县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (465, '150923', '150900', '商都县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (466, '150924', '150900', '兴和县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (467, '150925', '150900', '凉城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (468, '150926', '150900', '察哈尔右翼前旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (469, '150927', '150900', '察哈尔右翼中旗', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (470, '150928', '150900', '察哈尔右翼后旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (471, '150929', '150900', '四子王旗', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (472, '150981', '150900', '丰镇市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (473, '152200', '150000', '兴安盟', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (474, '152201', '152200', '乌兰浩特市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (475, '152202', '152200', '阿尔山市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (476, '152221', '152200', '科尔沁右翼前旗', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (477, '152222', '152200', '科尔沁右翼中旗', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (478, '152223', '152200', '扎赉特旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (479, '152224', '152200', '突泉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (480, '152500', '150000', '锡林郭勒盟', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (481, '152501', '152500', '二连浩特市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (482, '152502', '152500', '锡林浩特市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (483, '152522', '152500', '阿巴嘎旗', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (484, '152523', '152500', '苏尼特左旗', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (485, '152524', '152500', '苏尼特右旗', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (486, '152525', '152500', '东乌珠穆沁旗', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (487, '152526', '152500', '西乌珠穆沁旗', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (488, '152527', '152500', '太仆寺旗', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (489, '152528', '152500', '镶黄旗', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (490, '152529', '152500', '正镶白旗', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (491, '152530', '152500', '正蓝旗', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (492, '152531', '152500', '多伦县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (493, '152900', '150000', '阿拉善盟', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (494, '152921', '152900', '阿拉善左旗', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (495, '152922', '152900', '阿拉善右旗', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (496, '152923', '152900', '额济纳旗', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (497, '210000', '0', '辽宁省', 1, 6, 1, '', '2017-04-24 15:54:31', '2017-05-08 21:33:56');
INSERT INTO `sys_area` VALUES (498, '210100', '210000', '沈阳市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (499, '210101', '210100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (500, '210102', '210100', '和平区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (501, '210103', '210100', '沈河区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (502, '210104', '210100', '大东区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (503, '210105', '210100', '皇姑区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (504, '210106', '210100', '铁西区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (505, '210111', '210100', '苏家屯区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (506, '210112', '210100', '浑南区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (507, '210113', '210100', '沈北新区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (508, '210114', '210100', '于洪区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (509, '210115', '210100', '辽中区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (510, '210123', '210100', '康平县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (511, '210124', '210100', '法库县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (512, '210181', '210100', '新民市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (513, '210200', '210000', '大连市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (514, '210201', '210200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (515, '210202', '210200', '中山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (516, '210203', '210200', '西岗区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (517, '210204', '210200', '沙河口区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (518, '210211', '210200', '甘井子区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (519, '210212', '210200', '旅顺口区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (520, '210213', '210200', '金州区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (521, '210214', '210200', '普兰店区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (522, '210224', '210200', '长海县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (523, '210281', '210200', '瓦房店市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (524, '210283', '210200', '庄河市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (525, '210300', '210000', '鞍山市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (526, '210301', '210300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (527, '210302', '210300', '铁东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (528, '210303', '210300', '铁西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (529, '210304', '210300', '立山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (530, '210311', '210300', '千山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (531, '210321', '210300', '台安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (532, '210323', '210300', '岫岩满族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (533, '210381', '210300', '海城市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (534, '210400', '210000', '抚顺市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (535, '210401', '210400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (536, '210402', '210400', '新抚区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (537, '210403', '210400', '东洲区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (538, '210404', '210400', '望花区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (539, '210411', '210400', '顺城区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (540, '210421', '210400', '抚顺县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (541, '210422', '210400', '新宾满族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (542, '210423', '210400', '清原满族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (543, '210500', '210000', '本溪市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (544, '210501', '210500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (545, '210502', '210500', '平山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (546, '210503', '210500', '溪湖区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (547, '210504', '210500', '明山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (548, '210505', '210500', '南芬区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (549, '210521', '210500', '本溪满族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (550, '210522', '210500', '桓仁满族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (551, '210600', '210000', '丹东市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (552, '210601', '210600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (553, '210602', '210600', '元宝区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (554, '210603', '210600', '振兴区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (555, '210604', '210600', '振安区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (556, '210624', '210600', '宽甸满族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (557, '210681', '210600', '东港市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (558, '210682', '210600', '凤城市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (559, '210700', '210000', '锦州市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (560, '210701', '210700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (561, '210702', '210700', '古塔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (562, '210703', '210700', '凌河区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (563, '210711', '210700', '太和区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (564, '210726', '210700', '黑山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (565, '210727', '210700', '义县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (566, '210781', '210700', '凌海市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (567, '210782', '210700', '北镇市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (568, '210800', '210000', '营口市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (569, '210801', '210800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (570, '210802', '210800', '站前区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (571, '210803', '210800', '西市区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (572, '210804', '210800', '鲅鱼圈区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (573, '210811', '210800', '老边区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (574, '210881', '210800', '盖州市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (575, '210882', '210800', '大石桥市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (576, '210900', '210000', '阜新市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (577, '210901', '210900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (578, '210902', '210900', '海州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (579, '210903', '210900', '新邱区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (580, '210904', '210900', '太平区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (581, '210905', '210900', '清河门区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (582, '210911', '210900', '细河区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (583, '210921', '210900', '阜新蒙古族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (584, '210922', '210900', '彰武县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (585, '211000', '210000', '辽阳市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (586, '211001', '211000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (587, '211002', '211000', '白塔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (588, '211003', '211000', '文圣区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (589, '211004', '211000', '宏伟区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (590, '211005', '211000', '弓长岭区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (591, '211011', '211000', '太子河区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (592, '211021', '211000', '辽阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (593, '211081', '211000', '灯塔市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (594, '211100', '210000', '盘锦市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (595, '211101', '211100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (596, '211102', '211100', '双台子区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (597, '211103', '211100', '兴隆台区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (598, '211104', '211100', '大洼区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (599, '211122', '211100', '盘山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (600, '211200', '210000', '铁岭市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (601, '211201', '211200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (602, '211202', '211200', '银州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (603, '211204', '211200', '清河区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (604, '211221', '211200', '铁岭县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (605, '211223', '211200', '西丰县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (606, '211224', '211200', '昌图县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (607, '211281', '211200', '调兵山市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (608, '211282', '211200', '开原市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (609, '211300', '210000', '朝阳市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (610, '211301', '211300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (611, '211302', '211300', '双塔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (612, '211303', '211300', '龙城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (613, '211321', '211300', '朝阳县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (614, '211322', '211300', '建平县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (615, '211324', '211300', '喀喇沁左翼蒙古族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (616, '211381', '211300', '北票市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (617, '211382', '211300', '凌源市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (618, '211400', '210000', '葫芦岛市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (619, '211401', '211400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (620, '211402', '211400', '连山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (621, '211403', '211400', '龙港区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (622, '211404', '211400', '南票区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (623, '211421', '211400', '绥中县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (624, '211422', '211400', '建昌县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (625, '211481', '211400', '兴城市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (626, '220000', '0', '吉林省', 1, 7, 1, '', '2017-04-24 15:54:31', '2017-05-09 10:04:39');
INSERT INTO `sys_area` VALUES (627, '220100', '220000', '长春市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (628, '220101', '220100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (629, '220102', '220100', '南关区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (630, '220103', '220100', '宽城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (631, '220104', '220100', '朝阳区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (632, '220105', '220100', '二道区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (633, '220106', '220100', '绿园区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (634, '220112', '220100', '双阳区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (635, '220113', '220100', '九台区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (636, '220122', '220100', '农安县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (637, '220182', '220100', '榆树市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (638, '220183', '220100', '德惠市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (639, '220200', '220000', '吉林市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (640, '220201', '220200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (641, '220202', '220200', '昌邑区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (642, '220203', '220200', '龙潭区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (643, '220204', '220200', '船营区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (644, '220211', '220200', '丰满区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (645, '220221', '220200', '永吉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (646, '220281', '220200', '蛟河市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (647, '220282', '220200', '桦甸市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (648, '220283', '220200', '舒兰市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (649, '220284', '220200', '磐石市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (650, '220300', '220000', '四平市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (651, '220301', '220300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (652, '220302', '220300', '铁西区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (653, '220303', '220300', '铁东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (654, '220322', '220300', '梨树县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (655, '220323', '220300', '伊通满族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (656, '220381', '220300', '公主岭市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (657, '220382', '220300', '双辽市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (658, '220400', '220000', '辽源市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (659, '220401', '220400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (660, '220402', '220400', '龙山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (661, '220403', '220400', '西安区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (662, '220421', '220400', '东丰县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (663, '220422', '220400', '东辽县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (664, '220500', '220000', '通化市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (665, '220501', '220500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (666, '220502', '220500', '东昌区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (667, '220503', '220500', '二道江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (668, '220521', '220500', '通化县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (669, '220523', '220500', '辉南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (670, '220524', '220500', '柳河县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (671, '220581', '220500', '梅河口市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (672, '220582', '220500', '集安市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (673, '220600', '220000', '白山市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (674, '220601', '220600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (675, '220602', '220600', '浑江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (676, '220605', '220600', '江源区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (677, '220621', '220600', '抚松县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (678, '220622', '220600', '靖宇县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (679, '220623', '220600', '长白朝鲜族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (680, '220681', '220600', '临江市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (681, '220700', '220000', '松原市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (682, '220701', '220700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (683, '220702', '220700', '宁江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (684, '220721', '220700', '前郭尔罗斯蒙古族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (685, '220722', '220700', '长岭县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (686, '220723', '220700', '乾安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (687, '220781', '220700', '扶余市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (688, '220800', '220000', '白城市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (689, '220801', '220800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (690, '220802', '220800', '洮北区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (691, '220821', '220800', '镇赉县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (692, '220822', '220800', '通榆县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (693, '220881', '220800', '洮南市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (694, '220882', '220800', '大安市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (695, '222400', '220000', '延边朝鲜族自治州', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (696, '222401', '222400', '延吉市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (697, '222402', '222400', '图们市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (698, '222403', '222400', '敦化市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (699, '222404', '222400', '珲春市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (700, '222405', '222400', '龙井市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (701, '222406', '222400', '和龙市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (702, '222424', '222400', '汪清县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (703, '222426', '222400', '安图县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (704, '230000', '0', '黑龙江省', 1, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (705, '230100', '230000', '哈尔滨市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (706, '230101', '230100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (707, '230102', '230100', '道里区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (708, '230103', '230100', '南岗区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (709, '230104', '230100', '道外区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (710, '230108', '230100', '平房区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (711, '230109', '230100', '松北区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (712, '230110', '230100', '香坊区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (713, '230111', '230100', '呼兰区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (714, '230112', '230100', '阿城区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (715, '230113', '230100', '双城区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (716, '230123', '230100', '依兰县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (717, '230124', '230100', '方正县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (718, '230125', '230100', '宾县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (719, '230126', '230100', '巴彦县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (720, '230127', '230100', '木兰县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (721, '230128', '230100', '通河县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (722, '230129', '230100', '延寿县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (723, '230183', '230100', '尚志市', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (724, '230184', '230100', '五常市', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (725, '230200', '230000', '齐齐哈尔市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (726, '230201', '230200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (727, '230202', '230200', '龙沙区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (728, '230203', '230200', '建华区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (729, '230204', '230200', '铁锋区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (730, '230205', '230200', '昂昂溪区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (731, '230206', '230200', '富拉尔基区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (732, '230207', '230200', '碾子山区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (733, '230208', '230200', '梅里斯达斡尔族区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (734, '230221', '230200', '龙江县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (735, '230223', '230200', '依安县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (736, '230224', '230200', '泰来县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (737, '230225', '230200', '甘南县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (738, '230227', '230200', '富裕县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (739, '230229', '230200', '克山县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (740, '230230', '230200', '克东县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (741, '230231', '230200', '拜泉县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (742, '230281', '230200', '讷河市', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (743, '230300', '230000', '鸡西市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (744, '230301', '230300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (745, '230302', '230300', '鸡冠区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (746, '230303', '230300', '恒山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (747, '230304', '230300', '滴道区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (748, '230305', '230300', '梨树区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (749, '230306', '230300', '城子河区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (750, '230307', '230300', '麻山区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (751, '230321', '230300', '鸡东县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (752, '230381', '230300', '虎林市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (753, '230382', '230300', '密山市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (754, '230400', '230000', '鹤岗市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (755, '230401', '230400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (756, '230402', '230400', '向阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (757, '230403', '230400', '工农区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (758, '230404', '230400', '南山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (759, '230405', '230400', '兴安区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (760, '230406', '230400', '东山区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (761, '230407', '230400', '兴山区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (762, '230421', '230400', '萝北县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (763, '230422', '230400', '绥滨县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (764, '230500', '230000', '双鸭山市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (765, '230501', '230500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (766, '230502', '230500', '尖山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (767, '230503', '230500', '岭东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (768, '230505', '230500', '四方台区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (769, '230506', '230500', '宝山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (770, '230521', '230500', '集贤县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (771, '230522', '230500', '友谊县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (772, '230523', '230500', '宝清县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (773, '230524', '230500', '饶河县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (774, '230600', '230000', '大庆市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (775, '230601', '230600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (776, '230602', '230600', '萨尔图区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (777, '230603', '230600', '龙凤区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (778, '230604', '230600', '让胡路区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (779, '230605', '230600', '红岗区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (780, '230606', '230600', '大同区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (781, '230621', '230600', '肇州县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (782, '230622', '230600', '肇源县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (783, '230623', '230600', '林甸县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (784, '230624', '230600', '杜尔伯特蒙古族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (785, '230700', '230000', '伊春市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (786, '230701', '230700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (787, '230702', '230700', '伊春区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (788, '230703', '230700', '南岔区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (789, '230704', '230700', '友好区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (790, '230705', '230700', '西林区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (791, '230706', '230700', '翠峦区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (792, '230707', '230700', '新青区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (793, '230708', '230700', '美溪区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (794, '230709', '230700', '金山屯区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (795, '230710', '230700', '五营区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (796, '230711', '230700', '乌马河区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (797, '230712', '230700', '汤旺河区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (798, '230713', '230700', '带岭区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (799, '230714', '230700', '乌伊岭区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (800, '230715', '230700', '红星区', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (801, '230716', '230700', '上甘岭区', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (802, '230722', '230700', '嘉荫县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (803, '230781', '230700', '铁力市', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (804, '230800', '230000', '佳木斯市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (805, '230801', '230800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (806, '230803', '230800', '向阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (807, '230804', '230800', '前进区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (808, '230805', '230800', '东风区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (809, '230811', '230800', '郊区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (810, '230822', '230800', '桦南县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (811, '230826', '230800', '桦川县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (812, '230828', '230800', '汤原县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (813, '230881', '230800', '同江市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (814, '230882', '230800', '富锦市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (815, '230883', '230800', '抚远市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (816, '230900', '230000', '七台河市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (817, '230901', '230900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (818, '230902', '230900', '新兴区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (819, '230903', '230900', '桃山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (820, '230904', '230900', '茄子河区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (821, '230921', '230900', '勃利县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (822, '231000', '230000', '牡丹江市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (823, '231001', '231000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (824, '231002', '231000', '东安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (825, '231003', '231000', '阳明区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (826, '231004', '231000', '爱民区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (827, '231005', '231000', '西安区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (828, '231025', '231000', '林口县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (829, '231081', '231000', '绥芬河市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (830, '231083', '231000', '海林市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (831, '231084', '231000', '宁安市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (832, '231085', '231000', '穆棱市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (833, '231086', '231000', '东宁市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (834, '231100', '230000', '黑河市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (835, '231101', '231100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (836, '231102', '231100', '爱辉区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (837, '231121', '231100', '嫩江县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (838, '231123', '231100', '逊克县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (839, '231124', '231100', '孙吴县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (840, '231181', '231100', '北安市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (841, '231182', '231100', '五大连池市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (842, '231200', '230000', '绥化市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (843, '231201', '231200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (844, '231202', '231200', '北林区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (845, '231221', '231200', '望奎县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (846, '231222', '231200', '兰西县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (847, '231223', '231200', '青冈县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (848, '231224', '231200', '庆安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (849, '231225', '231200', '明水县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (850, '231226', '231200', '绥棱县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (851, '231281', '231200', '安达市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (852, '231282', '231200', '肇东市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (853, '231283', '231200', '海伦市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (854, '232700', '230000', '大兴安岭地区', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (855, '232721', '232700', '呼玛县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (856, '232722', '232700', '塔河县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (857, '232723', '232700', '漠河县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (858, '310000', '0', '上海市', 1, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (859, '310100', '310000', '市辖区', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (860, '310101', '310100', '黄浦区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (861, '310104', '310100', '徐汇区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (862, '310105', '310100', '长宁区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (863, '310106', '310100', '静安区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (864, '310107', '310100', '普陀区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (865, '310109', '310100', '虹口区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (866, '310110', '310100', '杨浦区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (867, '310112', '310100', '闵行区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (868, '310113', '310100', '宝山区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (869, '310114', '310100', '嘉定区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (870, '310115', '310100', '浦东新区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (871, '310116', '310100', '金山区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (872, '310117', '310100', '松江区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (873, '310118', '310100', '青浦区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (874, '310120', '310100', '奉贤区', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (875, '310151', '310100', '崇明区', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (876, '320000', '0', '江苏省', 1, 10, 1, '', '2017-04-24 15:54:31', '2017-05-08 20:51:01');
INSERT INTO `sys_area` VALUES (877, '320100', '320000', '南京市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (878, '320101', '320100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (879, '320102', '320100', '玄武区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (880, '320104', '320100', '秦淮区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (881, '320105', '320100', '建邺区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (882, '320106', '320100', '鼓楼区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (883, '320111', '320100', '浦口区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (884, '320113', '320100', '栖霞区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (885, '320114', '320100', '雨花台区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (886, '320115', '320100', '江宁区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (887, '320116', '320100', '六合区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (888, '320117', '320100', '溧水区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (889, '320118', '320100', '高淳区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (890, '320200', '320000', '无锡市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (891, '320201', '320200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (892, '320205', '320200', '锡山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (893, '320206', '320200', '惠山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (894, '320211', '320200', '滨湖区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (895, '320213', '320200', '梁溪区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (896, '320214', '320200', '新吴区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (897, '320281', '320200', '江阴市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (898, '320282', '320200', '宜兴市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (899, '320300', '320000', '徐州市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (900, '320301', '320300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (901, '320302', '320300', '鼓楼区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (902, '320303', '320300', '云龙区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (903, '320305', '320300', '贾汪区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (904, '320311', '320300', '泉山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (905, '320312', '320300', '铜山区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (906, '320321', '320300', '丰县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (907, '320322', '320300', '沛县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (908, '320324', '320300', '睢宁县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (909, '320381', '320300', '新沂市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (910, '320382', '320300', '邳州市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (911, '320400', '320000', '常州市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (912, '320401', '320400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (913, '320402', '320400', '天宁区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (914, '320404', '320400', '钟楼区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (915, '320411', '320400', '新北区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (916, '320412', '320400', '武进区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (917, '320413', '320400', '金坛区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (918, '320481', '320400', '溧阳市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (919, '320500', '320000', '苏州市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (920, '320501', '320500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (921, '320505', '320500', '虎丘区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (922, '320506', '320500', '吴中区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (923, '320507', '320500', '相城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (924, '320508', '320500', '姑苏区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (925, '320509', '320500', '吴江区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (926, '320581', '320500', '常熟市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (927, '320582', '320500', '张家港市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (928, '320583', '320500', '昆山市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (929, '320585', '320500', '太仓市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (930, '320600', '320000', '南通市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (931, '320601', '320600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (932, '320602', '320600', '崇川区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (933, '320611', '320600', '港闸区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (934, '320612', '320600', '通州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (935, '320621', '320600', '海安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (936, '320623', '320600', '如东县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (937, '320681', '320600', '启东市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (938, '320682', '320600', '如皋市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (939, '320684', '320600', '海门市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (940, '320700', '320000', '连云港市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (941, '320701', '320700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (942, '320703', '320700', '连云区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (943, '320706', '320700', '海州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (944, '320707', '320700', '赣榆区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (945, '320722', '320700', '东海县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (946, '320723', '320700', '灌云县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (947, '320724', '320700', '灌南县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (948, '320800', '320000', '淮安市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (949, '320801', '320800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (950, '320803', '320800', '淮安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (951, '320804', '320800', '淮阴区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (952, '320812', '320800', '清江浦区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (953, '320813', '320800', '洪泽区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (954, '320826', '320800', '涟水县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (955, '320830', '320800', '盱眙县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (956, '320831', '320800', '金湖县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (957, '320900', '320000', '盐城市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (958, '320901', '320900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (959, '320902', '320900', '亭湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (960, '320903', '320900', '盐都区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (961, '320904', '320900', '大丰区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (962, '320921', '320900', '响水县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (963, '320922', '320900', '滨海县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (964, '320923', '320900', '阜宁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (965, '320924', '320900', '射阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (966, '320925', '320900', '建湖县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (967, '320981', '320900', '东台市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (968, '321000', '320000', '扬州市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (969, '321001', '321000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (970, '321002', '321000', '广陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (971, '321003', '321000', '邗江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (972, '321012', '321000', '江都区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (973, '321023', '321000', '宝应县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (974, '321081', '321000', '仪征市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (975, '321084', '321000', '高邮市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (976, '321100', '320000', '镇江市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (977, '321101', '321100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (978, '321102', '321100', '京口区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (979, '321111', '321100', '润州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (980, '321112', '321100', '丹徒区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (981, '321181', '321100', '丹阳市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (982, '321182', '321100', '扬中市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (983, '321183', '321100', '句容市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (984, '321200', '320000', '泰州市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (985, '321201', '321200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (986, '321202', '321200', '海陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (987, '321203', '321200', '高港区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (988, '321204', '321200', '姜堰区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (989, '321281', '321200', '兴化市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (990, '321282', '321200', '靖江市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (991, '321283', '321200', '泰兴市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (992, '321300', '320000', '宿迁市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (993, '321301', '321300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (994, '321302', '321300', '宿城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (995, '321311', '321300', '宿豫区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (996, '321322', '321300', '沭阳县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (997, '321323', '321300', '泗阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (998, '321324', '321300', '泗洪县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (999, '330000', '0', '浙江省', 1, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1000, '330100', '330000', '杭州市', 2, 1, 1, '', '2017-04-24 15:54:31', '2017-04-25 22:15:02');
INSERT INTO `sys_area` VALUES (1001, '330101', '330100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1002, '330102', '330100', '上城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1003, '330103', '330100', '下城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1004, '330104', '330100', '江干区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1005, '330105', '330100', '拱墅区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1006, '330106', '330100', '西湖区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1007, '330108', '330100', '滨江区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1008, '330109', '330100', '萧山区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1009, '330110', '330100', '余杭区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1010, '330111', '330100', '富阳区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1011, '330122', '330100', '桐庐县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1012, '330127', '330100', '淳安县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1013, '330182', '330100', '建德市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1014, '330185', '330100', '临安市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1015, '330200', '330000', '宁波市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1016, '330201', '330200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1017, '330203', '330200', '海曙区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1018, '330204', '330200', '江东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1019, '330205', '330200', '江北区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1020, '330206', '330200', '北仑区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1021, '330211', '330200', '镇海区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1022, '330212', '330200', '鄞州区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1023, '330225', '330200', '象山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1024, '330226', '330200', '宁海县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1025, '330281', '330200', '余姚市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1026, '330282', '330200', '慈溪市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1027, '330283', '330200', '奉化市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1028, '330300', '330000', '温州市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1029, '330301', '330300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1030, '330302', '330300', '鹿城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1031, '330303', '330300', '龙湾区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1032, '330304', '330300', '瓯海区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1033, '330305', '330300', '洞头区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1034, '330324', '330300', '永嘉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1035, '330326', '330300', '平阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1036, '330327', '330300', '苍南县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1037, '330328', '330300', '文成县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1038, '330329', '330300', '泰顺县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1039, '330381', '330300', '瑞安市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1040, '330382', '330300', '乐清市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1041, '330400', '330000', '嘉兴市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1042, '330401', '330400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1043, '330402', '330400', '南湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1044, '330411', '330400', '秀洲区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1045, '330421', '330400', '嘉善县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1046, '330424', '330400', '海盐县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1047, '330481', '330400', '海宁市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1048, '330482', '330400', '平湖市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1049, '330483', '330400', '桐乡市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1050, '330500', '330000', '湖州市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1051, '330501', '330500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1052, '330502', '330500', '吴兴区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1053, '330503', '330500', '南浔区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1054, '330521', '330500', '德清县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1055, '330522', '330500', '长兴县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1056, '330523', '330500', '安吉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1057, '330600', '330000', '绍兴市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1058, '330601', '330600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1059, '330602', '330600', '越城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1060, '330603', '330600', '柯桥区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1061, '330604', '330600', '上虞区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1062, '330624', '330600', '新昌县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1063, '330681', '330600', '诸暨市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1064, '330683', '330600', '嵊州市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1065, '330700', '330000', '金华市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1066, '330701', '330700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1067, '330702', '330700', '婺城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1068, '330703', '330700', '金东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1069, '330723', '330700', '武义县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1070, '330726', '330700', '浦江县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1071, '330727', '330700', '磐安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1072, '330781', '330700', '兰溪市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1073, '330782', '330700', '义乌市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1074, '330783', '330700', '东阳市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1075, '330784', '330700', '永康市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1076, '330800', '330000', '衢州市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1077, '330801', '330800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1078, '330802', '330800', '柯城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1079, '330803', '330800', '衢江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1080, '330822', '330800', '常山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1081, '330824', '330800', '开化县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1082, '330825', '330800', '龙游县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1083, '330881', '330800', '江山市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1084, '330900', '330000', '舟山市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1085, '330901', '330900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1086, '330902', '330900', '定海区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1087, '330903', '330900', '普陀区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1088, '330921', '330900', '岱山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1089, '330922', '330900', '嵊泗县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1090, '331000', '330000', '台州市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1091, '331001', '331000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1092, '331002', '331000', '椒江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1093, '331003', '331000', '黄岩区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1094, '331004', '331000', '路桥区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1095, '331021', '331000', '玉环县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1096, '331022', '331000', '三门县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1097, '331023', '331000', '天台县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1098, '331024', '331000', '仙居县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1099, '331081', '331000', '温岭市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1100, '331082', '331000', '临海市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1101, '331100', '330000', '丽水市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1102, '331101', '331100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1103, '331102', '331100', '莲都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1104, '331121', '331100', '青田县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1105, '331122', '331100', '缙云县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1106, '331123', '331100', '遂昌县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1107, '331124', '331100', '松阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1108, '331125', '331100', '云和县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1109, '331126', '331100', '庆元县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1110, '331127', '331100', '景宁畲族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1111, '331181', '331100', '龙泉市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1112, '340000', '0', '安徽省', 1, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1113, '340100', '340000', '合肥市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1114, '340101', '340100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1115, '340102', '340100', '瑶海区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1116, '340103', '340100', '庐阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1117, '340104', '340100', '蜀山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1118, '340111', '340100', '包河区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1119, '340121', '340100', '长丰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1120, '340122', '340100', '肥东县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1121, '340123', '340100', '肥西县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1122, '340124', '340100', '庐江县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1123, '340181', '340100', '巢湖市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1124, '340200', '340000', '芜湖市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1125, '340201', '340200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1126, '340202', '340200', '镜湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1127, '340203', '340200', '弋江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1128, '340207', '340200', '鸠江区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1129, '340208', '340200', '三山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1130, '340221', '340200', '芜湖县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1131, '340222', '340200', '繁昌县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1132, '340223', '340200', '南陵县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1133, '340225', '340200', '无为县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1134, '340300', '340000', '蚌埠市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1135, '340301', '340300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1136, '340302', '340300', '龙子湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1137, '340303', '340300', '蚌山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1138, '340304', '340300', '禹会区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1139, '340311', '340300', '淮上区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1140, '340321', '340300', '怀远县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1141, '340322', '340300', '五河县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1142, '340323', '340300', '固镇县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1143, '340400', '340000', '淮南市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1144, '340401', '340400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1145, '340402', '340400', '大通区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1146, '340403', '340400', '田家庵区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1147, '340404', '340400', '谢家集区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1148, '340405', '340400', '八公山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1149, '340406', '340400', '潘集区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1150, '340421', '340400', '凤台县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1151, '340422', '340400', '寿县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1152, '340500', '340000', '马鞍山市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1153, '340501', '340500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1154, '340503', '340500', '花山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1155, '340504', '340500', '雨山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1156, '340506', '340500', '博望区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1157, '340521', '340500', '当涂县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1158, '340522', '340500', '含山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1159, '340523', '340500', '和县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1160, '340600', '340000', '淮北市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1161, '340601', '340600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1162, '340602', '340600', '杜集区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1163, '340603', '340600', '相山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1164, '340604', '340600', '烈山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1165, '340621', '340600', '濉溪县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1166, '340700', '340000', '铜陵市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1167, '340701', '340700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1168, '340705', '340700', '铜官区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1169, '340706', '340700', '义安区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1170, '340711', '340700', '郊区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1171, '340722', '340700', '枞阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1172, '340800', '340000', '安庆市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1173, '340801', '340800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1174, '340802', '340800', '迎江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1175, '340803', '340800', '大观区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1176, '340811', '340800', '宜秀区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1177, '340822', '340800', '怀宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1178, '340824', '340800', '潜山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1179, '340825', '340800', '太湖县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1180, '340826', '340800', '宿松县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1181, '340827', '340800', '望江县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1182, '340828', '340800', '岳西县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1183, '340881', '340800', '桐城市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1184, '341000', '340000', '黄山市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1185, '341001', '341000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1186, '341002', '341000', '屯溪区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1187, '341003', '341000', '黄山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1188, '341004', '341000', '徽州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1189, '341021', '341000', '歙县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1190, '341022', '341000', '休宁县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1191, '341023', '341000', '黟县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1192, '341024', '341000', '祁门县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1193, '341100', '340000', '滁州市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1194, '341101', '341100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1195, '341102', '341100', '琅琊区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1196, '341103', '341100', '南谯区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1197, '341122', '341100', '来安县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1198, '341124', '341100', '全椒县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1199, '341125', '341100', '定远县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1200, '341126', '341100', '凤阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1201, '341181', '341100', '天长市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1202, '341182', '341100', '明光市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1203, '341200', '340000', '阜阳市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1204, '341201', '341200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1205, '341202', '341200', '颍州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1206, '341203', '341200', '颍东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1207, '341204', '341200', '颍泉区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1208, '341221', '341200', '临泉县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1209, '341222', '341200', '太和县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1210, '341225', '341200', '阜南县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1211, '341226', '341200', '颍上县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1212, '341282', '341200', '界首市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1213, '341300', '340000', '宿州市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1214, '341301', '341300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1215, '341302', '341300', '埇桥区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1216, '341321', '341300', '砀山县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1217, '341322', '341300', '萧县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1218, '341323', '341300', '灵璧县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1219, '341324', '341300', '泗县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1220, '341500', '340000', '六安市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1221, '341501', '341500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1222, '341502', '341500', '金安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1223, '341503', '341500', '裕安区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1224, '341504', '341500', '叶集区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1225, '341522', '341500', '霍邱县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1226, '341523', '341500', '舒城县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1227, '341524', '341500', '金寨县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1228, '341525', '341500', '霍山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1229, '341600', '340000', '亳州市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1230, '341601', '341600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1231, '341602', '341600', '谯城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1232, '341621', '341600', '涡阳县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1233, '341622', '341600', '蒙城县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1234, '341623', '341600', '利辛县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1235, '341700', '340000', '池州市', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1236, '341701', '341700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1237, '341702', '341700', '贵池区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1238, '341721', '341700', '东至县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1239, '341722', '341700', '石台县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1240, '341723', '341700', '青阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1241, '341800', '340000', '宣城市', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1242, '341801', '341800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1243, '341802', '341800', '宣州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1244, '341821', '341800', '郎溪县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1245, '341822', '341800', '广德县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1246, '341823', '341800', '泾县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1247, '341824', '341800', '绩溪县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1248, '341825', '341800', '旌德县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1249, '341881', '341800', '宁国市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1250, '350000', '0', '福建省', 1, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1251, '350100', '350000', '福州市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1252, '350101', '350100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1253, '350102', '350100', '鼓楼区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1254, '350103', '350100', '台江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1255, '350104', '350100', '仓山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1256, '350105', '350100', '马尾区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1257, '350111', '350100', '晋安区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1258, '350121', '350100', '闽侯县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1259, '350122', '350100', '连江县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1260, '350123', '350100', '罗源县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1261, '350124', '350100', '闽清县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1262, '350125', '350100', '永泰县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1263, '350128', '350100', '平潭县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1264, '350181', '350100', '福清市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1265, '350182', '350100', '长乐市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1266, '350200', '350000', '厦门市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1267, '350201', '350200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1268, '350203', '350200', '思明区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1269, '350205', '350200', '海沧区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1270, '350206', '350200', '湖里区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1271, '350211', '350200', '集美区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1272, '350212', '350200', '同安区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1273, '350213', '350200', '翔安区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1274, '350300', '350000', '莆田市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1275, '350301', '350300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1276, '350302', '350300', '城厢区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1277, '350303', '350300', '涵江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1278, '350304', '350300', '荔城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1279, '350305', '350300', '秀屿区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1280, '350322', '350300', '仙游县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1281, '350400', '350000', '三明市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1282, '350401', '350400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1283, '350402', '350400', '梅列区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1284, '350403', '350400', '三元区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1285, '350421', '350400', '明溪县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1286, '350423', '350400', '清流县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1287, '350424', '350400', '宁化县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1288, '350425', '350400', '大田县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1289, '350426', '350400', '尤溪县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1290, '350427', '350400', '沙县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1291, '350428', '350400', '将乐县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1292, '350429', '350400', '泰宁县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1293, '350430', '350400', '建宁县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1294, '350481', '350400', '永安市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1295, '350500', '350000', '泉州市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1296, '350501', '350500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1297, '350502', '350500', '鲤城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1298, '350503', '350500', '丰泽区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1299, '350504', '350500', '洛江区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1300, '350505', '350500', '泉港区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1301, '350521', '350500', '惠安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1302, '350524', '350500', '安溪县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1303, '350525', '350500', '永春县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1304, '350526', '350500', '德化县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1305, '350527', '350500', '金门县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1306, '350581', '350500', '石狮市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1307, '350582', '350500', '晋江市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1308, '350583', '350500', '南安市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1309, '350600', '350000', '漳州市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1310, '350601', '350600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1311, '350602', '350600', '芗城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1312, '350603', '350600', '龙文区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1313, '350622', '350600', '云霄县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1314, '350623', '350600', '漳浦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1315, '350624', '350600', '诏安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1316, '350625', '350600', '长泰县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1317, '350626', '350600', '东山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1318, '350627', '350600', '南靖县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1319, '350628', '350600', '平和县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1320, '350629', '350600', '华安县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1321, '350681', '350600', '龙海市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1322, '350700', '350000', '南平市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1323, '350701', '350700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1324, '350702', '350700', '延平区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1325, '350703', '350700', '建阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1326, '350721', '350700', '顺昌县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1327, '350722', '350700', '浦城县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1328, '350723', '350700', '光泽县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1329, '350724', '350700', '松溪县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1330, '350725', '350700', '政和县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1331, '350781', '350700', '邵武市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1332, '350782', '350700', '武夷山市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1333, '350783', '350700', '建瓯市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1334, '350800', '350000', '龙岩市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1335, '350801', '350800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1336, '350802', '350800', '新罗区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1337, '350803', '350800', '永定区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1338, '350821', '350800', '长汀县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1339, '350823', '350800', '上杭县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1340, '350824', '350800', '武平县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1341, '350825', '350800', '连城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1342, '350881', '350800', '漳平市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1343, '350900', '350000', '宁德市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1344, '350901', '350900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1345, '350902', '350900', '蕉城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1346, '350921', '350900', '霞浦县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1347, '350922', '350900', '古田县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1348, '350923', '350900', '屏南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1349, '350924', '350900', '寿宁县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1350, '350925', '350900', '周宁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1351, '350926', '350900', '柘荣县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1352, '350981', '350900', '福安市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1353, '350982', '350900', '福鼎市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1354, '360000', '0', '江西省', 1, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1355, '360100', '360000', '南昌市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1356, '360101', '360100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1357, '360102', '360100', '东湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1358, '360103', '360100', '西湖区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1359, '360104', '360100', '青云谱区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1360, '360105', '360100', '湾里区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1361, '360111', '360100', '青山湖区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1362, '360112', '360100', '新建区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1363, '360121', '360100', '南昌县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1364, '360123', '360100', '安义县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1365, '360124', '360100', '进贤县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1366, '360200', '360000', '景德镇市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1367, '360201', '360200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1368, '360202', '360200', '昌江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1369, '360203', '360200', '珠山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1370, '360222', '360200', '浮梁县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1371, '360281', '360200', '乐平市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1372, '360300', '360000', '萍乡市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1373, '360301', '360300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1374, '360302', '360300', '安源区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1375, '360313', '360300', '湘东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1376, '360321', '360300', '莲花县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1377, '360322', '360300', '上栗县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1378, '360323', '360300', '芦溪县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1379, '360400', '360000', '九江市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1380, '360401', '360400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1381, '360402', '360400', '濂溪区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1382, '360403', '360400', '浔阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1383, '360421', '360400', '九江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1384, '360423', '360400', '武宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1385, '360424', '360400', '修水县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1386, '360425', '360400', '永修县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1387, '360426', '360400', '德安县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1388, '360428', '360400', '都昌县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1389, '360429', '360400', '湖口县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1390, '360430', '360400', '彭泽县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1391, '360481', '360400', '瑞昌市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1392, '360482', '360400', '共青城市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1393, '360483', '360400', '庐山市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1394, '360500', '360000', '新余市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1395, '360501', '360500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1396, '360502', '360500', '渝水区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1397, '360521', '360500', '分宜县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1398, '360600', '360000', '鹰潭市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1399, '360601', '360600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1400, '360602', '360600', '月湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1401, '360622', '360600', '余江县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1402, '360681', '360600', '贵溪市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1403, '360700', '360000', '赣州市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1404, '360701', '360700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1405, '360702', '360700', '章贡区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1406, '360703', '360700', '南康区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1407, '360721', '360700', '赣县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1408, '360722', '360700', '信丰县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1409, '360723', '360700', '大余县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1410, '360724', '360700', '上犹县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1411, '360725', '360700', '崇义县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1412, '360726', '360700', '安远县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1413, '360727', '360700', '龙南县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1414, '360728', '360700', '定南县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1415, '360729', '360700', '全南县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1416, '360730', '360700', '宁都县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1417, '360731', '360700', '于都县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1418, '360732', '360700', '兴国县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1419, '360733', '360700', '会昌县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1420, '360734', '360700', '寻乌县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1421, '360735', '360700', '石城县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1422, '360781', '360700', '瑞金市', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1423, '360800', '360000', '吉安市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1424, '360801', '360800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1425, '360802', '360800', '吉州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1426, '360803', '360800', '青原区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1427, '360821', '360800', '吉安县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1428, '360822', '360800', '吉水县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1429, '360823', '360800', '峡江县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1430, '360824', '360800', '新干县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1431, '360825', '360800', '永丰县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1432, '360826', '360800', '泰和县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1433, '360827', '360800', '遂川县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1434, '360828', '360800', '万安县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1435, '360829', '360800', '安福县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1436, '360830', '360800', '永新县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1437, '360881', '360800', '井冈山市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1438, '360900', '360000', '宜春市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1439, '360901', '360900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1440, '360902', '360900', '袁州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1441, '360921', '360900', '奉新县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1442, '360922', '360900', '万载县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1443, '360923', '360900', '上高县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1444, '360924', '360900', '宜丰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1445, '360925', '360900', '靖安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1446, '360926', '360900', '铜鼓县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1447, '360981', '360900', '丰城市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1448, '360982', '360900', '樟树市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1449, '360983', '360900', '高安市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1450, '361000', '360000', '抚州市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1451, '361001', '361000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1452, '361002', '361000', '临川区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1453, '361021', '361000', '南城县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1454, '361022', '361000', '黎川县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1455, '361023', '361000', '南丰县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1456, '361024', '361000', '崇仁县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1457, '361025', '361000', '乐安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1458, '361026', '361000', '宜黄县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1459, '361027', '361000', '金溪县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1460, '361028', '361000', '资溪县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1461, '361029', '361000', '东乡县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1462, '361030', '361000', '广昌县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1463, '361100', '360000', '上饶市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1464, '361101', '361100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1465, '361102', '361100', '信州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1466, '361103', '361100', '广丰区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1467, '361121', '361100', '上饶县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1468, '361123', '361100', '玉山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1469, '361124', '361100', '铅山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1470, '361125', '361100', '横峰县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1471, '361126', '361100', '弋阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1472, '361127', '361100', '余干县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1473, '361128', '361100', '鄱阳县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1474, '361129', '361100', '万年县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1475, '361130', '361100', '婺源县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1476, '361181', '361100', '德兴市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1477, '370000', '0', '山东省', 1, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1478, '370100', '370000', '济南市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1479, '370101', '370100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1480, '370102', '370100', '历下区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1481, '370103', '370100', '市中区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1482, '370104', '370100', '槐荫区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1483, '370105', '370100', '天桥区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1484, '370112', '370100', '历城区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1485, '370113', '370100', '长清区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1486, '370124', '370100', '平阴县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1487, '370125', '370100', '济阳县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1488, '370126', '370100', '商河县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1489, '370181', '370100', '章丘市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1490, '370200', '370000', '青岛市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1491, '370201', '370200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1492, '370202', '370200', '市南区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1493, '370203', '370200', '市北区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1494, '370211', '370200', '黄岛区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1495, '370212', '370200', '崂山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1496, '370213', '370200', '李沧区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1497, '370214', '370200', '城阳区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1498, '370281', '370200', '胶州市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1499, '370282', '370200', '即墨市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1500, '370283', '370200', '平度市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1501, '370285', '370200', '莱西市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1502, '370300', '370000', '淄博市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1503, '370301', '370300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1504, '370302', '370300', '淄川区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1505, '370303', '370300', '张店区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1506, '370304', '370300', '博山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1507, '370305', '370300', '临淄区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1508, '370306', '370300', '周村区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1509, '370321', '370300', '桓台县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1510, '370322', '370300', '高青县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1511, '370323', '370300', '沂源县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1512, '370400', '370000', '枣庄市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1513, '370401', '370400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1514, '370402', '370400', '市中区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1515, '370403', '370400', '薛城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1516, '370404', '370400', '峄城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1517, '370405', '370400', '台儿庄区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1518, '370406', '370400', '山亭区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1519, '370481', '370400', '滕州市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1520, '370500', '370000', '东营市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1521, '370501', '370500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1522, '370502', '370500', '东营区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1523, '370503', '370500', '河口区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1524, '370505', '370500', '垦利区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1525, '370522', '370500', '利津县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1526, '370523', '370500', '广饶县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1527, '370600', '370000', '烟台市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1528, '370601', '370600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1529, '370602', '370600', '芝罘区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1530, '370611', '370600', '福山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1531, '370612', '370600', '牟平区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1532, '370613', '370600', '莱山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1533, '370634', '370600', '长岛县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1534, '370681', '370600', '龙口市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1535, '370682', '370600', '莱阳市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1536, '370683', '370600', '莱州市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1537, '370684', '370600', '蓬莱市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1538, '370685', '370600', '招远市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1539, '370686', '370600', '栖霞市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1540, '370687', '370600', '海阳市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1541, '370700', '370000', '潍坊市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1542, '370701', '370700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1543, '370702', '370700', '潍城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1544, '370703', '370700', '寒亭区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1545, '370704', '370700', '坊子区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1546, '370705', '370700', '奎文区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1547, '370724', '370700', '临朐县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1548, '370725', '370700', '昌乐县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1549, '370781', '370700', '青州市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1550, '370782', '370700', '诸城市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1551, '370783', '370700', '寿光市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1552, '370784', '370700', '安丘市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1553, '370785', '370700', '高密市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1554, '370786', '370700', '昌邑市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1555, '370800', '370000', '济宁市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1556, '370801', '370800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1557, '370811', '370800', '任城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1558, '370812', '370800', '兖州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1559, '370826', '370800', '微山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1560, '370827', '370800', '鱼台县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1561, '370828', '370800', '金乡县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1562, '370829', '370800', '嘉祥县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1563, '370830', '370800', '汶上县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1564, '370831', '370800', '泗水县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1565, '370832', '370800', '梁山县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1566, '370881', '370800', '曲阜市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1567, '370883', '370800', '邹城市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1568, '370900', '370000', '泰安市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1569, '370901', '370900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1570, '370902', '370900', '泰山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1571, '370911', '370900', '岱岳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1572, '370921', '370900', '宁阳县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1573, '370923', '370900', '东平县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1574, '370982', '370900', '新泰市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1575, '370983', '370900', '肥城市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1576, '371000', '370000', '威海市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1577, '371001', '371000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1578, '371002', '371000', '环翠区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1579, '371003', '371000', '文登区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1580, '371082', '371000', '荣成市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1581, '371083', '371000', '乳山市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1582, '371100', '370000', '日照市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1583, '371101', '371100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1584, '371102', '371100', '东港区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1585, '371103', '371100', '岚山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1586, '371121', '371100', '五莲县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1587, '371122', '371100', '莒县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1588, '371200', '370000', '莱芜市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1589, '371201', '371200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1590, '371202', '371200', '莱城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1591, '371203', '371200', '钢城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1592, '371300', '370000', '临沂市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1593, '371301', '371300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1594, '371302', '371300', '兰山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1595, '371311', '371300', '罗庄区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1596, '371312', '371300', '河东区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1597, '371321', '371300', '沂南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1598, '371322', '371300', '郯城县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1599, '371323', '371300', '沂水县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1600, '371324', '371300', '兰陵县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1601, '371325', '371300', '费县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1602, '371326', '371300', '平邑县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1603, '371327', '371300', '莒南县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1604, '371328', '371300', '蒙阴县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1605, '371329', '371300', '临沭县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1606, '371400', '370000', '德州市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1607, '371401', '371400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1608, '371402', '371400', '德城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1609, '371403', '371400', '陵城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1610, '371422', '371400', '宁津县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1611, '371423', '371400', '庆云县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1612, '371424', '371400', '临邑县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1613, '371425', '371400', '齐河县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1614, '371426', '371400', '平原县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1615, '371427', '371400', '夏津县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1616, '371428', '371400', '武城县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1617, '371481', '371400', '乐陵市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1618, '371482', '371400', '禹城市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1619, '371500', '370000', '聊城市', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1620, '371501', '371500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1621, '371502', '371500', '东昌府区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1622, '371521', '371500', '阳谷县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1623, '371522', '371500', '莘县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1624, '371523', '371500', '茌平县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1625, '371524', '371500', '东阿县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1626, '371525', '371500', '冠县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1627, '371526', '371500', '高唐县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1628, '371581', '371500', '临清市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1629, '371600', '370000', '滨州市', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1630, '371601', '371600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1631, '371602', '371600', '滨城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1632, '371603', '371600', '沾化区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1633, '371621', '371600', '惠民县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1634, '371622', '371600', '阳信县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1635, '371623', '371600', '无棣县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1636, '371625', '371600', '博兴县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1637, '371626', '371600', '邹平县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1638, '371700', '370000', '菏泽市', 2, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1639, '371701', '371700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1640, '371702', '371700', '牡丹区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1641, '371703', '371700', '定陶区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1642, '371721', '371700', '曹县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1643, '371722', '371700', '单县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1644, '371723', '371700', '成武县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1645, '371724', '371700', '巨野县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1646, '371725', '371700', '郓城县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1647, '371726', '371700', '鄄城县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1648, '371728', '371700', '东明县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1649, '410000', '0', '河南省', 1, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1650, '410100', '410000', '郑州市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1651, '410101', '410100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1652, '410102', '410100', '中原区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1653, '410103', '410100', '二七区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1654, '410104', '410100', '管城回族区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1655, '410105', '410100', '金水区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1656, '410106', '410100', '上街区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1657, '410108', '410100', '惠济区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1658, '410122', '410100', '中牟县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1659, '410181', '410100', '巩义市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1660, '410182', '410100', '荥阳市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1661, '410183', '410100', '新密市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1662, '410184', '410100', '新郑市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1663, '410185', '410100', '登封市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1664, '410200', '410000', '开封市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1665, '410201', '410200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1666, '410202', '410200', '龙亭区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1667, '410203', '410200', '顺河回族区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1668, '410204', '410200', '鼓楼区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1669, '410205', '410200', '禹王台区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1670, '410211', '410200', '金明区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1671, '410212', '410200', '祥符区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1672, '410221', '410200', '杞县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1673, '410222', '410200', '通许县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1674, '410223', '410200', '尉氏县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1675, '410225', '410200', '兰考县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1676, '410300', '410000', '洛阳市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1677, '410301', '410300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1678, '410302', '410300', '老城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1679, '410303', '410300', '西工区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1680, '410304', '410300', '瀍河回族区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1681, '410305', '410300', '涧西区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1682, '410306', '410300', '吉利区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1683, '410311', '410300', '洛龙区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1684, '410322', '410300', '孟津县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1685, '410323', '410300', '新安县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1686, '410324', '410300', '栾川县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1687, '410325', '410300', '嵩县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1688, '410326', '410300', '汝阳县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1689, '410327', '410300', '宜阳县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1690, '410328', '410300', '洛宁县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1691, '410329', '410300', '伊川县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1692, '410381', '410300', '偃师市', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1693, '410400', '410000', '平顶山市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1694, '410401', '410400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1695, '410402', '410400', '新华区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1696, '410403', '410400', '卫东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1697, '410404', '410400', '石龙区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1698, '410411', '410400', '湛河区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1699, '410421', '410400', '宝丰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1700, '410422', '410400', '叶县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1701, '410423', '410400', '鲁山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1702, '410425', '410400', '郏县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1703, '410481', '410400', '舞钢市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1704, '410482', '410400', '汝州市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1705, '410500', '410000', '安阳市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1706, '410501', '410500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1707, '410502', '410500', '文峰区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1708, '410503', '410500', '北关区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1709, '410505', '410500', '殷都区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1710, '410506', '410500', '龙安区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1711, '410522', '410500', '安阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1712, '410523', '410500', '汤阴县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1713, '410526', '410500', '滑县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1714, '410527', '410500', '内黄县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1715, '410581', '410500', '林州市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1716, '410600', '410000', '鹤壁市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1717, '410601', '410600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1718, '410602', '410600', '鹤山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1719, '410603', '410600', '山城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1720, '410611', '410600', '淇滨区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1721, '410621', '410600', '浚县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1722, '410622', '410600', '淇县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1723, '410700', '410000', '新乡市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1724, '410701', '410700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1725, '410702', '410700', '红旗区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1726, '410703', '410700', '卫滨区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1727, '410704', '410700', '凤泉区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1728, '410711', '410700', '牧野区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1729, '410721', '410700', '新乡县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1730, '410724', '410700', '获嘉县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1731, '410725', '410700', '原阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1732, '410726', '410700', '延津县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1733, '410727', '410700', '封丘县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1734, '410728', '410700', '长垣县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1735, '410781', '410700', '卫辉市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1736, '410782', '410700', '辉县市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1737, '410800', '410000', '焦作市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1738, '410801', '410800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1739, '410802', '410800', '解放区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1740, '410803', '410800', '中站区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1741, '410804', '410800', '马村区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1742, '410811', '410800', '山阳区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1743, '410821', '410800', '修武县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1744, '410822', '410800', '博爱县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1745, '410823', '410800', '武陟县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1746, '410825', '410800', '温县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1747, '410882', '410800', '沁阳市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1748, '410883', '410800', '孟州市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1749, '410900', '410000', '濮阳市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1750, '410901', '410900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1751, '410902', '410900', '华龙区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1752, '410922', '410900', '清丰县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1753, '410923', '410900', '南乐县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1754, '410926', '410900', '范县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1755, '410927', '410900', '台前县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1756, '410928', '410900', '濮阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1757, '411000', '410000', '许昌市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1758, '411001', '411000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1759, '411002', '411000', '魏都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1760, '411023', '411000', '许昌县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1761, '411024', '411000', '鄢陵县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1762, '411025', '411000', '襄城县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1763, '411081', '411000', '禹州市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1764, '411082', '411000', '长葛市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1765, '411100', '410000', '漯河市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1766, '411101', '411100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1767, '411102', '411100', '源汇区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1768, '411103', '411100', '郾城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1769, '411104', '411100', '召陵区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1770, '411121', '411100', '舞阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1771, '411122', '411100', '临颍县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1772, '411200', '410000', '三门峡市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1773, '411201', '411200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1774, '411202', '411200', '湖滨区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1775, '411203', '411200', '陕州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1776, '411221', '411200', '渑池县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1777, '411224', '411200', '卢氏县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1778, '411281', '411200', '义马市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1779, '411282', '411200', '灵宝市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1780, '411300', '410000', '南阳市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1781, '411301', '411300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1782, '411302', '411300', '宛城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1783, '411303', '411300', '卧龙区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1784, '411321', '411300', '南召县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1785, '411322', '411300', '方城县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1786, '411323', '411300', '西峡县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1787, '411324', '411300', '镇平县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1788, '411325', '411300', '内乡县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1789, '411326', '411300', '淅川县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1790, '411327', '411300', '社旗县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1791, '411328', '411300', '唐河县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1792, '411329', '411300', '新野县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1793, '411330', '411300', '桐柏县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1794, '411381', '411300', '邓州市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1795, '411400', '410000', '商丘市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1796, '411401', '411400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1797, '411402', '411400', '梁园区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1798, '411403', '411400', '睢阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1799, '411421', '411400', '民权县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1800, '411422', '411400', '睢县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1801, '411423', '411400', '宁陵县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1802, '411424', '411400', '柘城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1803, '411425', '411400', '虞城县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1804, '411426', '411400', '夏邑县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1805, '411481', '411400', '永城市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1806, '411500', '410000', '信阳市', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1807, '411501', '411500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1808, '411502', '411500', '浉河区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1809, '411503', '411500', '平桥区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1810, '411521', '411500', '罗山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1811, '411522', '411500', '光山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1812, '411523', '411500', '新县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1813, '411524', '411500', '商城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1814, '411525', '411500', '固始县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1815, '411526', '411500', '潢川县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1816, '411527', '411500', '淮滨县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1817, '411528', '411500', '息县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1818, '411600', '410000', '周口市', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1819, '411601', '411600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1820, '411602', '411600', '川汇区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1821, '411621', '411600', '扶沟县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1822, '411622', '411600', '西华县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1823, '411623', '411600', '商水县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1824, '411624', '411600', '沈丘县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1825, '411625', '411600', '郸城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1826, '411626', '411600', '淮阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1827, '411627', '411600', '太康县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1828, '411628', '411600', '鹿邑县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1829, '411681', '411600', '项城市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1830, '411700', '410000', '驻马店市', 2, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1831, '411701', '411700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1832, '411702', '411700', '驿城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1833, '411721', '411700', '西平县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1834, '411722', '411700', '上蔡县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1835, '411723', '411700', '平舆县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1836, '411724', '411700', '正阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1837, '411725', '411700', '确山县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1838, '411726', '411700', '泌阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1839, '411727', '411700', '汝南县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1840, '411728', '411700', '遂平县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1841, '411729', '411700', '新蔡县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1842, '419000', '410000', '省直辖县级行政区划', 2, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1843, '419001', '419000', '济源市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1844, '420000', '0', '湖北省', 1, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1845, '420100', '420000', '武汉市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1846, '420101', '420100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1847, '420102', '420100', '江岸区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1848, '420103', '420100', '江汉区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1849, '420104', '420100', '硚口区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1850, '420105', '420100', '汉阳区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1851, '420106', '420100', '武昌区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1852, '420107', '420100', '青山区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1853, '420111', '420100', '洪山区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1854, '420112', '420100', '东西湖区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1855, '420113', '420100', '汉南区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1856, '420114', '420100', '蔡甸区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1857, '420115', '420100', '江夏区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1858, '420116', '420100', '黄陂区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1859, '420117', '420100', '新洲区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1860, '420200', '420000', '黄石市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1861, '420201', '420200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1862, '420202', '420200', '黄石港区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1863, '420203', '420200', '西塞山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1864, '420204', '420200', '下陆区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1865, '420205', '420200', '铁山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1866, '420222', '420200', '阳新县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1867, '420281', '420200', '大冶市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1868, '420300', '420000', '十堰市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1869, '420301', '420300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1870, '420302', '420300', '茅箭区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1871, '420303', '420300', '张湾区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1872, '420304', '420300', '郧阳区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1873, '420322', '420300', '郧西县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1874, '420323', '420300', '竹山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1875, '420324', '420300', '竹溪县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1876, '420325', '420300', '房县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1877, '420381', '420300', '丹江口市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1878, '420500', '420000', '宜昌市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1879, '420501', '420500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1880, '420502', '420500', '西陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1881, '420503', '420500', '伍家岗区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1882, '420504', '420500', '点军区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1883, '420505', '420500', '猇亭区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1884, '420506', '420500', '夷陵区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1885, '420525', '420500', '远安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1886, '420526', '420500', '兴山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1887, '420527', '420500', '秭归县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1888, '420528', '420500', '长阳土家族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1889, '420529', '420500', '五峰土家族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1890, '420581', '420500', '宜都市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1891, '420582', '420500', '当阳市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1892, '420583', '420500', '枝江市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1893, '420600', '420000', '襄阳市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1894, '420601', '420600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1895, '420602', '420600', '襄城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1896, '420606', '420600', '樊城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1897, '420607', '420600', '襄州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1898, '420624', '420600', '南漳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1899, '420625', '420600', '谷城县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1900, '420626', '420600', '保康县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1901, '420682', '420600', '老河口市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1902, '420683', '420600', '枣阳市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1903, '420684', '420600', '宜城市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1904, '420700', '420000', '鄂州市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1905, '420701', '420700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1906, '420702', '420700', '梁子湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1907, '420703', '420700', '华容区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1908, '420704', '420700', '鄂城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1909, '420800', '420000', '荆门市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1910, '420801', '420800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1911, '420802', '420800', '东宝区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1912, '420804', '420800', '掇刀区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1913, '420821', '420800', '京山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1914, '420822', '420800', '沙洋县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1915, '420881', '420800', '钟祥市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1916, '420900', '420000', '孝感市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1917, '420901', '420900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1918, '420902', '420900', '孝南区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1919, '420921', '420900', '孝昌县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1920, '420922', '420900', '大悟县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1921, '420923', '420900', '云梦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1922, '420981', '420900', '应城市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1923, '420982', '420900', '安陆市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1924, '420984', '420900', '汉川市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1925, '421000', '420000', '荆州市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1926, '421001', '421000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1927, '421002', '421000', '沙市区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1928, '421003', '421000', '荆州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1929, '421022', '421000', '公安县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1930, '421023', '421000', '监利县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1931, '421024', '421000', '江陵县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1932, '421081', '421000', '石首市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1933, '421083', '421000', '洪湖市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1934, '421087', '421000', '松滋市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1935, '421100', '420000', '黄冈市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1936, '421101', '421100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1937, '421102', '421100', '黄州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1938, '421121', '421100', '团风县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1939, '421122', '421100', '红安县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1940, '421123', '421100', '罗田县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1941, '421124', '421100', '英山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1942, '421125', '421100', '浠水县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1943, '421126', '421100', '蕲春县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1944, '421127', '421100', '黄梅县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1945, '421181', '421100', '麻城市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1946, '421182', '421100', '武穴市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1947, '421200', '420000', '咸宁市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1948, '421201', '421200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1949, '421202', '421200', '咸安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1950, '421221', '421200', '嘉鱼县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1951, '421222', '421200', '通城县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1952, '421223', '421200', '崇阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1953, '421224', '421200', '通山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1954, '421281', '421200', '赤壁市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1955, '421300', '420000', '随州市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1956, '421301', '421300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1957, '421303', '421300', '曾都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1958, '421321', '421300', '随县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1959, '421381', '421300', '广水市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1960, '422800', '420000', '恩施土家族苗族自治州', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1961, '422801', '422800', '恩施市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1962, '422802', '422800', '利川市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1963, '422822', '422800', '建始县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1964, '422823', '422800', '巴东县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1965, '422825', '422800', '宣恩县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1966, '422826', '422800', '咸丰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1967, '422827', '422800', '来凤县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1968, '422828', '422800', '鹤峰县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1969, '429000', '420000', '省直辖县级行政区划', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1970, '429004', '429000', '仙桃市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1971, '429005', '429000', '潜江市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1972, '429006', '429000', '天门市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1973, '429021', '429000', '神农架林区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1974, '430000', '0', '湖南省', 1, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1975, '430100', '430000', '长沙市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1976, '430101', '430100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1977, '430102', '430100', '芙蓉区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1978, '430103', '430100', '天心区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1979, '430104', '430100', '岳麓区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1980, '430105', '430100', '开福区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1981, '430111', '430100', '雨花区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1982, '430112', '430100', '望城区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1983, '430121', '430100', '长沙县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1984, '430124', '430100', '宁乡县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1985, '430181', '430100', '浏阳市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1986, '430200', '430000', '株洲市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1987, '430201', '430200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1988, '430202', '430200', '荷塘区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1989, '430203', '430200', '芦淞区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1990, '430204', '430200', '石峰区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1991, '430211', '430200', '天元区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1992, '430221', '430200', '株洲县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1993, '430223', '430200', '攸县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1994, '430224', '430200', '茶陵县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1995, '430225', '430200', '炎陵县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1996, '430281', '430200', '醴陵市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1997, '430300', '430000', '湘潭市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1998, '430301', '430300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (1999, '430302', '430300', '雨湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2000, '430304', '430300', '岳塘区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2001, '430321', '430300', '湘潭县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2002, '430381', '430300', '湘乡市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2003, '430382', '430300', '韶山市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2004, '430400', '430000', '衡阳市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2005, '430401', '430400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2006, '430405', '430400', '珠晖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2007, '430406', '430400', '雁峰区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2008, '430407', '430400', '石鼓区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2009, '430408', '430400', '蒸湘区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2010, '430412', '430400', '南岳区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2011, '430421', '430400', '衡阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2012, '430422', '430400', '衡南县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2013, '430423', '430400', '衡山县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2014, '430424', '430400', '衡东县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2015, '430426', '430400', '祁东县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2016, '430481', '430400', '耒阳市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2017, '430482', '430400', '常宁市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2018, '430500', '430000', '邵阳市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2019, '430501', '430500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2020, '430502', '430500', '双清区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2021, '430503', '430500', '大祥区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2022, '430511', '430500', '北塔区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2023, '430521', '430500', '邵东县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2024, '430522', '430500', '新邵县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2025, '430523', '430500', '邵阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2026, '430524', '430500', '隆回县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2027, '430525', '430500', '洞口县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2028, '430527', '430500', '绥宁县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2029, '430528', '430500', '新宁县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2030, '430529', '430500', '城步苗族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2031, '430581', '430500', '武冈市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2032, '430600', '430000', '岳阳市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2033, '430601', '430600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2034, '430602', '430600', '岳阳楼区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2035, '430603', '430600', '云溪区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2036, '430611', '430600', '君山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2037, '430621', '430600', '岳阳县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2038, '430623', '430600', '华容县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2039, '430624', '430600', '湘阴县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2040, '430626', '430600', '平江县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2041, '430681', '430600', '汨罗市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2042, '430682', '430600', '临湘市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2043, '430700', '430000', '常德市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2044, '430701', '430700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2045, '430702', '430700', '武陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2046, '430703', '430700', '鼎城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2047, '430721', '430700', '安乡县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2048, '430722', '430700', '汉寿县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2049, '430723', '430700', '澧县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2050, '430724', '430700', '临澧县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2051, '430725', '430700', '桃源县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2052, '430726', '430700', '石门县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2053, '430781', '430700', '津市市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2054, '430800', '430000', '张家界市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2055, '430801', '430800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2056, '430802', '430800', '永定区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2057, '430811', '430800', '武陵源区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2058, '430821', '430800', '慈利县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2059, '430822', '430800', '桑植县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2060, '430900', '430000', '益阳市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2061, '430901', '430900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2062, '430902', '430900', '资阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2063, '430903', '430900', '赫山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2064, '430921', '430900', '南县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2065, '430922', '430900', '桃江县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2066, '430923', '430900', '安化县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2067, '430981', '430900', '沅江市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2068, '431000', '430000', '郴州市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2069, '431001', '431000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2070, '431002', '431000', '北湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2071, '431003', '431000', '苏仙区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2072, '431021', '431000', '桂阳县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2073, '431022', '431000', '宜章县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2074, '431023', '431000', '永兴县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2075, '431024', '431000', '嘉禾县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2076, '431025', '431000', '临武县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2077, '431026', '431000', '汝城县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2078, '431027', '431000', '桂东县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2079, '431028', '431000', '安仁县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2080, '431081', '431000', '资兴市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2081, '431100', '430000', '永州市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2082, '431101', '431100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2083, '431102', '431100', '零陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2084, '431103', '431100', '冷水滩区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2085, '431121', '431100', '祁阳县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2086, '431122', '431100', '东安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2087, '431123', '431100', '双牌县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2088, '431124', '431100', '道县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2089, '431125', '431100', '江永县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2090, '431126', '431100', '宁远县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2091, '431127', '431100', '蓝山县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2092, '431128', '431100', '新田县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2093, '431129', '431100', '江华瑶族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2094, '431200', '430000', '怀化市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2095, '431201', '431200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2096, '431202', '431200', '鹤城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2097, '431221', '431200', '中方县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2098, '431222', '431200', '沅陵县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2099, '431223', '431200', '辰溪县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2100, '431224', '431200', '溆浦县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2101, '431225', '431200', '会同县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2102, '431226', '431200', '麻阳苗族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2103, '431227', '431200', '新晃侗族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2104, '431228', '431200', '芷江侗族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2105, '431229', '431200', '靖州苗族侗族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2106, '431230', '431200', '通道侗族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2107, '431281', '431200', '洪江市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2108, '431300', '430000', '娄底市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2109, '431301', '431300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2110, '431302', '431300', '娄星区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2111, '431321', '431300', '双峰县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2112, '431322', '431300', '新化县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2113, '431381', '431300', '冷水江市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2114, '431382', '431300', '涟源市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2115, '433100', '430000', '湘西土家族苗族自治州', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2116, '433101', '433100', '吉首市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2117, '433122', '433100', '泸溪县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2118, '433123', '433100', '凤凰县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2119, '433124', '433100', '花垣县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2120, '433125', '433100', '保靖县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2121, '433126', '433100', '古丈县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2122, '433127', '433100', '永顺县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2123, '433130', '433100', '龙山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2124, '440000', '0', '广东省', 1, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2125, '440100', '440000', '广州市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2126, '440101', '440100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2127, '440103', '440100', '荔湾区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2128, '440104', '440100', '越秀区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2129, '440105', '440100', '海珠区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2130, '440106', '440100', '天河区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2131, '440111', '440100', '白云区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2132, '440112', '440100', '黄埔区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2133, '440113', '440100', '番禺区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2134, '440114', '440100', '花都区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2135, '440115', '440100', '南沙区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2136, '440117', '440100', '从化区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2137, '440118', '440100', '增城区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2138, '440200', '440000', '韶关市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2139, '440201', '440200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2140, '440203', '440200', '武江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2141, '440204', '440200', '浈江区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2142, '440205', '440200', '曲江区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2143, '440222', '440200', '始兴县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2144, '440224', '440200', '仁化县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2145, '440229', '440200', '翁源县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2146, '440232', '440200', '乳源瑶族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2147, '440233', '440200', '新丰县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2148, '440281', '440200', '乐昌市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2149, '440282', '440200', '南雄市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2150, '440300', '440000', '深圳市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2151, '440301', '440300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2152, '440303', '440300', '罗湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2153, '440304', '440300', '福田区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2154, '440305', '440300', '南山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2155, '440306', '440300', '宝安区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2156, '440307', '440300', '龙岗区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2157, '440308', '440300', '盐田区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2158, '440400', '440000', '珠海市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2159, '440401', '440400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2160, '440402', '440400', '香洲区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2161, '440403', '440400', '斗门区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2162, '440404', '440400', '金湾区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2163, '440500', '440000', '汕头市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2164, '440501', '440500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2165, '440507', '440500', '龙湖区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2166, '440511', '440500', '金平区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2167, '440512', '440500', '濠江区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2168, '440513', '440500', '潮阳区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2169, '440514', '440500', '潮南区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2170, '440515', '440500', '澄海区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2171, '440523', '440500', '南澳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2172, '440600', '440000', '佛山市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2173, '440601', '440600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2174, '440604', '440600', '禅城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2175, '440605', '440600', '南海区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2176, '440606', '440600', '顺德区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2177, '440607', '440600', '三水区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2178, '440608', '440600', '高明区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2179, '440700', '440000', '江门市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2180, '440701', '440700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2181, '440703', '440700', '蓬江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2182, '440704', '440700', '江海区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2183, '440705', '440700', '新会区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2184, '440781', '440700', '台山市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2185, '440783', '440700', '开平市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2186, '440784', '440700', '鹤山市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2187, '440785', '440700', '恩平市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2188, '440800', '440000', '湛江市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2189, '440801', '440800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2190, '440802', '440800', '赤坎区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2191, '440803', '440800', '霞山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2192, '440804', '440800', '坡头区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2193, '440811', '440800', '麻章区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2194, '440823', '440800', '遂溪县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2195, '440825', '440800', '徐闻县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2196, '440881', '440800', '廉江市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2197, '440882', '440800', '雷州市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2198, '440883', '440800', '吴川市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2199, '440900', '440000', '茂名市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2200, '440901', '440900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2201, '440902', '440900', '茂南区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2202, '440904', '440900', '电白区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2203, '440981', '440900', '高州市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2204, '440982', '440900', '化州市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2205, '440983', '440900', '信宜市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2206, '441200', '440000', '肇庆市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2207, '441201', '441200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2208, '441202', '441200', '端州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2209, '441203', '441200', '鼎湖区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2210, '441204', '441200', '高要区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2211, '441223', '441200', '广宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2212, '441224', '441200', '怀集县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2213, '441225', '441200', '封开县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2214, '441226', '441200', '德庆县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2215, '441284', '441200', '四会市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2216, '441300', '440000', '惠州市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2217, '441301', '441300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2218, '441302', '441300', '惠城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2219, '441303', '441300', '惠阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2220, '441322', '441300', '博罗县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2221, '441323', '441300', '惠东县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2222, '441324', '441300', '龙门县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2223, '441400', '440000', '梅州市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2224, '441401', '441400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2225, '441402', '441400', '梅江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2226, '441403', '441400', '梅县区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2227, '441422', '441400', '大埔县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2228, '441423', '441400', '丰顺县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2229, '441424', '441400', '五华县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2230, '441426', '441400', '平远县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2231, '441427', '441400', '蕉岭县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2232, '441481', '441400', '兴宁市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2233, '441500', '440000', '汕尾市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2234, '441501', '441500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2235, '441502', '441500', '城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2236, '441521', '441500', '海丰县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2237, '441523', '441500', '陆河县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2238, '441581', '441500', '陆丰市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2239, '441600', '440000', '河源市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2240, '441601', '441600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2241, '441602', '441600', '源城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2242, '441621', '441600', '紫金县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2243, '441622', '441600', '龙川县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2244, '441623', '441600', '连平县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2245, '441624', '441600', '和平县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2246, '441625', '441600', '东源县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2247, '441700', '440000', '阳江市', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2248, '441701', '441700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2249, '441702', '441700', '江城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2250, '441704', '441700', '阳东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2251, '441721', '441700', '阳西县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2252, '441781', '441700', '阳春市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2253, '441800', '440000', '清远市', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2254, '441801', '441800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2255, '441802', '441800', '清城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2256, '441803', '441800', '清新区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2257, '441821', '441800', '佛冈县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2258, '441823', '441800', '阳山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2259, '441825', '441800', '连山壮族瑶族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2260, '441826', '441800', '连南瑶族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2261, '441881', '441800', '英德市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2262, '441882', '441800', '连州市', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2263, '441900', '440000', '东莞市', 2, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2264, '442000', '440000', '中山市', 2, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2265, '445100', '440000', '潮州市', 2, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2266, '445101', '445100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2267, '445102', '445100', '湘桥区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2268, '445103', '445100', '潮安区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2269, '445122', '445100', '饶平县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2270, '445200', '440000', '揭阳市', 2, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2271, '445201', '445200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2272, '445202', '445200', '榕城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2273, '445203', '445200', '揭东区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2274, '445222', '445200', '揭西县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2275, '445224', '445200', '惠来县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2276, '445281', '445200', '普宁市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2277, '445300', '440000', '云浮市', 2, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2278, '445301', '445300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2279, '445302', '445300', '云城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2280, '445303', '445300', '云安区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2281, '445321', '445300', '新兴县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2282, '445322', '445300', '郁南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2283, '445381', '445300', '罗定市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2284, '450000', '0', '广西壮族自治区', 1, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2285, '450100', '450000', '南宁市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2286, '450101', '450100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2287, '450102', '450100', '兴宁区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2288, '450103', '450100', '青秀区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2289, '450105', '450100', '江南区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2290, '450107', '450100', '西乡塘区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2291, '450108', '450100', '良庆区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2292, '450109', '450100', '邕宁区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2293, '450110', '450100', '武鸣区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2294, '450123', '450100', '隆安县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2295, '450124', '450100', '马山县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2296, '450125', '450100', '上林县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2297, '450126', '450100', '宾阳县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2298, '450127', '450100', '横县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2299, '450200', '450000', '柳州市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2300, '450201', '450200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2301, '450202', '450200', '城中区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2302, '450203', '450200', '鱼峰区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2303, '450204', '450200', '柳南区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2304, '450205', '450200', '柳北区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2305, '450206', '450200', '柳江区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2306, '450222', '450200', '柳城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2307, '450223', '450200', '鹿寨县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2308, '450224', '450200', '融安县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2309, '450225', '450200', '融水苗族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2310, '450226', '450200', '三江侗族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2311, '450300', '450000', '桂林市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2312, '450301', '450300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2313, '450302', '450300', '秀峰区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2314, '450303', '450300', '叠彩区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2315, '450304', '450300', '象山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2316, '450305', '450300', '七星区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2317, '450311', '450300', '雁山区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2318, '450312', '450300', '临桂区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2319, '450321', '450300', '阳朔县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2320, '450323', '450300', '灵川县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2321, '450324', '450300', '全州县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2322, '450325', '450300', '兴安县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2323, '450326', '450300', '永福县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2324, '450327', '450300', '灌阳县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2325, '450328', '450300', '龙胜各族自治县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2326, '450329', '450300', '资源县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2327, '450330', '450300', '平乐县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2328, '450331', '450300', '荔浦县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2329, '450332', '450300', '恭城瑶族自治县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2330, '450400', '450000', '梧州市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2331, '450401', '450400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2332, '450403', '450400', '万秀区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2333, '450405', '450400', '长洲区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2334, '450406', '450400', '龙圩区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2335, '450421', '450400', '苍梧县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2336, '450422', '450400', '藤县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2337, '450423', '450400', '蒙山县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2338, '450481', '450400', '岑溪市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2339, '450500', '450000', '北海市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2340, '450501', '450500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2341, '450502', '450500', '海城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2342, '450503', '450500', '银海区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2343, '450512', '450500', '铁山港区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2344, '450521', '450500', '合浦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2345, '450600', '450000', '防城港市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2346, '450601', '450600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2347, '450602', '450600', '港口区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2348, '450603', '450600', '防城区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2349, '450621', '450600', '上思县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2350, '450681', '450600', '东兴市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2351, '450700', '450000', '钦州市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2352, '450701', '450700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2353, '450702', '450700', '钦南区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2354, '450703', '450700', '钦北区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2355, '450721', '450700', '灵山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2356, '450722', '450700', '浦北县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2357, '450800', '450000', '贵港市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2358, '450801', '450800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2359, '450802', '450800', '港北区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2360, '450803', '450800', '港南区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2361, '450804', '450800', '覃塘区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2362, '450821', '450800', '平南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2363, '450881', '450800', '桂平市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2364, '450900', '450000', '玉林市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2365, '450901', '450900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2366, '450902', '450900', '玉州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2367, '450903', '450900', '福绵区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2368, '450921', '450900', '容县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2369, '450922', '450900', '陆川县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2370, '450923', '450900', '博白县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2371, '450924', '450900', '兴业县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2372, '450981', '450900', '北流市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2373, '451000', '450000', '百色市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2374, '451001', '451000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2375, '451002', '451000', '右江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2376, '451021', '451000', '田阳县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2377, '451022', '451000', '田东县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2378, '451023', '451000', '平果县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2379, '451024', '451000', '德保县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2380, '451026', '451000', '那坡县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2381, '451027', '451000', '凌云县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2382, '451028', '451000', '乐业县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2383, '451029', '451000', '田林县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2384, '451030', '451000', '西林县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2385, '451031', '451000', '隆林各族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2386, '451081', '451000', '靖西市', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2387, '451100', '450000', '贺州市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2388, '451101', '451100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2389, '451102', '451100', '八步区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2390, '451103', '451100', '平桂区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2391, '451121', '451100', '昭平县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2392, '451122', '451100', '钟山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2393, '451123', '451100', '富川瑶族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2394, '451200', '450000', '河池市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2395, '451201', '451200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2396, '451202', '451200', '金城江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2397, '451221', '451200', '南丹县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2398, '451222', '451200', '天峨县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2399, '451223', '451200', '凤山县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2400, '451224', '451200', '东兰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2401, '451225', '451200', '罗城仫佬族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2402, '451226', '451200', '环江毛南族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2403, '451227', '451200', '巴马瑶族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2404, '451228', '451200', '都安瑶族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2405, '451229', '451200', '大化瑶族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2406, '451281', '451200', '宜州市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2407, '451300', '450000', '来宾市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2408, '451301', '451300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2409, '451302', '451300', '兴宾区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2410, '451321', '451300', '忻城县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2411, '451322', '451300', '象州县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2412, '451323', '451300', '武宣县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2413, '451324', '451300', '金秀瑶族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2414, '451381', '451300', '合山市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2415, '451400', '450000', '崇左市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2416, '451401', '451400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2417, '451402', '451400', '江州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2418, '451421', '451400', '扶绥县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2419, '451422', '451400', '宁明县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2420, '451423', '451400', '龙州县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2421, '451424', '451400', '大新县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2422, '451425', '451400', '天等县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2423, '451481', '451400', '凭祥市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2424, '460000', '0', '海南省', 1, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2425, '460100', '460000', '海口市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2426, '460101', '460100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2427, '460105', '460100', '秀英区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2428, '460106', '460100', '龙华区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2429, '460107', '460100', '琼山区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2430, '460108', '460100', '美兰区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2431, '460200', '460000', '三亚市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2432, '460201', '460200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2433, '460202', '460200', '海棠区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2434, '460203', '460200', '吉阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2435, '460204', '460200', '天涯区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2436, '460205', '460200', '崖州区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2437, '460300', '460000', '三沙市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2438, '460400', '460000', '儋州市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2439, '469000', '460000', '省直辖县级行政区划', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2440, '469001', '469000', '五指山市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2441, '469002', '469000', '琼海市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2442, '469005', '469000', '文昌市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2443, '469006', '469000', '万宁市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2444, '469007', '469000', '东方市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2445, '469021', '469000', '定安县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2446, '469022', '469000', '屯昌县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2447, '469023', '469000', '澄迈县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2448, '469024', '469000', '临高县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2449, '469025', '469000', '白沙黎族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2450, '469026', '469000', '昌江黎族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2451, '469027', '469000', '乐东黎族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2452, '469028', '469000', '陵水黎族自治县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2453, '469029', '469000', '保亭黎族苗族自治县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2454, '469030', '469000', '琼中黎族苗族自治县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2455, '500000', '0', '重庆市', 1, 22, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2456, '500100', '500000', '市辖区', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2457, '500101', '500100', '万州区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2458, '500102', '500100', '涪陵区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2459, '500103', '500100', '渝中区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2460, '500104', '500100', '大渡口区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2461, '500105', '500100', '江北区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2462, '500106', '500100', '沙坪坝区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2463, '500107', '500100', '九龙坡区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2464, '500108', '500100', '南岸区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2465, '500109', '500100', '北碚区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2466, '500110', '500100', '綦江区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2467, '500111', '500100', '大足区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2468, '500112', '500100', '渝北区', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2469, '500113', '500100', '巴南区', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2470, '500114', '500100', '黔江区', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2471, '500115', '500100', '长寿区', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2472, '500116', '500100', '江津区', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2473, '500117', '500100', '合川区', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2474, '500118', '500100', '永川区', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2475, '500119', '500100', '南川区', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2476, '500120', '500100', '璧山区', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2477, '500151', '500100', '铜梁区', 3, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2478, '500152', '500100', '潼南区', 3, 22, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2479, '500153', '500100', '荣昌区', 3, 23, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2480, '500154', '500100', '开州区', 3, 24, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2481, '500200', '500000', '县', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2482, '500228', '500200', '梁平县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2483, '500229', '500200', '城口县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2484, '500230', '500200', '丰都县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2485, '500231', '500200', '垫江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2486, '500232', '500200', '武隆县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2487, '500233', '500200', '忠县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2488, '500235', '500200', '云阳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2489, '500236', '500200', '奉节县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2490, '500237', '500200', '巫山县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2491, '500238', '500200', '巫溪县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2492, '500240', '500200', '石柱土家族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2493, '500241', '500200', '秀山土家族苗族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2494, '500242', '500200', '酉阳土家族苗族自治县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2495, '500243', '500200', '彭水苗族土家族自治县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2496, '510000', '0', '四川省', 1, 23, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2497, '510100', '510000', '成都市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2498, '510101', '510100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2499, '510104', '510100', '锦江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2500, '510105', '510100', '青羊区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2501, '510106', '510100', '金牛区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2502, '510107', '510100', '武侯区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2503, '510108', '510100', '成华区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2504, '510112', '510100', '龙泉驿区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2505, '510113', '510100', '青白江区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2506, '510114', '510100', '新都区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2507, '510115', '510100', '温江区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2508, '510116', '510100', '双流区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2509, '510121', '510100', '金堂县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2510, '510124', '510100', '郫县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2511, '510129', '510100', '大邑县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2512, '510131', '510100', '蒲江县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2513, '510132', '510100', '新津县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2514, '510181', '510100', '都江堰市', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2515, '510182', '510100', '彭州市', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2516, '510183', '510100', '邛崃市', 3, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2517, '510184', '510100', '崇州市', 3, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2518, '510185', '510100', '简阳市', 3, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2519, '510300', '510000', '自贡市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2520, '510301', '510300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2521, '510302', '510300', '自流井区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2522, '510303', '510300', '贡井区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2523, '510304', '510300', '大安区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2524, '510311', '510300', '沿滩区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2525, '510321', '510300', '荣县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2526, '510322', '510300', '富顺县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2527, '510400', '510000', '攀枝花市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2528, '510401', '510400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2529, '510402', '510400', '东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2530, '510403', '510400', '西区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2531, '510411', '510400', '仁和区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2532, '510421', '510400', '米易县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2533, '510422', '510400', '盐边县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2534, '510500', '510000', '泸州市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2535, '510501', '510500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2536, '510502', '510500', '江阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2537, '510503', '510500', '纳溪区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2538, '510504', '510500', '龙马潭区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2539, '510521', '510500', '泸县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2540, '510522', '510500', '合江县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2541, '510524', '510500', '叙永县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2542, '510525', '510500', '古蔺县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2543, '510600', '510000', '德阳市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2544, '510601', '510600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2545, '510603', '510600', '旌阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2546, '510623', '510600', '中江县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2547, '510626', '510600', '罗江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2548, '510681', '510600', '广汉市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2549, '510682', '510600', '什邡市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2550, '510683', '510600', '绵竹市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2551, '510700', '510000', '绵阳市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2552, '510701', '510700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2553, '510703', '510700', '涪城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2554, '510704', '510700', '游仙区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2555, '510705', '510700', '安州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2556, '510722', '510700', '三台县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2557, '510723', '510700', '盐亭县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2558, '510725', '510700', '梓潼县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2559, '510726', '510700', '北川羌族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2560, '510727', '510700', '平武县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2561, '510781', '510700', '江油市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2562, '510800', '510000', '广元市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2563, '510801', '510800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2564, '510802', '510800', '利州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2565, '510811', '510800', '昭化区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2566, '510812', '510800', '朝天区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2567, '510821', '510800', '旺苍县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2568, '510822', '510800', '青川县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2569, '510823', '510800', '剑阁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2570, '510824', '510800', '苍溪县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2571, '510900', '510000', '遂宁市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2572, '510901', '510900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2573, '510903', '510900', '船山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2574, '510904', '510900', '安居区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2575, '510921', '510900', '蓬溪县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2576, '510922', '510900', '射洪县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2577, '510923', '510900', '大英县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2578, '511000', '510000', '内江市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2579, '511001', '511000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2580, '511002', '511000', '市中区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2581, '511011', '511000', '东兴区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2582, '511024', '511000', '威远县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2583, '511025', '511000', '资中县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2584, '511028', '511000', '隆昌县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2585, '511100', '510000', '乐山市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2586, '511101', '511100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2587, '511102', '511100', '市中区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2588, '511111', '511100', '沙湾区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2589, '511112', '511100', '五通桥区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2590, '511113', '511100', '金口河区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2591, '511123', '511100', '犍为县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2592, '511124', '511100', '井研县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2593, '511126', '511100', '夹江县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2594, '511129', '511100', '沐川县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2595, '511132', '511100', '峨边彝族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2596, '511133', '511100', '马边彝族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2597, '511181', '511100', '峨眉山市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2598, '511300', '510000', '南充市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2599, '511301', '511300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2600, '511302', '511300', '顺庆区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2601, '511303', '511300', '高坪区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2602, '511304', '511300', '嘉陵区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2603, '511321', '511300', '南部县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2604, '511322', '511300', '营山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2605, '511323', '511300', '蓬安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2606, '511324', '511300', '仪陇县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2607, '511325', '511300', '西充县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2608, '511381', '511300', '阆中市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2609, '511400', '510000', '眉山市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2610, '511401', '511400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2611, '511402', '511400', '东坡区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2612, '511403', '511400', '彭山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2613, '511421', '511400', '仁寿县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2614, '511423', '511400', '洪雅县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2615, '511424', '511400', '丹棱县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2616, '511425', '511400', '青神县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2617, '511500', '510000', '宜宾市', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2618, '511501', '511500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2619, '511502', '511500', '翠屏区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2620, '511503', '511500', '南溪区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2621, '511521', '511500', '宜宾县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2622, '511523', '511500', '江安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2623, '511524', '511500', '长宁县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2624, '511525', '511500', '高县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2625, '511526', '511500', '珙县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2626, '511527', '511500', '筠连县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2627, '511528', '511500', '兴文县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2628, '511529', '511500', '屏山县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2629, '511600', '510000', '广安市', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2630, '511601', '511600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2631, '511602', '511600', '广安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2632, '511603', '511600', '前锋区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2633, '511621', '511600', '岳池县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2634, '511622', '511600', '武胜县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2635, '511623', '511600', '邻水县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2636, '511681', '511600', '华蓥市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2637, '511700', '510000', '达州市', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2638, '511701', '511700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2639, '511702', '511700', '通川区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2640, '511703', '511700', '达川区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2641, '511722', '511700', '宣汉县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2642, '511723', '511700', '开江县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2643, '511724', '511700', '大竹县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2644, '511725', '511700', '渠县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2645, '511781', '511700', '万源市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2646, '511800', '510000', '雅安市', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2647, '511801', '511800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2648, '511802', '511800', '雨城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2649, '511803', '511800', '名山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2650, '511822', '511800', '荥经县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2651, '511823', '511800', '汉源县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2652, '511824', '511800', '石棉县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2653, '511825', '511800', '天全县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2654, '511826', '511800', '芦山县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2655, '511827', '511800', '宝兴县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2656, '511900', '510000', '巴中市', 2, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2657, '511901', '511900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2658, '511902', '511900', '巴州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2659, '511903', '511900', '恩阳区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2660, '511921', '511900', '通江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2661, '511922', '511900', '南江县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2662, '511923', '511900', '平昌县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2663, '512000', '510000', '资阳市', 2, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2664, '512001', '512000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2665, '512002', '512000', '雁江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2666, '512021', '512000', '安岳县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2667, '512022', '512000', '乐至县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2668, '513200', '510000', '阿坝藏族羌族自治州', 2, 19, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2669, '513201', '513200', '马尔康市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2670, '513221', '513200', '汶川县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2671, '513222', '513200', '理县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2672, '513223', '513200', '茂县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2673, '513224', '513200', '松潘县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2674, '513225', '513200', '九寨沟县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2675, '513226', '513200', '金川县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2676, '513227', '513200', '小金县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2677, '513228', '513200', '黑水县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2678, '513230', '513200', '壤塘县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2679, '513231', '513200', '阿坝县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2680, '513232', '513200', '若尔盖县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2681, '513233', '513200', '红原县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2682, '513300', '510000', '甘孜藏族自治州', 2, 20, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2683, '513301', '513300', '康定市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2684, '513322', '513300', '泸定县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2685, '513323', '513300', '丹巴县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2686, '513324', '513300', '九龙县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2687, '513325', '513300', '雅江县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2688, '513326', '513300', '道孚县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2689, '513327', '513300', '炉霍县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2690, '513328', '513300', '甘孜县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2691, '513329', '513300', '新龙县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2692, '513330', '513300', '德格县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2693, '513331', '513300', '白玉县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2694, '513332', '513300', '石渠县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2695, '513333', '513300', '色达县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2696, '513334', '513300', '理塘县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2697, '513335', '513300', '巴塘县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2698, '513336', '513300', '乡城县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2699, '513337', '513300', '稻城县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2700, '513338', '513300', '得荣县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2701, '513400', '510000', '凉山彝族自治州', 2, 21, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2702, '513401', '513400', '西昌市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2703, '513422', '513400', '木里藏族自治县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2704, '513423', '513400', '盐源县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2705, '513424', '513400', '德昌县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2706, '513425', '513400', '会理县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2707, '513426', '513400', '会东县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2708, '513427', '513400', '宁南县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2709, '513428', '513400', '普格县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2710, '513429', '513400', '布拖县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2711, '513430', '513400', '金阳县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2712, '513431', '513400', '昭觉县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2713, '513432', '513400', '喜德县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2714, '513433', '513400', '冕宁县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2715, '513434', '513400', '越西县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2716, '513435', '513400', '甘洛县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2717, '513436', '513400', '美姑县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2718, '513437', '513400', '雷波县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2719, '520000', '0', '贵州省', 1, 24, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2720, '520100', '520000', '贵阳市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2721, '520101', '520100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2722, '520102', '520100', '南明区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2723, '520103', '520100', '云岩区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2724, '520111', '520100', '花溪区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2725, '520112', '520100', '乌当区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2726, '520113', '520100', '白云区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2727, '520115', '520100', '观山湖区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2728, '520121', '520100', '开阳县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2729, '520122', '520100', '息烽县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2730, '520123', '520100', '修文县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2731, '520181', '520100', '清镇市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2732, '520200', '520000', '六盘水市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2733, '520201', '520200', '钟山区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2734, '520203', '520200', '六枝特区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2735, '520221', '520200', '水城县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2736, '520222', '520200', '盘县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2737, '520300', '520000', '遵义市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2738, '520301', '520300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2739, '520302', '520300', '红花岗区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2740, '520303', '520300', '汇川区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2741, '520304', '520300', '播州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2742, '520322', '520300', '桐梓县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2743, '520323', '520300', '绥阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2744, '520324', '520300', '正安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2745, '520325', '520300', '道真仡佬族苗族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2746, '520326', '520300', '务川仡佬族苗族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2747, '520327', '520300', '凤冈县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2748, '520328', '520300', '湄潭县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2749, '520329', '520300', '余庆县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2750, '520330', '520300', '习水县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2751, '520381', '520300', '赤水市', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2752, '520382', '520300', '仁怀市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2753, '520400', '520000', '安顺市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2754, '520401', '520400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2755, '520402', '520400', '西秀区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2756, '520403', '520400', '平坝区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2757, '520422', '520400', '普定县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2758, '520423', '520400', '镇宁布依族苗族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2759, '520424', '520400', '关岭布依族苗族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2760, '520425', '520400', '紫云苗族布依族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2761, '520500', '520000', '毕节市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2762, '520501', '520500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2763, '520502', '520500', '七星关区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2764, '520521', '520500', '大方县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2765, '520522', '520500', '黔西县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2766, '520523', '520500', '金沙县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2767, '520524', '520500', '织金县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2768, '520525', '520500', '纳雍县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2769, '520526', '520500', '威宁彝族回族苗族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2770, '520527', '520500', '赫章县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2771, '520600', '520000', '铜仁市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2772, '520601', '520600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2773, '520602', '520600', '碧江区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2774, '520603', '520600', '万山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2775, '520621', '520600', '江口县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2776, '520622', '520600', '玉屏侗族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2777, '520623', '520600', '石阡县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2778, '520624', '520600', '思南县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2779, '520625', '520600', '印江土家族苗族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2780, '520626', '520600', '德江县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2781, '520627', '520600', '沿河土家族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2782, '520628', '520600', '松桃苗族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2783, '522300', '520000', '黔西南布依族苗族自治州', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2784, '522301', '522300', '兴义市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2785, '522322', '522300', '兴仁县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2786, '522323', '522300', '普安县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2787, '522324', '522300', '晴隆县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2788, '522325', '522300', '贞丰县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2789, '522326', '522300', '望谟县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2790, '522327', '522300', '册亨县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2791, '522328', '522300', '安龙县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2792, '522600', '520000', '黔东南苗族侗族自治州', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2793, '522601', '522600', '凯里市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2794, '522622', '522600', '黄平县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2795, '522623', '522600', '施秉县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2796, '522624', '522600', '三穗县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2797, '522625', '522600', '镇远县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2798, '522626', '522600', '岑巩县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2799, '522627', '522600', '天柱县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2800, '522628', '522600', '锦屏县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2801, '522629', '522600', '剑河县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2802, '522630', '522600', '台江县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2803, '522631', '522600', '黎平县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2804, '522632', '522600', '榕江县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2805, '522633', '522600', '从江县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2806, '522634', '522600', '雷山县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2807, '522635', '522600', '麻江县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2808, '522636', '522600', '丹寨县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2809, '522700', '520000', '黔南布依族苗族自治州', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2810, '522701', '522700', '都匀市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2811, '522702', '522700', '福泉市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2812, '522722', '522700', '荔波县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2813, '522723', '522700', '贵定县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2814, '522725', '522700', '瓮安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2815, '522726', '522700', '独山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2816, '522727', '522700', '平塘县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2817, '522728', '522700', '罗甸县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2818, '522729', '522700', '长顺县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2819, '522730', '522700', '龙里县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2820, '522731', '522700', '惠水县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2821, '522732', '522700', '三都水族自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2822, '530000', '0', '云南省', 1, 25, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2823, '530100', '530000', '昆明市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2824, '530101', '530100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2825, '530102', '530100', '五华区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2826, '530103', '530100', '盘龙区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2827, '530111', '530100', '官渡区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2828, '530112', '530100', '西山区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2829, '530113', '530100', '东川区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2830, '530114', '530100', '呈贡区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2831, '530122', '530100', '晋宁县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2832, '530124', '530100', '富民县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2833, '530125', '530100', '宜良县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2834, '530126', '530100', '石林彝族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2835, '530127', '530100', '嵩明县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2836, '530128', '530100', '禄劝彝族苗族自治县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2837, '530129', '530100', '寻甸回族彝族自治县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2838, '530181', '530100', '安宁市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2839, '530300', '530000', '曲靖市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2840, '530301', '530300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2841, '530302', '530300', '麒麟区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2842, '530303', '530300', '沾益区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2843, '530321', '530300', '马龙县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2844, '530322', '530300', '陆良县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2845, '530323', '530300', '师宗县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2846, '530324', '530300', '罗平县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2847, '530325', '530300', '富源县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2848, '530326', '530300', '会泽县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2849, '530381', '530300', '宣威市', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2850, '530400', '530000', '玉溪市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2851, '530401', '530400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2852, '530402', '530400', '红塔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2853, '530403', '530400', '江川区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2854, '530422', '530400', '澄江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2855, '530423', '530400', '通海县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2856, '530424', '530400', '华宁县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2857, '530425', '530400', '易门县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2858, '530426', '530400', '峨山彝族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2859, '530427', '530400', '新平彝族傣族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2860, '530428', '530400', '元江哈尼族彝族傣族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2861, '530500', '530000', '保山市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2862, '530501', '530500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2863, '530502', '530500', '隆阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2864, '530521', '530500', '施甸县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2865, '530523', '530500', '龙陵县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2866, '530524', '530500', '昌宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2867, '530581', '530500', '腾冲市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2868, '530600', '530000', '昭通市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2869, '530601', '530600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2870, '530602', '530600', '昭阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2871, '530621', '530600', '鲁甸县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2872, '530622', '530600', '巧家县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2873, '530623', '530600', '盐津县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2874, '530624', '530600', '大关县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2875, '530625', '530600', '永善县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2876, '530626', '530600', '绥江县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2877, '530627', '530600', '镇雄县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2878, '530628', '530600', '彝良县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2879, '530629', '530600', '威信县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2880, '530630', '530600', '水富县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2881, '530700', '530000', '丽江市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2882, '530701', '530700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2883, '530702', '530700', '古城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2884, '530721', '530700', '玉龙纳西族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2885, '530722', '530700', '永胜县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2886, '530723', '530700', '华坪县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2887, '530724', '530700', '宁蒗彝族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2888, '530800', '530000', '普洱市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2889, '530801', '530800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2890, '530802', '530800', '思茅区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2891, '530821', '530800', '宁洱哈尼族彝族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2892, '530822', '530800', '墨江哈尼族自治县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2893, '530823', '530800', '景东彝族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2894, '530824', '530800', '景谷傣族彝族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2895, '530825', '530800', '镇沅彝族哈尼族拉祜族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2896, '530826', '530800', '江城哈尼族彝族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2897, '530827', '530800', '孟连傣族拉祜族佤族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2898, '530828', '530800', '澜沧拉祜族自治县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2899, '530829', '530800', '西盟佤族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2900, '530900', '530000', '临沧市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2901, '530901', '530900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2902, '530902', '530900', '临翔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2903, '530921', '530900', '凤庆县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2904, '530922', '530900', '云县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2905, '530923', '530900', '永德县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2906, '530924', '530900', '镇康县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2907, '530925', '530900', '双江拉祜族佤族布朗族傣族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2908, '530926', '530900', '耿马傣族佤族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2909, '530927', '530900', '沧源佤族自治县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2910, '532300', '530000', '楚雄彝族自治州', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2911, '532301', '532300', '楚雄市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2912, '532322', '532300', '双柏县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2913, '532323', '532300', '牟定县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2914, '532324', '532300', '南华县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2915, '532325', '532300', '姚安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2916, '532326', '532300', '大姚县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2917, '532327', '532300', '永仁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2918, '532328', '532300', '元谋县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2919, '532329', '532300', '武定县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2920, '532331', '532300', '禄丰县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2921, '532500', '530000', '红河哈尼族彝族自治州', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2922, '532501', '532500', '个旧市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2923, '532502', '532500', '开远市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2924, '532503', '532500', '蒙自市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2925, '532504', '532500', '弥勒市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2926, '532523', '532500', '屏边苗族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2927, '532524', '532500', '建水县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2928, '532525', '532500', '石屏县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2929, '532527', '532500', '泸西县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2930, '532528', '532500', '元阳县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2931, '532529', '532500', '红河县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2932, '532530', '532500', '金平苗族瑶族傣族自治县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2933, '532531', '532500', '绿春县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2934, '532532', '532500', '河口瑶族自治县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2935, '532600', '530000', '文山壮族苗族自治州', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2936, '532601', '532600', '文山市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2937, '532622', '532600', '砚山县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2938, '532623', '532600', '西畴县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2939, '532624', '532600', '麻栗坡县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2940, '532625', '532600', '马关县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2941, '532626', '532600', '丘北县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2942, '532627', '532600', '广南县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2943, '532628', '532600', '富宁县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2944, '532800', '530000', '西双版纳傣族自治州', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2945, '532801', '532800', '景洪市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2946, '532822', '532800', '勐海县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2947, '532823', '532800', '勐腊县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2948, '532900', '530000', '大理白族自治州', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2949, '532901', '532900', '大理市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2950, '532922', '532900', '漾濞彝族自治县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2951, '532923', '532900', '祥云县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2952, '532924', '532900', '宾川县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2953, '532925', '532900', '弥渡县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2954, '532926', '532900', '南涧彝族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2955, '532927', '532900', '巍山彝族回族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2956, '532928', '532900', '永平县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2957, '532929', '532900', '云龙县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2958, '532930', '532900', '洱源县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2959, '532931', '532900', '剑川县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2960, '532932', '532900', '鹤庆县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2961, '533100', '530000', '德宏傣族景颇族自治州', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2962, '533102', '533100', '瑞丽市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2963, '533103', '533100', '芒市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2964, '533122', '533100', '梁河县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2965, '533123', '533100', '盈江县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2966, '533124', '533100', '陇川县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2967, '533300', '530000', '怒江傈僳族自治州', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2968, '533301', '533300', '泸水市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2969, '533323', '533300', '福贡县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2970, '533324', '533300', '贡山独龙族怒族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2971, '533325', '533300', '兰坪白族普米族自治县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2972, '533400', '530000', '迪庆藏族自治州', 2, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2973, '533401', '533400', '香格里拉市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2974, '533422', '533400', '德钦县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2975, '533423', '533400', '维西傈僳族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2976, '540000', '0', '西藏自治区', 1, 26, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2977, '540100', '540000', '拉萨市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2978, '540101', '540100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2979, '540102', '540100', '城关区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2980, '540103', '540100', '堆龙德庆区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2981, '540121', '540100', '林周县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2982, '540122', '540100', '当雄县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2983, '540123', '540100', '尼木县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2984, '540124', '540100', '曲水县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2985, '540126', '540100', '达孜县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2986, '540127', '540100', '墨竹工卡县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2987, '540200', '540000', '日喀则市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2988, '540202', '540200', '桑珠孜区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2989, '540221', '540200', '南木林县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2990, '540222', '540200', '江孜县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2991, '540223', '540200', '定日县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2992, '540224', '540200', '萨迦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2993, '540225', '540200', '拉孜县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2994, '540226', '540200', '昂仁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2995, '540227', '540200', '谢通门县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2996, '540228', '540200', '白朗县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2997, '540229', '540200', '仁布县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2998, '540230', '540200', '康马县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (2999, '540231', '540200', '定结县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3000, '540232', '540200', '仲巴县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3001, '540233', '540200', '亚东县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3002, '540234', '540200', '吉隆县', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3003, '540235', '540200', '聂拉木县', 3, 16, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3004, '540236', '540200', '萨嘎县', 3, 17, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3005, '540237', '540200', '岗巴县', 3, 18, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3006, '540300', '540000', '昌都市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3007, '540302', '540300', '卡若区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3008, '540321', '540300', '江达县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3009, '540322', '540300', '贡觉县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3010, '540323', '540300', '类乌齐县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3011, '540324', '540300', '丁青县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3012, '540325', '540300', '察雅县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3013, '540326', '540300', '八宿县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3014, '540327', '540300', '左贡县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3015, '540328', '540300', '芒康县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3016, '540329', '540300', '洛隆县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3017, '540330', '540300', '边坝县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3018, '540400', '540000', '林芝市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3019, '540402', '540400', '巴宜区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3020, '540421', '540400', '工布江达县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3021, '540422', '540400', '米林县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3022, '540423', '540400', '墨脱县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3023, '540424', '540400', '波密县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3024, '540425', '540400', '察隅县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3025, '540426', '540400', '朗县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3026, '540500', '540000', '山南市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3027, '540501', '540500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3028, '540502', '540500', '乃东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3029, '540521', '540500', '扎囊县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3030, '540522', '540500', '贡嘎县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3031, '540523', '540500', '桑日县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3032, '540524', '540500', '琼结县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3033, '540525', '540500', '曲松县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3034, '540526', '540500', '措美县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3035, '540527', '540500', '洛扎县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3036, '540528', '540500', '加查县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3037, '540529', '540500', '隆子县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3038, '540530', '540500', '错那县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3039, '540531', '540500', '浪卡子县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3040, '542400', '540000', '那曲地区', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3041, '542421', '542400', '那曲县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3042, '542422', '542400', '嘉黎县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3043, '542423', '542400', '比如县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3044, '542424', '542400', '聂荣县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3045, '542425', '542400', '安多县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3046, '542426', '542400', '申扎县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3047, '542427', '542400', '索县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3048, '542428', '542400', '班戈县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3049, '542429', '542400', '巴青县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3050, '542430', '542400', '尼玛县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3051, '542431', '542400', '双湖县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3052, '542500', '540000', '阿里地区', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3053, '542521', '542500', '普兰县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3054, '542522', '542500', '札达县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3055, '542523', '542500', '噶尔县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3056, '542524', '542500', '日土县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3057, '542525', '542500', '革吉县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3058, '542526', '542500', '改则县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3059, '542527', '542500', '措勤县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3060, '610000', '0', '陕西省', 1, 27, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3061, '610100', '610000', '西安市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3062, '610101', '610100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3063, '610102', '610100', '新城区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3064, '610103', '610100', '碑林区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3065, '610104', '610100', '莲湖区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3066, '610111', '610100', '灞桥区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3067, '610112', '610100', '未央区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3068, '610113', '610100', '雁塔区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3069, '610114', '610100', '阎良区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3070, '610115', '610100', '临潼区', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3071, '610116', '610100', '长安区', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3072, '610117', '610100', '高陵区', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3073, '610122', '610100', '蓝田县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3074, '610124', '610100', '周至县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3075, '610125', '610100', '户县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3076, '610200', '610000', '铜川市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3077, '610201', '610200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3078, '610202', '610200', '王益区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3079, '610203', '610200', '印台区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3080, '610204', '610200', '耀州区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3081, '610222', '610200', '宜君县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3082, '610300', '610000', '宝鸡市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3083, '610301', '610300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3084, '610302', '610300', '渭滨区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3085, '610303', '610300', '金台区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3086, '610304', '610300', '陈仓区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3087, '610322', '610300', '凤翔县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3088, '610323', '610300', '岐山县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3089, '610324', '610300', '扶风县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3090, '610326', '610300', '眉县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3091, '610327', '610300', '陇县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3092, '610328', '610300', '千阳县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3093, '610329', '610300', '麟游县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3094, '610330', '610300', '凤县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3095, '610331', '610300', '太白县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3096, '610400', '610000', '咸阳市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3097, '610401', '610400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3098, '610402', '610400', '秦都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3099, '610403', '610400', '杨陵区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3100, '610404', '610400', '渭城区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3101, '610422', '610400', '三原县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3102, '610423', '610400', '泾阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3103, '610424', '610400', '乾县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3104, '610425', '610400', '礼泉县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3105, '610426', '610400', '永寿县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3106, '610427', '610400', '彬县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3107, '610428', '610400', '长武县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3108, '610429', '610400', '旬邑县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3109, '610430', '610400', '淳化县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3110, '610431', '610400', '武功县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3111, '610481', '610400', '兴平市', 3, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3112, '610500', '610000', '渭南市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3113, '610501', '610500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3114, '610502', '610500', '临渭区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3115, '610503', '610500', '华州区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3116, '610522', '610500', '潼关县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3117, '610523', '610500', '大荔县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3118, '610524', '610500', '合阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3119, '610525', '610500', '澄城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3120, '610526', '610500', '蒲城县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3121, '610527', '610500', '白水县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3122, '610528', '610500', '富平县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3123, '610581', '610500', '韩城市', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3124, '610582', '610500', '华阴市', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3125, '610600', '610000', '延安市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3126, '610601', '610600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3127, '610602', '610600', '宝塔区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3128, '610603', '610600', '安塞区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3129, '610621', '610600', '延长县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3130, '610622', '610600', '延川县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3131, '610623', '610600', '子长县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3132, '610625', '610600', '志丹县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3133, '610626', '610600', '吴起县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3134, '610627', '610600', '甘泉县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3135, '610628', '610600', '富县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3136, '610629', '610600', '洛川县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3137, '610630', '610600', '宜川县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3138, '610631', '610600', '黄龙县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3139, '610632', '610600', '黄陵县', 3, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3140, '610700', '610000', '汉中市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3141, '610701', '610700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3142, '610702', '610700', '汉台区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3143, '610721', '610700', '南郑县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3144, '610722', '610700', '城固县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3145, '610723', '610700', '洋县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3146, '610724', '610700', '西乡县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3147, '610725', '610700', '勉县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3148, '610726', '610700', '宁强县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3149, '610727', '610700', '略阳县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3150, '610728', '610700', '镇巴县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3151, '610729', '610700', '留坝县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3152, '610730', '610700', '佛坪县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3153, '610800', '610000', '榆林市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3154, '610801', '610800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3155, '610802', '610800', '榆阳区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3156, '610803', '610800', '横山区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3157, '610821', '610800', '神木县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3158, '610822', '610800', '府谷县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3159, '610824', '610800', '靖边县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3160, '610825', '610800', '定边县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3161, '610826', '610800', '绥德县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3162, '610827', '610800', '米脂县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3163, '610828', '610800', '佳县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3164, '610829', '610800', '吴堡县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3165, '610830', '610800', '清涧县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3166, '610831', '610800', '子洲县', 3, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3167, '610900', '610000', '安康市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3168, '610901', '610900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3169, '610902', '610900', '汉滨区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3170, '610921', '610900', '汉阴县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3171, '610922', '610900', '石泉县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3172, '610923', '610900', '宁陕县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3173, '610924', '610900', '紫阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3174, '610925', '610900', '岚皋县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3175, '610926', '610900', '平利县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3176, '610927', '610900', '镇坪县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3177, '610928', '610900', '旬阳县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3178, '610929', '610900', '白河县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3179, '611000', '610000', '商洛市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3180, '611001', '611000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3181, '611002', '611000', '商州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3182, '611021', '611000', '洛南县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3183, '611022', '611000', '丹凤县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3184, '611023', '611000', '商南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3185, '611024', '611000', '山阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3186, '611025', '611000', '镇安县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3187, '611026', '611000', '柞水县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3188, '620000', '0', '甘肃省', 1, 28, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3189, '620100', '620000', '兰州市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3190, '620101', '620100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3191, '620102', '620100', '城关区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3192, '620103', '620100', '七里河区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3193, '620104', '620100', '西固区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3194, '620105', '620100', '安宁区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3195, '620111', '620100', '红古区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3196, '620121', '620100', '永登县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3197, '620122', '620100', '皋兰县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3198, '620123', '620100', '榆中县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3199, '620200', '620000', '嘉峪关市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3200, '620201', '620200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3201, '620300', '620000', '金昌市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3202, '620301', '620300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3203, '620302', '620300', '金川区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3204, '620321', '620300', '永昌县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3205, '620400', '620000', '白银市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3206, '620401', '620400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3207, '620402', '620400', '白银区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3208, '620403', '620400', '平川区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3209, '620421', '620400', '靖远县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3210, '620422', '620400', '会宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3211, '620423', '620400', '景泰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3212, '620500', '620000', '天水市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3213, '620501', '620500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3214, '620502', '620500', '秦州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3215, '620503', '620500', '麦积区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3216, '620521', '620500', '清水县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3217, '620522', '620500', '秦安县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3218, '620523', '620500', '甘谷县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3219, '620524', '620500', '武山县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3220, '620525', '620500', '张家川回族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3221, '620600', '620000', '武威市', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3222, '620601', '620600', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3223, '620602', '620600', '凉州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3224, '620621', '620600', '民勤县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3225, '620622', '620600', '古浪县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3226, '620623', '620600', '天祝藏族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3227, '620700', '620000', '张掖市', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3228, '620701', '620700', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3229, '620702', '620700', '甘州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3230, '620721', '620700', '肃南裕固族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3231, '620722', '620700', '民乐县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3232, '620723', '620700', '临泽县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3233, '620724', '620700', '高台县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3234, '620725', '620700', '山丹县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3235, '620800', '620000', '平凉市', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3236, '620801', '620800', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3237, '620802', '620800', '崆峒区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3238, '620821', '620800', '泾川县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3239, '620822', '620800', '灵台县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3240, '620823', '620800', '崇信县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3241, '620824', '620800', '华亭县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3242, '620825', '620800', '庄浪县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3243, '620826', '620800', '静宁县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3244, '620900', '620000', '酒泉市', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3245, '620901', '620900', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3246, '620902', '620900', '肃州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3247, '620921', '620900', '金塔县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3248, '620922', '620900', '瓜州县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3249, '620923', '620900', '肃北蒙古族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3250, '620924', '620900', '阿克塞哈萨克族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3251, '620981', '620900', '玉门市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3252, '620982', '620900', '敦煌市', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3253, '621000', '620000', '庆阳市', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3254, '621001', '621000', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3255, '621002', '621000', '西峰区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3256, '621021', '621000', '庆城县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3257, '621022', '621000', '环县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3258, '621023', '621000', '华池县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3259, '621024', '621000', '合水县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3260, '621025', '621000', '正宁县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3261, '621026', '621000', '宁县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3262, '621027', '621000', '镇原县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3263, '621100', '620000', '定西市', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3264, '621101', '621100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3265, '621102', '621100', '安定区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3266, '621121', '621100', '通渭县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3267, '621122', '621100', '陇西县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3268, '621123', '621100', '渭源县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3269, '621124', '621100', '临洮县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3270, '621125', '621100', '漳县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3271, '621126', '621100', '岷县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3272, '621200', '620000', '陇南市', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3273, '621201', '621200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3274, '621202', '621200', '武都区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3275, '621221', '621200', '成县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3276, '621222', '621200', '文县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3277, '621223', '621200', '宕昌县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3278, '621224', '621200', '康县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3279, '621225', '621200', '西和县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3280, '621226', '621200', '礼县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3281, '621227', '621200', '徽县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3282, '621228', '621200', '两当县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3283, '622900', '620000', '临夏回族自治州', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3284, '622901', '622900', '临夏市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3285, '622921', '622900', '临夏县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3286, '622922', '622900', '康乐县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3287, '622923', '622900', '永靖县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3288, '622924', '622900', '广河县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3289, '622925', '622900', '和政县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3290, '622926', '622900', '东乡族自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3291, '622927', '622900', '积石山保安族东乡族撒拉族自治县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3292, '623000', '620000', '甘南藏族自治州', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3293, '623001', '623000', '合作市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3294, '623021', '623000', '临潭县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3295, '623022', '623000', '卓尼县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3296, '623023', '623000', '舟曲县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3297, '623024', '623000', '迭部县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3298, '623025', '623000', '玛曲县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3299, '623026', '623000', '碌曲县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3300, '623027', '623000', '夏河县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3301, '630000', '0', '青海省', 1, 29, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3302, '630100', '630000', '西宁市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3303, '630101', '630100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3304, '630102', '630100', '城东区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3305, '630103', '630100', '城中区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3306, '630104', '630100', '城西区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3307, '630105', '630100', '城北区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3308, '630121', '630100', '大通回族土族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3309, '630122', '630100', '湟中县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3310, '630123', '630100', '湟源县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3311, '630200', '630000', '海东市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3312, '630202', '630200', '乐都区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3313, '630203', '630200', '平安区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3314, '630222', '630200', '民和回族土族自治县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3315, '630223', '630200', '互助土族自治县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3316, '630224', '630200', '化隆回族自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3317, '630225', '630200', '循化撒拉族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3318, '632200', '630000', '海北藏族自治州', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3319, '632221', '632200', '门源回族自治县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3320, '632222', '632200', '祁连县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3321, '632223', '632200', '海晏县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3322, '632224', '632200', '刚察县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3323, '632300', '630000', '黄南藏族自治州', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3324, '632321', '632300', '同仁县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3325, '632322', '632300', '尖扎县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3326, '632323', '632300', '泽库县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3327, '632324', '632300', '河南蒙古族自治县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3328, '632500', '630000', '海南藏族自治州', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3329, '632521', '632500', '共和县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3330, '632522', '632500', '同德县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3331, '632523', '632500', '贵德县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3332, '632524', '632500', '兴海县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3333, '632525', '632500', '贵南县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3334, '632600', '630000', '果洛藏族自治州', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3335, '632621', '632600', '玛沁县', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3336, '632622', '632600', '班玛县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3337, '632623', '632600', '甘德县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3338, '632624', '632600', '达日县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3339, '632625', '632600', '久治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3340, '632626', '632600', '玛多县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3341, '632700', '630000', '玉树藏族自治州', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3342, '632701', '632700', '玉树市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3343, '632722', '632700', '杂多县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3344, '632723', '632700', '称多县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3345, '632724', '632700', '治多县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3346, '632725', '632700', '囊谦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3347, '632726', '632700', '曲麻莱县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3348, '632800', '630000', '海西蒙古族藏族自治州', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3349, '632801', '632800', '格尔木市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3350, '632802', '632800', '德令哈市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3351, '632821', '632800', '乌兰县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3352, '632822', '632800', '都兰县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3353, '632823', '632800', '天峻县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3354, '640000', '0', '宁夏回族自治区', 1, 30, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3355, '640100', '640000', '银川市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3356, '640101', '640100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3357, '640104', '640100', '兴庆区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3358, '640105', '640100', '西夏区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3359, '640106', '640100', '金凤区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3360, '640121', '640100', '永宁县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3361, '640122', '640100', '贺兰县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3362, '640181', '640100', '灵武市', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3363, '640200', '640000', '石嘴山市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3364, '640201', '640200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3365, '640202', '640200', '大武口区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3366, '640205', '640200', '惠农区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3367, '640221', '640200', '平罗县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3368, '640300', '640000', '吴忠市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3369, '640301', '640300', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3370, '640302', '640300', '利通区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3371, '640303', '640300', '红寺堡区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3372, '640323', '640300', '盐池县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3373, '640324', '640300', '同心县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3374, '640381', '640300', '青铜峡市', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3375, '640400', '640000', '固原市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3376, '640401', '640400', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3377, '640402', '640400', '原州区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3378, '640422', '640400', '西吉县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3379, '640423', '640400', '隆德县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3380, '640424', '640400', '泾源县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3381, '640425', '640400', '彭阳县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3382, '640500', '640000', '中卫市', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3383, '640501', '640500', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3384, '640502', '640500', '沙坡头区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3385, '640521', '640500', '中宁县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3386, '640522', '640500', '海原县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3387, '650000', '0', '新疆维吾尔自治区', 1, 31, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3388, '650100', '650000', '乌鲁木齐市', 2, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3389, '650101', '650100', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3390, '650102', '650100', '天山区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3391, '650103', '650100', '沙依巴克区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3392, '650104', '650100', '新市区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3393, '650105', '650100', '水磨沟区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3394, '650106', '650100', '头屯河区', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3395, '650107', '650100', '达坂城区', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3396, '650109', '650100', '米东区', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3397, '650121', '650100', '乌鲁木齐县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3398, '650200', '650000', '克拉玛依市', 2, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3399, '650201', '650200', '市辖区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3400, '650202', '650200', '独山子区', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3401, '650203', '650200', '克拉玛依区', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3402, '650204', '650200', '白碱滩区', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3403, '650205', '650200', '乌尔禾区', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3404, '650400', '650000', '吐鲁番市', 2, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3405, '650402', '650400', '高昌区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3406, '650421', '650400', '鄯善县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3407, '650422', '650400', '托克逊县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3408, '650500', '650000', '哈密市', 2, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3409, '650502', '650500', '伊州区', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3410, '650521', '650500', '巴里坤哈萨克自治县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3411, '650522', '650500', '伊吾县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3412, '652300', '650000', '昌吉回族自治州', 2, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3413, '652301', '652300', '昌吉市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3414, '652302', '652300', '阜康市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3415, '652323', '652300', '呼图壁县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3416, '652324', '652300', '玛纳斯县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3417, '652325', '652300', '奇台县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3418, '652327', '652300', '吉木萨尔县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3419, '652328', '652300', '木垒哈萨克自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3420, '652700', '650000', '博尔塔拉蒙古自治州', 2, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3421, '652701', '652700', '博乐市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3422, '652702', '652700', '阿拉山口市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3423, '652722', '652700', '精河县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3424, '652723', '652700', '温泉县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3425, '652800', '650000', '巴音郭楞蒙古自治州', 2, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3426, '652801', '652800', '库尔勒市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3427, '652822', '652800', '轮台县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3428, '652823', '652800', '尉犁县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3429, '652824', '652800', '若羌县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3430, '652825', '652800', '且末县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3431, '652826', '652800', '焉耆回族自治县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3432, '652827', '652800', '和静县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3433, '652828', '652800', '和硕县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3434, '652829', '652800', '博湖县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3435, '652900', '650000', '阿克苏地区', 2, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3436, '652901', '652900', '阿克苏市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3437, '652922', '652900', '温宿县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3438, '652923', '652900', '库车县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3439, '652924', '652900', '沙雅县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3440, '652925', '652900', '新和县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3441, '652926', '652900', '拜城县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3442, '652927', '652900', '乌什县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3443, '652928', '652900', '阿瓦提县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3444, '652929', '652900', '柯坪县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3445, '653000', '650000', '克孜勒苏柯尔克孜自治州', 2, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3446, '653001', '653000', '阿图什市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3447, '653022', '653000', '阿克陶县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3448, '653023', '653000', '阿合奇县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3449, '653024', '653000', '乌恰县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3450, '653100', '650000', '喀什地区', 2, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3451, '653101', '653100', '喀什市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3452, '653121', '653100', '疏附县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3453, '653122', '653100', '疏勒县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3454, '653123', '653100', '英吉沙县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3455, '653124', '653100', '泽普县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3456, '653125', '653100', '莎车县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3457, '653126', '653100', '叶城县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3458, '653127', '653100', '麦盖提县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3459, '653128', '653100', '岳普湖县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3460, '653129', '653100', '伽师县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3461, '653130', '653100', '巴楚县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3462, '653131', '653100', '塔什库尔干塔吉克自治县', 3, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3463, '653200', '650000', '和田地区', 2, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3464, '653201', '653200', '和田市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3465, '653221', '653200', '和田县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3466, '653222', '653200', '墨玉县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3467, '653223', '653200', '皮山县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3468, '653224', '653200', '洛浦县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3469, '653225', '653200', '策勒县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3470, '653226', '653200', '于田县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3471, '653227', '653200', '民丰县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3472, '654000', '650000', '伊犁哈萨克自治州', 2, 12, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3473, '654002', '654000', '伊宁市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3474, '654003', '654000', '奎屯市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3475, '654004', '654000', '霍尔果斯市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3476, '654021', '654000', '伊宁县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3477, '654022', '654000', '察布查尔锡伯自治县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3478, '654023', '654000', '霍城县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3479, '654024', '654000', '巩留县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3480, '654025', '654000', '新源县', 3, 8, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3481, '654026', '654000', '昭苏县', 3, 9, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3482, '654027', '654000', '特克斯县', 3, 10, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3483, '654028', '654000', '尼勒克县', 3, 11, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3484, '654200', '650000', '塔城地区', 2, 13, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3485, '654201', '654200', '塔城市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3486, '654202', '654200', '乌苏市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3487, '654221', '654200', '额敏县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3488, '654223', '654200', '沙湾县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3489, '654224', '654200', '托里县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3490, '654225', '654200', '裕民县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3491, '654226', '654200', '和布克赛尔蒙古自治县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3492, '654300', '650000', '阿勒泰地区', 2, 14, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3493, '654301', '654300', '阿勒泰市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3494, '654321', '654300', '布尔津县', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3495, '654322', '654300', '富蕴县', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3496, '654323', '654300', '福海县', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3497, '654324', '654300', '哈巴河县', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3498, '654325', '654300', '青河县', 3, 6, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3499, '654326', '654300', '吉木乃县', 3, 7, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3500, '659000', '650000', '自治区直辖县级行政区划', 2, 15, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3501, '659001', '659000', '石河子市', 3, 1, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3502, '659002', '659000', '阿拉尔市', 3, 2, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3503, '659003', '659000', '图木舒克市', 3, 3, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3504, '659004', '659000', '五家渠市', 3, 4, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3505, '659006', '659000', '铁门关市', 3, 5, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3506, '710000', '0', '台湾省', 1, 32, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3507, '810000', '0', '香港特别行政区', 1, 33, 1, NULL, '2017-04-24 15:54:31', NULL);
INSERT INTO `sys_area` VALUES (3508, '820000', '0', '澳门特别行政区', 1, 34, 1, NULL, '2017-04-24 15:54:31', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `operation` varchar(50) DEFAULT NULL COMMENT '用户操作',
  `time` int(11) DEFAULT NULL COMMENT '响应时间',
  `method` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `params` varchar(5000) DEFAULT NULL COMMENT '请求参数',
  `ip` varchar(64) DEFAULT NULL COMMENT 'IP地址',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统日志';

-- ----------------------------
-- Records of sys_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_macro
-- ----------------------------
DROP TABLE IF EXISTS `sys_macro`;
CREATE TABLE `sys_macro` (
  `macro_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_id` bigint(255) DEFAULT NULL COMMENT '父级id',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `value` varchar(2000) DEFAULT NULL COMMENT '值',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态，0：隐藏   1：显示',
  `type` tinyint(20) DEFAULT NULL COMMENT '类型,0:目录，1:参数配置',
  `order_num` int(11) DEFAULT NULL COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`macro_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='通用字典表';

-- ----------------------------
-- Records of sys_macro
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单id',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `name` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `url` varchar(200) DEFAULT NULL COMMENT '菜单URL',
  `perms` varchar(500) DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `type` int(11) DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  `icon` varchar(50) DEFAULT NULL COMMENT '菜单图标',
  `order_num` int(11) DEFAULT NULL COMMENT '排序',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8 COMMENT='菜单管理';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', NULL, '', 0, 'fa fa-coffee', 0, '2017-08-09 22:49:47', '2017-09-11 17:25:22');
INSERT INTO `sys_menu` VALUES (2, 1, '系统菜单', 'base/menu/list.html', NULL, 1, 'fa fa-th-list', 1, '2017-08-09 22:55:15', '2017-08-17 10:00:12');
INSERT INTO `sys_menu` VALUES (3, 0, '组织机构', NULL, NULL, 0, 'fa fa-desktop', 1, '2017-08-09 23:06:55', '2017-08-17 09:54:28');
INSERT INTO `sys_menu` VALUES (4, 1, '通用字典', 'base/macro/list.html', NULL, 1, 'fa fa-book', 2, '2017-08-09 23:06:58', '2017-08-17 10:00:24');
INSERT INTO `sys_menu` VALUES (6, 3, '用户管理', 'base/user/list.html', '', 1, 'fa fa-user', 2, '2017-08-10 14:12:11', '2017-09-05 12:57:42');
INSERT INTO `sys_menu` VALUES (7, 3, '角色管理', 'base/role/list.html', '', 1, 'fa fa-paw', 1, '2017-08-10 14:13:19', '2017-09-05 12:57:30');
INSERT INTO `sys_menu` VALUES (11, 6, '刷新', '/sys/user/list', 'sys:user:list', 2, NULL, 0, '2017-08-14 10:51:05', '2017-09-05 12:47:23');
INSERT INTO `sys_menu` VALUES (12, 6, '新增', '/sys/user/save', 'sys:user:save', 2, NULL, 0, '2017-08-14 10:51:35', '2017-09-05 12:47:34');
INSERT INTO `sys_menu` VALUES (13, 6, '编辑', '/sys/user/update', 'sys:user:edit', 2, NULL, 0, '2017-08-14 10:52:06', '2017-09-05 12:47:46');
INSERT INTO `sys_menu` VALUES (14, 6, '删除', '/sys/user/remove', 'sys:user:remove', 2, NULL, 0, '2017-08-14 10:52:24', '2017-09-05 12:48:03');
INSERT INTO `sys_menu` VALUES (15, 7, '刷新', '/sys/role/list', 'sys:role:list', 2, NULL, 0, '2017-08-14 10:56:37', '2017-09-05 12:44:04');
INSERT INTO `sys_menu` VALUES (16, 7, '新增', '/sys/role/save', 'sys:role:save', 2, NULL, 0, '2017-08-14 10:57:02', '2017-09-05 12:44:23');
INSERT INTO `sys_menu` VALUES (17, 7, '编辑', '/sys/role/update', 'sys:role:edit', 2, NULL, 0, '2017-08-14 10:57:31', '2017-09-05 12:44:48');
INSERT INTO `sys_menu` VALUES (18, 7, '删除', '/sys/role/remove', 'sys:role:remove', 2, NULL, 0, '2017-08-14 10:57:50', '2017-09-05 12:45:02');
INSERT INTO `sys_menu` VALUES (19, 7, '操作权限', '/sys/role/authorize/opt', 'sys:role:authorizeOpt', 2, NULL, 0, '2017-08-14 10:58:55', '2017-09-05 12:45:29');
INSERT INTO `sys_menu` VALUES (20, 2, '刷新', '/sys/menu/list', 'sys:menu:list', 2, NULL, 0, '2017-08-14 10:59:32', '2017-09-05 13:06:24');
INSERT INTO `sys_menu` VALUES (21, 2, '新增', '/sys/menu/save', 'sys:menu:save', 2, NULL, 0, '2017-08-14 10:59:56', '2017-09-05 13:06:35');
INSERT INTO `sys_menu` VALUES (22, 2, '编辑', '/sys/menu/update', 'sys:menu:edit', 2, NULL, 0, '2017-08-14 11:00:26', '2017-09-05 13:06:48');
INSERT INTO `sys_menu` VALUES (23, 2, '删除', '/sys/menu/remove', 'sys:menu:remove', 2, NULL, 0, '2017-08-14 11:00:58', '2017-09-05 13:07:00');
INSERT INTO `sys_menu` VALUES (24, 6, '启用', '/sys/user/enable', 'sys:user:enable', 2, NULL, 0, '2017-08-14 17:27:18', '2017-09-05 12:48:30');
INSERT INTO `sys_menu` VALUES (25, 6, '停用', '/sys/user/disable', 'sys:user:disable', 2, NULL, 0, '2017-08-14 17:27:43', '2017-09-05 12:48:49');
INSERT INTO `sys_menu` VALUES (26, 6, '重置密码', '/sys/user/rest', 'sys:user:resetPassword', 2, NULL, 0, '2017-08-14 17:28:34', '2017-09-05 12:49:17');
INSERT INTO `sys_menu` VALUES (27, 1, '系统日志', 'base/log/list.html', NULL, 1, 'fa fa-warning', 3, '2017-08-14 22:11:53', '2017-08-17 09:55:19');
INSERT INTO `sys_menu` VALUES (28, 27, '刷新', '/sys/log/list', 'sys:log:list', 2, NULL, 0, '2017-08-14 22:30:22', '2017-09-05 13:05:24');
INSERT INTO `sys_menu` VALUES (29, 27, '删除', '/sys/log/remove', 'sys:log:remove', 2, NULL, 0, '2017-08-14 22:30:43', '2017-09-05 13:05:37');
INSERT INTO `sys_menu` VALUES (30, 27, '清空', '/sys/log/clear', 'sys:log:clear', 2, NULL, 0, '2017-08-14 22:31:02', '2017-09-05 13:05:53');
INSERT INTO `sys_menu` VALUES (32, 4, '刷新', '/sys/macro/list', 'sys:macro:list', 2, NULL, 0, '2017-08-15 16:55:33', '2017-09-05 13:04:00');
INSERT INTO `sys_menu` VALUES (33, 4, '新增', '/sys/macro/save', 'sys:macro:save', 2, NULL, 0, '2017-08-15 16:55:52', '2017-09-05 13:04:22');
INSERT INTO `sys_menu` VALUES (34, 4, '编辑', '/sys/macro/update', 'sys:macro:edit', 2, NULL, 0, '2017-08-15 16:56:09', '2017-09-05 13:04:36');
INSERT INTO `sys_menu` VALUES (35, 4, '删除', '/sys/macro/remove', 'sys:macro:remove', 2, NULL, 0, '2017-08-15 16:56:29', '2017-09-05 13:04:49');
INSERT INTO `sys_menu` VALUES (36, 3, '机构管理', 'base/org/list.html', '', 1, 'fa fa-sitemap', 0, '2017-08-17 09:57:14', '2017-09-05 12:58:53');
INSERT INTO `sys_menu` VALUES (37, 1, '行政区域', 'base/area/list.html', 'sys:area:list', 1, 'fa fa-leaf', 0, '2017-08-17 09:59:57', '2017-09-05 12:49:47');
INSERT INTO `sys_menu` VALUES (38, 37, '刷新', '/sys/area/list', 'sys:area:list', 2, NULL, 0, '2017-08-17 10:01:33', '2017-09-05 13:00:54');
INSERT INTO `sys_menu` VALUES (39, 37, '新增', '/sys/area/save', 'sys:area:save', 2, NULL, 0, '2017-08-17 10:02:16', '2017-09-05 13:01:06');
INSERT INTO `sys_menu` VALUES (40, 37, '编辑', '/sys/area/update', 'sys:area:edit', 2, NULL, 0, '2017-08-17 10:02:33', '2017-09-05 13:01:21');
INSERT INTO `sys_menu` VALUES (41, 37, '删除', '/sys/area/remove', 'sys:area:remove', 2, NULL, 0, '2017-08-17 10:02:50', '2017-09-05 13:01:32');
INSERT INTO `sys_menu` VALUES (42, 36, '刷新', '/sys/org/list', 'sys:org:list', 2, NULL, 0, '2017-08-17 10:03:36', '2017-09-05 11:47:37');
INSERT INTO `sys_menu` VALUES (43, 36, '新增', '/sys/org/save', 'sys:org:save', 2, NULL, 0, '2017-08-17 10:03:54', '2017-09-05 12:40:55');
INSERT INTO `sys_menu` VALUES (44, 36, '编辑', '/sys/org/update', 'sys:org:edit', 2, NULL, 0, '2017-08-17 10:04:11', '2017-09-05 12:43:06');
INSERT INTO `sys_menu` VALUES (45, 36, '删除', '/sys/org/remove', 'sys:org:remove', 2, NULL, 0, '2017-08-17 10:04:30', '2017-09-05 12:42:19');
INSERT INTO `sys_menu` VALUES (46, 7, '数据权限', '/sys/role/authorize/data', 'sys:role:authorizeData', 2, NULL, 0, '2017-08-17 13:48:11', '2017-09-05 12:45:54');
INSERT INTO `sys_menu` VALUES (47, 1, '定时任务', 'base/quartz/list.html', NULL, 1, 'fa fa-bell', 4, '2017-08-19 23:00:08', NULL);
INSERT INTO `sys_menu` VALUES (48, 47, '刷新', '/quartz/job/list', 'quartz:job:list', 2, NULL, 0, '2017-08-19 23:00:54', '2017-09-05 13:08:18');
INSERT INTO `sys_menu` VALUES (49, 47, '新增', '/quartz/job/save', 'quartz:job:save', 2, NULL, 0, '2017-08-19 23:01:29', '2017-09-05 13:08:30');
INSERT INTO `sys_menu` VALUES (50, 47, '编辑', '/quartz/job/update', 'quartz:job:edit', 2, NULL, 0, '2017-08-19 23:01:58', '2017-09-05 13:08:44');
INSERT INTO `sys_menu` VALUES (51, 47, '删除', '/quartz/job/remove', 'quartz:job:remove', 2, NULL, 0, '2017-08-19 23:02:30', '2017-09-05 13:08:57');
INSERT INTO `sys_menu` VALUES (52, 63, '启用', '/quartz/job/enable', 'quartz:job:enable', 2, NULL, 0, '2017-08-19 23:08:59', '2017-09-13 22:12:35');
INSERT INTO `sys_menu` VALUES (53, 63, '停用', '/quartz/job/disable', 'quartz:job:disable', 2, NULL, 0, '2017-08-19 23:09:31', '2017-09-13 22:12:53');
INSERT INTO `sys_menu` VALUES (54, 63, '立即执行', '/quartz/job/run', 'quartz:job:run', 2, NULL, 0, '2017-08-19 23:10:09', '2017-09-13 22:13:11');
INSERT INTO `sys_menu` VALUES (55, 47, '日志列表', NULL, 'quartz:job:log', 1, NULL, 0, '2017-08-19 23:10:40', '2017-09-13 22:21:12');
INSERT INTO `sys_menu` VALUES (56, 55, '刷新', '/quartz/job/log/list', 'quartz:log:list', 2, NULL, 0, '2017-08-21 13:25:33', '2017-09-13 22:21:27');
INSERT INTO `sys_menu` VALUES (57, 55, '删除', '/quartz/job/log/remove', 'quartz:log:remove', 2, NULL, 0, '2017-08-21 13:25:52', '2017-09-13 22:21:46');
INSERT INTO `sys_menu` VALUES (58, 55, '清空', '/quartz/job/log/clear', 'quartz:log:clear', 2, NULL, 0, '2017-08-21 13:26:11', '2017-09-13 22:22:04');
INSERT INTO `sys_menu` VALUES (59, 1, '敏捷开发', 'base/generator/list.html', NULL, 1, 'fa fa-archive', 5, '2017-09-05 10:49:04', NULL);
INSERT INTO `sys_menu` VALUES (60, 59, '刷新', '/sys/generator/list', 'sys:gen:list', 2, NULL, 0, '2017-09-05 10:49:25', '2017-09-05 13:07:33');
INSERT INTO `sys_menu` VALUES (61, 59, '生成代码', '/sys/generator/code', 'sys:gen:code', 2, NULL, 0, '2017-09-05 10:49:44', '2017-09-05 13:07:48');
INSERT INTO `sys_menu` VALUES (62, 1, '系统监控', 'druid/index.html', NULL, 1, 'fa fa-bug', 6, '2017-09-10 17:01:59', '2017-09-10 17:02:19');
INSERT INTO `sys_menu` VALUES (63, 47, '更多', NULL, 'quartz:job:more', 1, NULL, 0, '2017-09-13 22:11:51', '2017-09-13 22:12:12');
INSERT INTO `sys_menu` VALUES (64, 1, '接口管理', 'swagger-ui.html', NULL, 1, 'fa fa-support', 7, '2017-09-10 17:01:59', '2017-09-10 17:02:19');
INSERT INTO `sys_menu` VALUES (66, 0, '交易', NULL, NULL, 0, 'fa fa-circle-o', 2, '2020-08-09 21:02:33', '2020-08-09 21:25:28');
INSERT INTO `sys_menu` VALUES (67, 66, '代付订单', 'modules/billOut/list.html', NULL, 1, 'fa fa-circle-o', 1, '2020-08-09 21:03:34', '2020-08-13 01:50:36');
INSERT INTO `sys_menu` VALUES (68, 66, '商户充值', 'modules/billIn/list.html', NULL, 1, 'fa fa-circle-o', 0, '2020-08-09 21:06:24', '2020-08-24 16:20:54');
INSERT INTO `sys_menu` VALUES (69, 66, '资金调度', 'modules/procurement/list.html', NULL, 1, 'fa fa-circle-o', 4, '2020-08-09 21:07:06', '2020-08-20 23:45:18');
INSERT INTO `sys_menu` VALUES (70, 66, '商户冻结', 'modules/frozen/list.html', NULL, 1, 'fa fa-circle-o', 3, '2020-08-09 21:07:33', '2020-08-09 21:24:24');
INSERT INTO `sys_menu` VALUES (71, 0, '银行卡管理', NULL, NULL, 0, 'fa fa-circle-o', 3, '2020-08-09 21:08:51', '2020-08-09 21:25:51');
INSERT INTO `sys_menu` VALUES (72, 71, '专员付款卡', 'modules/bankCard/list.html', NULL, 1, 'fa fa-circle-o', 0, '2020-08-09 21:09:17', '2020-08-19 21:12:40');
INSERT INTO `sys_menu` VALUES (74, 0, '报表', NULL, NULL, 0, 'fa fa-circle-o', 4, '2020-08-09 21:12:45', '2020-08-09 21:26:04');
INSERT INTO `sys_menu` VALUES (76, 74, '专员付款日报表', 'modules/reportBusiness/list.html', NULL, 1, 'fa fa-circle-o', 1, '2020-08-09 21:16:40', '2020-08-09 21:28:30');
INSERT INTO `sys_menu` VALUES (77, 0, '历史数据', NULL, NULL, 0, 'fa fa-circle-o', 5, '2020-08-09 21:17:50', '2020-08-09 21:26:17');
INSERT INTO `sys_menu` VALUES (78, 3, '在线成员', 'modules/onlineBusiness/list.html', NULL, 1, 'fa fa-circle-o', 3, '2020-08-09 21:19:34', '2020-08-19 17:10:13');
INSERT INTO `sys_menu` VALUES (79, 66, '商户管理', 'modules/balance/list.html', NULL, 1, 'fa fa-circle-o', 2, '2020-08-09 21:22:01', '2020-08-09 21:24:09');
INSERT INTO `sys_menu` VALUES (80, 67, '刷新', '/apiV1/billOut/list', 'apiV1:billOut:list', 2, 'fa fa-circle-o', 0, '2020-08-13 01:51:23', '2020-08-13 01:51:53');
INSERT INTO `sys_menu` VALUES (81, 67, '成功', '/apiV1/billOut/bill/success', 'apiV1:billOut:success', 2, 'fa fa-circle-o', 1, '2020-08-13 02:06:18', NULL);
INSERT INTO `sys_menu` VALUES (82, 67, '失败', '/apiV1/billOut/bill/failed', 'apiV1:billOut:failed', 2, 'fa fa-circle-o', 2, NULL, NULL);
INSERT INTO `sys_menu` VALUES (83, 67, '回退', '/apiV1/billOut//bill/goBackOrg', 'apiV1:billOut:goBack', 2, 'fa fa-circle-o', 3, NULL, NULL);
INSERT INTO `sys_menu` VALUES (84, 67, '指定', '/apiV1/billOut/appoint/human', 'apiV1:billOut:appoint:people', 2, 'fa fa-circle-o', 4, NULL, NULL);
INSERT INTO `sys_menu` VALUES (85, 67, '自动开关', '/apiV1/billOut/appoint/auto', 'apiV1:billOut:appoint:auto', 2, 'fa fa-circle-o', 5, NULL, NULL);
INSERT INTO `sys_menu` VALUES (86, 67, '派单', '/apiV1/billOut/push/order', 'apiV1:billOut:save', 2, 'fa fa-circle-o', 6, NULL, NULL);
INSERT INTO `sys_menu` VALUES (87, 78, '刷新', NULL, 'apiV1:onlineBusiness:list', 2, 'fa fa-circle-o', 0, '2020-08-19 17:11:24', NULL);
INSERT INTO `sys_menu` VALUES (88, 78, '禁用', NULL, 'apiV1:onlineBusiness:enable', 2, 'fa fa-circle-o', 0, '2020-08-19 17:12:01', NULL);
INSERT INTO `sys_menu` VALUES (89, 72, '刷新', NULL, 'bankCard:list', 2, 'fa fa-circle-o', 0, '2020-08-19 21:13:55', '2020-08-19 21:14:06');
INSERT INTO `sys_menu` VALUES (90, 72, '启用', NULL, 'bankCard:enable', 2, 'fa fa-circle-o', 0, '2020-08-19 21:15:01', NULL);
INSERT INTO `sys_menu` VALUES (91, 72, '禁用', NULL, 'bankCard:disable', 2, 'fa fa-circle-o', 0, '2020-08-19 21:15:34', NULL);
INSERT INTO `sys_menu` VALUES (92, 72, '删除', NULL, 'bankCard:remove', 2, 'fa fa-circle-o', 0, '2020-08-19 21:16:02', NULL);
INSERT INTO `sys_menu` VALUES (93, 72, '增加', NULL, 'bankCard:save', 2, 'fa fa-circle-o', 0, '2020-08-19 21:16:35', NULL);
INSERT INTO `sys_menu` VALUES (94, 66, '增加', NULL, 'procurement:save', 8, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (95, 66, '增加：代理', NULL, 'procurement:save:agent', 8, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (96, 66, '刷新', NULL, 'procurement:list', 8, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (97, 68, '刷新', NULL, 'merchant:charge:list', 2, 'fa fa-circle-o', 0, '2020-08-24 16:22:35', NULL);
INSERT INTO `sys_menu` VALUES (98, 68, '添加充值订单', NULL, 'merchant:charge:success', 2, 'fa fa-circle-o', 0, '2020-08-24 16:23:07', NULL);
INSERT INTO `sys_menu` VALUES (99, 68, '确认充值成功', NULL, 'merchant:charge:save', 2, 'fa fa-circle-o', 0, '2020-08-24 16:24:37', NULL);
INSERT INTO `sys_menu` VALUES (100, 68, '确认充值失败', NULL, 'merchant:charge:fail', 2, 'fa fa-circle-o', 0, '2020-08-24 16:25:25', NULL);
INSERT INTO `sys_menu` VALUES (101, 67, '通知', NULL, 'apiV1:billOut:notice', 2, 'fa fa-circle-o', 7, NULL, NULL);
INSERT INTO `sys_menu` VALUES (102, 76, '刷新', NULL, 'report:business:list', 2, 'fa fa-circle-o', 0, '2020-09-15 10:07:51', NULL);
INSERT INTO `sys_menu` VALUES (103, 66, '商户关联出款员', 'modules/businessMerchant/list.html', NULL, 1, 'fa fa-circle-o', 5, '2020-12-28 20:36:00', '2020-12-28 20:36:59');
INSERT INTO `sys_menu` VALUES (104, 103, '刷新', '/apiV1/businessMerchant/list', 'apiV1:businessMerchant:list', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (105, 103, '新增', '/apiV1/businessMerchant/save', 'apiV1:businessMerchant:save', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (106, 103, '修改', '/apiV1/businessMerchant/update', 'apiV1:businessMerchant:edit', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (107, 103, '删除', '/apiV1/businessMerchant/remove', 'apiV1:businessMerchant:remove', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (108, 66, '账变日志', 'modules/balanceChangeLog/list.html', NULL, 1, 'fa fa-circle-o', 6, '2020-12-29 22:18:32', NULL);
INSERT INTO `sys_menu` VALUES (109, 108, '刷新', '/apiV1/balanceChangeLog/list', 'apiV1:balanceChangeLog:list', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (110, 67, '锁定', NULL, 'apiV1:billOut:lock', 2, 'fa fa-circle-o', 8, NULL, NULL);
INSERT INTO `sys_menu` VALUES (111, 74, '商户日报表', 'modules/reportMerchant/list.html', NULL, 1, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (112, 111, '刷新', '/apiV1/reportMerchant/list', 'apiV1:reportMerchant:list', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (113, 66, '代收订单', 'modules/billInPlayer/list.html', '', 1, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (114, 113, '刷新', '/billInPlayer/list', 'billInPlayer:list', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (115, 113, '新增', '/billInPlayer/save', 'billInPlayer:save', 2, 'fa fa-circle-o', NULL, NULL, NULL);
INSERT INTO `sys_menu` VALUES (116, 113, '修改', '/billInPlayer/update', 'billInPlayer:edit', 2, 'fa fa-circle-o', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_org
-- ----------------------------
DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org` (
  `org_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '机构id',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '上级机构ID，一级机构为0',
  `code` varchar(100) DEFAULT NULL COMMENT '机构编码',
  `name` varchar(100) DEFAULT NULL COMMENT '机构名称',
  `order_num` int(11) DEFAULT NULL COMMENT '排序',
  `status` tinyint(4) DEFAULT '1' COMMENT '可用标识  1：可用  0：不可用',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='机构管理';

-- ----------------------------
-- Records of sys_org
-- ----------------------------
BEGIN;
INSERT INTO `sys_org` VALUES (1, 0, 'js', '江苏省', 0, 1, '2017-08-17 12:03:15', '2017-08-17 17:06:08');
INSERT INTO `sys_org` VALUES (2, 1, 'dx001', 'DaXiong', 0, 1, '2020-08-09 20:14:48', NULL);
INSERT INTO `sys_org` VALUES (3, 1, 'rmi001', 'Rmi', 0, 1, '2020-08-09 20:15:04', NULL);
INSERT INTO `sys_org` VALUES (4, 1, 'TL01', '天龙01', 0, 1, '2020-09-05 23:11:11', NULL);
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='系统角色';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (1, 1, '超级管理员', 'admin', '【系统内置】', 2, '2017-08-12 00:43:52', '2017-09-05 14:02:04');
INSERT INTO `sys_role` VALUES (2, 1, '出款员', 'customer service', NULL, 1, '2020-08-09 20:17:18', '2020-08-09 20:36:07');
INSERT INTO `sys_role` VALUES (3, 1, '代付商户', 'bill out merchant', NULL, 1, '2020-08-09 20:34:35', '2020-08-14 17:26:18');
INSERT INTO `sys_role` VALUES (4, 1, '机构管理员', 'organization', NULL, 1, '2020-08-14 17:12:01', '2020-08-14 17:12:46');
INSERT INTO `sys_role` VALUES (5, 1, '代收商户', 'bill in merchant', NULL, 1, '2020-08-14 17:26:09', NULL);
INSERT INTO `sys_role` VALUES (6, 1, '代付商户服务器', 'bill out merchant server', NULL, 1, NULL, NULL);
INSERT INTO `sys_role` VALUES (7, 1, '收款员', 'bill in customer service', NULL, 1, '2021-02-27 00:40:21', NULL);
INSERT INTO `sys_role` VALUES (8, 1, '代收商户服务器', 'bill in merchant server', NULL, 1, '2021-02-27 00:40:58', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `menu_id` bigint(20) DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=utf8 COMMENT='角色与菜单对应关系';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_menu` VALUES (1, 1, 1);
INSERT INTO `sys_role_menu` VALUES (2, 1, 2);
INSERT INTO `sys_role_menu` VALUES (3, 1, 4);
INSERT INTO `sys_role_menu` VALUES (4, 1, 3);
INSERT INTO `sys_role_menu` VALUES (5, 1, 6);
INSERT INTO `sys_role_menu` VALUES (6, 1, 7);
INSERT INTO `sys_role_menu` VALUES (7, 1, 11);
INSERT INTO `sys_role_menu` VALUES (8, 1, 12);
INSERT INTO `sys_role_menu` VALUES (9, 1, 13);
INSERT INTO `sys_role_menu` VALUES (10, 1, 14);
INSERT INTO `sys_role_menu` VALUES (11, 1, 15);
INSERT INTO `sys_role_menu` VALUES (12, 1, 16);
INSERT INTO `sys_role_menu` VALUES (13, 1, 17);
INSERT INTO `sys_role_menu` VALUES (14, 1, 18);
INSERT INTO `sys_role_menu` VALUES (15, 1, 19);
INSERT INTO `sys_role_menu` VALUES (16, 1, 20);
INSERT INTO `sys_role_menu` VALUES (17, 1, 21);
INSERT INTO `sys_role_menu` VALUES (18, 1, 22);
INSERT INTO `sys_role_menu` VALUES (19, 1, 23);
INSERT INTO `sys_role_menu` VALUES (20, 1, 24);
INSERT INTO `sys_role_menu` VALUES (21, 1, 25);
INSERT INTO `sys_role_menu` VALUES (22, 1, 26);
INSERT INTO `sys_role_menu` VALUES (23, 1, 27);
INSERT INTO `sys_role_menu` VALUES (24, 1, 28);
INSERT INTO `sys_role_menu` VALUES (25, 1, 29);
INSERT INTO `sys_role_menu` VALUES (26, 1, 30);
INSERT INTO `sys_role_menu` VALUES (27, 1, 32);
INSERT INTO `sys_role_menu` VALUES (28, 1, 33);
INSERT INTO `sys_role_menu` VALUES (29, 1, 34);
INSERT INTO `sys_role_menu` VALUES (30, 1, 35);
INSERT INTO `sys_role_menu` VALUES (31, 1, 36);
INSERT INTO `sys_role_menu` VALUES (32, 1, 37);
INSERT INTO `sys_role_menu` VALUES (33, 1, 38);
INSERT INTO `sys_role_menu` VALUES (34, 1, 39);
INSERT INTO `sys_role_menu` VALUES (35, 1, 40);
INSERT INTO `sys_role_menu` VALUES (36, 1, 41);
INSERT INTO `sys_role_menu` VALUES (37, 1, 42);
INSERT INTO `sys_role_menu` VALUES (38, 1, 43);
INSERT INTO `sys_role_menu` VALUES (39, 1, 44);
INSERT INTO `sys_role_menu` VALUES (40, 1, 45);
INSERT INTO `sys_role_menu` VALUES (41, 1, 46);
INSERT INTO `sys_role_menu` VALUES (42, 1, 47);
INSERT INTO `sys_role_menu` VALUES (43, 1, 48);
INSERT INTO `sys_role_menu` VALUES (44, 1, 49);
INSERT INTO `sys_role_menu` VALUES (45, 1, 50);
INSERT INTO `sys_role_menu` VALUES (46, 1, 51);
INSERT INTO `sys_role_menu` VALUES (47, 1, 55);
INSERT INTO `sys_role_menu` VALUES (48, 1, 56);
INSERT INTO `sys_role_menu` VALUES (49, 1, 57);
INSERT INTO `sys_role_menu` VALUES (50, 1, 58);
INSERT INTO `sys_role_menu` VALUES (51, 1, 63);
INSERT INTO `sys_role_menu` VALUES (52, 1, 52);
INSERT INTO `sys_role_menu` VALUES (53, 1, 53);
INSERT INTO `sys_role_menu` VALUES (54, 1, 54);
INSERT INTO `sys_role_menu` VALUES (55, 1, 59);
INSERT INTO `sys_role_menu` VALUES (56, 1, 60);
INSERT INTO `sys_role_menu` VALUES (57, 1, 61);
INSERT INTO `sys_role_menu` VALUES (58, 1, 62);
INSERT INTO `sys_role_menu` VALUES (59, 1, 64);
INSERT INTO `sys_role_menu` VALUES (120, 1, 66);
INSERT INTO `sys_role_menu` VALUES (122, 1, 67);
INSERT INTO `sys_role_menu` VALUES (123, 1, 68);
INSERT INTO `sys_role_menu` VALUES (124, 1, 69);
INSERT INTO `sys_role_menu` VALUES (125, 1, 70);
INSERT INTO `sys_role_menu` VALUES (126, 1, 71);
INSERT INTO `sys_role_menu` VALUES (127, 1, 72);
INSERT INTO `sys_role_menu` VALUES (129, 1, 74);
INSERT INTO `sys_role_menu` VALUES (131, 1, 76);
INSERT INTO `sys_role_menu` VALUES (132, 1, 77);
INSERT INTO `sys_role_menu` VALUES (133, 1, 78);
INSERT INTO `sys_role_menu` VALUES (134, 1, 79);
INSERT INTO `sys_role_menu` VALUES (135, 1, 80);
INSERT INTO `sys_role_menu` VALUES (136, 1, 81);
INSERT INTO `sys_role_menu` VALUES (137, 1, 82);
INSERT INTO `sys_role_menu` VALUES (138, 1, 83);
INSERT INTO `sys_role_menu` VALUES (139, 1, 84);
INSERT INTO `sys_role_menu` VALUES (140, 1, 85);
INSERT INTO `sys_role_menu` VALUES (141, 1, 86);
INSERT INTO `sys_role_menu` VALUES (142, 2, 67);
INSERT INTO `sys_role_menu` VALUES (143, 2, 80);
INSERT INTO `sys_role_menu` VALUES (144, 2, 81);
INSERT INTO `sys_role_menu` VALUES (145, 2, 82);
INSERT INTO `sys_role_menu` VALUES (146, 2, 83);
INSERT INTO `sys_role_menu` VALUES (150, 2, 67);
INSERT INTO `sys_role_menu` VALUES (151, 2, 66);
INSERT INTO `sys_role_menu` VALUES (154, 2, 76);
INSERT INTO `sys_role_menu` VALUES (155, 2, 3);
INSERT INTO `sys_role_menu` VALUES (156, 2, 78);
INSERT INTO `sys_role_menu` VALUES (157, 1, 87);
INSERT INTO `sys_role_menu` VALUES (158, 1, 88);
INSERT INTO `sys_role_menu` VALUES (159, 1, 89);
INSERT INTO `sys_role_menu` VALUES (160, 1, 90);
INSERT INTO `sys_role_menu` VALUES (161, 1, 91);
INSERT INTO `sys_role_menu` VALUES (162, 1, 92);
INSERT INTO `sys_role_menu` VALUES (163, 1, 93);
INSERT INTO `sys_role_menu` VALUES (164, 2, 71);
INSERT INTO `sys_role_menu` VALUES (165, 2, 72);
INSERT INTO `sys_role_menu` VALUES (166, 2, 89);
INSERT INTO `sys_role_menu` VALUES (167, 2, 90);
INSERT INTO `sys_role_menu` VALUES (168, 2, 91);
INSERT INTO `sys_role_menu` VALUES (169, 2, 92);
INSERT INTO `sys_role_menu` VALUES (170, 2, 93);
INSERT INTO `sys_role_menu` VALUES (171, 4, 71);
INSERT INTO `sys_role_menu` VALUES (172, 4, 72);
INSERT INTO `sys_role_menu` VALUES (173, 4, 89);
INSERT INTO `sys_role_menu` VALUES (174, 4, 91);
INSERT INTO `sys_role_menu` VALUES (175, 4, 92);
INSERT INTO `sys_role_menu` VALUES (176, 1, 94);
INSERT INTO `sys_role_menu` VALUES (177, 1, 95);
INSERT INTO `sys_role_menu` VALUES (178, 1, 96);
INSERT INTO `sys_role_menu` VALUES (179, 3, 66);
INSERT INTO `sys_role_menu` VALUES (180, 3, 68);
INSERT INTO `sys_role_menu` VALUES (181, 3, 97);
INSERT INTO `sys_role_menu` VALUES (182, 3, 98);
INSERT INTO `sys_role_menu` VALUES (183, 3, 99);
INSERT INTO `sys_role_menu` VALUES (184, 3, 100);
INSERT INTO `sys_role_menu` VALUES (185, 3, 79);
INSERT INTO `sys_role_menu` VALUES (186, 4, 79);
INSERT INTO `sys_role_menu` VALUES (187, 3, 67);
INSERT INTO `sys_role_menu` VALUES (188, 4, 67);
INSERT INTO `sys_role_menu` VALUES (189, 3, 80);
INSERT INTO `sys_role_menu` VALUES (190, 4, 80);
INSERT INTO `sys_role_menu` VALUES (192, 4, 81);
INSERT INTO `sys_role_menu` VALUES (194, 4, 82);
INSERT INTO `sys_role_menu` VALUES (198, 4, 84);
INSERT INTO `sys_role_menu` VALUES (200, 4, 85);
INSERT INTO `sys_role_menu` VALUES (201, 3, 86);
INSERT INTO `sys_role_menu` VALUES (203, 4, 66);
INSERT INTO `sys_role_menu` VALUES (204, 4, 70);
INSERT INTO `sys_role_menu` VALUES (205, 3, 70);
INSERT INTO `sys_role_menu` VALUES (206, 4, 68);
INSERT INTO `sys_role_menu` VALUES (207, 3, 68);
INSERT INTO `sys_role_menu` VALUES (208, 4, 97);
INSERT INTO `sys_role_menu` VALUES (209, 3, 97);
INSERT INTO `sys_role_menu` VALUES (210, 4, 98);
INSERT INTO `sys_role_menu` VALUES (211, 3, 98);
INSERT INTO `sys_role_menu` VALUES (212, 4, 99);
INSERT INTO `sys_role_menu` VALUES (213, 3, 99);
INSERT INTO `sys_role_menu` VALUES (214, 4, 100);
INSERT INTO `sys_role_menu` VALUES (215, 3, 100);
INSERT INTO `sys_role_menu` VALUES (216, 4, 69);
INSERT INTO `sys_role_menu` VALUES (217, 3, 69);
INSERT INTO `sys_role_menu` VALUES (218, 2, 69);
INSERT INTO `sys_role_menu` VALUES (219, 4, 6);
INSERT INTO `sys_role_menu` VALUES (220, 4, 3);
INSERT INTO `sys_role_menu` VALUES (221, 4, 11);
INSERT INTO `sys_role_menu` VALUES (222, 4, 12);
INSERT INTO `sys_role_menu` VALUES (223, 4, 13);
INSERT INTO `sys_role_menu` VALUES (224, 4, 14);
INSERT INTO `sys_role_menu` VALUES (225, 4, 24);
INSERT INTO `sys_role_menu` VALUES (226, 4, 25);
INSERT INTO `sys_role_menu` VALUES (227, 4, 26);
INSERT INTO `sys_role_menu` VALUES (228, 4, 36);
INSERT INTO `sys_role_menu` VALUES (229, 4, 42);
INSERT INTO `sys_role_menu` VALUES (230, 3, 68);
INSERT INTO `sys_role_menu` VALUES (231, 3, 70);
INSERT INTO `sys_role_menu` VALUES (232, 3, 79);
INSERT INTO `sys_role_menu` VALUES (236, 2, 101);
INSERT INTO `sys_role_menu` VALUES (237, 4, 101);
INSERT INTO `sys_role_menu` VALUES (238, 4, 78);
INSERT INTO `sys_role_menu` VALUES (239, 2, 102);
INSERT INTO `sys_role_menu` VALUES (240, 2, 74);
INSERT INTO `sys_role_menu` VALUES (241, 2, 76);
INSERT INTO `sys_role_menu` VALUES (242, 4, 102);
INSERT INTO `sys_role_menu` VALUES (243, 4, 74);
INSERT INTO `sys_role_menu` VALUES (244, 4, 76);
INSERT INTO `sys_role_menu` VALUES (246, 2, 68);
INSERT INTO `sys_role_menu` VALUES (247, 1, 103);
INSERT INTO `sys_role_menu` VALUES (248, 1, 104);
INSERT INTO `sys_role_menu` VALUES (249, 1, 105);
INSERT INTO `sys_role_menu` VALUES (250, 1, 106);
INSERT INTO `sys_role_menu` VALUES (251, 1, 107);
INSERT INTO `sys_role_menu` VALUES (252, 4, 103);
INSERT INTO `sys_role_menu` VALUES (253, 4, 104);
INSERT INTO `sys_role_menu` VALUES (254, 4, 105);
INSERT INTO `sys_role_menu` VALUES (255, 4, 106);
INSERT INTO `sys_role_menu` VALUES (256, 4, 107);
INSERT INTO `sys_role_menu` VALUES (257, 2, 79);
INSERT INTO `sys_role_menu` VALUES (258, 4, 108);
INSERT INTO `sys_role_menu` VALUES (259, 4, 109);
INSERT INTO `sys_role_menu` VALUES (260, 1, 108);
INSERT INTO `sys_role_menu` VALUES (261, 1, 109);
INSERT INTO `sys_role_menu` VALUES (262, 2, 108);
INSERT INTO `sys_role_menu` VALUES (263, 2, 109);
INSERT INTO `sys_role_menu` VALUES (264, 1, 110);
INSERT INTO `sys_role_menu` VALUES (265, 2, 110);
INSERT INTO `sys_role_menu` VALUES (266, 4, 110);
INSERT INTO `sys_role_menu` VALUES (267, 3, 108);
INSERT INTO `sys_role_menu` VALUES (268, 3, 109);
INSERT INTO `sys_role_menu` VALUES (269, 1, 113);
INSERT INTO `sys_role_menu` VALUES (270, 1, 114);
INSERT INTO `sys_role_menu` VALUES (271, 1, 115);
INSERT INTO `sys_role_menu` VALUES (272, 1, 116);
INSERT INTO `sys_role_menu` VALUES (273, 4, 113);
INSERT INTO `sys_role_menu` VALUES (274, 4, 114);
INSERT INTO `sys_role_menu` VALUES (275, 4, 115);
INSERT INTO `sys_role_menu` VALUES (276, 4, 116);
INSERT INTO `sys_role_menu` VALUES (277, 5, 113);
INSERT INTO `sys_role_menu` VALUES (278, 5, 114);
INSERT INTO `sys_role_menu` VALUES (279, 5, 115);
INSERT INTO `sys_role_menu` VALUES (280, 7, 113);
INSERT INTO `sys_role_menu` VALUES (281, 7, 114);
INSERT INTO `sys_role_menu` VALUES (282, 7, 115);
INSERT INTO `sys_role_menu` VALUES (283, 7, 116);
INSERT INTO `sys_role_menu` VALUES (284, 4, 111);
INSERT INTO `sys_role_menu` VALUES (285, 1, 111);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_org
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_org`;
CREATE TABLE `sys_role_org` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `org_id` bigint(20) DEFAULT NULL COMMENT '机构ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='角色与机构对应关系';

-- ----------------------------
-- Records of sys_role_org
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_org` VALUES (1, 1, 1);
COMMIT;

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
  `enable_google_kaptcha` tinyint(1) unsigned zerofill DEFAULT NULL,
  `google_kaptcha_key` varchar(25) DEFAULT NULL,
  `bill_auto` tinyint(4) DEFAULT '1' COMMENT '1:自动,0手动',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uniq_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='系统用户';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, 1, 'admin', '1f11ab14825ea2b7127a394cfd853090', 'admin@example.com', '123456', 1, NULL, 1, '2017-08-15 21:40:39', '2021-05-14 01:41:04', 0, 'ON73R5IHSLS6C6FU', 1);
INSERT INTO `sys_user` VALUES (2, 2, 'xiaoxiong', 'dd5052330db4909cd017bc47f14ea990', NULL, NULL, 0, NULL, 1, '2020-08-09 20:18:12', '2020-08-09 20:35:48', NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (3, 3, 'lynn', '88f6abf53883a2a640202bfca985b75e', NULL, NULL, 0, NULL, 1, '2020-08-09 20:41:52', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (4, 2, '106', '7463cb8010e452217859ec619236c397', NULL, NULL, 1, NULL, 1, '2020-08-13 23:16:39', '2021-04-25 23:12:56', 0, 'HXSWS2EJLYLXLSCT', 0);
INSERT INTO `sys_user` VALUES (5, 3, 'Becky', 'a32e9f38514e6db10b4298608c6d9939', NULL, NULL, 1, NULL, 1, '2020-08-19 01:10:00', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (6, 3, 'Allen', 'f1ab5d145e018210e7aaa036e08b0112', NULL, NULL, 1, NULL, 1, '2020-08-19 01:14:43', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (7, 2, '106Admin', '73dc64cef667e1428c2162e219b86f6c', NULL, NULL, 1, NULL, 1, '2020-08-25 23:53:16', '2021-04-26 00:59:28', NULL, 'N3FKCAFYUPZOJZNB', 1);
INSERT INTO `sys_user` VALUES (8, 2, 'mighty', '34f1ddb08e18047804d27f00ceef4c24', NULL, NULL, 1, NULL, 1, '2020-08-25 23:56:32', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (9, 2, 'adrian', 'ce60ec109a00d553da35735d7c7a8bef', NULL, NULL, 1, NULL, 7, '2020-08-26 00:22:40', '2021-04-26 18:26:18', NULL, '2O255IN5ELFEW5RW', 1);
INSERT INTO `sys_user` VALUES (10, 2, 'ketty', 'cf686ebd0319af9c546fffb6437db256', NULL, NULL, 1, NULL, 7, '2020-08-27 13:29:31', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (11, 2, '106Server', '0fc87f4157c67bbe47dd596d9ac63355', NULL, NULL, 1, 'abcd1234', 1, '2020-08-28 21:24:45', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (12, 4, '888Merchant', 'bd47ee8d5ab1fad85b7ab89fc108bd2e', NULL, NULL, 1, NULL, 1, '2020-09-05 23:12:06', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (13, 4, '888Server', 'd01ab47388b608f590eb28977be3dbc7', NULL, NULL, 1, NULL, 1, '2020-09-05 23:18:17', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (14, 4, 'TianLong01', '0e211c17c0ceef23fe47bf67083ba0af', NULL, NULL, 1, NULL, 1, '2020-09-06 00:42:43', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (15, 4, 'rmiTest', '4b5afd48f2b159b11f3e066b30b3278a', NULL, NULL, 1, NULL, 14, '2020-09-07 14:48:46', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (16, 4, 'wushang01', 'e4c137bff7ad493d11fdffff2028d27d', NULL, NULL, 1, NULL, 14, '2020-09-09 11:27:34', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (17, 4, 'wushang02', 'cb569cca527d40a8cb8a962276cf9d3e', NULL, NULL, 1, NULL, 14, '2020-09-09 11:28:08', '2020-09-11 21:33:04', NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (18, 4, 'Earth', '624386966c02ff051305bea88d29ceef', NULL, NULL, 1, NULL, 14, '2020-09-13 15:31:11', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (19, 4, 'EarthServer', '89ccde45d5ca3aed6915d424d99e31e1', NULL, NULL, 1, NULL, 14, '2020-09-13 15:32:04', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (20, 4, 'C711', '55c134853f6ba301597b473577b63e2d', NULL, NULL, 1, NULL, 14, '2020-09-23 22:15:12', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (21, 4, 'C711Server', 'd7dcedcb8e2b9d91f3083b370e4ac886', NULL, NULL, 1, NULL, 14, '2020-09-23 22:16:09', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (22, 4, 'wushang03', '2bcdfd3bfd8c1bbb3be056bb06c89d43', NULL, NULL, 1, NULL, 14, '2020-09-28 09:43:16', NULL, NULL, NULL, 1);
INSERT INTO `sys_user` VALUES (23, 4, '112', '1234567890123457', NULL, NULL, 1, NULL, 1, '2021-03-07 00:28:40', NULL, 0, NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='用户与角色对应关系';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` VALUES (1, 1, 1);
INSERT INTO `sys_user_role` VALUES (3, 2, 2);
INSERT INTO `sys_user_role` VALUES (4, 3, 2);
INSERT INTO `sys_user_role` VALUES (6, 5, 2);
INSERT INTO `sys_user_role` VALUES (7, 6, 2);
INSERT INTO `sys_user_role` VALUES (8, 7, 4);
INSERT INTO `sys_user_role` VALUES (9, 8, 2);
INSERT INTO `sys_user_role` VALUES (10, 9, 2);
INSERT INTO `sys_user_role` VALUES (11, 10, 2);
INSERT INTO `sys_user_role` VALUES (12, 11, 6);
INSERT INTO `sys_user_role` VALUES (13, 12, 3);
INSERT INTO `sys_user_role` VALUES (14, 13, 6);
INSERT INTO `sys_user_role` VALUES (15, 14, 4);
INSERT INTO `sys_user_role` VALUES (16, 15, 2);
INSERT INTO `sys_user_role` VALUES (17, 16, 2);
INSERT INTO `sys_user_role` VALUES (19, 17, 2);
INSERT INTO `sys_user_role` VALUES (20, 18, 3);
INSERT INTO `sys_user_role` VALUES (21, 19, 6);
INSERT INTO `sys_user_role` VALUES (22, 20, 3);
INSERT INTO `sys_user_role` VALUES (23, 21, 6);
INSERT INTO `sys_user_role` VALUES (24, 22, 2);
INSERT INTO `sys_user_role` VALUES (25, 4, 3);
INSERT INTO `sys_user_role` VALUES (26, 23, 3);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_token
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_token`;
CREATE TABLE `sys_user_token` (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `token` varchar(100) NOT NULL COMMENT 'token',
  `gmt_expire` datetime DEFAULT NULL COMMENT '过期时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `token` (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户Token';

-- ----------------------------
-- Records of sys_user_token
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_token` VALUES (1, 'a3c646202882f1213b63fe74dc118e9d', '2017-10-26 22:10:52', '2017-10-26 10:10:52');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

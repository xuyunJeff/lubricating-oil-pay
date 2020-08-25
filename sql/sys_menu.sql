/*
Navicat MySQL Data Transfer

Source Server         : LocalHost
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : bottle_pay

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-08-24 16:38:40
*/

SET FOREIGN_KEY_CHECKS=0;

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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COMMENT='菜单管理';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', '系统管理', null, '', '0', 'fa fa-coffee', '0', '2017-08-09 22:49:47', '2017-09-11 17:25:22');
INSERT INTO `sys_menu` VALUES ('2', '1', '系统菜单', 'base/menu/list.html', null, '1', 'fa fa-th-list', '1', '2017-08-09 22:55:15', '2017-08-17 10:00:12');
INSERT INTO `sys_menu` VALUES ('3', '0', '组织机构', null, null, '0', 'fa fa-desktop', '1', '2017-08-09 23:06:55', '2017-08-17 09:54:28');
INSERT INTO `sys_menu` VALUES ('4', '1', '通用字典', 'base/macro/list.html', null, '1', 'fa fa-book', '2', '2017-08-09 23:06:58', '2017-08-17 10:00:24');
INSERT INTO `sys_menu` VALUES ('6', '3', '用户管理', 'base/user/list.html', '', '1', 'fa fa-user', '2', '2017-08-10 14:12:11', '2017-09-05 12:57:42');
INSERT INTO `sys_menu` VALUES ('7', '3', '角色管理', 'base/role/list.html', '', '1', 'fa fa-paw', '1', '2017-08-10 14:13:19', '2017-09-05 12:57:30');
INSERT INTO `sys_menu` VALUES ('11', '6', '刷新', '/sys/user/list', 'sys:user:list', '2', null, '0', '2017-08-14 10:51:05', '2017-09-05 12:47:23');
INSERT INTO `sys_menu` VALUES ('12', '6', '新增', '/sys/user/save', 'sys:user:save', '2', null, '0', '2017-08-14 10:51:35', '2017-09-05 12:47:34');
INSERT INTO `sys_menu` VALUES ('13', '6', '编辑', '/sys/user/update', 'sys:user:edit', '2', null, '0', '2017-08-14 10:52:06', '2017-09-05 12:47:46');
INSERT INTO `sys_menu` VALUES ('14', '6', '删除', '/sys/user/remove', 'sys:user:remove', '2', null, '0', '2017-08-14 10:52:24', '2017-09-05 12:48:03');
INSERT INTO `sys_menu` VALUES ('15', '7', '刷新', '/sys/role/list', 'sys:role:list', '2', null, '0', '2017-08-14 10:56:37', '2017-09-05 12:44:04');
INSERT INTO `sys_menu` VALUES ('16', '7', '新增', '/sys/role/save', 'sys:role:save', '2', null, '0', '2017-08-14 10:57:02', '2017-09-05 12:44:23');
INSERT INTO `sys_menu` VALUES ('17', '7', '编辑', '/sys/role/update', 'sys:role:edit', '2', null, '0', '2017-08-14 10:57:31', '2017-09-05 12:44:48');
INSERT INTO `sys_menu` VALUES ('18', '7', '删除', '/sys/role/remove', 'sys:role:remove', '2', null, '0', '2017-08-14 10:57:50', '2017-09-05 12:45:02');
INSERT INTO `sys_menu` VALUES ('19', '7', '操作权限', '/sys/role/authorize/opt', 'sys:role:authorizeOpt', '2', null, '0', '2017-08-14 10:58:55', '2017-09-05 12:45:29');
INSERT INTO `sys_menu` VALUES ('20', '2', '刷新', '/sys/menu/list', 'sys:menu:list', '2', null, '0', '2017-08-14 10:59:32', '2017-09-05 13:06:24');
INSERT INTO `sys_menu` VALUES ('21', '2', '新增', '/sys/menu/save', 'sys:menu:save', '2', null, '0', '2017-08-14 10:59:56', '2017-09-05 13:06:35');
INSERT INTO `sys_menu` VALUES ('22', '2', '编辑', '/sys/menu/update', 'sys:menu:edit', '2', null, '0', '2017-08-14 11:00:26', '2017-09-05 13:06:48');
INSERT INTO `sys_menu` VALUES ('23', '2', '删除', '/sys/menu/remove', 'sys:menu:remove', '2', null, '0', '2017-08-14 11:00:58', '2017-09-05 13:07:00');
INSERT INTO `sys_menu` VALUES ('24', '6', '启用', '/sys/user/enable', 'sys:user:enable', '2', null, '0', '2017-08-14 17:27:18', '2017-09-05 12:48:30');
INSERT INTO `sys_menu` VALUES ('25', '6', '停用', '/sys/user/disable', 'sys:user:disable', '2', null, '0', '2017-08-14 17:27:43', '2017-09-05 12:48:49');
INSERT INTO `sys_menu` VALUES ('26', '6', '重置密码', '/sys/user/rest', 'sys:user:resetPassword', '2', null, '0', '2017-08-14 17:28:34', '2017-09-05 12:49:17');
INSERT INTO `sys_menu` VALUES ('27', '1', '系统日志', 'base/log/list.html', null, '1', 'fa fa-warning', '3', '2017-08-14 22:11:53', '2017-08-17 09:55:19');
INSERT INTO `sys_menu` VALUES ('28', '27', '刷新', '/sys/log/list', 'sys:log:list', '2', null, '0', '2017-08-14 22:30:22', '2017-09-05 13:05:24');
INSERT INTO `sys_menu` VALUES ('29', '27', '删除', '/sys/log/remove', 'sys:log:remove', '2', null, '0', '2017-08-14 22:30:43', '2017-09-05 13:05:37');
INSERT INTO `sys_menu` VALUES ('30', '27', '清空', '/sys/log/clear', 'sys:log:clear', '2', null, '0', '2017-08-14 22:31:02', '2017-09-05 13:05:53');
INSERT INTO `sys_menu` VALUES ('32', '4', '刷新', '/sys/macro/list', 'sys:macro:list', '2', null, '0', '2017-08-15 16:55:33', '2017-09-05 13:04:00');
INSERT INTO `sys_menu` VALUES ('33', '4', '新增', '/sys/macro/save', 'sys:macro:save', '2', null, '0', '2017-08-15 16:55:52', '2017-09-05 13:04:22');
INSERT INTO `sys_menu` VALUES ('34', '4', '编辑', '/sys/macro/update', 'sys:macro:edit', '2', null, '0', '2017-08-15 16:56:09', '2017-09-05 13:04:36');
INSERT INTO `sys_menu` VALUES ('35', '4', '删除', '/sys/macro/remove', 'sys:macro:remove', '2', null, '0', '2017-08-15 16:56:29', '2017-09-05 13:04:49');
INSERT INTO `sys_menu` VALUES ('36', '3', '机构管理', 'base/org/list.html', '', '1', 'fa fa-sitemap', '0', '2017-08-17 09:57:14', '2017-09-05 12:58:53');
INSERT INTO `sys_menu` VALUES ('37', '1', '行政区域', 'base/area/list.html', 'sys:area:list', '1', 'fa fa-leaf', '0', '2017-08-17 09:59:57', '2017-09-05 12:49:47');
INSERT INTO `sys_menu` VALUES ('38', '37', '刷新', '/sys/area/list', 'sys:area:list', '2', null, '0', '2017-08-17 10:01:33', '2017-09-05 13:00:54');
INSERT INTO `sys_menu` VALUES ('39', '37', '新增', '/sys/area/save', 'sys:area:save', '2', null, '0', '2017-08-17 10:02:16', '2017-09-05 13:01:06');
INSERT INTO `sys_menu` VALUES ('40', '37', '编辑', '/sys/area/update', 'sys:area:edit', '2', null, '0', '2017-08-17 10:02:33', '2017-09-05 13:01:21');
INSERT INTO `sys_menu` VALUES ('41', '37', '删除', '/sys/area/remove', 'sys:area:remove', '2', null, '0', '2017-08-17 10:02:50', '2017-09-05 13:01:32');
INSERT INTO `sys_menu` VALUES ('42', '36', '刷新', '/sys/org/list', 'sys:org:list', '2', null, '0', '2017-08-17 10:03:36', '2017-09-05 11:47:37');
INSERT INTO `sys_menu` VALUES ('43', '36', '新增', '/sys/org/save', 'sys:org:save', '2', null, '0', '2017-08-17 10:03:54', '2017-09-05 12:40:55');
INSERT INTO `sys_menu` VALUES ('44', '36', '编辑', '/sys/org/update', 'sys:org:edit', '2', null, '0', '2017-08-17 10:04:11', '2017-09-05 12:43:06');
INSERT INTO `sys_menu` VALUES ('45', '36', '删除', '/sys/org/remove', 'sys:org:remove', '2', null, '0', '2017-08-17 10:04:30', '2017-09-05 12:42:19');
INSERT INTO `sys_menu` VALUES ('46', '7', '数据权限', '/sys/role/authorize/data', 'sys:role:authorizeData', '2', null, '0', '2017-08-17 13:48:11', '2017-09-05 12:45:54');
INSERT INTO `sys_menu` VALUES ('47', '1', '定时任务', 'base/quartz/list.html', null, '1', 'fa fa-bell', '4', '2017-08-19 23:00:08', null);
INSERT INTO `sys_menu` VALUES ('48', '47', '刷新', '/quartz/job/list', 'quartz:job:list', '2', null, '0', '2017-08-19 23:00:54', '2017-09-05 13:08:18');
INSERT INTO `sys_menu` VALUES ('49', '47', '新增', '/quartz/job/save', 'quartz:job:save', '2', null, '0', '2017-08-19 23:01:29', '2017-09-05 13:08:30');
INSERT INTO `sys_menu` VALUES ('50', '47', '编辑', '/quartz/job/update', 'quartz:job:edit', '2', null, '0', '2017-08-19 23:01:58', '2017-09-05 13:08:44');
INSERT INTO `sys_menu` VALUES ('51', '47', '删除', '/quartz/job/remove', 'quartz:job:remove', '2', null, '0', '2017-08-19 23:02:30', '2017-09-05 13:08:57');
INSERT INTO `sys_menu` VALUES ('52', '63', '启用', '/quartz/job/enable', 'quartz:job:enable', '2', null, '0', '2017-08-19 23:08:59', '2017-09-13 22:12:35');
INSERT INTO `sys_menu` VALUES ('53', '63', '停用', '/quartz/job/disable', 'quartz:job:disable', '2', null, '0', '2017-08-19 23:09:31', '2017-09-13 22:12:53');
INSERT INTO `sys_menu` VALUES ('54', '63', '立即执行', '/quartz/job/run', 'quartz:job:run', '2', null, '0', '2017-08-19 23:10:09', '2017-09-13 22:13:11');
INSERT INTO `sys_menu` VALUES ('55', '47', '日志列表', null, 'quartz:job:log', '1', null, '0', '2017-08-19 23:10:40', '2017-09-13 22:21:12');
INSERT INTO `sys_menu` VALUES ('56', '55', '刷新', '/quartz/job/log/list', 'quartz:log:list', '2', null, '0', '2017-08-21 13:25:33', '2017-09-13 22:21:27');
INSERT INTO `sys_menu` VALUES ('57', '55', '删除', '/quartz/job/log/remove', 'quartz:log:remove', '2', null, '0', '2017-08-21 13:25:52', '2017-09-13 22:21:46');
INSERT INTO `sys_menu` VALUES ('58', '55', '清空', '/quartz/job/log/clear', 'quartz:log:clear', '2', null, '0', '2017-08-21 13:26:11', '2017-09-13 22:22:04');
INSERT INTO `sys_menu` VALUES ('59', '1', '敏捷开发', 'base/generator/list.html', null, '1', 'fa fa-archive', '5', '2017-09-05 10:49:04', null);
INSERT INTO `sys_menu` VALUES ('60', '59', '刷新', '/sys/generator/list', 'sys:gen:list', '2', null, '0', '2017-09-05 10:49:25', '2017-09-05 13:07:33');
INSERT INTO `sys_menu` VALUES ('61', '59', '生成代码', '/sys/generator/code', 'sys:gen:code', '2', null, '0', '2017-09-05 10:49:44', '2017-09-05 13:07:48');
INSERT INTO `sys_menu` VALUES ('62', '1', '系统监控', 'druid/index.html', null, '1', 'fa fa-bug', '6', '2017-09-10 17:01:59', '2017-09-10 17:02:19');
INSERT INTO `sys_menu` VALUES ('63', '47', '更多', null, 'quartz:job:more', '1', null, '0', '2017-09-13 22:11:51', '2017-09-13 22:12:12');
INSERT INTO `sys_menu` VALUES ('64', '1', '接口管理', 'swagger-ui.html', null, '1', 'fa fa-support', '7', '2017-09-10 17:01:59', '2017-09-10 17:02:19');
INSERT INTO `sys_menu` VALUES ('66', '0', '交易', null, null, '0', 'fa fa-circle-o', '2', '2020-08-09 21:02:33', '2020-08-09 21:25:28');
INSERT INTO `sys_menu` VALUES ('67', '66', '代付订单', 'modules/billOut/list.html', null, '1', 'fa fa-circle-o', '1', '2020-08-09 21:03:34', '2020-08-13 01:50:36');
INSERT INTO `sys_menu` VALUES ('68', '66', '商户充值', 'modules/billIn/list.html', null, '1', 'fa fa-circle-o', '0', '2020-08-09 21:06:24', '2020-08-24 16:20:54');
INSERT INTO `sys_menu` VALUES ('69', '66', '资金调度', 'modules/procurement/list.html', null, '1', 'fa fa-circle-o', '4', '2020-08-09 21:07:06', '2020-08-20 23:45:18');
INSERT INTO `sys_menu` VALUES ('70', '66', '商户冻结', null, null, '1', 'fa fa-circle-o', '3', '2020-08-09 21:07:33', '2020-08-09 21:24:24');
INSERT INTO `sys_menu` VALUES ('71', '0', '银行卡管理', null, null, '0', 'fa fa-circle-o', '3', '2020-08-09 21:08:51', '2020-08-09 21:25:51');
INSERT INTO `sys_menu` VALUES ('72', '71', '专员付款卡', 'modules/bankCard/list.html', null, '1', 'fa fa-circle-o', '0', '2020-08-09 21:09:17', '2020-08-19 21:12:40');
INSERT INTO `sys_menu` VALUES ('74', '0', '报表', null, null, '0', 'fa fa-circle-o', '4', '2020-08-09 21:12:45', '2020-08-09 21:26:04');
INSERT INTO `sys_menu` VALUES ('75', '74', '代付日报表', null, null, '1', 'fa fa-circle-o', '0', '2020-08-09 21:14:00', null);
INSERT INTO `sys_menu` VALUES ('76', '74', '专员付款日报表', null, null, '1', 'fa fa-circle-o', '1', '2020-08-09 21:16:40', '2020-08-09 21:28:30');
INSERT INTO `sys_menu` VALUES ('77', '0', '历史数据', null, null, '0', 'fa fa-circle-o', '5', '2020-08-09 21:17:50', '2020-08-09 21:26:17');
INSERT INTO `sys_menu` VALUES ('78', '3', '在线成员', 'modules/onlineBusiness/list.html', null, '1', 'fa fa-circle-o', '3', '2020-08-09 21:19:34', '2020-08-19 17:10:13');
INSERT INTO `sys_menu` VALUES ('79', '66', '商户管理', null, null, '1', 'fa fa-circle-o', '2', '2020-08-09 21:22:01', '2020-08-09 21:24:09');
INSERT INTO `sys_menu` VALUES ('80', '67', '刷新', '/apiV1/billOut/list', 'apiV1:billOut:list', '2', 'fa fa-circle-o', '0', '2020-08-13 01:51:23', '2020-08-13 01:51:53');
INSERT INTO `sys_menu` VALUES ('81', '67', '成功', '/apiV1/billOut/bill/success', 'apiV1:billOut:success', '2', 'fa fa-circle-o', '1', '2020-08-13 02:06:18', null);
INSERT INTO `sys_menu` VALUES ('82', '67', '失败', '/apiV1/billOut/bill/failed', 'apiV1:billOut:failed', '2', 'fa fa-circle-o', '2', null, null);
INSERT INTO `sys_menu` VALUES ('83', '67', '回退', '/apiV1/billOut//bill/goBackOrg', 'apiV1:billOut:goBack', '2', 'fa fa-circle-o', '3', null, null);
INSERT INTO `sys_menu` VALUES ('84', '67', '指定', '/apiV1/billOut/appoint/human', 'apiV1:billOut:appoint:people', '2', 'fa fa-circle-o', '4', null, null);
INSERT INTO `sys_menu` VALUES ('85', '67', '自动开关', '/apiV1/billOut/appoint/auto', 'apiV1:billOut:appoint:auto', '2', 'fa fa-circle-o', '5', null, null);
INSERT INTO `sys_menu` VALUES ('86', '67', '派单', '/apiV1/billOut/push/order', 'apiV1:billOut:save', '2', 'fa fa-circle-o', '6', null, null);
INSERT INTO `sys_menu` VALUES ('87', '78', '刷新', null, 'apiV1:onlineBusiness:list', '2', 'fa fa-circle-o', '0', '2020-08-19 17:11:24', null);
INSERT INTO `sys_menu` VALUES ('88', '78', '禁用', null, 'apiV1:onlineBusiness:enable', '2', 'fa fa-circle-o', '0', '2020-08-19 17:12:01', null);
INSERT INTO `sys_menu` VALUES ('89', '72', '刷新', null, 'bankCard:list', '2', 'fa fa-circle-o', '0', '2020-08-19 21:13:55', '2020-08-19 21:14:06');
INSERT INTO `sys_menu` VALUES ('90', '72', '启用', null, 'bankCard:enable', '2', 'fa fa-circle-o', '0', '2020-08-19 21:15:01', null);
INSERT INTO `sys_menu` VALUES ('91', '72', '禁用', null, 'bankCard:disable', '2', 'fa fa-circle-o', '0', '2020-08-19 21:15:34', null);
INSERT INTO `sys_menu` VALUES ('92', '72', '删除', null, 'bankCard:remove', '2', 'fa fa-circle-o', '0', '2020-08-19 21:16:02', null);
INSERT INTO `sys_menu` VALUES ('93', '72', '增加', null, 'bankCard:save', '2', 'fa fa-circle-o', '0', '2020-08-19 21:16:35', null);
INSERT INTO `sys_menu` VALUES ('94', '66', '增加', null, 'procurement:save', '8', 'fa fa-circle-o', null, null, null);
INSERT INTO `sys_menu` VALUES ('95', '66', '增加：代理', null, 'procurement:save:agent', '8', 'fa fa-circle-o', null, null, null);
INSERT INTO `sys_menu` VALUES ('96', '66', '刷新', null, 'procurement:list', '8', 'fa fa-circle-o', null, null, null);
INSERT INTO `sys_menu` VALUES ('97', '68', '刷新', null, 'merchant:charge:list', '2', 'fa fa-circle-o', '0', '2020-08-24 16:22:35', null);
INSERT INTO `sys_menu` VALUES ('98', '68', '添加充值订单', null, 'merchant:charge:success', '2', 'fa fa-circle-o', '0', '2020-08-24 16:23:07', null);
INSERT INTO `sys_menu` VALUES ('99', '68', '确认充值成功', null, 'merchant:charge:save', '2', 'fa fa-circle-o', '0', '2020-08-24 16:24:37', null);
INSERT INTO `sys_menu` VALUES ('100', '68', '确认充值失败', null, 'merchant:charge:fail', '2', 'fa fa-circle-o', '0', '2020-08-24 16:25:25', null);

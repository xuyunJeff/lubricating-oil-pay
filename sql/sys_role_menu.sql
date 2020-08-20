/*
Navicat MySQL Data Transfer

Source Server         : LocalHost
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : bottle_pay

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-08-20 16:54:13
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `menu_id` bigint(20) DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8 COMMENT='角色与菜单对应关系';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1', '1', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '1', '2');
INSERT INTO `sys_role_menu` VALUES ('3', '1', '4');
INSERT INTO `sys_role_menu` VALUES ('4', '1', '3');
INSERT INTO `sys_role_menu` VALUES ('5', '1', '6');
INSERT INTO `sys_role_menu` VALUES ('6', '1', '7');
INSERT INTO `sys_role_menu` VALUES ('7', '1', '11');
INSERT INTO `sys_role_menu` VALUES ('8', '1', '12');
INSERT INTO `sys_role_menu` VALUES ('9', '1', '13');
INSERT INTO `sys_role_menu` VALUES ('10', '1', '14');
INSERT INTO `sys_role_menu` VALUES ('11', '1', '15');
INSERT INTO `sys_role_menu` VALUES ('12', '1', '16');
INSERT INTO `sys_role_menu` VALUES ('13', '1', '17');
INSERT INTO `sys_role_menu` VALUES ('14', '1', '18');
INSERT INTO `sys_role_menu` VALUES ('15', '1', '19');
INSERT INTO `sys_role_menu` VALUES ('16', '1', '20');
INSERT INTO `sys_role_menu` VALUES ('17', '1', '21');
INSERT INTO `sys_role_menu` VALUES ('18', '1', '22');
INSERT INTO `sys_role_menu` VALUES ('19', '1', '23');
INSERT INTO `sys_role_menu` VALUES ('20', '1', '24');
INSERT INTO `sys_role_menu` VALUES ('21', '1', '25');
INSERT INTO `sys_role_menu` VALUES ('22', '1', '26');
INSERT INTO `sys_role_menu` VALUES ('23', '1', '27');
INSERT INTO `sys_role_menu` VALUES ('24', '1', '28');
INSERT INTO `sys_role_menu` VALUES ('25', '1', '29');
INSERT INTO `sys_role_menu` VALUES ('26', '1', '30');
INSERT INTO `sys_role_menu` VALUES ('27', '1', '32');
INSERT INTO `sys_role_menu` VALUES ('28', '1', '33');
INSERT INTO `sys_role_menu` VALUES ('29', '1', '34');
INSERT INTO `sys_role_menu` VALUES ('30', '1', '35');
INSERT INTO `sys_role_menu` VALUES ('31', '1', '36');
INSERT INTO `sys_role_menu` VALUES ('32', '1', '37');
INSERT INTO `sys_role_menu` VALUES ('33', '1', '38');
INSERT INTO `sys_role_menu` VALUES ('34', '1', '39');
INSERT INTO `sys_role_menu` VALUES ('35', '1', '40');
INSERT INTO `sys_role_menu` VALUES ('36', '1', '41');
INSERT INTO `sys_role_menu` VALUES ('37', '1', '42');
INSERT INTO `sys_role_menu` VALUES ('38', '1', '43');
INSERT INTO `sys_role_menu` VALUES ('39', '1', '44');
INSERT INTO `sys_role_menu` VALUES ('40', '1', '45');
INSERT INTO `sys_role_menu` VALUES ('41', '1', '46');
INSERT INTO `sys_role_menu` VALUES ('42', '1', '47');
INSERT INTO `sys_role_menu` VALUES ('43', '1', '48');
INSERT INTO `sys_role_menu` VALUES ('44', '1', '49');
INSERT INTO `sys_role_menu` VALUES ('45', '1', '50');
INSERT INTO `sys_role_menu` VALUES ('46', '1', '51');
INSERT INTO `sys_role_menu` VALUES ('47', '1', '55');
INSERT INTO `sys_role_menu` VALUES ('48', '1', '56');
INSERT INTO `sys_role_menu` VALUES ('49', '1', '57');
INSERT INTO `sys_role_menu` VALUES ('50', '1', '58');
INSERT INTO `sys_role_menu` VALUES ('51', '1', '63');
INSERT INTO `sys_role_menu` VALUES ('52', '1', '52');
INSERT INTO `sys_role_menu` VALUES ('53', '1', '53');
INSERT INTO `sys_role_menu` VALUES ('54', '1', '54');
INSERT INTO `sys_role_menu` VALUES ('55', '1', '59');
INSERT INTO `sys_role_menu` VALUES ('56', '1', '60');
INSERT INTO `sys_role_menu` VALUES ('57', '1', '61');
INSERT INTO `sys_role_menu` VALUES ('58', '1', '62');
INSERT INTO `sys_role_menu` VALUES ('59', '1', '64');
INSERT INTO `sys_role_menu` VALUES ('120', '1', '66');
INSERT INTO `sys_role_menu` VALUES ('122', '1', '67');
INSERT INTO `sys_role_menu` VALUES ('123', '1', '68');
INSERT INTO `sys_role_menu` VALUES ('124', '1', '69');
INSERT INTO `sys_role_menu` VALUES ('125', '1', '70');
INSERT INTO `sys_role_menu` VALUES ('126', '1', '71');
INSERT INTO `sys_role_menu` VALUES ('127', '1', '72');
INSERT INTO `sys_role_menu` VALUES ('128', '1', '73');
INSERT INTO `sys_role_menu` VALUES ('129', '1', '74');
INSERT INTO `sys_role_menu` VALUES ('130', '1', '75');
INSERT INTO `sys_role_menu` VALUES ('131', '1', '76');
INSERT INTO `sys_role_menu` VALUES ('132', '1', '77');
INSERT INTO `sys_role_menu` VALUES ('133', '1', '78');
INSERT INTO `sys_role_menu` VALUES ('134', '1', '79');
INSERT INTO `sys_role_menu` VALUES ('135', '1', '80');
INSERT INTO `sys_role_menu` VALUES ('136', '1', '81');
INSERT INTO `sys_role_menu` VALUES ('137', '1', '82');
INSERT INTO `sys_role_menu` VALUES ('138', '1', '83');
INSERT INTO `sys_role_menu` VALUES ('139', '1', '84');
INSERT INTO `sys_role_menu` VALUES ('140', '1', '85');
INSERT INTO `sys_role_menu` VALUES ('141', '1', '86');
INSERT INTO `sys_role_menu` VALUES ('142', '2', '67');
INSERT INTO `sys_role_menu` VALUES ('143', '2', '80');
INSERT INTO `sys_role_menu` VALUES ('144', '2', '81');
INSERT INTO `sys_role_menu` VALUES ('145', '2', '82');
INSERT INTO `sys_role_menu` VALUES ('146', '2', '83');
INSERT INTO `sys_role_menu` VALUES ('150', '2', '67');
INSERT INTO `sys_role_menu` VALUES ('151', '2', '66');
INSERT INTO `sys_role_menu` VALUES ('154', '2', '76');
INSERT INTO `sys_role_menu` VALUES ('155', '2', '3');
INSERT INTO `sys_role_menu` VALUES ('156', '2', '78');
INSERT INTO `sys_role_menu` VALUES ('157', '1', '87');
INSERT INTO `sys_role_menu` VALUES ('158', '1', '88');
INSERT INTO `sys_role_menu` VALUES ('159', '1', '89');
INSERT INTO `sys_role_menu` VALUES ('160', '1', '90');
INSERT INTO `sys_role_menu` VALUES ('161', '1', '91');
INSERT INTO `sys_role_menu` VALUES ('162', '1', '92');
INSERT INTO `sys_role_menu` VALUES ('163', '1', '93');

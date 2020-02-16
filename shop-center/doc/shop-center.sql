/*
 Navicat Premium Data Transfer

 Source Server         : 本地mysql
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : shop_center

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 16/02/2020 17:16:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods_classify
-- ----------------------------
DROP TABLE IF EXISTS `goods_classify`;
CREATE TABLE `goods_classify`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `classify_code` int(11) NOT NULL DEFAULT 0 COMMENT '分类编号',
  `classify_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for goods_info
-- ----------------------------
DROP TABLE IF EXISTS `goods_info`;
CREATE TABLE `goods_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品详情地址',
  `goods_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品预览图片地址',
  `goods_describe` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品描述',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_info
-- ----------------------------
INSERT INTO `goods_info` VALUES (1, '测试啤酒', '111', '111', '111', '2019-10-11 17:39:47', '2019-10-11 17:39:47');
INSERT INTO `goods_info` VALUES (2, '啤酒', 'http://11123.png', 'http://123.png', '一瓶好酒', '2019-10-12 10:47:05', '2019-10-12 10:47:05');

-- ----------------------------
-- Table structure for goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `goods_sku`;
CREATE TABLE `goods_sku`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '商品ID',
  `origin_price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT '原有价格',
  `price` decimal(12, 2) NOT NULL DEFAULT 0.00 COMMENT 'sku价格',
  `amount` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '数量',
  `unit` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '单位：斤、桶等',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品sku表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for goods_stock
-- ----------------------------
DROP TABLE IF EXISTS `goods_stock`;
CREATE TABLE `goods_stock`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_id` int(11) NOT NULL DEFAULT 0 COMMENT '商品编号',
  `sku_id` int(11) NOT NULL DEFAULT 0 COMMENT 'sku编号',
  `total_amount` int(11) NOT NULL DEFAULT 0 COMMENT '总数量',
  `surplus_amount` int(11) NOT NULL DEFAULT 0 COMMENT '剩余数量',
  `used_amount` int(11) NOT NULL DEFAULT 0 COMMENT '已购买数量',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品sku库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for member_info
-- ----------------------------
DROP TABLE IF EXISTS `member_info`;
CREATE TABLE `member_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `wechat_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '微信昵称',
  `wechat_no` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '微信编号',
  `avatar_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '微信头像地址',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户密码',
  `salt` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码盐值',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_time`(`create_time`) USING BTREE COMMENT '创建时间索引'
) ENGINE = InnoDB AUTO_INCREMENT = 10001 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_info
-- ----------------------------
INSERT INTO `member_info` VALUES (10000, '111', '11', '11', '11', '11', '11', '2019-10-08 10:25:58', '2019-10-08 10:25:58');

-- ----------------------------
-- Table structure for platform_authority
-- ----------------------------
DROP TABLE IF EXISTS `platform_authority`;
CREATE TABLE `platform_authority`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限名称',
  `path` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限菜单路径',
  `icon` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父权限ID，如果为父权限，则为空',
  `valid` tinyint(4) NULL DEFAULT NULL COMMENT '是否有效 0：无效 1：有效',
  `sort_id` tinyint(4) NULL DEFAULT NULL,
  `gmt_create` timestamp(0) NULL DEFAULT NULL,
  `gmt_modified` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of platform_authority
-- ----------------------------
INSERT INTO `platform_authority` VALUES (1, '设备管理', '/device', 'iconfont  icon-shebeipeizhi', 0, 1, 1, '2018-07-17 22:46:59', '2018-07-17 22:47:02');
INSERT INTO `platform_authority` VALUES (2, '已注册设备', '/device/device_register', 'iconfont  icon-devices-other', 1, 1, 2, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (3, '未注册设备', '/device/device_unregister', 'iconfont  icon-ic_devices', 1, 1, 3, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (4, '通道管理', '/device/channel_manage', 'iconfont  icon-shebei', 1, 1, 4, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (5, '平台信息', '/manage_info', 'iconfont  icon-Info', 0, 1, 5, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (6, '配置管理', '/manage_info/configure', 'iconfont  icon-icon_compile', 5, 1, 6, '2018-07-17 22:47:59', '2018-07-17 22:48:02');
INSERT INTO `platform_authority` VALUES (7, '状态显示', '/manage_info/state_display', 'iconfont  icon-icon-', 5, 1, 7, '2018-07-17 23:36:40', '2018-07-17 23:36:44');
INSERT INTO `platform_authority` VALUES (8, '视频预览', '/video_preview', 'iconfont  icon-video', 0, 1, 8, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (9, '电子地图', '/video_preview/map_model', 'iconfont  icon-map', 8, 1, 9, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (10, '电视墙', '/video_preview/wall_model', 'iconfont  icon-icon_live', 8, 1, 10, '2018-07-21 22:23:40', '2018-07-21 22:23:43');
INSERT INTO `platform_authority` VALUES (80, '用户管理', '/user_manage', 'iconfont icon-personnel', 0, 1, 80, '2018-05-10 21:52:54', '2018-05-11 00:10:08');
INSERT INTO `platform_authority` VALUES (81, '用户管理', '/user_manage/user', 'iconfont icon-emaxcitygerenxinxitubiaoji01', 80, 1, 81, '2018-05-10 21:53:41', '2018-05-10 21:53:43');
INSERT INTO `platform_authority` VALUES (82, '角色管理', '/user_manage/role', 'iconfont icon-add-person-o', 80, 1, 82, '2018-05-10 21:54:07', '2018-05-10 21:54:11');
INSERT INTO `platform_authority` VALUES (83, '权限管理', '/user_manage/authority', 'iconfont  icon-icon-', 80, 1, 83, '2018-05-10 21:54:42', '2018-05-10 21:54:45');

-- ----------------------------
-- Table structure for platform_role
-- ----------------------------
DROP TABLE IF EXISTS `platform_role`;
CREATE TABLE `platform_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `menu_ids` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单树，以 \',\' 隔开',
  `valid` tinyint(4) NULL DEFAULT NULL COMMENT '是否有效',
  `gmt_create` timestamp(0) NULL DEFAULT NULL,
  `gmt_modified` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of platform_role
-- ----------------------------
INSERT INTO `platform_role` VALUES (1, '管理员', '管理员', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,40,41,42,43,50,51,52,53,54,55,56,57,58,59,60,61,62,80,81,82,83', 1, '2018-05-10 21:59:06', '2019-05-16 14:01:55');
INSERT INTO `platform_role` VALUES (2, '用户管理员', '用户管理员', '80,81,82,83', 1, '2018-05-10 22:00:03', '2018-09-05 00:02:32');
INSERT INTO `platform_role` VALUES (3, '设备管理角色', '用于管理设备', '1,2,3', 1, '2018-05-13 21:45:59', '2018-05-13 21:45:59');

-- ----------------------------
-- Table structure for platform_user
-- ----------------------------
DROP TABLE IF EXISTS `platform_user`;
CREATE TABLE `platform_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `nickname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `sex` tinyint(4) NULL DEFAULT NULL COMMENT '性别 0：男 1：女',
  `telephone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '座机号',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工描述',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录密码',
  `salt` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '盐值',
  `token` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `role_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色ID',
  `valid` tinyint(4) NULL DEFAULT NULL,
  `gmt_create` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `IDX_NAME`(`name`) USING BTREE COMMENT '员工名称'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of platform_user
-- ----------------------------
INSERT INTO `platform_user` VALUES (2, '邱伟1', 'pein1', 0, '23234234', '23423423@qq.coom', 'asdfasdf', '3b21d3a4e72266f3f84a8be4a4f0a4e2', 'ce7c0f84ba8046129eada00e3e31fcf5', '38a9369c237644cfa6b1496b6797e2a9', NULL, NULL, '2018-04-07 21:28:33', '2018-05-13 22:51:07');
INSERT INTO `platform_user` VALUES (3, '邱伟', 'pein', 0, '18500000000', '23423423@qq.coom', 'asdfasdf', '4571ae428db7039bca6b44f3f85a06e5', 'e19e32ee39564070a3dba73f82a65470', '567afef21a954f88a123790e030d220e', '2,3,1', 1, '2018-04-08 16:20:26', '2019-06-20 19:56:24');
INSERT INTO `platform_user` VALUES (4, '邱伟3', 'pein', 0, '23234234', '23423423@qq.coom', 'asdfasdf', '3c1ee14270800d63c798af7aa3deaead', '65bb1c5df36b45d78848b6f3bbee28cc', NULL, NULL, NULL, '2018-04-12 23:12:06', '2018-04-12 23:15:19');
INSERT INTO `platform_user` VALUES (5, 'admin', NULL, NULL, '', NULL, '默认超级管理员', '2b08fbba9f85b4cf49b7d2809b665f9b', '9e03d140ce174104b3f6fcf8d530c312', '7dd8fbbb4f904296bf0d32be2bf1381e', '1', 1, '2018-06-05 23:03:09', '2018-12-11 22:59:14');
INSERT INTO `platform_user` VALUES (6, 'aaa', NULL, NULL, '1123', NULL, '123123', '1eddb467bc891291926de9bbe622d619', 'ac15533dee5c46ec96609f00492be492', '31677f86724441c6adebe62f190c05b1', '1', 1, '2019-03-17 23:42:23', '2019-03-17 23:42:43');

SET FOREIGN_KEY_CHECKS = 1;

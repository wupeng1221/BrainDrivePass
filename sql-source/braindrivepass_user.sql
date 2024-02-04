/*
 Navicat MySQL Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80100
 Source Host           : localhost:3306
 Source Schema         : braindrivepass_user

 Target Server Type    : MySQL
 Target Server Version : 80100
 File Encoding         : 65001

 Date: 02/02/2024 04:26:01
*/

CREATE DATABASE IF NOT EXISTS braindrivepass_user;
USE braindrivepass_user;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL COMMENT '用户id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录邮箱',
  `password` varchar(64) NOT NULL COMMENT '密码密文',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
  `create_time` datetime DEFAULT (now()) COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES (1737093794300772353, 'test@wp.com', '6e04f2ad989b5384320e6355b61b607810f9049ba1e2cbb066c840432d3b7865', '13345678910', '2023-12-19 20:53:29', '2023-12-19 20:53:29');
INSERT INTO `user` VALUES (1753045242930884609, '1483238059@qq.com', '6e04f2ad989b5384320e6355b61b607810f9049ba1e2cbb066c840432d3b7865', '18992562785', '2024-02-01 21:18:51', '2024-02-01 21:18:51');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: 117.72.126.104    Database: ry-vue
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务组名',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2025-08-27 00:49:58','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2025-08-27 00:49:59','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2025-08-27 00:49:59','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','false','Y','admin','2025-08-27 00:49:59','ry','2025-08-27 18:25:34','是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2025-08-27 00:49:59','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2025-08-27 00:49:59','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2025-08-27 00:49:59','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2025-08-27 00:49:59','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_course_assignment`
--

DROP TABLE IF EXISTS `sys_course_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_course_assignment` (
  `assignment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '作业ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `assignment_title` varchar(200) NOT NULL COMMENT '作业标题',
  `assignment_describe` varchar(1000) DEFAULT NULL COMMENT '作业描述',
  `deadline` datetime DEFAULT NULL COMMENT '截止时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志(0存在,2删除)',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `dept_id` bigint NOT NULL COMMENT '班级ID',
  PRIMARY KEY (`assignment_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程作业表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_course_assignment`
--

LOCK TABLES `sys_course_assignment` WRITE;
/*!40000 ALTER TABLE `sys_course_assignment` DISABLE KEYS */;
INSERT INTO `sys_course_assignment` VALUES (17,13,'1012作业','请完成作业',NULL,'2025-10-12 16:21:26','2025-10-31 00:00:00','0',NULL,'2025-10-12 16:21:30','','2025-10-12 16:21:30',NULL,100);
/*!40000 ALTER TABLE `sys_course_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_course_assignment_submission`
--

DROP TABLE IF EXISTS `sys_course_assignment_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_course_assignment_submission` (
  `submission_id` bigint NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `assignment_id` bigint NOT NULL COMMENT '作业ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `file_name` varchar(255) DEFAULT NULL COMMENT '文件名',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件路径',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志(0存在,2删除)',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint NOT NULL COMMENT '班级ID',
  PRIMARY KEY (`submission_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程作业提交表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_course_assignment_submission`
--

LOCK TABLES `sys_course_assignment_submission` WRITE;
/*!40000 ALTER TABLE `sys_course_assignment_submission` DISABLE KEYS */;
INSERT INTO `sys_course_assignment_submission` VALUES (1,4,2,16,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010100630A038.doc','application/msword',120320,NULL,'0',NULL,'2025-09-28 23:46:06','','2025-10-10 10:06:30',120),(2,5,2,16,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-09-29 18:07:22','','2025-09-29 18:07:22',120),(3,6,2,11,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-09 14:13:07','','2025-10-09 14:13:07',100),(4,6,3,11,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-09 14:13:07','','2025-10-09 14:13:07',100),(5,6,4,11,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010103520A046.doc','application/msword',120320,NULL,'0',NULL,'2025-10-09 14:13:07','','2025-10-10 10:35:20',100),(6,7,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-09 14:13:40','','2025-10-09 14:13:40',100),(7,7,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-09 14:13:40','','2025-10-09 14:13:40',100),(8,7,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010100923A039.doc','application/msword',120320,NULL,'0',NULL,'2025-10-09 14:13:40','','2025-10-10 10:09:23',100),(9,8,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:37:36','','2025-10-10 10:37:36',100),(10,8,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:37:36','','2025-10-10 10:37:36',100),(11,8,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010103811A047.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:37:36','','2025-10-10 10:38:11',100),(12,9,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:41:00','','2025-10-10 10:41:00',100),(13,9,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:41:00','','2025-10-10 10:41:00',100),(14,9,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010104134A048.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:41:00','','2025-10-10 10:41:34',100),(15,10,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:41:13','','2025-10-10 10:41:13',100),(16,10,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:41:13','','2025-10-10 10:41:13',100),(17,10,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010104231A049.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:41:13','','2025-10-10 10:42:31',100),(18,11,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:44:45','','2025-10-10 10:44:45',100),(19,11,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:44:45','','2025-10-10 10:44:45',100),(20,11,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010104521A050.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:44:45','','2025-10-10 10:45:21',100),(21,12,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:44:59','','2025-10-10 10:44:59',100),(22,12,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:44:59','','2025-10-10 10:44:59',100),(23,12,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010104701A051.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:44:59','','2025-10-10 10:47:01',100),(24,13,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:51:09','','2025-10-10 10:51:09',100),(25,13,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:51:09','','2025-10-10 10:51:09',100),(26,13,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010105144A052.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:51:09','','2025-10-10 10:51:44',100),(27,14,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:51:24','','2025-10-10 10:51:24',100),(28,14,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 10:51:24','','2025-10-10 10:51:24',100),(29,14,4,18,'思想政治情况表.doc','/profile/upload/2025/10/10/思想政治情况表_20251010105202A053.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 10:51:24','','2025-10-10 10:52:02',100),(30,15,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 11:06:43','','2025-10-10 11:06:43',100),(31,15,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-10 11:06:43','','2025-10-10 11:06:43',100),(32,15,4,18,'思想政治情况表.doc','/profile/upload/2025/10/13/思想政治情况表_20251013160600A005.doc','application/msword',120320,NULL,'0',NULL,'2025-10-10 11:06:43','','2025-10-13 16:06:00',100),(33,16,1,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-11 16:01:03','','2025-10-11 16:01:03',100),(34,16,2,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-11 16:01:03','','2025-10-11 16:01:03',100),(35,16,3,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-11 16:01:03','','2025-10-11 16:01:03',100),(36,16,4,18,'思想政治情况表.doc','/profile/upload/2025/10/11/思想政治情况表_20251011160326A002.doc','application/msword',120320,NULL,'0',NULL,'2025-10-11 16:01:03','','2025-10-11 16:03:26',100),(37,16,5,18,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-11 16:01:03','','2025-10-11 16:01:03',100),(38,17,1,13,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-12 16:21:30','','2025-10-12 16:21:30',100),(39,17,2,13,'报名表_局2025年项目负责人政治能力培训班.xlsx','/profile/upload/2025/11/20/思想政治情况表_20251120231046A003.doc','application/msword',120320,NULL,'0',NULL,'2025-10-12 16:21:30','','2025-11-20 23:10:46',100),(40,17,4,13,NULL,NULL,NULL,NULL,NULL,'0',NULL,'2025-10-12 16:21:30','','2025-10-12 16:21:30',100);
/*!40000 ALTER TABLE `sys_course_assignment_submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_course_resource`
--

DROP TABLE IF EXISTS `sys_course_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_course_resource` (
  `resource_id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID（冗余，快速查询）',
  `file_name` varchar(200) NOT NULL COMMENT '原始文件名（展示）',
  `file_path` varchar(500) NOT NULL COMMENT '文件访问路径/URL（如 /profile/upload/....）',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型/后缀，如 pdf,pptx,jpg',
  `file_size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记（0存在 2删除）',
  PRIMARY KEY (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程资源表（PPT/PDF/IMG）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_course_resource`
--

LOCK TABLES `sys_course_resource` WRITE;
/*!40000 ALTER TABLE `sys_course_resource` DISABLE KEYS */;
INSERT INTO `sys_course_resource` VALUES (1,15,103,'test_20250912203900A001.png','http://117.72.126.104:8080/profile/upload/2025/09/12/test_20250912203900A001.png','png',NULL,NULL,'admin','2025-09-12 20:55:59',NULL,'2025-09-20 21:48:09','0'),(5,15,103,'思想政治情况表.doc','http://117.72.126.104:8080/profile/upload/2025/09/20/思想政治情况表_20250920233054A001.doc','doc',120320,NULL,'admin','2025-09-20 23:30:54',NULL,'2025-09-20 23:30:54','0'),(6,15,103,'思想政治情况表.doc','http://117.72.126.104:8080/profile/upload/2025/09/20/思想政治情况表_20250920233056A002.doc','doc',120320,NULL,'admin','2025-09-20 23:30:57',NULL,'2025-09-20 23:30:57','0'),(7,18,104,'思想政治情况表.doc','http://117.72.126.104:8080/profile/upload/2025/09/25/思想政治情况表_20250925172003A007.doc','doc',120320,NULL,'admin','2025-09-25 17:20:04',NULL,'2025-09-25 17:20:04','0'),(8,18,104,'选择导师意向表.docx','http://117.72.126.104:8080/profile/upload/2025/09/25/选择导师意向表_20250925192711A008.docx','docx',23185,NULL,'admin','2025-09-25 19:27:11',NULL,'2025-09-25 19:27:11','0'),(10,18,104,'选择导师意向表.docx','http://117.72.126.104:8080/profile/upload/2025/10/11/选择导师意向表_20251011155410A001.docx','docx',23185,NULL,'manager','2025-10-11 15:54:10',NULL,'2025-10-11 15:54:10','0'),(12,13,117,'选择导师意向表.docx','http://117.72.126.104:8080/profile/upload/2025/10/21/选择导师意向表_20251021190343A001.docx','docx',23185,NULL,'admin','2025-10-21 19:03:43',NULL,'2025-10-21 19:03:43','0'),(13,12,117,'252475.docx','http://117.72.126.104:8080/profile/upload/2025/11/20/252475_20251120145522A001.docx','docx',13904,NULL,'manager','2025-11-20 14:55:23',NULL,'2025-11-20 14:55:23','0');
/*!40000 ALTER TABLE `sys_course_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_course_signin`
--

DROP TABLE IF EXISTS `sys_course_signin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_course_signin` (
  `signin_id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` char(1) DEFAULT '0' COMMENT '签到任务状态(0未开始,1进行中,2已结束)',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记(0存在,2删除)',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`signin_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程的签到表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_course_signin`
--

LOCK TABLES `sys_course_signin` WRITE;
/*!40000 ALTER TABLE `sys_course_signin` DISABLE KEYS */;
INSERT INTO `sys_course_signin` VALUES (97,12,117,'1119新增一条签到活动','2025-11-19 21:41:30','2025-11-22 00:00:00',NULL,'2025-11-19 21:41:35','1','0','','2025-11-19 21:41:35'),(98,12,117,'新增一条即将过期的签到活动','2025-11-19 00:00:00','2025-11-20 00:00:00',NULL,'2025-11-19 21:42:01','1','0','','2025-11-19 21:42:01'),(99,15,117,'新增一条未开始的签到活动','2025-11-26 00:00:00','2025-11-29 00:00:00',NULL,'2025-11-19 21:42:24','0','0','','2025-11-19 21:42:24'),(100,12,117,'1120测试新增签到活动','2025-11-20 22:26:46','2025-11-22 00:00:00',NULL,'2025-11-20 22:26:52','1','2','','2025-11-20 22:27:01'),(101,12,117,'1120新增一条签到活动','2025-11-20 22:27:29','2025-11-22 00:00:00',NULL,'2025-11-20 22:27:34','1','0','','2025-11-20 22:27:34');
/*!40000 ALTER TABLE `sys_course_signin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_course_signin_record`
--

DROP TABLE IF EXISTS `sys_course_signin_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_course_signin_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '签到记录ID',
  `signin_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `course_id` bigint NOT NULL,
  `status` char(1) DEFAULT '0',
  `signin_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程的签到记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_course_signin_record`
--

LOCK TABLES `sys_course_signin_record` WRITE;
/*!40000 ALTER TABLE `sys_course_signin_record` DISABLE KEYS */;
INSERT INTO `sys_course_signin_record` VALUES (57,97,1,12,'0',NULL,NULL,'2025-11-19 21:41:35','2025-11-19 21:41:35','manager',NULL),(58,97,2,12,'0',NULL,NULL,'2025-11-19 21:41:35','2025-11-19 21:41:35','manager',NULL),(59,97,4,12,'0',NULL,NULL,'2025-11-19 21:41:35','2025-11-19 21:41:35','manager',NULL),(60,98,1,12,'0',NULL,NULL,'2025-11-19 21:42:01','2025-11-19 21:42:01','manager',NULL),(61,98,2,12,'0',NULL,NULL,'2025-11-19 21:42:01','2025-11-19 21:42:01','manager',NULL),(62,98,4,12,'1','2025-11-19 22:01:15',NULL,'2025-11-19 21:42:01','2025-11-19 22:01:15','manager',NULL),(63,99,1,15,'0',NULL,NULL,'2025-11-19 21:42:24','2025-11-19 21:42:24','manager',NULL),(64,99,2,15,'0',NULL,NULL,'2025-11-19 21:42:24','2025-11-19 21:42:24','manager',NULL),(65,99,4,15,'0',NULL,NULL,'2025-11-19 21:42:24','2025-11-19 21:42:24','manager',NULL),(66,100,1,12,'0',NULL,NULL,'2025-11-20 22:26:52','2025-11-20 22:26:52','manager',NULL),(67,100,2,12,'1','2025-12-10 18:31:51',NULL,'2025-11-20 22:26:52','2025-12-10 18:31:51','manager',NULL),(68,100,4,12,'0',NULL,NULL,'2025-11-20 22:26:52','2025-11-20 22:26:52','manager',NULL),(69,100,8,12,'0',NULL,NULL,'2025-11-20 22:26:52','2025-11-20 22:26:52','manager',NULL),(70,101,1,12,'0',NULL,NULL,'2025-11-20 22:27:35','2025-11-20 22:27:35','manager',NULL),(71,101,2,12,'0',NULL,NULL,'2025-11-20 22:27:35','2025-11-20 22:27:35','manager',NULL),(72,101,4,12,'0',NULL,NULL,'2025-11-20 22:27:35','2025-11-20 22:27:35','manager',NULL),(73,101,8,12,'0',NULL,NULL,'2025-11-20 22:27:35','2025-11-20 22:27:35','manager',NULL);
/*!40000 ALTER TABLE `sys_course_signin_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `brief` varchar(100) DEFAULT '' COMMENT '班级描述',
  `cover_url` varchar(100) DEFAULT '0' COMMENT '班级封面',
  `start_time` datetime DEFAULT NULL COMMENT '班级开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '班级结束时间',
  `size` int DEFAULT '0' COMMENT '班级人数',
  `cap` int DEFAULT '0' COMMENT '班级容量',
  `auto_join` char(1) DEFAULT '0' COMMENT '允许自动加入',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','图书馆培训班',0,'图书馆管理员','15888888888','','0','0','admin','2025-08-27 00:49:58','manager','2025-10-12 15:19:06','','','2025-01-01 00:00:00','2025-12-31 00:00:00',0,0,'0'),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','',NULL,'','',NULL,NULL,NULL,0,'0'),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','',NULL,'','',NULL,NULL,NULL,0,'0'),(103,124,'0,100,124','局2024年项目负责人政治能力培训班',1,'若依','15888888888','ry@qq.com','1','0','admin','2025-08-27 00:49:58','manager','2025-11-20 22:05:31','无','','2024-10-01 13:02:42','2024-10-31 13:02:44',0,30,'0'),(104,124,'0,100,124','局2024年党政主要负责人培训班',2,'张老师','15888888888','','1','0','admin','2025-08-27 00:49:58','manager','2025-10-12 15:19:26','','','2024-10-01 00:00:00','2024-10-31 00:00:00',0,20,'0'),(105,124,'0,100,124','局2024年新入职职工培训班',3,'刘老师','15888888888','','1','0','admin','2025-08-27 00:49:58','manager','2025-10-12 15:19:30','','','2024-10-01 00:00:00','2024-10-31 00:00:00',0,20,'0'),(106,100,'0,100','财务部门',4,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','admin','2025-09-11 13:19:48','','',NULL,NULL,0,0,'0'),(107,100,'0,100','运维部门',5,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','admin','2025-09-11 13:19:52','','',NULL,NULL,0,0,'0'),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','',NULL,'','',NULL,NULL,NULL,0,'0'),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','2','admin','2025-08-27 00:49:58','',NULL,'','',NULL,NULL,NULL,0,'0'),(112,100,'0,100','测试部门001',100,'张三','13800000000','zhangsan@example.com','0','2','admin','2025-09-05 11:23:15','',NULL,'这是一个用于接口测试的部门','http://example.com/cover.png','2025-09-01 09:00:00','2025-12-31 18:00:00',30,50,'1'),(113,100,'0,100','研发部',101,'修改一下, 现在叫他小王经理','13912345678','wang@example.com','0','2','admin','2025-09-05 12:48:15','admin','2025-09-05 13:11:40','主要负责产品研发','https://example.com/rd-dept.jpg','2023-09-01 09:00:00','2024-08-31 18:00:00',15,20,'1'),(114,100,'0,100','研发部2',102,'王经理','13912345678','wang@example.com','0','2','admin','2025-09-05 13:16:32','',NULL,'主要负责产品研发','https://example.com/rd-dept.jpg','2023-09-01 09:00:00','2024-08-31 18:00:00',15,20,'1'),(115,100,'0,100','研发部3',103,'王经理','13912345678','wang@example.com','0','2','admin','2025-09-05 13:17:30','',NULL,'主要负责产品研发','https://example.com/rd-dept.jpg','2023-09-01 09:00:00','2024-08-31 18:00:00',15,20,'1'),(116,100,'0,100','11',1,NULL,NULL,NULL,'0','2','admin','2025-09-09 13:28:01','',NULL,'','0',NULL,NULL,0,0,'0'),(117,125,'0,100,125','局2025年项目负责人政治能力培训班',6,'A老师','15888888888',NULL,'0','0','admin','2025-09-11 13:02:38','manager','2025-11-21 14:56:51','当前无具体班级信息介绍','0','2025-10-27 13:02:21','2025-10-31 13:02:23',0,20,'0'),(118,100,'0,100','11',1,NULL,NULL,NULL,'0','2','admin','2025-09-12 15:55:32','',NULL,'','0',NULL,NULL,0,0,'0'),(119,100,'0,100','培训班0915期',1,'王老师',NULL,NULL,'0','2','admin','2025-09-15 16:42:27','admin','2025-09-16 10:14:12','','0','2025-09-15 19:42:35','2025-09-15 20:42:42',0,5,'0'),(120,124,'0,100,124','局2024年中青年干部暨任职培训班',4,'王老师','15888667678',NULL,'1','0','admin','2025-09-16 09:29:21','manager','2025-11-20 22:19:16','','0','2024-10-01 09:28:57','2024-10-31 10:28:58',0,9,'0'),(121,100,'0,100','0916测试2',1,NULL,NULL,NULL,'0','2','admin','2025-09-16 10:01:02','admin','2025-09-16 10:08:34','','0','2025-09-16 10:00:48','2025-09-16 11:00:50',0,5,'0'),(122,120,'0,100,124,120','11',1,NULL,NULL,NULL,'0','2','manager','2025-10-11 13:03:22','',NULL,'','0','2025-10-11 13:03:16','2025-10-11 13:03:18',1,1,'0'),(123,125,'0,100,125','局2025年高层次青年人才国情研修班',7,'B老师','11222222222',NULL,'0','0','manager','2025-10-12 15:16:57','manager','2025-11-21 14:56:39','无具体班级介绍','0','2025-10-12 15:16:50','2025-10-31 00:00:00',1,20,'0'),(124,100,'0,100','2024年培训班',0,'张老师',NULL,NULL,'1','0','manager','2025-10-12 15:17:35','manager','2025-10-12 15:19:33','','0','2024-10-01 15:17:13','2024-10-31 00:00:00',1,1,'0'),(125,100,'0,100','2025年培训班',0,'张老师',NULL,NULL,'0','0','manager','2025-10-12 15:18:00','',NULL,'','0','2025-10-12 15:17:54','2025-12-31 00:00:00',1,1,'0'),(126,125,'0,100,125','1120测试新增班级功能',8,'测试','15888888888',NULL,'0','0','manager','2025-11-20 22:18:46','manager','2025-11-20 22:20:22','1120对新增班级功能进行测试，并修改负责人和联系电话信息，目前新增和修改班级功能正常运行。','0','2025-11-20 22:18:35','2025-11-22 00:00:00',0,20,'0'),(127,125,'0,100,125','1121新增测试班级',9,'1121','11213333333',NULL,'0','0','manager','2025-11-21 14:52:11','',NULL,'新增测试班级','0','2025-11-21 14:52:05','2025-11-22 00:00:00',0,0,'0');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept_apply`
--

DROP TABLE IF EXISTS `sys_dept_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept_apply` (
  `apply_id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `user_id` bigint NOT NULL COMMENT '申请用户ID',
  `dept_id` bigint NOT NULL COMMENT '申请加入的部门ID',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '申请状态（0待审核 1通过 2拒绝）',
  `remark` varchar(200) DEFAULT '' COMMENT '备注',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `phone` varchar(100) DEFAULT '' COMMENT '申请人手机号',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  `email` varchar(100) DEFAULT '' COMMENT '申请人电子邮箱',
  `job` varchar(100) DEFAULT '' COMMENT '申请人职位',
  PRIMARY KEY (`apply_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门加入申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept_apply`
--

LOCK TABLES `sys_dept_apply` WRITE;
/*!40000 ALTER TABLE `sys_dept_apply` DISABLE KEYS */;
INSERT INTO `sys_dept_apply` VALUES (45,2,123,'0','','ry','2025-11-19 21:21:47','','2025-11-19 21:21:47','',NULL,'',''),(46,8,117,'1','','学员1','2025-11-20 21:56:01','manager','2025-11-21 14:52:28','',NULL,'',''),(47,1,125,'1','','admin','2025-11-21 15:01:03','admin','2025-11-21 15:01:10','',NULL,'',''),(48,2,123,'0','','ry','2025-11-21 16:13:59','','2025-11-21 16:13:59','',NULL,'',''),(49,2,117,'0','','ry','2025-12-10 18:04:41','','2025-12-10 18:04:41','',NULL,'','');
/*!40000 ALTER TABLE `sys_dept_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept_course`
--

DROP TABLE IF EXISTS `sys_dept_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept_course` (
  `course_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  `course_name` varchar(100) NOT NULL COMMENT '课程名称',
  `brief` varchar(500) DEFAULT NULL COMMENT '课程描述',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `size` bigint DEFAULT '0' COMMENT '课程人数',
  `cap` bigint DEFAULT '0' COMMENT '课程容量',
  `cover_url` varchar(100) DEFAULT '' COMMENT '课程封面',
  `del_flag` char(1) DEFAULT '0' COMMENT '0存在,2删除',
  PRIMARY KEY (`course_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门课程表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept_course`
--

LOCK TABLES `sys_dept_course` WRITE;
/*!40000 ALTER TABLE `sys_dept_course` DISABLE KEYS */;
INSERT INTO `sys_dept_course` VALUES (12,117,'第一期课程','这是培训第一期课程的课程描述，请在此处进行课程的简介补充。','','2025-09-10 17:39:08','','2025-11-21 14:59:36',0,0,'','0'),(13,117,'第三期课程','培训第三期课程','','2025-09-10 17:39:58','','2025-10-12 15:21:27',0,0,'','0'),(15,117,'第二期课程','培训第二期课程','','2025-09-11 14:06:42','','2025-10-12 15:21:10',0,0,'','0');
/*!40000 ALTER TABLE `sys_dept_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2025-08-27 00:49:58','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2025-08-27 00:49:58','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2025-08-27 00:49:58','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2025-08-27 00:49:58','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2025-08-27 00:49:58','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2025-08-27 00:49:58','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2025-08-27 00:49:58','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2025-08-27 00:49:58','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2025-08-27 00:49:58','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2025-08-27 00:49:58','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2025-08-27 00:49:58','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2025-08-27 00:49:58','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2025-08-27 00:49:58','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2025-08-27 00:49:58','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2025-08-27 00:49:58','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2025-08-27 00:49:58','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2025-08-27 00:49:58','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2025-08-27 00:49:58','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2025-08-27 00:49:58','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2025-08-27 00:49:58','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2025-08-27 00:49:58','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2025-08-27 00:49:58','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2025-08-27 00:49:58','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2025-08-27 00:49:58','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2025-08-27 00:49:58','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2025-08-27 00:49:58','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2025-08-27 00:49:58','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2025-08-27 00:49:58','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2025-08-27 00:49:58','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2025-08-27 00:49:58','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2025-08-27 00:49:58','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2025-08-27 00:49:59','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2025-08-27 00:49:59','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2025-08-27 00:49:59','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_leave_request`
--

DROP TABLE IF EXISTS `sys_leave_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_leave_request` (
  `leave_id` bigint NOT NULL AUTO_INCREMENT COMMENT '请假ID',
  `user_id` bigint NOT NULL COMMENT '申请用户ID',
  `dept_id` bigint NOT NULL COMMENT '申请人部门ID',
  `title` varchar(200) NOT NULL COMMENT '请假标题',
  `reason` varchar(500) DEFAULT NULL COMMENT '请假理由/描述',
  `start_time` datetime NOT NULL COMMENT '请假开始时间',
  `end_time` datetime NOT NULL COMMENT '请假结束时间',
  `status` char(1) DEFAULT '0' COMMENT '审批状态(0=待审批,1=通过,2=拒绝)',
  `approver_id` bigint DEFAULT NULL COMMENT '审批人ID',
  `approve_time` datetime DEFAULT NULL COMMENT '审批时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '审批备注',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标记(0存在,2删除)',
  PRIMARY KEY (`leave_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='请假申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_leave_request`
--

LOCK TABLES `sys_leave_request` WRITE;
/*!40000 ALTER TABLE `sys_leave_request` DISABLE KEYS */;
INSERT INTO `sys_leave_request` VALUES (7,4,104,'事假','事假','2025-09-22 08:14:13','2025-09-24 00:00:00','1',5,'2025-10-11 16:22:16',NULL,'牛博','2025-09-22 08:14:27','manager','2025-10-11 16:22:15','0'),(8,4,104,'0922新增请假','0922新增请假','2025-09-22 08:17:14','2025-09-24 00:00:00','1',5,'2025-11-19 21:15:55',NULL,'牛博','2025-09-22 08:17:23','manager','2025-11-19 21:15:55','0'),(10,5,104,'测试','请假','2025-10-11 15:04:41','2025-10-12 00:00:00','1',5,'2025-11-19 21:16:00',NULL,'manager','2025-10-11 15:04:50','manager','2025-11-19 21:16:00','0'),(11,4,117,'1120新增请假测试','测试请假功能','2025-11-20 15:00:22','2025-11-22 00:00:00','0',NULL,NULL,NULL,'牛博','2025-11-20 15:00:33',NULL,'2025-11-20 15:00:33','0'),(12,2,117,'1120测试新增请假','1120测试新增一条请假申请，测试管理员是否可以审核该申请。','2025-11-20 00:00:00','2025-11-22 00:00:00','0',NULL,NULL,NULL,'ry','2025-11-20 22:53:55',NULL,'2025-11-20 22:53:55','0'),(13,2,117,'1121新增请假','是假','2025-11-21 16:15:34','2025-11-28 00:00:00','0',NULL,NULL,NULL,'ry','2025-11-21 16:15:45',NULL,'2025-11-21 16:15:45','0');
/*!40000 ALTER TABLE `sys_leave_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (1,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 14:16:03'),(2,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 14:16:25'),(3,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 14:43:02'),(4,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 14:50:32'),(5,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 15:00:08'),(6,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 15:00:13'),(7,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 15:00:36'),(8,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 15:00:41'),(9,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 15:04:15'),(10,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 15:04:19'),(11,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 18:32:29'),(12,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 18:32:31'),(13,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 21:51:00'),(14,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 21:51:04'),(15,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 21:55:02'),(16,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 21:55:05'),(17,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 21:55:09'),(18,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 21:55:14'),(19,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 21:55:48'),(20,'学员1','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 21:55:53'),(21,'学员1','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 21:56:04'),(22,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 21:56:08'),(23,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 22:48:08'),(24,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 22:48:14'),(25,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 23:11:16'),(26,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 23:11:20'),(27,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-20 23:12:07'),(28,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-20 23:12:13'),(29,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:36:26'),(30,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:38:00'),(31,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 14:38:43'),(32,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:38:48'),(33,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 14:48:38'),(34,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:48:43'),(35,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 14:50:03'),(36,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:50:07'),(37,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 14:52:32'),(38,'学员1','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:52:36'),(39,'学员1','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 14:52:53'),(40,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 14:52:57'),(41,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:00:48'),(42,'admin','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:00:51'),(43,'admin','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:01:21'),(44,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:01:26'),(45,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:11:17'),(46,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:11:21'),(47,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:28:23'),(48,'admin','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:28:27'),(49,'admin','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:28:55'),(50,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:28:58'),(51,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:29:31'),(52,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:29:32'),(53,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:29:36'),(54,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:29:40'),(55,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 15:47:00'),(56,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 15:47:01'),(57,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 16:03:41'),(58,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 16:03:43'),(59,'牛博','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 16:13:26'),(60,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 16:13:32'),(61,'ry','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-11-21 16:27:45'),(62,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-11-21 16:27:50'),(63,'admin','114.254.1.11','XX XX','Unknown','Unknown','0','登录成功','2025-11-23 16:06:11'),(64,'ry','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-02 21:03:42'),(65,'ry','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 17:14:08'),(66,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 19:46:45'),(67,'ry','127.0.0.1','内网IP','Unknown','Unknown','0','退出成功','2025-12-03 19:53:37'),(68,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 20:01:59'),(69,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 20:02:51'),(70,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 20:10:29'),(71,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 20:12:52'),(72,'ry','127.0.0.1','内网IP','Unknown','Unknown','0','退出成功','2025-12-03 20:22:17'),(73,'15947113700','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-03 20:22:35'),(74,'ry','127.0.0.1','内网IP','Unknown','Unknown','0','退出成功','2025-12-03 20:22:46'),(75,'19317427915','127.0.0.1','内网IP','Unknown','Unknown','0','登录成功','2025-12-07 17:08:38'),(76,'manager','127.0.0.1','内网IP','Unknown','Unknown','0','退出成功','2025-12-07 17:09:11'),(77,'19317427915','111.203.137.98','XX XX','Unknown','Unknown','0','登录成功','2025-12-07 18:41:46'),(78,'manager','111.203.137.98','XX XX','Unknown','Unknown','0','退出成功','2025-12-07 18:42:05'),(79,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 16:29:10'),(80,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 16:43:25'),(81,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 16:45:58'),(82,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 16:46:25'),(83,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 16:46:29'),(84,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 16:46:35'),(85,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 16:46:51'),(86,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 16:46:58'),(87,'ry','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 16:50:20'),(88,'15947113700','111.203.137.119','XX XX','Unknown','Unknown','1','验证码错误','2025-12-10 16:50:29'),(89,'17778827153','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 16:51:53'),(90,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 16:52:07'),(91,'ry','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 16:57:37'),(92,'admin','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:03:06'),(93,'admin','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 17:03:14'),(94,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:03:31'),(95,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 17:04:14'),(96,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:06:55'),(97,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 17:06:58'),(98,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:07:00'),(99,'manager','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 17:07:04'),(100,'17778827153','111.203.137.119','XX XX','Unknown','Unknown','1','验证码错误','2025-12-10 17:07:29'),(101,'17778827153','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 17:08:10'),(102,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 17:08:27'),(103,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:10:05'),(104,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 17:10:08'),(105,'17778827153','127.0.0.1','内网IP','Chrome 13','Mac OS X','1','验证码已失效','2025-12-10 17:10:13'),(106,'17778827153','111.203.137.119','XX XX','Unknown','Unknown','1','验证码已失效','2025-12-10 17:10:22'),(107,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码错误','2025-12-10 17:11:42'),(108,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码错误','2025-12-10 17:11:51'),(109,'admin','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:14:10'),(110,'admin','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','退出成功','2025-12-10 17:14:19'),(111,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:14:47'),(112,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码已失效','2025-12-10 17:14:54'),(113,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码错误','2025-12-10 17:15:37'),(114,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:16:25'),(115,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:18:50'),(116,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:20:22'),(117,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码已失效','2025-12-10 17:20:28'),(118,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:22:34'),(119,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 17:24:43'),(120,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','1','验证码错误','2025-12-10 17:25:41'),(121,'ry','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 17:30:49'),(122,'admin','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 17:30:57'),(123,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:32:22'),(124,'17778827153','111.203.137.119','XX XX','Unknown','Unknown','0','登录成功','2025-12-10 17:49:39'),(125,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 17:50:42'),(126,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 17:50:46'),(127,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 17:55:31'),(128,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 18:02:54'),(129,'manager','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 18:04:18'),(130,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 18:04:27'),(131,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 18:31:00'),(132,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 18:31:01'),(133,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:17:47'),(134,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 21:21:23'),(135,'牛博','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:24:57'),(136,'17778827153','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 21:28:42'),(137,'牛博','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:29:15'),(138,'17778827153','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 21:31:52'),(139,'牛博','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:32:08'),(140,'ry','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 21:51:41'),(141,'ry','172.20.20.99','内网IP','Chrome Mobile','Android 6.x','0','登录成功','2025-12-10 21:51:41'),(142,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:52:15'),(143,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 21:52:16'),(144,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-10 21:52:20'),(145,'17778827153','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-10 21:52:39'),(146,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-11 11:48:57'),(147,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-11 11:49:10'),(148,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','退出成功','2025-12-11 11:49:44'),(149,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-11 12:15:47'),(150,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-14 14:13:49'),(151,'ry','172.20.20.99','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-12-14 14:14:08');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3090 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,13,'system',NULL,'','',1,0,'M','0','0','','system','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:17','系统管理目录'),(2,'系统监控',0,17,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2025-08-27 00:49:58','admin','2025-10-10 18:48:00','系统监控目录'),(3,'系统工具',0,16,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:54','系统工具目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2025-08-27 00:49:58','admin','2025-10-09 09:24:40','用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2025-08-27 00:49:58','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2025-08-27 00:49:58','',NULL,'菜单管理菜单'),(103,'培训班管理',0,2,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2025-08-27 00:49:58','admin','2025-09-23 10:59:39','部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:31','岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:36','字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:41','参数设置菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2025-08-27 00:49:58','admin','2025-10-10 18:47:51','日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2025-08-27 00:49:58','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2025-08-27 00:49:58','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2025-08-27 00:49:58','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2025-08-27 00:49:58','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2025-08-27 00:49:58','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2025-08-27 00:49:58','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2025-08-27 00:49:58','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2025-08-27 00:49:58','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2025-08-27 00:49:58','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2025-08-27 00:49:58','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2025-08-27 00:49:58','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2025-08-27 00:49:58','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2025-08-27 00:49:58','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:list','#','admin','2025-08-27 00:49:58','admin','2025-10-10 18:25:36',''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2025-08-27 00:49:58','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2025-08-27 00:49:58','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2025-08-27 00:49:58','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2025-08-27 00:49:58','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2025-08-27 00:49:58','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2025-08-27 00:49:58','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2025-08-27 00:49:58','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2025-08-27 00:49:58','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2025-08-27 00:49:58','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2025-08-27 00:49:58','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2025-08-27 00:49:58','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2025-08-27 00:49:58','',NULL,''),(2000,'报名审核管理',0,1,'deptApply','system/deptApply/index',NULL,'',1,0,'C','0','0','system:deptApply:list','guide','admin','2025-08-27 14:59:42','admin','2025-09-23 10:57:52',''),(2001,'查询申请',2000,1,'','',NULL,'',1,0,'F','0','0','system:deptApply:list','#','admin','2025-08-27 14:59:42','',NULL,''),(2003,'审批通过',2000,3,'','',NULL,'',1,0,'F','0','0','system:deptApply:approve','#','admin','2025-08-27 14:59:42','',NULL,''),(2004,'审批拒绝',2000,4,'','',NULL,'',1,0,'F','0','0','system:deptApply:reject','#','admin','2025-08-27 14:59:42','',NULL,''),(2005,'删除申请',2000,5,'','',NULL,'',1,0,'F','0','0','system:deptApply:remove','#','admin','2025-08-27 14:59:42','',NULL,''),(2101,'新增课程',2104,1,'','',NULL,'',1,0,'F','0','0','system:deptCourse:add','#','','2025-08-28 16:00:21','',NULL,''),(2102,'修改课程',2104,2,'','',NULL,'',1,0,'F','0','0','system:deptCourse:edit','#','','2025-08-28 16:00:21','',NULL,''),(2103,'删除课程',2104,3,'','',NULL,'',1,0,'F','0','0','system:deptCourse:remove','#','','2025-08-28 16:00:21','',NULL,''),(2104,'课程管理',0,3,'deptCourse','system/deptCourse/index',NULL,'',1,0,'C','0','0','system:deptCourse:list','education','admin','2025-08-28 17:24:06','admin','2025-09-23 10:59:43',''),(2105,'我的课程',0,10,'myCourse','system/myCourse/index',NULL,'',1,0,'C','0','0','system:myCourse:list','education','admin','2025-08-28 19:12:40','admin','2025-10-10 15:55:07','普通用户查看自己部门课程'),(3000,'签到活动管理',0,5,'signin','system/signin/index',NULL,'',1,0,'C','0','0','system:signin:list','form','admin','2025-09-01 17:17:47','admin','2025-09-11 19:26:48',''),(3001,'签到查询',3000,1,'list',NULL,NULL,'',1,0,'F','0','0','system:signin:list','#','admin','2025-09-01 17:17:47','admin','2025-10-10 18:23:37',''),(3002,'签到新增',3000,2,'add',NULL,NULL,'',1,0,'F','0','0','system:signin:add','#','admin','2025-09-01 17:17:47','',NULL,''),(3003,'签到修改',3000,3,'edit',NULL,NULL,'',1,0,'F','0','0','system:signin:edit','#','admin','2025-09-01 17:17:47','',NULL,''),(3004,'签到删除',3000,4,'remove',NULL,NULL,'',1,0,'F','0','0','system:signin:remove','#','admin','2025-09-01 17:17:47','',NULL,''),(3006,'班级广场',0,9,'classDisplay','system/classDisplay/index',NULL,'',1,0,'C','0','0','system:dept:list','documentation','admin','2025-09-10 15:18:39','admin','2025-10-10 15:55:02',''),(3008,'我的签到',0,11,'mySignin','system/mySignin/index',NULL,'',1,0,'C','0','0','system:signinRecord:list','example','admin','2025-09-12 09:44:44','admin','2025-10-12 17:23:14',''),(3009,'通知公告',0,7,'notice','system/notice/index',NULL,'',1,0,'C','0','0','system:notice:list','dict','admin','2025-09-14 14:10:30','admin','2025-09-14 14:10:59',''),(3013,'请假管理',0,8,'leave','system/leave/index',NULL,'',1,0,'C','0','0','system:leave:list','checkbox','admin','2025-09-18 15:29:17','admin','2025-09-18 15:30:17',''),(3014,'我的请假',0,12,'myLeave','system/myLeave/index',NULL,'',1,0,'C','0','0','system:leave:myleave','edit','admin','2025-09-18 16:24:29','admin','2025-09-20 19:35:08',''),(3015,'评价管理',0,6,'questionnaire','system/questionnaire/index',NULL,'',1,0,'C','0','0','system:questionnaire:list','button','admin','2025-09-23 13:13:24','admin','2025-11-07 15:20:00',''),(3016,'填写问卷',0,12,'userList','system/questionnaire/userList',NULL,'',1,0,'C','0','0','system:questionnaire:submit','date','admin','2025-09-23 13:43:47','admin','2025-09-24 19:34:06',''),(3017,'我的所有签到',3008,0,'',NULL,NULL,'',1,0,'F','0','0','system:signinRecord:list','#','',NULL,'admin','2025-10-10 18:44:41',''),(3018,'上传资源',3037,0,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:resource:upload','#','',NULL,'admin','2025-10-10 18:43:51',''),(3019,'提交请假',3014,0,'',NULL,NULL,'',1,0,'F','0','0','system:leave:add','#','',NULL,'admin','2025-10-10 17:48:14',''),(3020,'查看问卷题目',3015,0,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:query','#','',NULL,'admin','2025-10-10 18:42:51',''),(3021,'提交课程作业',3055,1,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:assignment:submit','#','',NULL,'admin','2025-10-10 18:42:11',''),(3022,'查看待提交作业',3055,0,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:assignment:pending','#','',NULL,'admin','2025-10-10 18:41:36',''),(3024,'新增问卷',3015,1,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:add','#','admin','2025-10-10 17:45:57','',NULL,''),(3026,'修改问卷',3015,3,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:edit','#','admin','2025-10-10 17:46:58','',NULL,''),(3027,'删除问卷',3015,4,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:remove','#','admin','2025-10-10 17:47:14','',NULL,''),(3028,'查看问卷提交记录',3015,4,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:result','#','admin','2025-10-10 17:47:40','admin','2025-10-11 12:56:50',''),(3029,'新增通知',3009,1,'',NULL,NULL,'',1,0,'F','0','0','system:notice:add','#','admin','2025-10-10 17:49:42','',NULL,''),(3030,'修改通知',3009,2,'',NULL,NULL,'',1,0,'F','0','0','system:notice:edit','#','admin','2025-10-10 17:50:00','',NULL,''),(3031,'删除通知',3009,3,'',NULL,NULL,'',1,0,'F','0','0','system:notice:remove','#','admin','2025-10-10 17:50:20','',NULL,''),(3032,'查看通知详情',3009,4,'',NULL,NULL,'',1,0,'F','0','0','system:notice:query','#','admin','2025-10-10 17:51:03','',NULL,''),(3033,'通过请假申请',3013,1,'',NULL,NULL,'',1,0,'F','0','0','system:leave:approve','#','admin','2025-10-10 17:52:11','',NULL,''),(3034,'拒绝请假申请',3013,2,'',NULL,NULL,'',1,0,'F','0','0','system:leave:reject','#','admin','2025-10-10 17:52:29','',NULL,''),(3035,'删除请假申请',3013,3,'',NULL,NULL,'',1,0,'F','0','0','system:leave:remove','#','admin','2025-10-10 17:52:51','',NULL,''),(3036,'导出报名表',103,5,'',NULL,NULL,'',1,0,'F','0','0','system:dept:export','#','admin','2025-10-10 17:56:14','',NULL,''),(3037,'资源管理',2104,5,'system/deptCourse/resource',NULL,NULL,'',1,0,'C','0','0','system:deptCourse:resource','#','admin','2025-10-10 18:01:35','',NULL,''),(3039,'删除资源',3037,2,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:resource:remove','#','admin','2025-10-10 18:05:37','',NULL,''),(3040,'查询课程',2104,0,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:list','#','admin','2025-10-10 18:06:52','admin','2025-10-10 18:25:16',''),(3041,'作业管理',2104,7,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:assignment','#','admin','2025-10-10 18:08:40','',NULL,''),(3042,'发布作业',3041,1,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:assignment:publish','#','admin','2025-10-10 18:11:43','',NULL,''),(3043,'删除作业',3041,4,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:assignment:remove','#','admin','2025-10-10 18:12:10','admin','2025-10-10 18:15:52',''),(3044,'查看提交记录',3041,2,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:assignment:check','#','admin','2025-10-10 18:13:39','admin','2025-10-10 18:15:56',''),(3045,'修改作业内容',3041,3,'',NULL,NULL,'',1,0,'F','0','0','system:deptCourse:assignment:edit','#','admin','2025-10-10 18:14:25','',NULL,''),(3046,'查看签到结果',3000,5,'',NULL,NULL,'',1,0,'F','0','0','system:signin:result','#','admin','2025-10-10 18:18:55','',NULL,''),(3047,'导出签到表',3000,6,'',NULL,NULL,'',1,0,'F','0','0','system:signin:export','#','admin','2025-10-10 18:19:11','',NULL,''),(3048,'查看通知列表',3009,0,'',NULL,NULL,'',1,0,'F','0','0','system:notice:list','#','admin','2025-10-10 18:22:57','',NULL,''),(3049,'查询问卷',3015,0,'',NULL,NULL,'',1,0,'F','0','0','system:questionnaire:list','#','admin','2025-10-10 18:24:53','',NULL,''),(3050,'查询请假列表',3013,0,'',NULL,NULL,'',1,0,'F','0','0','system:leave:list','#','admin','2025-10-10 18:26:41','',NULL,''),(3051,'查看请假详情',3013,5,'',NULL,NULL,'',1,0,'F','0','0','system:leave:query','#','admin','2025-10-10 18:27:56','',NULL,''),(3052,'查看详情',3006,1,'',NULL,NULL,'',1,0,'F','0','0','system:classDisplay:query','#','admin','2025-10-10 18:29:31','',NULL,''),(3053,'报名该班级',3006,2,'',NULL,NULL,'',1,0,'F','0','0','system:classDisplay:signin','#','admin','2025-10-10 18:30:07','',NULL,''),(3054,'查看资源',2105,1,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:resource:view','#','admin','2025-10-10 18:32:04','',NULL,''),(3055,'提交作业',2105,2,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:assignment:userSubmit','#','admin','2025-10-10 18:32:35','',NULL,''),(3056,'下载资源',3054,1,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:resource:download','#','admin','2025-10-10 18:34:04','',NULL,''),(3057,'预览资源',3054,2,'',NULL,NULL,'',1,0,'F','0','0','system:myCourse:resource:preview','#','admin','2025-10-10 18:35:04','',NULL,''),(3059,'查询我的签到活动',3008,1,'',NULL,NULL,'',1,0,'F','0','0','system:signinRecord:myPending','#','admin','2025-10-10 18:38:06','admin','2025-10-12 17:22:55',''),(3060,'签到',3008,2,'',NULL,NULL,'',1,0,'F','0','0','system:signinRecord:doSignin','#','admin','2025-10-10 18:38:41','admin','2025-10-12 17:20:22',''),(3061,'新增请假',3014,1,'',NULL,NULL,'',1,0,'F','0','0','system:myLeave:add','#','admin','2025-10-10 18:39:49','',NULL,''),(3062,'填写问卷',3016,1,'',NULL,NULL,'',1,0,'F','0','0','system:questionna:userList:fill','#','admin','2025-10-10 18:52:26','',NULL,''),(3063,'查询问卷列表',3016,0,'',NULL,NULL,'',1,0,'F','0','0','system:questionna:userList:list','#','admin','2025-10-10 18:53:08','',NULL,''),(3064,'查询单个班级的课程',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptCourse:query','#','mysql',NULL,'',NULL,''),(3065,'获取部门详细信息',0,0,'',NULL,NULL,'',1,0,'','0','0','system:dept:query','#','mysql',NULL,'',NULL,''),(3066,'导出部门申请表',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptApply:export','#','mysql',NULL,'',NULL,''),(3067,'导出签到记录表',0,0,'',NULL,NULL,'',1,0,'','0','0','system:signinRecord:export','#','mysql',NULL,'',NULL,''),(3068,'列出课程资源',0,0,'',NULL,NULL,'',1,0,'','0','0','sytem:deptCourse:resource:list','#','mysql',NULL,'',NULL,''),(3069,'查看资源详情',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptCourse:resource:query','#','mysql',NULL,'',NULL,''),(3070,'查看我的课程下的资源',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptCourse:resource:myCourse','#','mysql',NULL,'',NULL,''),(3071,'新增课程资源',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptCourse:resource:add','#','mysql',NULL,'',NULL,''),(3072,'列出课程资源',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptCourse:resource:list','#','mysql',NULL,'',NULL,''),(3073,'创建作业活动',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:add','#','mysql',NULL,'',NULL,''),(3074,'删除作业活动',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:remove','#','mysql',NULL,'',NULL,''),(3075,'修改作业活动',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:edit','#','mysql',NULL,'',NULL,''),(3076,'列出作业活动',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:list','#','mysql',NULL,'',NULL,''),(3077,'查看作业活动信息',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:query','#','mysql',NULL,'',NULL,''),(3078,'提交我的作业',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:submit','#','mysql',NULL,'',NULL,''),(3079,'查看待提交作业',0,0,'',NULL,NULL,'',1,0,'','0','0','system:assignment:pending','#','mysql',NULL,'',NULL,''),(3080,'提交班级变更申请',0,0,'',NULL,NULL,'',1,0,'','0','0','system:deptApply:add','#','mysql',NULL,'',NULL,''),(3081,'查询提交问卷',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:list','#','',NULL,'',NULL,''),(3082,'查询提交问卷',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:query','#','',NULL,'',NULL,''),(3083,'增加问卷',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:add','#','mysql',NULL,'',NULL,''),(3084,'修改问卷',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:edit','#','mysql',NULL,'',NULL,''),(3085,'删除问卷',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:remove','#','mysql',NULL,'',NULL,''),(3086,'查看问卷提交记录',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:submission:list','#','mysql',NULL,'',NULL,''),(3087,'查看某次提交的具体答案',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:submission:answers','#','mysql',NULL,'',NULL,''),(3088,'条件筛选问卷提交记录',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:submission:list','#','mysql',NULL,'',NULL,''),(3089,'根据id查看问卷提交记录',0,0,'',NULL,NULL,'',1,0,'','0','0','system:questionnaire:submission:query','#','mysql',NULL,'',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (3,'新的培训班上线啦','1',_binary '<p>xxxxx</p>','0','admin','2025-09-14 14:11:32','manager','2025-11-19 21:27:13',NULL),(5,'今日新课程上线了','1',_binary '<p>请及时查看最新课程并进行课程报名</p>','0','admin','2025-10-10 09:05:23','manager','2025-10-11 13:05:39',NULL),(6,'1011测试新增一条通知','1',_binary '<p>请查收1011新的通知内容</p>','0','manager','2025-10-11 12:42:21','',NULL,NULL),(7,'manager测试修改一条公告','2',_binary '<p>1120测试一下修改公告是否成功</p>','0','manager','2025-11-20 22:40:39','manager','2025-11-20 22:40:59',NULL);
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (1,'课程资源',1,'com.ruoyi.web.controller.system.SysCourseResourceController.add()','POST',1,'manager',NULL,'/system/deptCourse/resource','127.0.0.1','内网IP','{\"courseId\":12,\"createBy\":\"manager\",\"deptId\":117,\"fileName\":\"252475.docx\",\"filePath\":\"http://117.72.126.104:8080/profile/upload/2025/11/20/252475_20251120145522A001.docx\",\"fileSize\":13904,\"fileType\":\"docx\",\"params\":{},\"resourceId\":13}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 14:55:23',125),(2,'请假申请',1,'com.ruoyi.web.controller.system.SysLeaveRequestController.add()','POST',1,'牛博','局2025年项目负责人政治能力培训班','/system/leave','127.0.0.1','内网IP','{\"createBy\":\"牛博\",\"createTime\":\"2025-11-20 15:00:33\",\"deptId\":117,\"endTime\":\"2025-11-22 00:00:00\",\"leaveId\":11,\"params\":{},\"reason\":\"测试请假功能\",\"startTime\":\"2025-11-20 15:00:22\",\"status\":\"0\",\"title\":\"1120新增请假测试\",\"userId\":4}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 15:00:33',32),(3,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'manager',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"manager\",\"deptId\":117,\"nickName\":\"学员1\",\"params\":{},\"postIds\":[],\"roleIds\":[3],\"status\":\"0\",\"userId\":8,\"userName\":\"学员1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 21:55:43',190),(4,'部门申请',1,'com.ruoyi.web.controller.system.SysDeptApplyController.add()','POST',1,'学员1','局2025年项目负责人政治能力培训班','/system/deptApply','127.0.0.1','内网IP','{\"createBy\":\"学员1\",\"deptId\":117,\"params\":{},\"status\":\"0\",\"updateBy\":\"学员1\",\"userId\":8}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 21:56:01',48),(5,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,124\",\"autoJoin\":\"0\",\"brief\":\"无\",\"cap\":30,\"children\":[],\"coverURL\":\"\",\"deptId\":103,\"deptName\":\"局2024年项目负责人政治能力培训班\",\"email\":\"ry@qq.com\",\"endTime\":\"2024-10-31 13:02:44\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":124,\"parentName\":\"2024年培训班\",\"phone\":\"15888888888\",\"size\":0,\"startTime\":\"2024-10-01 13:02:42\",\"status\":\"1\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:05:31',56),(6,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"cap\":20,\"children\":[],\"createBy\":\"manager\",\"deptName\":\"1120测试新增班级功能\",\"endTime\":\"2025-11-22 00:00:00\",\"orderNum\":8,\"params\":{},\"parentId\":125,\"size\":0,\"startTime\":\"2025-11-20 22:18:35\",\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:18:46',58),(7,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":126,\"deptName\":\"1120测试新增班级功能\",\"endTime\":\"2025-11-22 00:00:00\",\"orderNum\":9,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"size\":0,\"startTime\":\"2025-11-20 22:18:35\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:18:58',37),(8,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,124\",\"autoJoin\":\"0\",\"brief\":\"\",\"cap\":9,\"children\":[],\"coverURL\":\"0\",\"deptId\":120,\"deptName\":\"局2024年中青年干部暨任职培训班\",\"endTime\":\"2024-10-31 10:28:58\",\"leader\":\"王老师\",\"orderNum\":2,\"params\":{},\"parentId\":124,\"parentName\":\"2024年培训班\",\"phone\":\"15888667678\",\"size\":0,\"startTime\":\"2024-10-01 09:28:57\",\"status\":\"1\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:19:06',55),(9,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,124\",\"autoJoin\":\"0\",\"brief\":\"\",\"cap\":9,\"children\":[],\"coverURL\":\"0\",\"deptId\":120,\"deptName\":\"局2024年中青年干部暨任职培训班\",\"endTime\":\"2024-10-31 10:28:58\",\"leader\":\"王老师\",\"orderNum\":3,\"params\":{},\"parentId\":124,\"parentName\":\"2024年培训班\",\"phone\":\"15888667678\",\"size\":0,\"startTime\":\"2024-10-01 09:28:57\",\"status\":\"1\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:19:10',31),(10,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,124\",\"autoJoin\":\"0\",\"brief\":\"\",\"cap\":9,\"children\":[],\"coverURL\":\"0\",\"deptId\":120,\"deptName\":\"局2024年中青年干部暨任职培训班\",\"endTime\":\"2024-10-31 10:28:58\",\"leader\":\"王老师\",\"orderNum\":4,\"params\":{},\"parentId\":124,\"parentName\":\"2024年培训班\",\"phone\":\"15888667678\",\"size\":0,\"startTime\":\"2024-10-01 09:28:57\",\"status\":\"1\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:19:16',30),(11,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":126,\"deptName\":\"1120测试新增班级功能\",\"endTime\":\"2025-11-22 00:00:00\",\"orderNum\":8,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"size\":0,\"startTime\":\"2025-11-20 22:18:35\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:19:28',28),(12,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"1120对新增班级功能进行测试，并修改负责人和联系电话信息，目前新增和修改班级功能正常运行。\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":126,\"deptName\":\"1120测试新增班级功能\",\"endTime\":\"2025-11-22 00:00:00\",\"leader\":\"测试\",\"orderNum\":8,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"phone\":\"15888888888\",\"size\":0,\"startTime\":\"2025-11-20 22:18:35\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:20:22',37),(13,'导出报名(部门申请)表单',5,'com.ruoyi.web.controller.system.SysDeptApplyController.export()','POST',1,'manager',NULL,'/system/deptApply/export','127.0.0.1','内网IP','{\"deptId\":117,\"params\":{}}',NULL,0,NULL,'2025-11-20 22:20:33',1018),(14,'课程签到',1,'com.ruoyi.web.controller.system.SysCourseSigninController.add()','POST',1,'manager',NULL,'/system/signin','127.0.0.1','内网IP','{\"courseId\":12,\"createBy\":\"manager\",\"deptId\":117,\"endTime\":\"2025-11-22 00:00:00\",\"params\":{},\"signinId\":100,\"startTime\":\"2025-11-20 22:26:46\",\"status\":\"1\",\"title\":\"1120测试新增签到活动\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:26:52',74),(15,'课程签到',3,'com.ruoyi.web.controller.system.SysCourseSigninController.remove()','DELETE',1,'manager',NULL,'/system/signin/100','127.0.0.1','内网IP','[100]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:27:02',41),(16,'课程签到',1,'com.ruoyi.web.controller.system.SysCourseSigninController.add()','POST',1,'manager',NULL,'/system/signin','127.0.0.1','内网IP','{\"courseId\":12,\"createBy\":\"manager\",\"deptId\":117,\"endTime\":\"2025-11-22 00:00:00\",\"params\":{},\"signinId\":101,\"startTime\":\"2025-11-20 22:27:29\",\"status\":\"1\",\"title\":\"1120新增一条签到活动\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:27:35',44),(17,'问卷管理',1,'com.ruoyi.web.controller.system.SysQuestionnaireController.add()','POST',1,'manager',NULL,'/system/questionnaire','127.0.0.1','内网IP','{\"allowRepeat\":\"0\",\"description\":\"测试新增课程评价结果\",\"endTime\":\"2025-11-22 00:00:00\",\"items\":[{\"itemId\":104,\"itemType\":\"R\",\"metaId\":39,\"orderNum\":1,\"questionText\":\"测试问题一\",\"required\":\"true\"}],\"metaId\":39,\"params\":{},\"startTime\":\"2025-11-20 22:29:34\",\"status\":\"0\",\"targetRefId\":12,\"targetType\":\"C\",\"title\":\"1120新增一条课程评价\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:29:45',84),(18,'问卷管理',2,'com.ruoyi.web.controller.system.SysQuestionnaireController.edit()','PUT',1,'manager',NULL,'/system/questionnaire','127.0.0.1','内网IP','{\"allowRepeat\":\"0\",\"description\":\"请对您所在班级作出评价\",\"endTime\":\"2025-11-22 00:00:00\",\"items\":[{\"itemId\":105,\"itemType\":\"R\",\"metaId\":38,\"orderNum\":1,\"questionText\":\"对班级设定是否满意\",\"required\":\"true\"}],\"metaId\":38,\"params\":{},\"startTime\":\"2025-11-19 21:54:39\",\"status\":\"0\",\"targetRefId\":117,\"targetType\":\"D\",\"title\":\"1119新增一条班级评价\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:29:59',27),(19,'问卷管理',2,'com.ruoyi.web.controller.system.SysQuestionnaireController.edit()','PUT',1,'manager',NULL,'/system/questionnaire','127.0.0.1','内网IP','{\"allowRepeat\":\"0\",\"description\":\"测试修改课程评价结果\",\"endTime\":\"2025-11-22 00:00:00\",\"items\":[{\"itemId\":106,\"itemType\":\"R\",\"metaId\":39,\"orderNum\":1,\"questionText\":\"测试问题一\",\"required\":\"true\"}],\"metaId\":39,\"params\":{},\"startTime\":\"2025-11-20 22:29:34\",\"status\":\"0\",\"targetRefId\":12,\"targetType\":\"C\",\"title\":\"1120修改一条课程评价\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:30:16',39),(20,'问卷管理',2,'com.ruoyi.web.controller.system.SysQuestionnaireController.edit()','PUT',1,'manager',NULL,'/system/questionnaire','127.0.0.1','内网IP','{\"allowRepeat\":\"0\",\"description\":\"新增评价\",\"endTime\":\"2025-11-28 00:00:00\",\"items\":[{\"itemId\":107,\"itemType\":\"R\",\"metaId\":37,\"orderNum\":1,\"questionText\":\"对课程内容是否满意\",\"required\":\"true\"}],\"metaId\":37,\"params\":{},\"startTime\":\"2025-11-07 15:35:25\",\"status\":\"0\",\"targetRefId\":12,\"targetType\":\"C\",\"title\":\"对第一期课程新增评价\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:39:01',29),(21,'通知公告',1,'com.ruoyi.web.controller.system.SysNoticeController.add()','POST',1,'manager',NULL,'/system/notice','127.0.0.1','内网IP','{\"createBy\":\"manager\",\"noticeContent\":\"<p>1120测试一下新增公告是否成功</p>\",\"noticeTitle\":\"manager于1120新增一条公告\",\"noticeType\":\"2\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:40:39',40),(22,'通知公告',2,'com.ruoyi.web.controller.system.SysNoticeController.edit()','PUT',1,'manager',NULL,'/system/notice','127.0.0.1','内网IP','{\"createBy\":\"manager\",\"createTime\":\"2025-11-20 22:40:39\",\"noticeContent\":\"<p>1120测试一下修改公告是否成功</p>\",\"noticeId\":7,\"noticeTitle\":\"manager测试修改一条公告\",\"noticeType\":\"2\",\"params\":{},\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:40:59',25),(23,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'manager',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"manager\",\"createTime\":\"2025-11-20 21:55:43\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,125\",\"children\":[],\"deptId\":117,\"deptName\":\"局2025年项目负责人政治能力培训班\",\"leader\":\"张老师\",\"orderNum\":6,\"params\":{},\"parentId\":125,\"status\":\"0\"},\"deptId\":117,\"email\":\"\",\"loginDate\":\"2025-11-20 21:55:53\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"学员1\",\"params\":{},\"phonenumber\":\"17777777777\",\"postIds\":[],\"roleIds\":[3],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"common\",\"roleName\":\"普通用户\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"manager\",\"userId\":8,\"userName\":\"学员1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:44:54',66),(24,'请假申请',1,'com.ruoyi.web.controller.system.SysLeaveRequestController.add()','POST',1,'ry','局2025年项目负责人政治能力培训班','/system/leave','127.0.0.1','内网IP','{\"createBy\":\"ry\",\"createTime\":\"2025-11-20 22:53:55\",\"deptId\":117,\"endTime\":\"2025-11-22 00:00:00\",\"leaveId\":12,\"params\":{},\"reason\":\"1120测试新增一条请假申请，测试管理员是否可以审核该申请。\",\"startTime\":\"2025-11-20 00:00:00\",\"status\":\"0\",\"title\":\"1120测试新增请假\",\"userId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-20 22:53:55',14),(25,'导出报名(部门申请)表单',5,'com.ruoyi.web.controller.system.SysDeptApplyController.export()','POST',1,'manager',NULL,'/system/deptApply/export','127.0.0.1','内网IP','{\"deptId\":123,\"params\":{}}',NULL,0,NULL,'2025-11-21 14:41:00',120),(26,'导出报名(部门申请)表单',5,'com.ruoyi.web.controller.system.SysDeptApplyController.export()','POST',1,'manager',NULL,'/system/deptApply/export','127.0.0.1','内网IP','{\"deptId\":117,\"params\":{}}',NULL,0,NULL,'2025-11-21 14:47:06',65),(27,'用户管理',5,'com.ruoyi.web.controller.system.SysUserController.export()','POST',1,'manager',NULL,'/system/user/export','127.0.0.1','内网IP','{\"pageSize\":\"10\",\"pageNum\":\"1\"}',NULL,0,NULL,'2025-11-21 14:47:41',421),(28,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"当前无具体班级信息介绍\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":117,\"deptName\":\"局2025年项目负责人政治能力培训班\",\"endTime\":\"2025-10-31 13:02:23\",\"leader\":\"张老师\",\"orderNum\":6,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"phone\":\"15888888888\",\"size\":0,\"startTime\":\"2025-10-27 13:02:21\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:50:20',23),(29,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"新增测试班级\",\"children\":[],\"createBy\":\"manager\",\"deptName\":\"1121新增测试班级\",\"endTime\":\"2025-11-22 00:00:00\",\"leader\":\"1121\",\"orderNum\":9,\"params\":{},\"parentId\":125,\"phone\":\"11213333333\",\"startTime\":\"2025-11-21 14:52:05\",\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:52:11',24),(30,'部门申请-通过',2,'com.ruoyi.web.controller.system.SysDeptApplyController.approve()','PUT',1,'manager',NULL,'/system/deptApply/46/approve','127.0.0.1','内网IP','46','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:52:28',38),(31,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"无具体班级介绍\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":123,\"deptName\":\"局2025年高层次青年人才国情研修班\",\"endTime\":\"2025-10-31 00:00:00\",\"leader\":\"国情研修\",\"orderNum\":7,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"phone\":\"11222222222\",\"size\":1,\"startTime\":\"2025-10-12 15:16:50\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:53:26',32),(32,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"无具体班级介绍\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":123,\"deptName\":\"局2025年高层次青年人才国情研修班\",\"endTime\":\"2025-10-31 00:00:00\",\"leader\":\"B老师\",\"orderNum\":7,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"phone\":\"11222222222\",\"size\":1,\"startTime\":\"2025-10-12 15:16:50\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:56:39',32),(33,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'manager',NULL,'/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"0,100,125\",\"autoJoin\":\"0\",\"brief\":\"当前无具体班级信息介绍\",\"cap\":20,\"children\":[],\"coverURL\":\"0\",\"deptId\":117,\"deptName\":\"局2025年项目负责人政治能力培训班\",\"endTime\":\"2025-10-31 13:02:23\",\"leader\":\"A老师\",\"orderNum\":6,\"params\":{},\"parentId\":125,\"parentName\":\"2025年培训班\",\"phone\":\"15888888888\",\"size\":0,\"startTime\":\"2025-10-27 13:02:21\",\"status\":\"0\",\"updateBy\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:56:51',38),(34,'部门课程',2,'com.ruoyi.web.controller.system.SysDeptCourseController.edit()','PUT',1,'manager',NULL,'/system/deptCourse','127.0.0.1','内网IP','{\"brief\":\"这是培训第一期课程的课程描述，请在此处进行课程的简介补充。\",\"cap\":0,\"courseId\":12,\"courseName\":\"第一期课程\",\"coverURL\":\"\",\"createBy\":\"\",\"createTime\":\"2025-09-10 17:39:08\",\"deptId\":117,\"deptName\":\"局2025年项目负责人政治能力培训班\",\"params\":{},\"size\":0}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 14:59:36',36),(35,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'manager',NULL,'/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-10-10 09:09:38\",\"delFlag\":\"0\",\"deptId\":125,\"email\":\"\",\"loginDate\":\"2025-11-21 14:52:57\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"manager\",\"params\":{},\"phonenumber\":\"15888888889\",\"postIds\":[],\"pwdUpdateDate\":\"2025-10-11 12:33:35\",\"roleIds\":[4],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":4,\"roleKey\":\"manager\",\"roleName\":\"管理员\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"manager\",\"userId\":5,\"userName\":\"manager\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 15:00:18',30),(36,'部门申请',1,'com.ruoyi.web.controller.system.SysDeptApplyController.add()','POST',1,'admin','局2025年项目负责人政治能力培训班','/system/deptApply','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":125,\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":1}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 15:01:03',13),(37,'部门申请-通过',2,'com.ruoyi.web.controller.system.SysDeptApplyController.approve()','PUT',1,'admin','局2025年项目负责人政治能力培训班','/system/deptApply/47/approve','127.0.0.1','内网IP','47','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 15:01:10',33),(38,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin','2025年培训班','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-09-09 15:23:36\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[3009,3065,3070,3078,3079,3080,3081,3082,3048,3032,3006,3052,3053,2105,3054,3056,3057,3055,3022,3021,3008,3017,3059,3060,3014,3019,3061,3016,3063,3062],\"params\":{},\"roleId\":3,\"roleKey\":\"common\",\"roleName\":\"普通学员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 15:28:47',33),(39,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'ry','局2025年项目负责人政治能力培训班','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"ry@qq.com\",\"nickName\":\"ry\",\"params\":{},\"phonenumber\":\"15666666666\",\"sex\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 15:29:25',40),(40,'部门申请',1,'com.ruoyi.web.controller.system.SysDeptApplyController.add()','POST',1,'ry','局2025年项目负责人政治能力培训班','/system/deptApply','127.0.0.1','内网IP','{\"createBy\":\"ry\",\"deptId\":123,\"params\":{},\"status\":\"0\",\"updateBy\":\"ry\",\"userId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 16:13:59',31),(41,'请假申请',1,'com.ruoyi.web.controller.system.SysLeaveRequestController.add()','POST',1,'ry','局2025年项目负责人政治能力培训班','/system/leave','127.0.0.1','内网IP','{\"createBy\":\"ry\",\"createTime\":\"2025-11-21 16:15:45\",\"deptId\":117,\"endTime\":\"2025-11-28 00:00:00\",\"leaveId\":13,\"params\":{},\"reason\":\"是假\",\"startTime\":\"2025-11-21 16:15:34\",\"status\":\"0\",\"title\":\"1121新增请假\",\"userId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-11-21 16:15:45',12),(42,'部门课程',2,'com.ruoyi.web.controller.system.SysDeptCourseController.edit()','PUT',1,'admin','2025年培训班','/system/deptCourse','114.254.1.11','XX XX','{\"courseId\":7,\"courseName\":\"555改一下我们叫不测试课程555\",\"params\":{}}','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2025-11-23 16:06:19',41),(43,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'manager','2025年培训班','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"19317427915@163.com\",\"nickName\":\"manager\",\"params\":{},\"phonenumber\":\"19317427915\",\"sex\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-10 17:03:58',53),(44,'部门申请',1,'com.ruoyi.web.controller.system.SysDeptApplyController.add()','POST',1,'ry','局2025年项目负责人政治能力培训班','/system/deptApply','172.20.20.99','内网IP','{\"createBy\":\"ry\",\"deptId\":117,\"params\":{},\"status\":\"0\",\"updateBy\":\"ry\",\"userId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-12-10 18:04:41',63);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2025-08-27 00:49:58','admin','2025-09-11 18:49:19',''),(2,'se','项目经理',2,'0','admin','2025-08-27 00:49:58','',NULL,''),(3,'hr','人力资源',3,'0','admin','2025-08-27 00:49:58','',NULL,''),(4,'user','普通员工',4,'0','admin','2025-08-27 00:49:58','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_questionnaire_answer`
--

DROP TABLE IF EXISTS `sys_questionnaire_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_questionnaire_answer` (
  `answer_id` bigint NOT NULL AUTO_INCREMENT COMMENT '答案ID',
  `submission_id` bigint NOT NULL COMMENT '提交ID',
  `meta_id` bigint NOT NULL COMMENT '问卷ID',
  `item_id` bigint NOT NULL COMMENT '题目ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `score` tinyint DEFAULT NULL COMMENT '评分题（1-5）',
  `text_answer` varchar(2000) DEFAULT NULL COMMENT '文本题回答',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`answer_id`),
  KEY `idx_answer_submission` (`submission_id`),
  KEY `idx_answer_meta` (`meta_id`),
  KEY `idx_answer_item` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='问卷答案';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_questionnaire_answer`
--

LOCK TABLES `sys_questionnaire_answer` WRITE;
/*!40000 ALTER TABLE `sys_questionnaire_answer` DISABLE KEYS */;
INSERT INTO `sys_questionnaire_answer` VALUES (1,4,1,101,2,5,'',NULL,'2025-09-22 16:50:42',NULL,'2025-09-22 16:50:42',NULL,'0'),(2,4,1,102,2,4,'',NULL,'2025-09-22 16:50:42',NULL,'2025-09-22 16:50:42',NULL,'0'),(3,4,1,103,2,NULL,'老师讲得很清楚，建议增加互动环节。',NULL,'2025-09-22 16:50:42',NULL,'2025-09-22 16:50:42',NULL,'0'),(4,5,1,101,4,5,'',NULL,'2025-09-23 13:03:31',NULL,'2025-09-23 13:03:31',NULL,'0'),(5,5,1,102,4,4,'',NULL,'2025-09-23 13:03:31',NULL,'2025-09-23 13:03:31',NULL,'0'),(6,5,1,103,4,NULL,'老师讲得很清楚，建议增加互动环节。',NULL,'2025-09-23 13:03:31',NULL,'2025-09-23 13:03:31',NULL,'0'),(7,6,4,27,1,NULL,NULL,NULL,'2025-09-25 22:01:38',NULL,'2025-09-25 22:01:38',NULL,'0'),(8,7,4,28,4,NULL,NULL,NULL,'2025-09-25 22:10:51',NULL,'2025-09-25 22:10:51',NULL,'0'),(9,7,4,29,4,NULL,NULL,NULL,'2025-09-25 22:10:51',NULL,'2025-09-25 22:10:51',NULL,'0'),(10,7,4,30,4,NULL,NULL,NULL,'2025-09-25 22:10:51',NULL,'2025-09-25 22:10:51',NULL,'0'),(11,8,25,31,4,NULL,NULL,NULL,'2025-09-26 14:11:28',NULL,'2025-09-26 14:11:28',NULL,'0'),(12,8,25,32,4,NULL,NULL,NULL,'2025-09-26 14:11:28',NULL,'2025-09-26 14:11:28',NULL,'0'),(13,9,26,33,4,5,'',NULL,'2025-09-26 15:26:00',NULL,'2025-09-26 15:26:00',NULL,'0'),(14,9,26,34,4,5,'',NULL,'2025-09-26 15:26:00',NULL,'2025-09-26 15:26:00',NULL,'0'),(15,10,27,37,4,5,'',NULL,'2025-10-10 16:34:22',NULL,'2025-10-10 16:34:22',NULL,'0'),(16,11,27,37,1,5,'',NULL,'2025-10-10 18:50:54',NULL,'2025-10-10 18:50:54',NULL,'0'),(17,12,28,38,4,5,'',NULL,'2025-10-11 12:53:59',NULL,'2025-10-11 12:53:59',NULL,'0'),(18,13,29,39,4,5,'',NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(19,13,29,40,4,5,'',NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(20,13,29,41,4,5,'',NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(21,13,29,42,4,5,'',NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(22,13,29,43,4,5,'',NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(23,14,30,44,4,5,'',NULL,'2025-11-06 17:26:32',NULL,'2025-11-06 17:26:32',NULL,'0'),(24,15,35,56,4,5,'',NULL,'2025-11-07 14:58:09',NULL,'2025-11-07 14:58:09',NULL,'0'),(25,16,37,64,4,NULL,NULL,NULL,'2025-11-07 15:35:51',NULL,'2025-11-07 15:35:51',NULL,'0'),(26,17,1,101,1,5,'',NULL,'2025-11-07 19:50:58',NULL,'2025-11-07 19:50:58',NULL,'0'),(27,17,1,102,1,4,'',NULL,'2025-11-07 19:50:58',NULL,'2025-11-07 19:50:58',NULL,'0'),(28,17,1,103,1,NULL,'老师讲得很清楚，建议增加互动环节。',NULL,'2025-11-07 19:50:58',NULL,'2025-11-07 19:50:58',NULL,'0'),(29,18,38,103,4,NULL,NULL,NULL,'2025-11-19 22:05:22',NULL,'2025-11-19 22:05:22',NULL,'0'),(30,19,38,105,2,NULL,NULL,NULL,'2025-11-20 22:56:34',NULL,'2025-11-20 22:56:34',NULL,'0'),(31,20,37,107,2,NULL,NULL,NULL,'2025-11-21 16:14:57',NULL,'2025-11-21 16:14:57',NULL,'0');
/*!40000 ALTER TABLE `sys_questionnaire_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_questionnaire_item`
--

DROP TABLE IF EXISTS `sys_questionnaire_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_questionnaire_item` (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `meta_id` bigint NOT NULL COMMENT '问卷ID',
  `item_type` char(1) NOT NULL COMMENT 'S=评分(1-5),T=文本反馈, M=多选(扩展)',
  `question_text` varchar(1000) NOT NULL COMMENT '题目文本',
  `required` char(1) DEFAULT '1' COMMENT '1=必填,0=非必填',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`item_id`),
  KEY `idx_item_meta` (`meta_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='问卷题目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_questionnaire_item`
--

LOCK TABLES `sys_questionnaire_item` WRITE;
/*!40000 ALTER TABLE `sys_questionnaire_item` DISABLE KEYS */;
INSERT INTO `sys_questionnaire_item` VALUES (51,5,'S','加一个问题','1',1,NULL,'2025-11-07 14:02:10',NULL,'2025-11-07 14:02:10',NULL,'0'),(52,5,'S','再加一个问题','1',2,NULL,'2025-11-07 14:02:10',NULL,'2025-11-07 14:02:10',NULL,'0'),(53,5,'T','最后加一个问题','1',3,NULL,'2025-11-07 14:02:10',NULL,'2025-11-07 14:02:10',NULL,'0'),(81,35,'R','课程总体安排','1',1,NULL,'2025-11-19 21:44:30',NULL,'2025-11-19 21:44:30',NULL,'0'),(82,35,'R','活动安排','1',2,NULL,'2025-11-19 21:44:30',NULL,'2025-11-19 21:44:30',NULL,'0'),(83,35,'R','培训时间长短','1',3,NULL,'2025-11-19 21:44:30',NULL,'2025-11-19 21:44:30',NULL,'0'),(84,35,'R','教学组织与管理','1',4,NULL,'2025-11-19 21:44:30',NULL,'2025-11-19 21:44:30',NULL,'0'),(85,35,'R','工作人员服务水平','1',5,NULL,'2025-11-19 21:44:30',NULL,'2025-11-19 21:44:30',NULL,'0'),(86,36,'R','请对您现在所在班级进行评价','1',1,NULL,'2025-11-19 21:44:37',NULL,'2025-11-19 21:44:37',NULL,'0'),(98,30,'R','课程总体安排','1',1,NULL,'2025-11-19 21:48:08',NULL,'2025-11-19 21:48:08',NULL,'0'),(99,30,'R','活动安排','1',2,NULL,'2025-11-19 21:48:08',NULL,'2025-11-19 21:48:08',NULL,'0'),(100,30,'R','培训时长和进度安排','1',3,NULL,'2025-11-19 21:48:08',NULL,'2025-11-19 21:48:08',NULL,'0'),(101,30,'R','教学内容针对性','1',4,NULL,'2025-11-19 21:48:08',NULL,'2025-11-19 21:48:08',NULL,'0'),(102,30,'R','工作人员态度','1',5,NULL,'2025-11-19 21:48:08',NULL,'2025-11-19 21:48:08',NULL,'0'),(105,38,'R','对班级设定是否满意','1',1,NULL,'2025-11-20 22:29:59',NULL,'2025-11-20 22:29:59',NULL,'0'),(106,39,'R','测试问题一','1',1,NULL,'2025-11-20 22:30:16',NULL,'2025-11-20 22:30:16',NULL,'0'),(107,37,'R','对课程内容是否满意','1',1,NULL,'2025-11-20 22:39:01',NULL,'2025-11-20 22:39:01',NULL,'0');
/*!40000 ALTER TABLE `sys_questionnaire_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_questionnaire_meta`
--

DROP TABLE IF EXISTS `sys_questionnaire_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_questionnaire_meta` (
  `meta_id` bigint NOT NULL AUTO_INCREMENT COMMENT '问卷ID',
  `dept_id` bigint DEFAULT NULL COMMENT '冗余列：所属班级/部门，便于按班级筛选',
  `target_type` char(1) NOT NULL DEFAULT 'D' COMMENT '目标类型: D=dept, C=course, T=teacher',
  `target_ref_id` bigint DEFAULT NULL COMMENT '目标引用ID（根据 target_type）',
  `title` varchar(200) NOT NULL COMMENT '问卷标题',
  `description` varchar(2000) DEFAULT NULL COMMENT '问卷描述',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `status` char(1) DEFAULT '0' COMMENT '0未发布,1进行中,2已结束',
  `allow_repeat` char(1) DEFAULT '0' COMMENT '0=不允许重复提交,1=允许',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`meta_id`),
  KEY `idx_meta_dept` (`dept_id`),
  KEY `idx_meta_target` (`target_type`,`target_ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='问卷元数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_questionnaire_meta`
--

LOCK TABLES `sys_questionnaire_meta` WRITE;
/*!40000 ALTER TABLE `sys_questionnaire_meta` DISABLE KEYS */;
INSERT INTO `sys_questionnaire_meta` VALUES (30,120,'C',12,'第二期课程的问卷','对第二期课程发布问卷','2025-11-06 17:10:00','2025-11-07 00:00:00','0','0',NULL,'2025-11-06 17:10:14',NULL,'2025-11-19 21:48:08',NULL,'0'),(35,NULL,'C',13,'第三期课程的问卷','对第三期课程新增问卷','2025-11-07 14:45:04','2025-11-17 00:00:00','0','0',NULL,'2025-11-07 14:45:09',NULL,'2025-11-19 21:44:30',NULL,'0'),(36,NULL,'D',117,'1107新增班级问卷','1107新增班级问卷','2025-11-07 15:15:26','2025-11-14 00:00:00','0','0',NULL,'2025-11-07 15:15:40',NULL,'2025-11-19 21:44:37',NULL,'0'),(37,NULL,'C',12,'对第一期课程新增评价','新增评价','2025-11-07 15:35:25','2025-11-28 00:00:00','0','0',NULL,'2025-11-07 15:35:36',NULL,'2025-11-20 22:39:01',NULL,'0'),(38,NULL,'D',117,'1119新增一条班级评价','请对您所在班级作出评价','2025-11-19 21:54:39','2025-11-22 00:00:00','0','0',NULL,'2025-11-19 21:54:58',NULL,'2025-11-20 22:29:59',NULL,'0'),(39,NULL,'C',12,'1120修改一条课程评价','测试修改课程评价结果','2025-11-20 22:29:34','2025-11-22 00:00:00','0','0',NULL,'2025-11-20 22:29:45',NULL,'2025-11-20 22:30:16',NULL,'0');
/*!40000 ALTER TABLE `sys_questionnaire_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_questionnaire_submission`
--

DROP TABLE IF EXISTS `sys_questionnaire_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_questionnaire_submission` (
  `submission_id` bigint NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `meta_id` bigint NOT NULL COMMENT '问卷ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `submit_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `ip_addr` varchar(64) DEFAULT NULL COMMENT 'IP地址',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`submission_id`),
  KEY `idx_submission_meta` (`meta_id`),
  KEY `idx_submission_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='问卷提交记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_questionnaire_submission`
--

LOCK TABLES `sys_questionnaire_submission` WRITE;
/*!40000 ALTER TABLE `sys_questionnaire_submission` DISABLE KEYS */;
INSERT INTO `sys_questionnaire_submission` VALUES (4,1,2,NULL,'2025-09-22 16:50:42',NULL,NULL,'2025-09-22 16:50:42',NULL,'2025-09-22 16:50:42',NULL,'0'),(5,1,4,NULL,'2025-09-23 13:03:31',NULL,NULL,'2025-09-23 13:03:31',NULL,'2025-09-23 13:03:31',NULL,'0'),(6,4,1,NULL,'2025-09-25 22:01:38',NULL,NULL,'2025-09-25 22:01:38',NULL,'2025-09-25 22:01:38',NULL,'0'),(7,4,4,NULL,'2025-09-25 22:10:51',NULL,NULL,'2025-09-25 22:10:51',NULL,'2025-09-25 22:10:51',NULL,'0'),(8,25,4,NULL,'2025-09-26 14:11:28',NULL,NULL,'2025-09-26 14:11:28',NULL,'2025-09-26 14:11:28',NULL,'0'),(9,26,4,NULL,'2025-09-26 15:26:00',NULL,NULL,'2025-09-26 15:26:00',NULL,'2025-09-26 15:26:00',NULL,'0'),(10,27,4,NULL,'2025-10-10 16:34:22',NULL,NULL,'2025-10-10 16:34:22',NULL,'2025-10-10 16:34:22',NULL,'0'),(11,27,1,NULL,'2025-10-10 18:50:54',NULL,NULL,'2025-10-10 18:50:54',NULL,'2025-10-10 18:50:54',NULL,'0'),(12,28,4,NULL,'2025-10-11 12:53:59',NULL,NULL,'2025-10-11 12:53:59',NULL,'2025-10-11 12:53:59',NULL,'0'),(13,29,4,NULL,'2025-10-12 15:46:19',NULL,NULL,'2025-10-12 15:46:19',NULL,'2025-10-12 15:46:19',NULL,'0'),(14,30,4,NULL,'2025-11-06 17:26:32',NULL,NULL,'2025-11-06 17:26:32',NULL,'2025-11-06 17:26:32',NULL,'0'),(15,35,4,NULL,'2025-11-07 14:58:09',NULL,NULL,'2025-11-07 14:58:09',NULL,'2025-11-07 14:58:09',NULL,'0'),(16,37,4,NULL,'2025-11-07 15:35:51',NULL,NULL,'2025-11-07 15:35:51',NULL,'2025-11-07 15:35:51',NULL,'0'),(17,1,1,NULL,'2025-11-07 19:50:58',NULL,NULL,'2025-11-07 19:50:58',NULL,'2025-11-07 19:50:58',NULL,'0'),(18,38,4,NULL,'2025-11-19 22:05:22',NULL,NULL,'2025-11-19 22:05:22',NULL,'2025-11-19 22:05:22',NULL,'0'),(19,38,2,NULL,'2025-11-20 22:56:34',NULL,NULL,'2025-11-20 22:56:34',NULL,'2025-11-20 22:56:34',NULL,'0'),(20,37,2,NULL,'2025-11-21 16:14:57',NULL,NULL,'2025-11-21 16:14:57',NULL,'2025-11-21 16:14:57',NULL,'0');
/*!40000 ALTER TABLE `sys_questionnaire_submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2025-08-27 00:49:58','',NULL,'超级管理员'),(2,'李四','common2',4,'2',1,1,'1','2','admin','2025-08-27 00:49:58','admin','2025-09-11 18:18:46','普通角色'),(3,'普通学员','common',3,'1',1,1,'0','0','admin','2025-09-09 15:23:36','admin','2025-11-21 15:28:47',NULL),(4,'管理员','manager',2,'1',1,1,'0','0','admin','2025-10-10 09:08:13','admin','2025-11-06 17:30:10',NULL);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (3,2105),(3,3006),(3,3008),(3,3009),(3,3014),(3,3016),(3,3017),(3,3019),(3,3021),(3,3022),(3,3032),(3,3048),(3,3052),(3,3053),(3,3054),(3,3055),(3,3056),(3,3057),(3,3059),(3,3060),(3,3061),(3,3062),(3,3063),(3,3065),(3,3070),(3,3078),(3,3079),(3,3080),(3,3081),(3,3082),(4,1),(4,100),(4,103),(4,1000),(4,1001),(4,1002),(4,1003),(4,1004),(4,1005),(4,1006),(4,1016),(4,1017),(4,1018),(4,1019),(4,2000),(4,2001),(4,2003),(4,2004),(4,2005),(4,2101),(4,2102),(4,2103),(4,2104),(4,3000),(4,3001),(4,3002),(4,3003),(4,3004),(4,3009),(4,3013),(4,3015),(4,3018),(4,3020),(4,3024),(4,3026),(4,3027),(4,3028),(4,3029),(4,3030),(4,3031),(4,3032),(4,3033),(4,3034),(4,3035),(4,3036),(4,3037),(4,3039),(4,3040),(4,3041),(4,3042),(4,3043),(4,3044),(4,3045),(4,3046),(4,3047),(4,3048),(4,3049),(4,3050),(4,3051),(4,3064),(4,3065),(4,3066),(4,3067),(4,3068),(4,3069),(4,3071),(4,3072),(4,3073),(4,3074),(4,3075),(4,3076),(4,3077),(4,3081),(4,3082),(4,3083),(4,3084),(4,3085),(4,3086),(4,3087),(4,3088),(4,3089);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,125,'admin','admin','00','admin@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','111.203.137.119','2025-12-10 17:30:58','2025-08-27 00:49:58','admin','2025-08-27 00:49:58','','2025-09-22 08:35:18','管理员'),(2,117,'ry','ry','00','ry@qq.com','15947113700','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','172.20.20.99','2025-12-14 14:14:09','2025-08-27 00:49:58','admin','2025-08-27 00:49:58','manager','2025-11-21 15:29:25','测试员'),(4,117,'牛博','remon','00','17778827153@163.com','17778827153','1','','$2a$10$dxFeUGsEfZ1teccaLAfl6uf/xla0cr0LqRKi13Ewlr6dP/MN0a4Fy','0','0','127.0.0.1','2025-11-21 16:03:44','2025-10-11 12:42:58','admin','2025-09-16 16:48:10','manager','2025-10-12 15:27:41',NULL),(5,125,'manager','manager','00','19317427915@163.com','19317427915','1','','$2a$10$bsZFmTLYRPiSwdEJ.pS96eGd8NwdPc93e8zUkvez2B3kfc4iXOhXe','0','0','172.20.20.99','2025-12-10 18:02:54','2025-10-11 12:33:35','admin','2025-10-10 09:09:38','manager','2025-12-10 17:03:58',NULL),(8,117,'学员1','学员1','00','','17777777777','0','','$2a$10$G8LV8ZIhv7lzefXr94hNt.vJOJLwo.zNgzM50shr7q4L.stJg15ua','0','0','127.0.0.1','2025-11-21 14:52:37',NULL,'manager','2025-11-20 21:55:43','manager','2025-11-20 22:44:54',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,3),(4,3),(5,4),(8,3);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ry-vue'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-15 17:36:02

CREATE DATABASE  IF NOT EXISTS `post.e_demo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `post.e_demo`;
-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: 127.0.0.1    Database: post.e_demo
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.21-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `about`
--

DROP TABLE IF EXISTS `about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `about` (
  `About_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'About ID (Surrogate Key)',
  `About_Developer` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'About Author',
  `About_Contact` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'About Contact',
  `About_Website` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'About Website',
  PRIMARY KEY (`About_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `about`
--

LOCK TABLES `about` WRITE;
/*!40000 ALTER TABLE `about` DISABLE KEYS */;
INSERT INTO `about` VALUES (1,'Scott Grivner','scott.grivner@gmail.com','https://www.linktr.ee/scottgriv');
/*!40000 ALTER TABLE `about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api`
--

DROP TABLE IF EXISTS `api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api` (
  `API_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'API ID (Surrogate Key)',
  `API_Active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'API Active (1=Active, 0=Inactive)',
  `API_Desc` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'API Description',
  `API_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'API Created Date Time',
  PRIMARY KEY (`API_ID`),
  KEY `API_Active_INDEX` (`API_Active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Application Programming Interface (API) Applications';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api`
--

LOCK TABLES `api` WRITE;
/*!40000 ALTER TABLE `api` DISABLE KEYS */;
INSERT INTO `api` VALUES (1,1,'Example API','2022-08-23 01:39:40');
/*!40000 ALTER TABLE `api` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attachment`
--

DROP TABLE IF EXISTS `attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attachment` (
  `Attach_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Attachment ID (Surrogate Key)',
  `Attach_Key` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Attachment Key (Unique Identifier)',
  `Attach_Post_ID` int(11) NOT NULL COMMENT 'Post ID (Reference)',
  `Attach_File_Name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File Name',
  `Attach_File_Extension` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File Extension',
  `Attach_File_Size` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File Size',
  `Attach_File_Path` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File Path',
  `Attach_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  `Attach_Modified` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Modified Date/Time',
  PRIMARY KEY (`Attach_ID`),
  KEY `Attach_Post_ID_FK_idx` (`Attach_Post_ID`),
  KEY `Attach_File_Extension_FK` (`Attach_File_Extension`),
  CONSTRAINT `Attach_Post_ID_FK` FOREIGN KEY (`Attach_Post_ID`) REFERENCES `post` (`Post_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attachment`
--

LOCK TABLES `attachment` WRITE;
/*!40000 ALTER TABLE `attachment` DISABLE KEYS */;
INSERT INTO `attachment` VALUES (1,'mgao_s5',3,'jpg_Sample','jpg','86 KB','http://localhost/Post.e/server/uploads/1/posts/3/jpg_Sample.jpg','2022-10-24 16:56:33','2022-10-24 16:56:33'),(2,'cdtsj8',3,'pdf_Sample','pdf','15 KB','http://localhost/Post.e/server/uploads/1/posts/3/pdf_Sample.pdf','2022-10-24 16:56:33','2022-10-24 16:56:33'),(3,'iYlHeh',3,'png_Sample','png','77 KB','http://localhost/Post.e/server/uploads/1/posts/3/png_Sample.png','2022-10-24 16:56:33','2022-10-24 16:56:34'),(4,'dSYy4L',3,'txt_Sample','txt','212 B','http://localhost/Post.e/server/uploads/1/posts/3/txt_Sample.txt','2022-10-24 16:56:33','2022-10-24 16:56:33'),(5,'UR9Q1q',3,'417E8E2F-215C-4E45-9504-0F154A601C77','jpg','3.4 MB','http://localhost/Post.e/server/uploads/1/posts/3/417E8E2F-215C-4E45-9504-0F154A601C77.jpg','2022-10-28 16:46:05','2022-10-28 16:46:09'),(6,'4CBnnhX',20,'jpg_Sample','jpg','86 KB','http://localhost/Post.e/server/uploads/6/posts/20/jpg_Sample.jpg','2022-10-24 16:56:33','2022-10-24 16:56:33'),(7,'btqlhQ',20,'pdf_Sample','pdf','15 KB','http://localhost/Post.e/server/uploads/6/posts/20/pdf_Sample.pdf','2022-10-24 16:56:33','2022-10-24 16:56:33'),(8,'fU5h9r',20,'png_Sample','png','77 KB','http://localhost/Post.e/server/uploads/6/posts/20/png_Sample.png','2022-10-24 16:56:33','2022-10-24 16:56:34'),(9,'bwFPs1J',20,'txt_Sample','txt','212 B','http://localhost/Post.e/server/uploads/6/posts/20/txt_Sample.txt','2022-10-24 16:56:33','2022-10-24 16:56:33'),(10,'f3fk7f',29,'pdf_Sample','pdf','15 KB','http://localhost/Post.e/server/uploads/10/posts/29/pdf_Sample.pdf','2022-11-01 00:54:54','2022-11-01 00:54:54'),(11,'fWyViq',29,'jpg_Sample','jpg','86 KB','http://localhost/Post.e/server/uploads/10/posts/29/jpg_Sample.jpg','2022-11-01 00:54:54','2022-11-01 00:54:54'),(12,'e9O9kv',29,'png_Sample','png','77 KB','http://localhost/Post.e/server/uploads/10/posts/29/png_Sample.png','2022-11-02 02:01:27','2022-11-02 02:01:27'),(13,'d8Kb2R',30,'jpg_Sample','jpg','86 KB','http://localhost/Post.e/server/uploads/10/posts/30/jpg_Sample.jpg','2022-11-01 02:47:00','2022-11-01 02:47:00'),(14,'bCE5Frg',30,'pdf_Sample','pdf','15 KB','http://localhost/Post.e/server/uploads/10/posts/30/pdf_Sample.pdf','2022-11-01 02:47:00','2022-11-01 02:47:00'),(15,'mQBV2jP',30,'png_Sample','png','77 KB','http://localhost/Post.e/server/uploads/10/posts/30/png_Sample.png','2022-11-03 02:42:25','2022-11-03 02:42:25'),(16,'dAO8Jk',30,'txt_Sample','txt','212 B','http://localhost/Post.e/server/uploads/10/posts/30/txt_Sample.txt','2022-11-01 02:47:00','2022-11-01 02:47:00'),(27,'bqkyhIH',38,'jpg_Sample','jpg','86 KB','http://localhost/Post.e/server/uploads/1/posts/38/jpg_Sample.jpg','2023-01-14 04:54:38','2023-01-14 04:54:38'),(28,'wBagaG',38,'pdf_Sample','pdf','15 KB','http://localhost/Post.e/server/uploads/1/posts/38/pdf_Sample.pdf','2023-01-14 04:54:38','2023-01-14 04:54:38'),(29,'_2rXQ',38,'png_Sample','png','77 KB','http://localhost/Post.e/server/uploads/1/posts/38/png_Sample.png','2023-01-14 04:54:39','2023-01-14 04:54:39'),(30,'bvB3m1o',38,'txt_Sample','txt','212 B','http://localhost/Post.e/server/uploads/1/posts/38/txt_Sample.txt','2023-01-14 04:54:38','2023-01-14 04:54:38'),(31,'Oak3k',38,'92CD7247-891B-424C-A932-C59B6EB846FE','jpg','6.1 MB','http://localhost/Post.e/server/uploads/1/posts/38/92CD7247-891B-424C-A932-C59B6EB846FE.jpg','2023-01-14 20:37:27','2023-01-14 20:37:53');
/*!40000 ALTER TABLE `attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extension`
--

DROP TABLE IF EXISTS `extension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `extension` (
  `Ext_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Extension ID (Surrogate Key)',
  `Ext_Extension` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Extension Code',
  `Ext_Description` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Extension Description',
  `Ext_Image` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Extension Image',
  PRIMARY KEY (`Ext_ID`),
  UNIQUE KEY `Ext_Extension` (`Ext_Extension`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extension`
--

LOCK TABLES `extension` WRITE;
/*!40000 ALTER TABLE `extension` DISABLE KEYS */;
INSERT INTO `extension` VALUES (1,'bmp','Bitmap Image File',''),(2,'gif','Graphical Interchange Format File',''),(3,'jpg','JPEG Image File',''),(4,'jpeg','JPEG Image File',''),(5,'pdf','ortable Document Format File',''),(6,'doc','Microsoft Word Document File',''),(7,'docx','Microsoft Word Document File',''),(8,'xls','Microsoft Excel Spreadsheet File',''),(9,'xlsx','Microsoft Excel Spreadsheet File',''),(10,'csv','Comma-Separated Value File',''),(11,'zip','Data Compression File',''),(12,'m4a','MPEG-4 File',''),(13,'mp3','MPEG-1 Audio Layer 3 File',''),(14,'mp4','MPEG-4 Part 14 File',''),(15,'wav','Waveform Audio Format File',''),(16,'aac','Advanced Audio Coding File',''),(17,'mov','QuickTime Movie File',''),(18,'wmv','Windows Media Video\nWindows Media Video\nWindo',''),(19,'avi','Audio Video Interleave\nAudio Video Interleave',''),(20,'txt','Text File',''),(21,'png','Portable Network Graphic File',''),(22,'rtf','Rich Text Format File',''),(23,'sql','Structured Query Language File','');
/*!40000 ALTER TABLE `extension` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow`
--

DROP TABLE IF EXISTS `follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow` (
  `Fol_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Follow ID (Surrogate Key)',
  `Fol_Follower` int(11) NOT NULL COMMENT 'Follower Profile ID (Reference)',
  `Fol_Following` int(11) NOT NULL COMMENT 'Following Profile ID (Reference)',
  `Fol_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  PRIMARY KEY (`Fol_ID`),
  KEY `Fol_Follower_FK_idx` (`Fol_Follower`),
  KEY `Fol_Following_FK_idx` (`Fol_Following`),
  CONSTRAINT `Fol_Follower_FK` FOREIGN KEY (`Fol_Follower`) REFERENCES `profile` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fol_Following_FK` FOREIGN KEY (`Fol_Following`) REFERENCES `profile` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow`
--

LOCK TABLES `follow` WRITE;
/*!40000 ALTER TABLE `follow` DISABLE KEYS */;
INSERT INTO `follow` VALUES (1,1,2,'2022-10-28 18:53:03'),(2,1,3,'2022-10-28 18:53:04'),(3,1,4,'2022-10-28 18:53:04'),(4,1,5,'2022-10-28 18:53:05'),(5,1,6,'2022-10-28 18:53:06'),(6,1,7,'2022-10-28 18:53:06'),(7,1,8,'2022-10-28 18:53:07'),(8,2,1,'2022-10-28 19:24:51'),(10,2,8,'2022-10-28 19:25:02'),(11,2,4,'2022-10-28 19:25:06'),(12,5,7,'2022-10-28 19:25:36'),(13,5,3,'2022-10-28 19:25:37'),(14,5,6,'2022-10-28 19:25:42');
/*!40000 ALTER TABLE `follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `language` (
  `Lang_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Language ID (Surrogate Key)',
  `Lang_Active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Language Active (1=Active, 0=Inactive)',
  `Lang_Code` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Language ISO Code',
  `Lang_Name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Language Name',
  `Lang_Translated` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Language Translated',
  `Lang_Added` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Added Date/Time',
  `Lang_Removed` timestamp NULL DEFAULT NULL COMMENT 'Removed Date/Time',
  PRIMARY KEY (`Lang_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language`
--

LOCK TABLES `language` WRITE;
/*!40000 ALTER TABLE `language` DISABLE KEYS */;
INSERT INTO `language` VALUES (1,1,'en','English','English','2022-07-16 02:17:18',NULL),(2,1,'ru','Russian','Pусский','2022-07-16 02:17:18',NULL),(3,0,'es','Spanish','Español','2022-07-24 05:21:27',NULL),(4,0,'de','German','Deutsch','2022-07-24 05:21:27',NULL),(5,0,'fr','French','Français','2022-07-24 05:21:27',NULL),(6,0,'hi','Hindi','हिन्दी','2022-07-24 05:21:27',NULL),(7,0,'it','Italian','Italiano','2022-07-24 05:21:27',NULL),(8,0,'ja','Japanese','日本人','2022-07-24 05:21:27',NULL),(9,0,'zh','Chinese','中国','2022-07-24 05:21:27',NULL),(10,0,'na','Unknown','Unknown','2022-07-24 05:21:27',NULL);
/*!40000 ALTER TABLE `language` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `love`
--

DROP TABLE IF EXISTS `love`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `love` (
  `Love_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Love ID (Surrogate Key)',
  `Love_Prof_ID` int(11) NOT NULL COMMENT 'Profile ID (Reference)',
  `Love_Post_ID` int(11) NOT NULL COMMENT 'Post ID (Reference)',
  `Love_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  PRIMARY KEY (`Love_ID`),
  KEY `Love_Post_ID_FK_idx` (`Love_Post_ID`),
  KEY `Love_Prof_ID_FK_idx` (`Love_Prof_ID`),
  CONSTRAINT `Love_Post_ID_FK` FOREIGN KEY (`Love_Post_ID`) REFERENCES `post` (`Post_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Love_Prof_ID_FK` FOREIGN KEY (`Love_Prof_ID`) REFERENCES `profile` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `love`
--

LOCK TABLES `love` WRITE;
/*!40000 ALTER TABLE `love` DISABLE KEYS */;
INSERT INTO `love` VALUES (1,1,1,'2022-10-28 16:44:47'),(2,1,14,'2022-10-28 18:54:12'),(3,1,10,'2022-10-28 18:54:18'),(4,1,9,'2022-10-28 18:54:20'),(5,1,5,'2022-10-28 18:54:24'),(6,1,20,'2022-10-28 18:54:43'),(7,5,22,'2022-10-28 19:26:01'),(9,1,38,'2023-01-14 20:37:57');
/*!40000 ALTER TABLE `love` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter`
--

DROP TABLE IF EXISTS `parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parameter` (
  `Param_Key` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Parameter Key (Surrogate Key)',
  `Param_Active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Parameter Active (1=Active, 0=Inactive)',
  `Param_Type` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Parameter Type',
  `Param_Code` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Parameter Code (Unique)',
  `Param_Value_String` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Parameter Value - String Data Type',
  `Param_Value_Array` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Parameter Value - Array Data Type',
  `Param_Value_Integer` int(11) DEFAULT NULL COMMENT 'Parameter Value - Integer Data Type',
  `Param_Value_Decimal` decimal(10,0) DEFAULT NULL COMMENT 'Parameter Value - Decimal Data Type',
  `Param_Value_Float` float DEFAULT NULL COMMENT 'Parameter Value - Float Data Type',
  `Param_Value_Double` double DEFAULT NULL COMMENT 'Parameter Value - Double Data Type',
  `Param_Value_Boolean` tinyint(1) DEFAULT NULL COMMENT 'Parameter Value - Bool Data Type',
  `Param_Value_TimeStamp` timestamp NULL DEFAULT NULL COMMENT 'Parameter Value - Timestamp Data Type',
  `Param_UOM` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Parameter Unit of Measure (UOM)',
  `Param_Desc` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Parameter Description',
  `Param_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Parameter Created Date Time',
  `Param_Deactivated` timestamp NULL DEFAULT NULL COMMENT 'Parameter Deactivated Date Time',
  PRIMARY KEY (`Param_Key`),
  UNIQUE KEY `Param_Code_UNIQUE` (`Param_Code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Application Parameters';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parameter`
--

LOCK TABLES `parameter` WRITE;
/*!40000 ALTER TABLE `parameter` DISABLE KEYS */;
INSERT INTO `parameter` VALUES (1,1,'SESS','POLICY_SESSION',NULL,NULL,30,NULL,NULL,NULL,NULL,NULL,'Days','Session Policy (in Days) before a Session is Removed','2021-10-07 01:59:06',NULL),(2,1,'POST','MAX_ATTACHMENTS',NULL,NULL,9,NULL,NULL,NULL,NULL,NULL,'Attachment','Maximum Number of Attachments per Post','2022-03-09 04:29:33',NULL),(3,1,'POST','MAX_FILE_SIZE',NULL,NULL,1073741824,NULL,NULL,NULL,NULL,NULL,'Bytes','Maximum File Size of Attachment per File','2022-03-10 02:23:20',NULL);
/*!40000 ALTER TABLE `parameter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pin`
--

DROP TABLE IF EXISTS `pin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pin` (
  `Pin_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Pin ID (Surrogate Key)',
  `Pin_Prof_ID` int(11) NOT NULL COMMENT 'Profile ID (Reference)',
  `Pin_Post_ID` int(11) NOT NULL COMMENT 'Post ID (Reference)',
  `Pin_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  PRIMARY KEY (`Pin_ID`),
  KEY `Pin_Post_ID_FK_idx` (`Pin_Post_ID`),
  KEY `Pin_Prof_ID_FK_idx` (`Pin_Prof_ID`),
  CONSTRAINT `Pin_Post_ID` FOREIGN KEY (`Pin_Post_ID`) REFERENCES `post` (`Post_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Pin_Prof_ID` FOREIGN KEY (`Pin_Prof_ID`) REFERENCES `profile` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pin`
--

LOCK TABLES `pin` WRITE;
/*!40000 ALTER TABLE `pin` DISABLE KEYS */;
INSERT INTO `pin` VALUES (1,1,5,'2022-10-28 18:54:30'),(2,1,20,'2022-10-28 18:55:19'),(3,1,26,'2022-10-28 19:23:34'),(4,5,22,'2022-10-28 19:26:02');
/*!40000 ALTER TABLE `pin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post` (
  `Post_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Post ID (Primary Key)',
  `Post_Key` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Post Key (Unique Identifier)',
  `Post_Type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Post Type',
  `Post_Prof_ID` int(11) NOT NULL COMMENT 'Profile ID (Reference)',
  `Post_Post` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Post Text',
  `Post_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  `Post_Edited` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Edited Date/Time',
  PRIMARY KEY (`Post_ID`),
  KEY `Post_Prof_ID_FK_idx` (`Post_Prof_ID`),
  CONSTRAINT `Post_Prof_ID_FK` FOREIGN KEY (`Post_Prof_ID`) REFERENCES `profile` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,'gx3hm6','Profile',1,'First.Post.Ever!','2022-10-28 16:44:42',NULL),(2,'lOSmQZd','Reply',1,'First.Reply.Ever!','2022-10-28 16:45:00',NULL),(3,'JY-k8','Reply',1,'First.Reply.of.a.Reply.Ever! (With Attachments!)','2022-10-28 16:46:09',NULL),(4,'26qsjl','Profile',2,'We cannot solve our problems with the same thinking we used when we created them.','2022-10-28 17:48:45',NULL),(5,'bfYHc2L','Profile',2,'The true sign of intelligence is not knowledge but imagination.','2022-10-28 17:49:12',NULL),(6,'sv9-yG','Profile',2,'The only reason for time is so that everything doesn\'t happen at once.','2022-10-28 17:49:30',NULL),(7,'mgatC9s','Profile',3,'My mission is to create a world where we can live in harmony with nature.','2022-10-28 17:50:52',NULL),(8,'gkA75x','Profile',3,'The least I can do is speak out for those who cannot speak for themselves.','2022-10-28 17:51:05',NULL),(9,'7Etf6e','Profile',3,'Let us develop respect for all living things.','2022-10-28 17:51:18',NULL),(10,'bzq1GC_','Profile',4,'To suppress free speech is a double wrong. It violates the right of the hearer as well as those of the speaker.','2022-10-28 17:52:45',NULL),(11,'b2sZcBD','Profile',4,'The life of the nation is secure only while the nation is honest, truthful and virtuous.','2022-10-28 17:53:19',NULL),(12,'d3BLr-','Profile',4,'Once you learn to read, you will be forever free.','2022-10-28 17:53:32',NULL),(13,'fIwz93','Profile',5,'If you\'re afraid of butter, use cream.','2022-10-28 17:55:20',NULL),(14,'b3rTPl0M','Profile',5,'I think every woman should have a blowtorch.','2022-10-28 17:55:38',NULL),(15,'nxyRgI','Profile',5,'This is my invariable advice to people: Learn how to cook—try new recipes, learn from your mistakes, be fearless and above all have fun.','2022-10-28 17:56:31',NULL),(16,'h7mgiJ','Profile',6,'I do not think much of a man who is not wiser today than he was yesterday.','2022-10-28 18:38:17',NULL),(17,'jyCx9n','Profile',6,'Folks are usually about as happy as they make their minds up to be.','2022-10-28 18:38:58',NULL),(18,'jDC4GQ','Profile',6,'Whatever you are, be a good one.','2022-10-28 18:39:29',NULL),(19,'otOP1r0','Profile',6,'Books serve to show a man that those original thoughts of his aren\'t very new after all.','2022-10-28 18:40:58',NULL),(20,'G4cdqK','Profile',6,'Half finished work generally proves to be labor lost.','2022-10-28 18:41:39',NULL),(21,'kysKWXs','Profile',7,'Get busy living or get busy dying!','2022-10-28 18:42:33',NULL),(22,'bciAk3p','Profile',7,'Kindness in thinking or giving, creates profoundness and happiness.','2022-10-28 18:42:56',NULL),(23,'c24tNS','Profile',7,'The best way to confront, or deal with, technological innovation is to keep moving technologically.','2022-10-28 18:43:44',NULL),(24,'mQCoJ3z','Profile',8,'Like what you do, and then you will do your best.','2022-10-28 18:44:54',NULL),(25,'tlnNj','Profile',8,'We will always have STEM with us. Some things will drop out of the public eye and will go away, but there will always be science, engineering, and technology.','2022-10-28 18:45:44',NULL),(26,'b1rTH6P','Profile',8,'You are no better than anyone else, and no one is better than you.','2022-10-28 18:51:15',NULL),(27,'j9uMdV','Reply',1,'Wise words Mr. Lincoln!','2022-10-28 19:23:07',NULL),(29,'QP4dxX','Profile',10,'Test Post!','2022-11-05 21:19:04',NULL),(30,'eY5Fiz','Reply',10,'Test Reply!','2022-11-05 21:23:33',NULL),(38,'jD4xZ1','Profile',1,'Thank you for downloading and using Post.e! I appreciate your support!','2023-01-14 20:37:53',NULL);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile` (
  `Prof_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Profile ID (Primary Key)',
  `Prof_Key` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Profile Key (Unique Identifier)',
  `Prof_User` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Profile User Name - User Name (Reference)',
  `Prof_Name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Profile Name',
  `Prof_Pic` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Profile Picture (Server Reference)',
  `Prof_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  `Prof_Edited` timestamp NULL DEFAULT NULL COMMENT 'Edited Date/Time',
  PRIMARY KEY (`Prof_ID`),
  UNIQUE KEY `Prof_User_UNIQUE` (`Prof_User`),
  CONSTRAINT `Prof_ID_FK` FOREIGN KEY (`Prof_ID`) REFERENCES `user` (`User_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (1,'b5dKYoP','Demo123',NULL,'http://127.0.0.1/Post.e/server/uploads/1/1.jpg','2022-10-28 02:09:00','2023-01-14 20:58:01'),(2,'fya81u','Albert','Albert Einstein','http://localhost/Post.e/server/uploads/2/2.jpg','2022-10-28 16:43:47','2022-10-28 16:44:14'),(3,'gtRFO3x','Goodall','Jane Goodall','http://localhost/Post.e/server/uploads/3/3.jpg','2022-10-28 16:46:52','2022-10-28 16:47:15'),(4,'buRTs6v','Frederick1845','Frederick Douglass','http://localhost/Post.e/server/uploads/4/4.jpg','2022-10-28 16:48:29','2022-10-28 16:50:04'),(5,'frEvL','JuliaChild','Julia Child','http://localhost/Post.e/server/uploads/5/5.jpg','2022-10-28 16:50:42','2022-10-28 16:51:12'),(6,'z247TN','HonestAbe','Abraham Lincoln (16th POTUS)','http://localhost/Post.e/server/uploads/6/6.jpg','2022-10-28 16:51:59','2022-10-28 16:52:59'),(7,'chh1r1bC','Morgan','Morgan Freeman','http://localhost/Post.e/server/uploads/7/7.jpg','2022-10-28 16:53:31','2022-10-28 16:56:10'),(8,'uig-z','Coleman','Katherine Coleman Johnson','http://localhost/Post.e/server/uploads/8/8.jpg','2022-10-28 16:56:29','2022-10-28 16:56:51'),(9,'bw7Votf','NewUser7',NULL,NULL,'2022-10-28 18:52:41',NULL),(10,'ePNImLV','NewUser8',NULL,NULL,'2022-11-05 21:18:44',NULL);
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply` (
  `Reply_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Reply ID (Surrogate Key)',
  `Reply_Prof_ID` int(11) NOT NULL COMMENT 'Profile ID (Reference)',
  `Reply_Post_ID` int(11) NOT NULL COMMENT 'Post ID (Reference)',
  `Reply_Post_ID_Ref` int(11) NOT NULL COMMENT 'Replied Post ID (Reference)',
  `Reply_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  PRIMARY KEY (`Reply_ID`),
  KEY `Reply_Prof_ID_FK_idx` (`Reply_Prof_ID`),
  KEY `Reply_Post_ID_FK_idx` (`Reply_Post_ID`),
  CONSTRAINT `Reply_Post_ID_FK` FOREIGN KEY (`Reply_Post_ID`) REFERENCES `post` (`Post_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Reply_Prof_ID_FK` FOREIGN KEY (`Reply_Prof_ID`) REFERENCES `profile` (`Prof_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
INSERT INTO `reply` VALUES (1,1,2,1,'2022-10-28 16:45:00'),(2,1,3,2,'2022-10-28 16:46:09'),(3,1,27,20,'2022-10-28 19:23:07'),(4,10,30,29,'2022-11-05 21:23:33');
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `Ses_ID` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Session GUID (Surrogate Key)',
  `Ses_User` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User ID (Reference)',
  `Ses_Started` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Session Started Date Time',
  `Ses_Expires` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Session Expires Date Time',
  PRIMARY KEY (`Ses_ID`,`Ses_User`),
  UNIQUE KEY `Ses_ID_UNIQUE` (`Ses_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Application Sessions (Note: only Active Sessions will appear here)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES ('23b84258611169ff655848ac8a2749a8','UserSes|i:1;','2023-01-14 23:08:07','2023-02-13 23:08:07');
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `software_language`
--

DROP TABLE IF EXISTS `software_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `software_language` (
  `SL_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Software Language ID (Surrogate Key)',
  `SL_Type` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT 'NA' COMMENT 'Software Language Type (SV=Server Side, UI=User Interface, DB=Database, DV=Device, NA=N/A)',
  `SL_Supported` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Software Language Supported (1=Supported, 0=Not Supported)',
  `SL_Language` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Software Language',
  `SL_Language_Version` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Software Language Version',
  `SL_Extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Software Language Extension',
  `SL_Added` timestamp NULL DEFAULT NULL COMMENT 'Added Date/Time',
  `SL_Removed` timestamp NULL DEFAULT NULL COMMENT 'Removed Date/Time',
  PRIMARY KEY (`SL_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `software_language`
--

LOCK TABLES `software_language` WRITE;
/*!40000 ALTER TABLE `software_language` DISABLE KEYS */;
INSERT INTO `software_language` VALUES (1,'DV',1,'iOS','16.2',NULL,'2022-10-23 21:17:33',NULL),(2,'UI',1,'Objective-C','4.0','.h, .m','2022-10-23 21:17:33',NULL),(3,'UI',1,'Swift','5.7','.swift','2022-10-23 21:17:33',NULL),(4,'SV',1,'PHP','8.1.6','.php','2022-10-23 21:17:33',NULL),(5,'SV',0,'Python','3.11.0','.py',NULL,NULL),(6,'SV',0,'Node.js','18.12.1','.js',NULL,NULL),(7,'SV',0,'Ruby','2.6.10','.rb',NULL,NULL),(8,'SV',0,'Golang','1.19.3','.go',NULL,NULL),(9,'SV',0,'Rust','1.64.0','.rs',NULL,NULL),(10,'SV',0,'Perl','5.30.3','.pl',NULL,NULL),(11,'SV',0,'Java','17.0.5','.java',NULL,NULL),(12,'DB',1,'MariaDB','10.4.21','.sql','2022-10-23 21:17:33',NULL);
/*!40000 ALTER TABLE `software_language` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `User_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'User ID (Surrogate Key)',
  `User_Name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User Name (Reference)',
  `User_Pass` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Password',
  `User_Salt` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Password Salt',
  `User_Login_Status` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Login Status (1=Logged In, 0=Not Logged In)',
  `User_Last_Login` timestamp NULL DEFAULT NULL COMMENT 'Last Login Date/Time',
  `User_Last_Logout` timestamp NULL DEFAULT NULL COMMENT 'Last Logout Date/Time',
  `User_Created` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Created Date/Time',
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `User_Name_UNIQUE` (`User_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Demo123','87b7d9c96600ba5838473fcc50a5f37e1c1a5a9517ff8f22e5e79b9b8cf442932e7a7604357105b0f3a5a0d376de730bd527114b690f655ce65fc6d22cec64e2','76ab98678a8ec3f',1,'2023-01-14 21:39:49','2023-01-14 21:39:38','2022-10-28 02:09:00'),(2,'Albert','53cf4974f6434111fe723510dfa675404fdc6af79e20eb5d283b365b42b1dc2ea3b5a77f57fe44ec657899c245125ce26de98d7ef0e54dd622e34d69f1c77639','8f3a3eaa1292072',0,'2022-10-28 19:24:41','2022-10-28 19:25:22','2022-10-28 16:43:47'),(3,'Goodall','30d7c1c0aec03451799c09ecd2444f0171ff6bdb40603d2b427bc7f09c6641276b6cfbcca33d8b1a8db58f6da4aaab5e504cf6269c02d3b5bb20faa9fe78c843','860ae52cd53b2de',0,'2022-10-28 17:50:17','2022-10-28 17:51:24','2022-10-28 16:46:52'),(4,'Frederick1845','1b54b51fb2623c3d83d429fad9a067836a6439669a3f4873785289647e93c8e1226e8a47d440ddf6c901c6ff6314dad01529e9a5eff9c1cec6dbb11ead39a4a8','4ed28080c34a237',0,'2022-10-28 17:52:14','2022-10-28 17:53:39','2022-10-28 16:48:29'),(5,'JuliaChild','516d64539e1d1483663cf6d518a84249e5726ffdf8b5ff3f577d4bc4acdf6ab4291038f4d31fbcb33864b189da810f5dc1f2a5fa5b7b9a5900c22b3e435ca50d','902c5651149646b',0,'2022-10-28 19:25:31','2022-10-28 19:26:11','2022-10-28 16:50:42'),(6,'HonestAbe','4ca2825b2c6c2e0f76a4fbdf97176cf615a0ee741ef5bec7e3e1f5cbeee819ccd3ec0bb99dafb4092b225af9243680ded4af6a46443e71bd480cc92e7c7ded5f','bd76ba865757b88',0,'2022-10-28 18:37:24','2022-10-28 18:41:47','2022-10-28 16:51:59'),(7,'Morgan','cdb57a35cfd190963c8b4143177d9d064ab2b404ca059ab50e9b588265aef53a1e378b028a4dfa47426ae7f3f6bb04617700df3a67a2c434a45ea09ec6a04cd8','37eb9109a0eaaf2',0,'2022-10-28 18:42:26','2022-10-28 18:43:50','2022-10-28 16:53:31'),(8,'Coleman','4d512245526fcc10a74b079e4d68d1740a8c563b200028bb41bdfa4b15d7094dd8e404cb5c07fc27f849b024ebde46d59531bc2a718b7c21d2fdf1e4efc91c0b','fef857abc6d6b1a',0,'2022-10-28 18:44:46','2022-10-28 18:51:30','2022-10-28 16:56:29'),(9,'NewUser7','91d8882480a07eb27aca67141ba68c4bc74f3489853254803a8eccf2b0c554a8bcc015102e2f2a65de427ec349f63a6ee801b316fbc3c264de8f2449a453671a','7e27751a1695976',0,'2022-11-05 21:24:39','2022-11-05 21:24:46','2022-10-28 18:52:41'),(10,'NewUser8','30e3aa3fce3e77d2b08a4f88afd1d784480535482aa1d01f9bfd16f6c8a2a5eeb8c975720b173d28031bbd8b6a956993f040170065f94ff5dd61e570daf43fbd','8cde09b89d19c42',0,'2022-11-05 21:23:14','2022-11-05 21:23:59','2022-11-05 21:18:44');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_api`
--

DROP TABLE IF EXISTS `user_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_api` (
  `UA_Token` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User API Token (Unique)',
  `UA_Active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'User API Active (1=Valid, 0=Expired)',
  `UA_API` int(11) NOT NULL COMMENT 'API ID (Reference)',
  `UA_Prof` int(11) NOT NULL COMMENT 'User ID (Reference)',
  `UA_Issued` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'User API Issued Date Time',
  `UA_Expired` timestamp NULL DEFAULT NULL COMMENT 'User API Expired Date Time',
  PRIMARY KEY (`UA_Token`),
  UNIQUE KEY `UA_Token_UNIQUE` (`UA_Token`),
  KEY `UA_API_FK_idx` (`UA_API`),
  KEY `UA_Prof_FK_idx` (`UA_Prof`),
  KEY `UA_Active_Prof_FK_idx` (`UA_Active`,`UA_Prof`),
  KEY `UA_Active_FK_idx` (`UA_Active`,`UA_API`),
  CONSTRAINT `UA_API_FK` FOREIGN KEY (`UA_API`) REFERENCES `API` (`API_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `UA_Active_API_FK` FOREIGN KEY (`UA_Active`, `UA_API`) REFERENCES `API` (`API_Active`, `API_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `UA_Prof_FK` FOREIGN KEY (`UA_Prof`) REFERENCES `PROFILE` (`Prof_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tokens issued to Users for external API''s (Application Programming Interface)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_api`
--

LOCK TABLES `user_api` WRITE;
/*!40000 ALTER TABLE `user_api` DISABLE KEYS */;
INSERT INTO `user_api` VALUES ('j2Srmh',1,1,1,'2022-03-27 02:04:42',NULL);
/*!40000 ALTER TABLE `user_api` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_deleted`
--

DROP TABLE IF EXISTS `user_deleted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_deleted` (
  `User_ID` int(11) NOT NULL COMMENT 'User ID (Surrogate Key)',
  `User_Name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'User Name (Reference)',
  `User_Deleted` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Deleted Date/Time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_deleted`
--

LOCK TABLES `user_deleted` WRITE;
/*!40000 ALTER TABLE `user_deleted` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_deleted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_feed`
--

DROP TABLE IF EXISTS `v_feed`;
/*!50001 DROP VIEW IF EXISTS `v_feed`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_feed` AS SELECT 
 1 AS `Post_ID`,
 1 AS `Post_Key`,
 1 AS `Post_Type`,
 1 AS `Post_Prof_ID`,
 1 AS `Post_Prof_User`,
 1 AS `Post_Prof_Pic`,
 1 AS `Post_Post`,
 1 AS `Post_Created`,
 1 AS `Post_Edited`,
 1 AS `Post_Attachment_Count`,
 1 AS `Post_Pin_Count`,
 1 AS `Post_Reply_Count`,
 1 AS `Post_Love_Count`,
 1 AS `Post_Prof_ID_Ref`,
 1 AS `Post_ID_Ref`,
 1 AS `Fol_ID`,
 1 AS `Fol_Follower`,
 1 AS `Fol_Following`,
 1 AS `Fol_Created`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_post`
--

DROP TABLE IF EXISTS `v_post`;
/*!50001 DROP VIEW IF EXISTS `v_post`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_post` AS SELECT 
 1 AS `Post_ID`,
 1 AS `Post_Key`,
 1 AS `Post_Type`,
 1 AS `Post_Prof_ID`,
 1 AS `Post_Prof_User`,
 1 AS `Post_Prof_Pic`,
 1 AS `Post_Post`,
 1 AS `Post_Created`,
 1 AS `Post_Edited`,
 1 AS `Post_Attachment_Count`,
 1 AS `Post_Pin_Count`,
 1 AS `Post_Reply_Count`,
 1 AS `Post_Love_Count`,
 1 AS `Post_Prof_ID_Ref`,
 1 AS `Post_ID_Ref`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_profile`
--

DROP TABLE IF EXISTS `v_profile`;
/*!50001 DROP VIEW IF EXISTS `v_profile`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_profile` AS SELECT 
 1 AS `Prof_ID`,
 1 AS `Prof_Key`,
 1 AS `Prof_User`,
 1 AS `Prof_Name`,
 1 AS `Prof_Pic`,
 1 AS `Prof_Created`,
 1 AS `Prof_Follower_Count`,
 1 AS `Prof_Following_Count`,
 1 AS `Prof_Post_Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_user_api`
--

DROP TABLE IF EXISTS `v_user_api`;
/*!50001 DROP VIEW IF EXISTS `v_user_api`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_user_api` AS SELECT 
 1 AS `Token`,
 1 AS `Type`,
 1 AS `Name`,
 1 AS `Count`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'post.e_demo'
--

--
-- Dumping routines for database 'post.e_demo'
--
/*!50003 DROP FUNCTION IF EXISTS `f_follow_flag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_follow_flag`(PROFID INT, SESID INT) RETURNS tinyint(1)
BEGIN

DECLARE FLAG TINYINT(1);

SET FLAG = (
					SELECT
				    CASE
					-- 1 - FOLLOWING		
					WHEN EXISTS (SELECT Fol_Follower FROM FOLLOW WHERE Fol_Follower = SESID AND Fol_Following = Prof_ID) THEN 1
					-- 0 - NOT FOLLOWING	
					ELSE 0
					END AS FLAG
					FROM PROFILE WHERE Prof_ID = PROFID
);

RETURN FLAG;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `f_post_love_flag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_post_love_flag`(POSTID INT, SESID INT) RETURNS tinyint(1)
BEGIN

DECLARE FLAG TINYINT(1);

SET FLAG = (
					SELECT
				    CASE
					-- 1 - PINNED		
					WHEN EXISTS (SELECT Love_ID FROM LOVE WHERE Love_Prof_ID = SESID AND Love_Post_ID = POSTID) THEN 1
					-- 0 - NOT PINNED
					ELSE 0
					END AS FLAG
					FROM POST WHERE Post_ID = POSTID
);

RETURN FLAG;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `f_post_pin_flag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_post_pin_flag`(POSTID INT, SESID INT) RETURNS tinyint(1)
BEGIN

DECLARE FLAG TINYINT(1);

SET FLAG = (
					SELECT
				    CASE
					-- 1 - PINNED		
					WHEN EXISTS (SELECT Pin_ID FROM PIN WHERE Pin_Prof_ID = SESID AND Pin_Post_ID = POSTID) THEN 1
					-- 0 - NOT PINNED
					ELSE 0
					END AS FLAG
					FROM POST WHERE Post_ID = POSTID
);

RETURN FLAG;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `f_post_reply_flag` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `f_post_reply_flag`(POSTID INT, SESID INT) RETURNS tinyint(1)
BEGIN

DECLARE FLAG TINYINT(1);

SET FLAG = (
					SELECT
				    CASE
					-- 1 - REPLIED		
					WHEN EXISTS (SELECT Reply_ID FROM REPLY WHERE Reply_Prof_ID = SESID AND Reply_Post_ID_Ref = POSTID) THEN 1
					-- 0 - NOT REPLIED
					ELSE 0
					END AS FLAG
					FROM POST WHERE Post_ID = POSTID
);

RETURN FLAG;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `p_find_nested_reply` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_find_nested_reply`(IN REPLYID INT(11))
BEGIN

-- Find Nested Replies (Reply of Reply's)
SELECT 
(SELECT Post_Prof_ID FROM POST WHERE Post_ID = REPLYID) AS Parent_Prof_ID, 
Reply_Prof_ID AS Child_Prof_ID, 
Reply_Post_ID_Ref AS Parent_Post_ID, 
Reply_Post_ID AS Child_Post_ID
FROM REPLY a
WHERE FIND_IN_SET(Reply_Post_ID, (
   SELECT GROUP_CONCAT(Level SEPARATOR ',') FROM (
      SELECT @Ids := (
          SELECT GROUP_CONCAT(Reply_Post_ID SEPARATOR ',')
          FROM REPLY
          WHERE FIND_IN_SET(Reply_Post_ID_Ref, @Ids)
      ) Level
      FROM REPLY
      JOIN (SELECT @Ids := REPLYID) temp1
   ) temp2
)) ORDER BY Reply_Post_ID DESC;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `p_session_expire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_session_expire`()
BEGIN

-- Update USER Last Login Status and Datetime
UPDATE USER SET 
User_Login_Status = 0,
User_Last_Logout = CURRENT_TIMESTAMP
WHERE User_ID IN 
(SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(Ses_User,'"',2),'"',-1) 
FROM SESSION
WHERE Ses_Expires <= NOW());

-- Delete SESSION
DELETE FROM SESSION WHERE Ses_Expires <= NOW();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `p_truncate_all_tables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_truncate_all_tables`(
SELECTED_SCHEMA VARCHAR(100)
)
BEGIN

    DECLARE done int default false;
    DECLARE table_name CHAR(255);

    DECLARE cur1 cursor for 
	SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA = SELECTED_SCHEMA AND TABLE_TYPE = 'BASE TABLE'
    -- Below Line is for specifically Post.e (Comment Out Otherwise)
    AND TABLE_NAME NOT IN ('about', 'api', 'language', 'parameter', 'software_language', 'user_api', 'version');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    open cur1;

    myloop: loop
        fetch cur1 into table_name;
        if done then
            leave myloop;
        end if;
		-- Truncate Tables
        set @sql = CONCAT('TRUNCATE ',' TABLE ', table_name);
        prepare stmt from @sql;
        execute stmt;
        drop prepare stmt;
    end loop;

    close cur1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `p_update_urls` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_update_urls`(IN from_url VARCHAR(50), IN to_url VARCHAR(50))
BEGIN

-- Update Profile Pic URL's
UPDATE PROFILE SET Prof_Pic = REPLACE(Prof_Pic, from_url, to_url)
WHERE Prof_Pic IS NOT NULL;

-- Update Attachment File Path URL's
UPDATE ATTACHMENT SET Attach_File_Path = REPLACE(Attach_File_Path, from_url, to_url)
WHERE Attach_File_Path != '';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_feed`
--

/*!50001 DROP VIEW IF EXISTS `v_feed`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_feed` AS select `v_post`.`Post_ID` AS `Post_ID`,`v_post`.`Post_Key` AS `Post_Key`,`v_post`.`Post_Type` AS `Post_Type`,`v_post`.`Post_Prof_ID` AS `Post_Prof_ID`,`v_post`.`Post_Prof_User` AS `Post_Prof_User`,`v_post`.`Post_Prof_Pic` AS `Post_Prof_Pic`,`v_post`.`Post_Post` AS `Post_Post`,`v_post`.`Post_Created` AS `Post_Created`,`v_post`.`Post_Edited` AS `Post_Edited`,`v_post`.`Post_Attachment_Count` AS `Post_Attachment_Count`,`v_post`.`Post_Pin_Count` AS `Post_Pin_Count`,`v_post`.`Post_Reply_Count` AS `Post_Reply_Count`,`v_post`.`Post_Love_Count` AS `Post_Love_Count`,`v_post`.`Post_Prof_ID_Ref` AS `Post_Prof_ID_Ref`,`v_post`.`Post_ID_Ref` AS `Post_ID_Ref`,`follow`.`Fol_ID` AS `Fol_ID`,`follow`.`Fol_Follower` AS `Fol_Follower`,`follow`.`Fol_Following` AS `Fol_Following`,`follow`.`Fol_Created` AS `Fol_Created` from (`v_post` join `follow` on(`v_post`.`Post_Prof_ID` = `follow`.`Fol_Following`)) where `v_post`.`Post_Type` = 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_post`
--

/*!50001 DROP VIEW IF EXISTS `v_post`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_post` AS select `post`.`Post_ID` AS `Post_ID`,`post`.`Post_Key` AS `Post_Key`,case when (select `reply`.`Reply_Post_ID_Ref` from `reply` where `reply`.`Reply_Post_ID` = `post`.`Post_ID`) is null then '0' else '2' end AS `Post_Type`,`post`.`Post_Prof_ID` AS `Post_Prof_ID`,`profile`.`Prof_User` AS `Post_Prof_User`,`profile`.`Prof_Pic` AS `Post_Prof_Pic`,`post`.`Post_Post` AS `Post_Post`,`post`.`Post_Created` AS `Post_Created`,`post`.`Post_Edited` AS `Post_Edited`,(select count(`attachment`.`Attach_ID`) from `attachment` where `attachment`.`Attach_Post_ID` = `post`.`Post_ID`) AS `Post_Attachment_Count`,(select count(`pin`.`Pin_ID`) from `pin` where `pin`.`Pin_Post_ID` = `post`.`Post_ID`) AS `Post_Pin_Count`,(select count(`reply`.`Reply_ID`) from `reply` where `reply`.`Reply_Post_ID_Ref` = `post`.`Post_ID`) AS `Post_Reply_Count`,(select count(`love`.`Love_ID`) from `love` where `love`.`Love_Post_ID` = `post`.`Post_ID`) AS `Post_Love_Count`,NULL AS `Post_Prof_ID_Ref`,(select `reply`.`Reply_Post_ID_Ref` from `reply` where `reply`.`Reply_Post_ID` = `post`.`Post_ID`) AS `Post_ID_Ref` from (`post` join `profile` on(`post`.`Post_Prof_ID` = `profile`.`Prof_ID`)) union select `post`.`Post_ID` AS `Post_ID`,`post`.`Post_Key` AS `Post_Key`,'1' AS `Post_Type`,`pin`.`Pin_Prof_ID` AS `Post_Prof_ID`,`profile`.`Prof_User` AS `Post_Prof_User`,`profile`.`Prof_Pic` AS `Post_Prof_Pic`,`post`.`Post_Post` AS `Post_Post`,`pin`.`Pin_Created` AS `Post_Created`,`post`.`Post_Edited` AS `Post_Edited`,(select count(`attachment`.`Attach_ID`) from `attachment` where `attachment`.`Attach_Post_ID` = `post`.`Post_ID`) AS `Post_Attachment_Count`,(select count(`pin`.`Pin_ID`) from `pin` where `pin`.`Pin_Post_ID` = `post`.`Post_ID`) AS `Post_Pin_Count`,(select count(`reply`.`Reply_ID`) from `reply` where `reply`.`Reply_Post_ID_Ref` = `post`.`Post_ID`) AS `Post_Reply_Count`,(select count(`love`.`Love_ID`) from `love` where `love`.`Love_Post_ID` = `post`.`Post_ID`) AS `Post_Love_Count`,`post`.`Post_Prof_ID` AS `Post_Prof_ID_Ref`,(select `reply`.`Reply_Post_ID_Ref` from `reply` where `reply`.`Reply_Post_ID` = `post`.`Post_ID`) AS `Post_ID_Ref` from ((`post` join `profile` on(`post`.`Post_Prof_ID` = `profile`.`Prof_ID`)) join `pin` on(`post`.`Post_ID` = `pin`.`Pin_Post_ID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_profile`
--

/*!50001 DROP VIEW IF EXISTS `v_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_profile` AS select `profile`.`Prof_ID` AS `Prof_ID`,`profile`.`Prof_Key` AS `Prof_Key`,`profile`.`Prof_User` AS `Prof_User`,`profile`.`Prof_Name` AS `Prof_Name`,`profile`.`Prof_Pic` AS `Prof_Pic`,`profile`.`Prof_Created` AS `Prof_Created`,(select count(`follow`.`Fol_Follower`) from `follow` where `follow`.`Fol_Following` = `profile`.`Prof_ID`) AS `Prof_Follower_Count`,(select count(`follow`.`Fol_Following`) from `follow` where `follow`.`Fol_Follower` = `profile`.`Prof_ID`) AS `Prof_Following_Count`,(select count(`post`.`Post_ID`) from `post` where `post`.`Post_Prof_ID` = `profile`.`Prof_ID`) AS `Prof_Post_Count` from `profile` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_user_api`
--

/*!50001 DROP VIEW IF EXISTS `v_user_api`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_user_api` AS select `user_api`.`UA_Token` AS `Token`,'USER_OVERALL_TOTAL' AS `Type`,`a`.`Prof_User` AS `Name`,(select count(`profile`.`Prof_ID`) from `profile`) AS `Count` from (`profile` `a` join `user_api` on(`user_api`.`UA_Prof` = `a`.`Prof_ID`)) union select `user_api`.`UA_Token` AS `Token`,'POST_OVERALL_TOTAL' AS `Type`,`a`.`Prof_User` AS `Name`,(select count(`post`.`Post_ID`) from `post`) AS `Count` from (`profile` `a` join `user_api` on(`user_api`.`UA_Prof` = `a`.`Prof_ID`)) union select `user_api`.`UA_Token` AS `Token`,'POST_TOTAL_BY_PROF' AS `Type`,`a`.`Prof_User` AS `Name`,(select `v_profile`.`Prof_Post_Count` from `v_profile` where `v_profile`.`Prof_ID` = `a`.`Prof_ID`) AS `Count` from (`profile` `a` join `user_api` on(`user_api`.`UA_Prof` = `a`.`Prof_ID`)) union select `user_api`.`UA_Token` AS `Token`,'FOLLOWER_TOTAL_BY_PROF' AS `Type`,`a`.`Prof_User` AS `Name`,(select `v_profile`.`Prof_Follower_Count` from `v_profile` where `v_profile`.`Prof_ID` = `a`.`Prof_ID`) AS `Count` from (`profile` `a` join `user_api` on(`user_api`.`UA_Prof` = `a`.`Prof_ID`)) union select `user_api`.`UA_Token` AS `Token`,'FOLLOWING_TOTAL_BY_PROF' AS `Type`,`a`.`Prof_User` AS `Name`,(select `v_profile`.`Prof_Following_Count` from `v_profile` where `v_profile`.`Prof_ID` = `a`.`Prof_ID`) AS `Count` from (`profile` `a` join `user_api` on(`user_api`.`UA_Prof` = `a`.`Prof_ID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-14 18:14:22

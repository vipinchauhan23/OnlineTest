-- MySQL dump 10.13  Distrib 5.6.17, for Win64 (x86_64)
--
-- Host: localhost    Database: onlinetest
-- ------------------------------------------------------
-- Server version	5.6.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `answer`
--

DROP TABLE IF EXISTS `answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer` (
  `answer_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL,
  `selected_option` varchar(500) NOT NULL,
  `online_test_user_id` bigint(20) NOT NULL,
  `created_datetime` datetime NOT NULL,
  PRIMARY KEY (`answer_id`),
  KEY `answer_question_id` (`question_id`),
  KEY `ot_online_test_user_answer_fk_idx` (`online_test_user_id`),
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  CONSTRAINT `ot_online_test_user_answer_fk` FOREIGN KEY (`online_test_user_id`) REFERENCES `onlinetestuser` (`online_test_user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer`
--

LOCK TABLES `answer` WRITE;
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `onlinetest`.`answer_AFTER_INSERT` AFTER INSERT ON `answer` FOR EACH ROW
	BEGIN
        CREATE TEMPORARY TABLE IF NOT EXISTS table1 AS (
			SELECT a.option_id, a.question_id, a.is_correct, a.answer_id, a.user_correct, q.is_multiple_option FROM 
            ( 
				select qo.option_id, qo.question_id, qo.is_correct, IFNULL(op.answer_id,0) answer_id,
                CASE WHEN op.answer_id IS NULL THEN 0 ELSE 1 END user_correct
				from questionoption qo
				left join 
					(select answer.answer_id,answer.question_id,
						SUBSTRING_INDEX(SUBSTRING_INDEX(answer.selected_option, ',', numbers.n), ',', -1) option_id
						from numbers inner join answer
						on CHAR_LENGTH(answer.selected_option)
							-CHAR_LENGTH(REPLACE(answer.selected_option, ',', ''))>=numbers.n-1
						order by answer.answer_id,answer.question_id,n
					) op 
						on qo.option_id = op.option_id and op.answer_id = new.answer_id
						where qo.question_id = new.question_id
			) a
              join question q ON a.question_id = q.question_id);
                
		SET @correctAns:= (select COUNT(question_id) from table1 where is_correct = 1);
		SET @userSelectedAns:= (select COUNT(question_id) from table1 where user_correct = 1);
		SET @userCorrectAns:= (select COUNT(question_id) from table1 where user_correct = 1 AND is_correct = 1);
		SET @userInCorrectAns:= (select COUNT(question_id) from table1 where user_correct = 1 AND is_correct = 0);

		SET @score:= (SELECT DISTINCT
			(CASE WHEN is_multiple_option = 1 THEN
				(CASE WHEN @correctAns < @userSelectedAns THEN -((1/@correctAns)*@userInCorrectAns)
				ELSE ((1/@correctAns)*@userCorrectAns)-((1/@correctAns)*@userInCorrectAns) END)
			ELSE 
				@userCorrectAns END) score
			FROM table1);
		
        SET @isCorrectAns = (SELECT CASE WHEN @score = 1 THEN 1 ELSE 0 end);
        
        DROP TEMPORARY TABLE table1;
            
		INSERT INTO userscore (answer_id, score, is_correct_answer) values (new.answer_id, @score, @isCorrectAns);
        
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `company_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_title` varchar(100) NOT NULL,
  `company_url` varchar(50) NOT NULL,
  `company_address` varchar(200) DEFAULT NULL,
  `company_phone` varchar(40) DEFAULT NULL,
  `company_email` varchar(100) NOT NULL,
  `company_hr_phone` varchar(40) NOT NULL,
  `company_hr_emailid` varchar(100) NOT NULL,
  `smtp_host` varchar(45) NOT NULL DEFAULT '',
  `smtp_port` int(11) NOT NULL DEFAULT '0',
  `smtp_username` varchar(45) NOT NULL DEFAULT '',
  `smtp_password` varchar(45) NOT NULL DEFAULT '',
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'sample','dsfsd','hapur','9326985','h','589658','a@a.com','',0,'','','rkm','rkm','2016-01-19 03:14:07','2016-09-13 21:20:10'),(2,'sample1rkm','','noida','14253985','','74589652','d@d.com','',0,'','','rkm1','MITTAL','2016-01-19 03:14:07','2016-08-12 20:41:55'),(3,'sample1wewe','','noida','14253985','','74589652','d@d.com','',0,'','','MITTAL','MITTAL','2016-08-12 20:31:21','2016-08-12 20:31:21'),(4,'sample','','ds','ad','','sad','sad','',0,'','','rkm','rkm','2016-08-17 03:34:29','2016-08-17 03:34:29'),(5,'sample','','ds','ad','','sad','sad','',0,'','','rkm','rkm','2016-08-17 03:35:41','2016-08-17 03:35:41'),(6,'company1','conqsys.com','dsad','sad','asd','sad','sadf','',0,'','','rkm','rkm','2016-08-17 05:53:09','2016-09-20 11:25:33'),(13,'company123','','dwd','sad','','sad','sadf','',0,'','','rkm','rkm','2016-08-17 06:17:59','2016-08-17 06:17:59'),(14,'condfs','sdfsf','dfs','1231','undefined','121231','hare@gmail.com','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 16:18:52','2016-09-13 16:18:52'),(15,'dsf','dfsgs','sdf','45654','undefined','dfgdfg','445','',0,'','','undefined','undefined','2016-09-13 16:22:22','2016-09-13 16:22:22'),(16,'sdfsdfsdsff','sdf','sf','sdf','undefined','sdf','sdf','',0,'','','undefined','undefined','2016-09-13 16:22:55','2016-09-19 13:33:25'),(17,'ertret','ererterwt','ert','ererter','undefined','ertrew','erterwt','',0,'','','undefined','undefined','2016-09-13 16:25:04','2016-09-13 16:25:04'),(18,'sdf','sdf','sdf','sdf','undefined','sdf','sdf','',0,'','','undefined','undefined','2016-09-13 16:26:19','2016-09-13 16:26:19'),(19,'fdsf','dsf','sdf','dsfsd','dfs','df','undefindfsed','',0,'','','undefined','undefined','2016-09-13 16:41:39','2016-09-13 21:22:58'),(20,'Conqsys','www.conqsys.com','A 161','2123','contact@conqsys.com','123321','hr@conqsys.com','',0,'','','undefined','undefined','2016-09-13 16:42:42','2016-09-13 16:42:42'),(21,'sdf','sdf','sdf','sdf','dsf','sdf','sdfdsf','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 16:46:14','2016-09-13 16:46:14'),(22,'harry','haryy.com','32123','011','harry@gmail.com','12231','1231','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 21:14:15','2016-09-13 21:18:16'),(23,'asdasdas','vip',' asdasdasda','dasddasdas','vipinchauhan','adassadasdsd','asdadasda','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-16 18:08:20','2016-09-19 13:35:06'),(24,'abc','asdsad','abc','2122121212','sads','sdda','dsad','ssas',221121,'sdasda','sasad','Harendra Maurya','Harendra Maurya','2016-09-20 22:46:00','2016-09-20 22:46:00');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyuser`
--

DROP TABLE IF EXISTS `companyuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companyuser` (
  `company_user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`company_user_id`),
  KEY `company_id` (`company_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `companyuser_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `companyuser_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyuser`
--

LOCK TABLES `companyuser` WRITE;
/*!40000 ALTER TABLE `companyuser` DISABLE KEYS */;
INSERT INTO `companyuser` VALUES (3,13,1),(7,1,2),(9,1,4),(10,1,5),(11,1,6),(12,1,7),(13,1,8),(14,1,9),(15,1,10),(16,1,11);
/*!40000 ALTER TABLE `companyuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numbers`
--

DROP TABLE IF EXISTS `numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `numbers` (
  `n` int(11) NOT NULL,
  PRIMARY KEY (`n`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numbers`
--

LOCK TABLES `numbers` WRITE;
/*!40000 ALTER TABLE `numbers` DISABLE KEYS */;
INSERT INTO `numbers` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);
/*!40000 ALTER TABLE `numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlinetest`
--

DROP TABLE IF EXISTS `onlinetest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `onlinetest` (
  `online_test_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) NOT NULL,
  `online_test_title` varchar(200) NOT NULL,
  `test_start_date` datetime NOT NULL,
  `test_end_date` datetime NOT NULL,
  `question_set_id` bigint(20) NOT NULL,
  `test_support_text` text NOT NULL,
  `test_experience_years` int(11) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`online_test_id`),
  KEY `company_id` (`company_id`),
  KEY `question_set_id` (`question_set_id`),
  CONSTRAINT `onlinetest_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `onlinetest_ibfk_2` FOREIGN KEY (`question_set_id`) REFERENCES `questionset` (`question_set_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlinetest`
--

LOCK TABLES `onlinetest` WRITE;
/*!40000 ALTER TABLE `onlinetest` DISABLE KEYS */;
INSERT INTO `onlinetest` VALUES (2,1,'fresher ','2016-10-15 10:00:00','2016-10-28 20:00:00',1,'abc',3,'Vipin ','4','2016-09-19 17:44:13','2016-10-25 10:48:05'),(4,1,'exprience','2016-10-10 00:00:00','2016-10-10 00:00:00',1,'it is hard test',2,'Vipin','Vipin','2016-09-19 19:33:25','2016-09-19 19:33:25'),(5,1,'exprience','2016-10-01 00:00:00','2016-10-01 00:00:00',2,'superab',3,'Vipin','Vipin','2016-09-19 20:48:45','2016-09-19 20:48:45'),(6,1,'fresher','2016-08-16 00:00:00','2016-08-17 00:00:00',3,'cccccccccccc',0,'Vipin','Vipin','2016-09-20 15:13:30','2016-09-20 16:56:05'),(7,1,'sasa','2016-09-14 00:00:00','2016-09-15 00:00:00',2,'aaaaa',4,'Vipin','Vipin','2016-09-20 15:57:08','2016-09-20 15:57:08');
/*!40000 ALTER TABLE `onlinetest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlinetestuser`
--

DROP TABLE IF EXISTS `onlinetestuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `onlinetestuser` (
  `online_test_user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `online_test_id` bigint(20) NOT NULL,
  `test_completed_date` datetime DEFAULT NULL,
  `test_start_date_time` datetime DEFAULT NULL,
  `test_end_date_time` datetime DEFAULT NULL,
  `is_abandoned` tinyint(1) NOT NULL,
  `is_completed` tinyint(1) NOT NULL,
  PRIMARY KEY (`online_test_user_id`),
  KEY `user_id` (`user_id`),
  KEY `online_test_id` (`online_test_id`),
  CONSTRAINT `onlinetestuser_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `onlinetestuser_ibfk_2` FOREIGN KEY (`online_test_id`) REFERENCES `onlinetest` (`online_test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlinetestuser`
--

LOCK TABLES `onlinetestuser` WRITE;
/*!40000 ALTER TABLE `onlinetestuser` DISABLE KEYS */;
INSERT INTO `onlinetestuser` VALUES (1,10,2,NULL,NULL,NULL,0,0),(2,10,4,NULL,NULL,NULL,0,0);
/*!40000 ALTER TABLE `onlinetestuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `optionseries`
--

DROP TABLE IF EXISTS `optionseries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optionseries` (
  `option_series_id` bigint(20) NOT NULL,
  `option_series_name` varchar(45) NOT NULL,
  PRIMARY KEY (`option_series_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optionseries`
--

LOCK TABLES `optionseries` WRITE;
/*!40000 ALTER TABLE `optionseries` DISABLE KEYS */;
INSERT INTO `optionseries` VALUES (1,'Alphabetical Order'),(2,'Numerical Order');
/*!40000 ALTER TABLE `optionseries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question` (
  `question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_description` longtext NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `is_multiple_option` tinyint(1) NOT NULL,
  `answer_explanation` longtext,
  `company_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `question_topic_id` (`topic_id`),
  KEY `question_company_fk_idx` (`company_id`),
  CONSTRAINT `question_company_fk` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,'<p><br></p><p>Meera is older than Eric. Cliff is older than Tanya. Eric is older than Cliff. If the first two statements are true, the third statement is</p>',11,1,'Because the first two statements are true, Eric is the youngest of the three, so the third statement must be false.',1,'admin','4','2016-09-07 20:14:07','2016-10-19 11:05:47'),(2,'<p><img class=\"fr-dib fr-draggable fr-fil\" src=\"https://i.ytimg.com/vi/AnnsFB_iY-A/maxresdefault.jpg\" style=\"width: 300px;\">question line 1</p><p><br></p><p>asdjasjdlkjasd</p><p><br></p>',8,0,'no explanation required for this',1,'admin','admin','2016-09-13 20:08:36','2016-09-22 17:55:31'),(3,'<p>amit dkjahkjhkjhk</p>',3,1,'sdjkahksdasldkhlksaldkhalskd ',1,'admin','admin','2016-09-15 12:35:46','2016-09-19 22:00:33'),(6,'<p><span class=\"fr-emoticon fr-deletable fr-emoticon-img\" style=\"background: url(https://cdnjs.cloudflare.com/ajax/libs/emojione/2.0.1/assets/svg/1f611.svg);\">&nbsp;</span> new question admin<a href=\"http://google.com\">google</a></p>',2,1,'dasdas',1,'admin','admin','2016-09-16 20:30:26','2016-09-22 16:04:18'),(7,'<p>asdas</p>',2,1,'dasdas',1,'admin','admin','2016-09-16 21:04:09','2016-09-19 22:02:19'),(9,'<p>aaa</p>',3,0,'aaa',1,'admin','admin','2016-09-20 13:54:08','2016-09-22 17:56:57'),(10,'<p>xyz</p>',3,1,'xyz',1,'admin','admin','2016-09-20 13:55:45','2016-09-22 17:56:47');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionoption`
--

DROP TABLE IF EXISTS `questionoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionoption` (
  `option_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`option_id`),
  KEY `ot_question_option_fk_idx` (`question_id`),
  CONSTRAINT `ot_question_option_fk` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionoption`
--

LOCK TABLES `questionoption` WRITE;
/*!40000 ALTER TABLE `questionoption` DISABLE KEYS */;
INSERT INTO `questionoption` VALUES (1,'true',1,1),(2,'false',0,1),(3,'uncertain',1,1),(4,'no option',0,1),(5,'true',1,2),(6,'false',0,2),(7,'uncertain',0,2),(8,'option 1',1,3),(9,'optioin 2',0,3),(16,'asdasd',1,6),(17,'asdasd',1,7),(18,'asdasd',0,7),(22,'a',1,9),(23,'b',0,9),(24,'New Option',1,1);
/*!40000 ALTER TABLE `questionoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionset`
--

DROP TABLE IF EXISTS `questionset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionset` (
  `question_set_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_set_title` varchar(200) NOT NULL,
  `total_time` int(11) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `total_questions` int(11) NOT NULL,
  `is_randomize` tinyint(1) NOT NULL,
  `option_series_id` bigint(20) NOT NULL DEFAULT '1',
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`question_set_id`),
  KEY `company_id` (`company_id`),
  KEY `questionset_optionseries_fk_idx` (`option_series_id`),
  CONSTRAINT `questionset_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `questionset_optionseries_fk` FOREIGN KEY (`option_series_id`) REFERENCES `optionseries` (`option_series_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionset`
--

LOCK TABLES `questionset` WRITE;
/*!40000 ALTER TABLE `questionset` DISABLE KEYS */;
INSERT INTO `questionset` VALUES (1,'Set 1',50,1,100,1,1,'admin','4','2016-01-19 03:14:07','2016-10-21 06:57:41'),(2,'Set 2',2200,1,50,0,2,'admin','4','2016-09-13 22:51:03','2016-10-06 14:52:46'),(3,'Set 3',1000,1,20,1,1,'admin','4','2016-09-20 13:35:53','2016-10-06 14:53:09'),(4,'Permutation and combinatios',1200,1,12,1,1,'4','4','2016-09-26 16:53:03','2016-09-26 17:52:50'),(5,'',0,1,0,0,1,'4','4','2016-09-28 19:55:44','2016-09-28 19:55:44'),(6,'test_rkm',132300,1,3,0,1,'4','4','2016-10-14 12:01:42','2016-10-14 12:01:42'),(7,'Set 4',101200,1,20,1,1,'4','4','2016-10-14 16:29:23','2016-10-14 16:29:23'),(12,'Set 5',210900,1,10,1,2,'4','4','2016-10-14 16:41:21','2016-10-14 16:41:21'),(13,'set 6',100100,1,32,1,1,'4','4','2016-10-14 16:44:11','2016-10-14 16:44:11');
/*!40000 ALTER TABLE `questionset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionsetquestion`
--

DROP TABLE IF EXISTS `questionsetquestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionsetquestion` (
  `question_set_question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_set_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`question_set_question_id`),
  KEY `question_set_id` (`question_set_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `questionsetquestion_ibfk_1` FOREIGN KEY (`question_set_id`) REFERENCES `questionset` (`question_set_id`),
  CONSTRAINT `questionsetquestion_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionsetquestion`
--

LOCK TABLES `questionsetquestion` WRITE;
/*!40000 ALTER TABLE `questionsetquestion` DISABLE KEYS */;
INSERT INTO `questionsetquestion` VALUES (6,2,1),(8,1,6),(9,1,3),(12,1,2),(13,7,1),(14,7,3),(23,12,3),(24,13,2);
/*!40000 ALTER TABLE `questionsetquestion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `role_id` bigint(20) NOT NULL,
  `role_name` varchar(45) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'SuperAdmin'),(2,'CompanyAdmin'),(3,'User');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `topic_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `topic_title` varchar(200) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `topic_company_fk_idx` (`company_id`),
  CONSTRAINT `topic_company_fk` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'Logical Questions',1,'admin','admin','2016-09-07 20:31:21','2016-09-21 19:18:33'),(2,'java',1,'vipin','vipin','2016-09-08 16:08:16','2016-09-13 17:26:19'),(3,'c++',1,'vipin','vipin','2016-09-08 19:48:56','2016-09-19 13:39:57'),(6,'objective',1,'vipin','vipin','2016-09-13 20:52:13','2016-09-13 20:52:13'),(8,'Apptitude',1,'vipin','vipin','2016-09-21 16:58:27','2016-09-21 19:20:07'),(10,'angular',1,'vipin','vipin','2016-09-21 19:20:54','2016-09-21 19:20:54'),(11,'reactjs',1,'4','4','2016-09-27 13:58:15','2016-09-27 13:58:15');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_mobile_no` varchar(15) NOT NULL,
  `user_address` varchar(500) DEFAULT NULL,
  `user_pwd` varchar(500) CHARACTER SET utf8 NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_fresher` tinyint(1) NOT NULL,
  `user_exp_month` int(11) NOT NULL,
  `user_exp_year` int(11) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `ot_role_user_fk_idx` (`role_id`),
  CONSTRAINT `ot_user_role_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'rkm','a@a','22','22','$2a$10$IXzmhTiprgxC9WTsSLaxj.o3rWbvWITAALYM.9k9R66dP08laTjDi',1,1,2,2,3,'rkm','tkm','2016-01-19 03:14:07','2016-01-19 03:14:07'),(2,'Amit','b@b.com','8470864154','asd','vuedlHlS',1,0,2,3,3,'admin','admin','2016-09-19 21:19:26','2016-09-20 13:26:02'),(4,'Amit ','amit8774@gmail.com','8470864154','fsdfs skdf','$2a$10$Kup24wp3tJjW/Gr13Z1io./uoYO8WkkfWgjPSxVaOp3B0eQBU9P0q',1,0,2,3,3,'admin','admin','2016-09-22 15:37:29','2016-09-22 15:37:29'),(5,'shashi','acb@abc.com','7597286877','a-163','$2a$10$YiHKUA./O/1pe47.5Y9jYObdIG6H0kQmarfrwJmdt1OBdSDyg04Pm',1,0,14,1,3,'4','4','2016-09-27 18:18:04','2016-09-27 18:18:13'),(6,'','abc@abc.com','','','$2a$10$slBlscLNoOxRxu8cr9u9sOMVkKcGqvD6j9Kjzk7L339d.5MurIqaK',1,0,0,0,3,'4','4','2016-09-27 18:18:26','2016-09-27 18:18:26'),(7,'','acb@abc.comas','','','$2a$10$vj2gmufp2ldyYlzslNzQj.p2U5Ez3xH/vYssB1dO3at33tNLneVoO',1,0,0,0,3,'4','4','2016-09-27 18:18:45','2016-09-27 18:18:45'),(8,'','acb@abc.comasasda','','','$2a$10$e.zNUtK5EJ5M/hxMueTSCOh4tRZTKeh7oM/DM7YHSK/S91SybPj8q',1,0,0,0,3,'4','4','2016-09-27 18:19:03','2016-09-27 18:19:03'),(9,'a','a@b.com','','a','$2a$10$A0g20OwCVm5wq2Pq2VRi5.D4xQjtLszbuXh2XtvgUbqZV0DCuEFjK',1,1,0,0,3,'4','4','2016-09-29 15:27:48','2016-09-29 15:27:48'),(10,'v','v@v','','','$2a$10$2P/rBnbVFgtiW7OtLb9DnOStPtFhwMmkUEiJSQyLYYIRkkI2.EwM6',1,1,0,0,3,'4','4','2016-09-29 15:30:50','2016-09-29 15:30:50'),(11,'','acb@abc.comlkmokm kmikk,pl','','','$2a$10$IXzmhTiprgxC9WTsSLaxj.o3rWbvWITAALYM.9k9R66dP08laTjDi',1,0,0,0,3,'10','10','2016-09-29 15:32:18','2016-09-29 15:32:18');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userscore`
--

DROP TABLE IF EXISTS `userscore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userscore` (
  `score_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `answer_id` bigint(20) NOT NULL,
  `score` decimal(18,2) NOT NULL,
  `is_correct_answer` varchar(45) NOT NULL,
  PRIMARY KEY (`score_id`),
  KEY `answer_score_fk_idx` (`answer_id`),
  CONSTRAINT `answer_score_fk` FOREIGN KEY (`answer_id`) REFERENCES `answer` (`answer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userscore`
--

LOCK TABLES `userscore` WRITE;
/*!40000 ALTER TABLE `userscore` DISABLE KEYS */;
/*!40000 ALTER TABLE `userscore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'onlinetest'
--
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteQuestionSetQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteQuestionSetQuestion`(
IN questionSetQuestionId BIGINT
)
BEGIN

DELETE FROM questionsetquestion where question_set_question_id = questionSetQuestionId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetLoginDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetLoginDetail`(
IN userId BIGINT
)
BEGIN

SELECT 	u.user_id,
		u.user_name,
        u.user_email,
        u.user_mobile_no,
        u.role_id,
        role.role_name,
        cu.company_id,
        c.company_title,
        c.company_url
        
FROM	user u
		INNER JOIN companyuser cu ON cu.user_id = u.user_id
        INNER JOIN company c ON c.company_id = cu.company_id
        INNER JOIN role ON role.role_id = u.role_id
WHERE	u.user_id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOnlineTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOnlineTest`(
IN onlineTestId BIGINT,
IN companyId BIGINT
)
BEGIN

SELECT 	online_test_id,
		company_id,
        online_test_title,
        DATE_FORMAT(test_start_date,'%d/%m/%Y') test_start_date,
        DATE_FORMAT(test_start_date,'%T') test_start_time,
        DATE_FORMAT(test_end_date,'%d/%m/%Y') test_end_date,
        DATE_FORMAT(test_end_date,'%T') test_end_time,
        question_set_id,
        test_support_text,
        test_experience_years,
        created_by,
        updated_by,
        created_datetime,
        updated_datetime
        
FROM	OnlineTest
WHERE	online_test_id = onlineTestId
		AND company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOnlineTestUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOnlineTestUser`(
	IN onlineTestId BIGINT,
    IN companyId BIGINT
)
BEGIN

SELECT 	u.user_id, u.user_name, u.user_email, u.user_mobile_no, u.is_fresher, 
        CONCAT(CONCAT(u.user_exp_year, '.'), u.user_exp_month) user_exp_year,
		IFNULL(otu.online_test_user_id, 0) online_test_user_id, 
        IFNULL(otu.online_test_id, 0) online_test_id,
        0 is_deleted,
        CASE WHEN IFNULL(otu.online_test_user_id, 0) = 0 THEN 0 ELSE 1 END is_selected
FROM 	user u
INNER JOIN companyuser cu 
			ON u.user_id = cu.user_id AND u.role_id = 3
LEFT JOIN onlinetestuser otu 
			ON otu.user_id = u.user_id AND otu.online_test_id = onlineTestId
WHERE cu.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOptionSeries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOptionSeries`()
BEGIN

SELECT * FROM optionseries;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionOption` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionOption`(
IN questionId BIGINT
)
BEGIN
select qo.description,qo.option_id
from question as q 
inner join questionoption as qo ON qo.question_id = q.question_id
where qo.question_id = questionId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionsByCompany` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionsByCompany`(
IN companyId BIGINT
)
BEGIN

SELECT 	DISTINCT A.*,
		COUNT(DISTINCT D.User_Id) as UserCount,
        COUNT(DISTINCT B.question_set_id) as QuestionSetCount,
		COUNT(DISTINCT C.online_test_id) as OnlineTestCount,
        COUNT(DISTINCT option_id) as OptionCount,
		COUNT(DISTINCT pass.answer_id) as PappuPass,
        COUNT(DISTINCT fail.answer_id) as PappuFail
FROM 	question A 
		left JOIN questionsetquestion B ON A.question_id=B.question_id
		left JOIN onlinetest C ON B.question_set_id=C.question_set_id
		LEFT JOIN onlinetestuser D ON D.online_test_id=C.online_test_id
		left JOIN questionoption E ON E.question_id=A.question_id 
		LEFT JOIN answer pass ON A.question_id=pass.question_id AND pass.is_correct_answer=1
		LEFT JOIN answer fail ON A.question_id=fail.question_id AND fail.is_correct_answer=0
where A.company_id=companyId
GROUP BY 	A.question_id,
			A.question_description,
            A.topic_id,
			A.is_multiple_option,
            A.answer_explanation,
            A.company_id,
			A.created_by,
            A.updated_by,
            A.created_datetime,
            A.updated_datetime;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionsByTopic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionsByTopic`(
IN topicId BIGINT
)
BEGIN

SELECT 	question_id,
		question_description,
        topic_id,
        is_multiple_option,
        answer_explanation,
        company_id,
        0 AS is_selected
FROM	question
WHERE	topic_id = topicId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionSetQuestions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionSetQuestions`(
IN questionSetId BIGINT,
IN companyId BIGINT
)
BEGIN
SELECT 	qsq.question_set_question_id,
		qsq.question_set_id,
		qsq.question_id,
        q.question_description,
        false AS is_deleted
        
FROM 	questionset qs
		LEFT JOIN questionsetquestion qsq
		ON qs.question_set_id = qsq.question_set_id 
		LEFT JOIN question q
		ON q.question_id = qsq.question_id
WHERE	qs.question_set_id = questionSetId
		AND qs.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionSets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionSets`(
IN userId BIGINT
)
BEGIN
SELECT otu.online_test_user_id,
	   otu.user_id,
	   ot.online_test_id,
       ot.company_id,
       ot.online_test_title,
	   ot.test_start_date,
       ot.test_end_date,
       ot.test_start_time,
       ot.test_end_time,
       ot.question_set_id,
       qs.question_set_title,
       qs.total_time
FROM   onlinetestuser AS otu 
    INNER JOIN onlinetest AS ot 
		ON otu.online_test_id = ot.online_test_id
	 INNER JOIN questionset AS qs 
		ON ot.question_set_id = qs.question_set_id
        
WHERE otu.user_id=userId 
		AND otu.is_completed = 0
		AND (UTC_TIMESTAMP() BETWEEN ot.test_start_date
        AND ot.test_end_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionStateInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionStateInfo`(IN companyId BIGINT)
BEGIN

SELECT 	DISTINCT A.*,
		COUNT(DISTINCT D.User_Id) as UserCount,
        COUNT(DISTINCT B.question_set_id) as QuestionSetCount,
		COUNT(DISTINCT C.online_test_id) as OnlineTestCount,
        COUNT(DISTINCT option_id) as OptionCount,
		COUNT(DISTINCT pass.answer_id) as CandidatePass,
        COUNT(DISTINCT fail.answer_id) as CandidateFail
FROM 	question A 
		LEFT JOIN questionsetquestion B ON A.question_id=B.question_id
		LEFT JOIN onlinetest C ON B.question_set_id=C.question_set_id
		LEFT JOIN onlinetestuser D ON D.online_test_id=C.online_test_id
		LEFT JOIN questionoption E ON E.question_id=A.question_id 
		LEFT JOIN answer ans ON A.question_id=ans.question_id 
		LEFT JOIN userscore pass ON ans.answer_id=pass.answer_id AND pass.is_correct_answer=1
        LEFT JOIN userscore fail ON ans.answer_id=fail.answer_id AND fail.is_correct_answer=0
WHERE 	A.company_id = companyId
GROUP BY 	A.question_id,
			A.question_description,
            A.topic_id,
			A.is_multiple_option,
            A.answer_explanation,
            A.company_id,
			A.created_by,
            A.updated_by,
            A.created_datetime,
            A.updated_datetime;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetScore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetScore`(
IN id BIGINT
)
BEGIN
select sum(us.score) AS score, count(score_id) AS totalscore,a.online_test_user_id 
		from userscore AS us INNER JOIN answer AS a 
		ON us.answer_id = a.answer_id
		WHERE online_test_user_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetTestQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetTestQuestion`(
IN testUserId BIGINT,
IN userId BIGINT,
IN questionSetId BIGINT
)
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS table1 AS (
		SELECT 	otu.online_test_user_id, 
		otu.user_id, 
        otu.online_test_id, 
        ot.company_id, 
        ot.online_test_title, 
        ot.question_set_id,
		sq.question_id, 
        q.question_description, 
        q.topic_id, 
        q.is_multiple_option,
		a.answer_id 

FROM 	onlinetestuser otu
		INNER JOIN onlinetest ot 
			ON otu.online_test_id = ot.online_test_id
		INNER JOIN questionsetquestion sq 
			ON sq.question_set_id = ot.question_set_id AND sq.question_set_id = questionSetId
		INNER JOIN question q 
			ON q.question_id = sq.question_id
		LEFT JOIN answer a 
			ON a.question_id = q.question_id AND a.online_test_user_id = otu.online_test_user_id

WHERE 	otu.user_id=userId 
		AND otu.is_completed = 0
        AND otu.online_test_user_id = testUserId
		AND (UTC_TIMESTAMP() BETWEEN ot.test_start_date AND ot.test_end_date) 
        );

SET @totalQuestion:= (SELECT COUNT(online_test_user_id) FROM table1);
SET @totalAnsweredQuestion:= (SELECT COUNT(online_test_user_id) FROM table1 where answer_id IS NOT NULL);

SELECT 	table1.*, 
		@totalQuestion totalQuestions, 
        (@totalAnsweredQuestion + 1) selectedQuestion,
        (@totalQuestion - (@totalAnsweredQuestion + 1)) remainingQuestion
		
FROM table1 WHERE answer_id IS NULL
ORDER BY rand() LIMIT 1;  

 DROP TEMPORARY TABLE table1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetTestResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetTestResult`(
IN id BIGINT
)
BEGIN
select sum(us.score) AS score, count(score_id) AS totalscore,a.online_test_user_id 
		from userscore AS us INNER JOIN answer AS a 
		ON us.answer_id = a.answer_id
		WHERE online_test_user_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetUserById`(
IN userId BIGINT,
IN companyId BIGINT
)
BEGIN

select 	*
FROM	user u
		INNER JOIN companyuser cu 
        ON cu.user_id = u.user_id
WHERE	u.role_id = 3 
		AND cu.company_id = companyId
        AND u.user_id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetUsers`(
IN companyId BIGINT
)
BEGIN

SELECT 	u.user_id,
		u.user_name,
        u.user_email,
        u.user_mobile_no,
        u.is_active,
        u.is_fresher,
        u.user_exp_month,
        u.user_exp_year,
        cu.company_id,
        0 isSelected
FROM	user u
		INNER JOIN companyuser cu 
        ON cu.user_id = u.user_id
WHERE	u.role_id = 3 AND cu.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveAnswer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveAnswer`(
IN questionId bigint(20), 
IN selectedOption varchar(500),
IN onlineTestUserId bigint(20),
IN userId BIGINT,
IN questionSetId BIGINT
)
BEGIN
INSERT INTO answer
	(
		question_id, 
		selected_option,
		online_test_user_id,
		created_datetime
	)
	VALUES 
	(
		questionId, 
		selectedOption,
		onlineTestUserId,
		UTC_TIMESTAMP()
	);
            
call spGetTestQuestion(onlineTestUserId, userId, questionSetId);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCompany` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCompany`(
IN id INT, 
IN company_title varchar(100),
IN company_url varchar(50), 
IN company_address varchar(200), 
IN company_phone varchar(40), 
IN company_email varchar(100), 
IN company_hr_phone varchar(40), 
IN company_hr_emailid varchar(100),
IN smtp_host varchar(45), 
IN smtp_port int(11) ,
IN smtp_username varchar(45), 
IN smtp_password varchar(45),
IN created_by varchar(50),
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO company
		(
            company_title,
			company_url, 
			company_address, 
			company_phone, 
			company_email, 
			company_hr_phone, 
			company_hr_emailid ,
            smtp_host,
            smtp_port,
            smtp_username,
            smtp_password,
			created_by ,
			updated_by ,
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			company_title,
			company_url, 
			company_address, 
			company_phone, 
			company_email, 
			company_hr_phone, 
			company_hr_emailid ,
            smtp_host,
            smtp_port,
            smtp_username,
            smtp_password,
			created_by ,
			updated_by ,
            UTC_TIMESTAMP(), 
           UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE company SET
		company_title = company_title,
        company_url = company_url,
        company_address = company_address,
        company_phone = company_phone,
        company_email = company_email,
        company_hr_phone = company_hr_phone,
        company_hr_emailid = company_hr_emailid,
		smtp_host=smtp_host,
        smtp_port=smtp_port,
        smtp_username=smtp_username,
		smtp_password=smtp_password,
		updated_by = updated_by,
        updated_datetime =UTC_TIMESTAMP()
	WHERE company_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCompanyUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCompanyUser`(
IN companyId bigint(20), 
IN userId bigint(20)
)
BEGIN

SET @existCount := (SELECT COUNT(*) from companyuser where company_id = companyId AND user_id = userId);

IF (@existCount = 0)
THEN
		INSERT INTO companyuser
		(
            company_id,
			user_id
			
		)
		VALUES 
		(
			companyId,
			userId
			
		);
            
SELECT LAST_INSERT_ID() as id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveOnlineTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveOnlineTest`(
IN id INT, 
IN company_id bigint(20) ,
IN online_test_title varchar(200), 
IN test_start_date datetime,
IN test_end_date datetime,
IN question_set_id bigint(20),
IN test_support_text text,
IN test_experience_years int(11),
IN created_by varchar(50),
IN updated_by varchar(50) 
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO onlinetest
		(
            company_id, 
			online_test_title ,
			test_start_date ,
			test_end_date ,
			question_set_id,
			test_support_text,
			test_experience_years,
			created_by , 
			updated_by ,
			created_datetime,
			updated_datetime
		)
		VALUES 
		(
			company_id, 
			online_test_title ,
			test_start_date ,
			test_end_date ,
			question_set_id,
			test_support_text,
			test_experience_years,
			created_by , 
			updated_by ,
			UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE onlinetest SET
		company_id = company_id,
        online_test_title = online_test_title,
        test_start_date = test_start_date,
        test_end_date = test_end_date,
        question_set_id = question_set_id,
        test_support_text = test_support_text,
        test_experience_years =test_experience_years,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE online_test_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveOnlinetestuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveOnlinetestuser`(
IN id INT, 
IN user_id bigint(20), 
IN online_test_id bigint(20), 
IN test_completed_date datetime ,
IN test_start_date_time datetime ,
IN test_end_date_time datetime ,
IN is_abonded bit(1) ,
IN is_completed bit(1)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO onlinetestuser
		(
            user_id , 
			online_test_id,
			test_completed_date,
			test_start_date_time,
			test_end_date_time , 
			is_abonded, 
			is_completed
		)
		VALUES 
		(
			user_id , 
			online_test_id,
			test_completed_date,
			test_start_date_time,
			test_end_date_time , 
			is_abonded, 
			is_completed
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE onlinetestuser SET
		test_completed_date = test_completed_date,
        test_start_date_time = test_start_date_time,
        test_end_date_time = test_end_date_time,
        test_end_time = test_end_time,
        is_abonded = is_abonded,
        is_completed = is_completed
	WHERE online_test_user_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestion`(
IN id INT, 
IN question_description longtext, 
IN topic_id INT,
IN is_multiple_option bit,
IN answer_explanation longtext,
IN company_id bigint(20),
IN created_by varchar(50), 
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO question
		(
            question_description, 
            topic_id,
            is_multiple_option,
            answer_explanation,
            company_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			question_description, 
			topic_id,
            is_multiple_option,
            answer_explanation,
            company_id,
			created_by, 
            updated_by,
            UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE question SET
		question_description = question_description,
        topic_id = topic_id,
        is_multiple_option = is_multiple_option,
        answer_explanation = answer_explanation,
        company_id = company_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE question_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionOption` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionOption`(
IN id BIGINT, 
IN description text, 
IN is_correct Bit,
IN question_id BIGINT

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO questionoption
		(
            description, 
            is_correct,
            question_id
            
		)
		VALUES 
		(
			description, 
			is_correct,
            question_id
            
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE questionoption SET
		description = description,
        is_correct = is_correct,
        question_id = question_id
       	WHERE option_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionSet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionSet`(
IN id INT, 
IN question_set_title VARCHAR(200), 
IN total_time INT,
IN company_id BIGINT(20),
IN total_questions INT(11),
IN is_randomize TINYINT,
IN option_series_id BIGINT,
IN created_by varchar(50), 
IN updated_by varchar(50)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO questionset
		(
            question_set_title, 
            total_time,
            company_id,
            total_questions,
            is_randomize,
            option_series_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			question_set_title, 
            total_time,
            company_id,
            total_questions,
            is_randomize,
            option_series_id,
            created_by, 
            updated_by, 
            UTC_TIMESTAMP(), 
			UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE questionset SET
		question_set_title = question_set_title,
        total_time = total_time,
        company_id = company_id,
        total_questions = total_questions,
        is_randomize = is_randomize,
        option_series_id = option_series_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE question_set_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionSetQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionSetQuestion`(
IN id INT, 
IN question_set_id bigint(20),
IN question_id bigint(20)
)
BEGIN
	IF (id = 0)
		THEN
			INSERT INTO questionsetquestion
			(
				question_set_id, 
				question_id 
			)
			VALUES 
			(
				question_set_id, 
				question_id 
			);
				
		SELECT LAST_INSERT_ID() as id;
		ELSE
			UPDATE questionsetquestion SET
				question_set_id = question_set_id,
				question_id = question_id
			WHERE question_set_question_id  = id;
		SELECT id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveTopic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveTopic`(
IN id INT, 
IN topic_title varchar(100), 
IN company_id bigint(20),
IN created_by varchar(100), 
IN updated_by varchar(100)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO topic
		(
            topic_title, 
            company_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
            topic_title,
            company_id,
			created_by, 
            updated_by,
			UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE topic SET
		topic_title = topic_title,
        company_id = company_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE topic_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveUser`(
IN id INT, 
IN user_name varchar(100) ,
IN user_email varchar(100), 
IN user_mobile_no varchar(15) ,
IN user_address varchar(500), 
IN user_pwd varchar(100) ,
IN is_active bit(1) ,
IN is_fresher bit(1) ,
IN user_exp_month int(11) ,
IN user_exp_year int(11), 
IN role_id bigint(20), 
IN created_by varchar(50) ,
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO user
		(
            user_name ,
			user_email, 
			user_mobile_no ,
			user_address , 
			user_pwd ,
			is_active ,
			is_fresher ,
			user_exp_month  ,
			user_exp_year , 
			role_id , 
			created_by  ,
			updated_by, 
			created_datetime ,
			updated_datetime 
		)
		VALUES 
		(
			user_name ,
			user_email, 
			user_mobile_no ,
			user_address , 
			user_pwd ,
			is_active ,
			is_fresher ,
			user_exp_month  ,
			user_exp_year , 
			role_id , 
			created_by  ,
			updated_by, 
			UTC_TIMESTAMP() ,
			UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE user SET
		user_name = user_name,
        user_email = user_email,
        user_mobile_no = user_mobile_no,
        user_address = user_address,
        user_pwd = user_pwd,
        is_active = is_active,
        is_fresher = is_fresher,
        user_exp_month = user_exp_month,
        user_exp_year=user_exp_year,
        role_id=role_id,
        updated_by=updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE user_id  = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateOnlineTestUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spUpdateOnlineTestUser`(
IN id BIGINT, 
IN isTestBegin tinyint
)
BEGIN
IF(isTestBegin = 1)
THEN
	UPDATE 	onlinetestuser 
	SET		test_start_date_time = UTC_TIMESTAMP(),
			is_abandoned = 1,
			is_completed = 0
	WHERE online_test_user_id = id;
    SELECT id;
ELSE
 UPDATE onlinetestuser SET
		test_completed_date = UTC_TIMESTAMP(),
        test_end_date_time = UTC_TIMESTAMP(),
        is_abandoned = 0,
        is_completed = 1
	WHERE online_test_user_id = id;
    SELECT id;
END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `test`(
in listString varchar(255)
)
BEGIN

set @query = concat('select * from testTable where id in (',listString,');');
prepare sql_query from @query;
execute sql_query;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-25 16:20:21

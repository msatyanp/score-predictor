-- MySQL dump 10.13  Distrib 9.6.0, for macos26.4 (arm64)
--
-- Host: localhost    Database: worldcup2026
-- ------------------------------------------------------
-- Server version	9.6.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'b394d7c2-5773-11f1-bdb3-21a5db5c3701:1-190';

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `team1_id` int NOT NULL,
  `team2_id` int NOT NULL,
  `team1_score` int DEFAULT NULL,
  `team2_score` int DEFAULT NULL,
  `yellow_card_count` int DEFAULT NULL,
  `red_card_count` int DEFAULT NULL,
  `kick_off_team_id` int DEFAULT NULL,
  `first_scoring_team_id` int DEFAULT NULL,
  `is_goal_in_first_half` tinyint(1) DEFAULT NULL,
  `match_duration` enum('90','120','PENALTY') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `match_stage` enum('GROUP','R32','R16','QF','SF','3P','F') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `match_datetime` timestamp NOT NULL,
  `match_day` int NOT NULL,
  `venue_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `match_locked` tinyint(1) NOT NULL DEFAULT '0',
  `match_reminder_sent` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_matches_match_datetime` (`match_datetime`),
  KEY `ix_matches_match_day` (`match_day`),
  KEY `ix_matches_match_locked` (`match_locked`),
  KEY `ix_matches_locked_datetime` (`match_locked`,`match_datetime`),
  KEY `ix_matches_team1_id` (`team1_id`),
  KEY `ix_matches_team2_id` (`team2_id`),
  KEY `ix_matches_kick_off_team_id` (`kick_off_team_id`),
  KEY `ix_matches_first_scoring_team_id` (`first_scoring_team_id`),
  CONSTRAINT `fk_matches_first_scoring_team` FOREIGN KEY (`first_scoring_team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `fk_matches_kick_off_team` FOREIGN KEY (`kick_off_team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `fk_matches_team1` FOREIGN KEY (`team1_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `fk_matches_team2` FOREIGN KEY (`team2_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `ck_matches_distinct_teams` CHECK ((`team1_id` <> `team2_id`)),
  CONSTRAINT `ck_matches_first_scoring_team_participant` CHECK (((`first_scoring_team_id` is null) or (`first_scoring_team_id` = `team1_id`) or (`first_scoring_team_id` = `team2_id`))),
  CONSTRAINT `ck_matches_kick_off_team_participant` CHECK (((`kick_off_team_id` is null) or (`kick_off_team_id` = `team1_id`) or (`kick_off_team_id` = `team2_id`))),
  CONSTRAINT `ck_matches_match_day_positive` CHECK ((`match_day` > 0)),
  CONSTRAINT `ck_matches_red_card_count_nonnegative` CHECK (((`red_card_count` is null) or (`red_card_count` >= 0))),
  CONSTRAINT `ck_matches_team1_score_nonnegative` CHECK (((`team1_score` is null) or (`team1_score` >= 0))),
  CONSTRAINT `ck_matches_team2_score_nonnegative` CHECK (((`team2_score` is null) or (`team2_score` >= 0))),
  CONSTRAINT `ck_matches_yellow_card_count_nonnegative` CHECK (((`yellow_card_count` is null) or (`yellow_card_count` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES 
(1,8,23,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-11 13:15:00',1,'Mexico City Stadium',0,0,'2026-05-30 17:11:55','2026-05-31 20:47:34'),
(2,32,47,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-11 20:15:00',1,'Guadalajara Stadium',0,0,'2026-05-30 17:11:55','2026-05-31 20:47:40'),
(3,4,24,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-12 13:15:00',2,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),
(4,12,21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-12 19:15:00',2,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(5,33,44,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-13 13:15:00',3,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(6,3,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-13 16:15:00',3,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(7,30,43,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-13 19:15:00',3,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(8,25,46,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-13 22:15:00',3,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(9,7,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-14 11:15:00',3,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(10,9,19,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-14 14:15:00',4,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(11,27,38,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-14 17:15:00',4,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(12,35,45,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-14 20:15:00',4,'Monterrey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(13,11,14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-15 10:15:00',4,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(14,2,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-15 13:15:00',5,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(15,34,48,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-15 16:15:00',5,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(16,31,40,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-15 19:15:00',5,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(17,6,22,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-16 13:15:00',6,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(18,28,41,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-16 16:15:00',6,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(19,1,13,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-16 19:15:00',6,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(20,26,39,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-16 22:15:00',6,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(21,10,18,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-17 11:15:00',6,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(22,5,15,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-17 14:15:00',7,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(23,29,42,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-17 17:15:00',7,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(24,36,37,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-17 20:15:00',7,'Mexico City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(25,47,23,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-18 10:15:00',7,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(26,44,24,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-18 13:15:00',8,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(27,4,33,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-18 16:15:00',8,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(28,8,32,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-18 19:15:00',8,'Guadalajara Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(29,12,25,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-19 13:15:00',9,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(30,43,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-19 16:15:00',9,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(31,3,30,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-19 19:15:00',9,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(32,46,21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-19 22:15:00',9,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(33,9,35,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-20 11:15:00',9,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(34,7,27,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-20 14:15:00',10,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(35,38,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-20 18:15:00',10,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(36,45,19,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-20 22:15:00',10,'Monterrey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(37,11,34,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-21 10:15:00',10,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(38,2,31,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-21 13:15:00',11,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(39,48,14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-21 16:15:00',11,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(40,40,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-21 19:15:00',11,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(41,1,26,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-22 11:15:00',11,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(42,6,28,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-22 15:15:00',12,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(43,41,22,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-22 18:15:00',12,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(44,39,13,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-22 21:15:00',12,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(45,10,36,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-23 11:15:00',12,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(46,5,29,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-23 14:15:00',13,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(47,42,15,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-23 17:15:00',13,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(48,37,18,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-23 20:15:00',13,'Guadalajara Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(49,44,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 13:15:00',14,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(50,24,33,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 13:15:00',14,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(51,43,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 16:15:00',14,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(52,20,30,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 16:15:00',14,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(53,47,8,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 19:15:00',14,'Mexico City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(54,23,32,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-24 19:15:00',14,'Monterrey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(55,16,27,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 14:15:00',15,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(56,38,7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 14:15:00',15,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(57,19,35,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 17:15:00',15,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(58,45,9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 17:15:00',15,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(59,46,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 20:15:00',15,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(60,21,25,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-25 20:15:00',15,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(61,41,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 13:15:00',16,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(62,22,28,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 13:15:00',16,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(63,14,34,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 18:15:00',16,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(64,48,11,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 18:15:00',16,'Guadalajara Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(65,17,31,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 21:15:00',16,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(66,40,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-26 21:15:00',16,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(67,42,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 15:15:00',17,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(68,15,29,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 15:15:00',17,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(69,37,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 17:45:00',17,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(70,18,36,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 17:45:00',17,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(71,13,26,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 20:15:00',17,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(72,39,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'90','GROUP','2026-06-27 20:15:00',17,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 20:40:18'),(73,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-28 14:15:00',18,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(74,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-29 12:15:00',18,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(75,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-29 03:45:00',19,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(76,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-29 20:15:00',19,'Monterrey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(77,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-30 12:15:00',19,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(78,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-30 16:15:00',20,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(79,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-06-30 20:15:00',20,'Mexico City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(80,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-01 11:15:00',20,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(81,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-01 15:15:00',21,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(82,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-01 19:15:00',21,'San Francisco Bay Area Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(83,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-02 02:15:00',22,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(84,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-02 18:15:00',22,'Toronto Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(85,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-02 22:15:00',22,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(86,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-03 13:15:00',22,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(87,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-03 17:15:00',23,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(88,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R32','2026-07-03 20:45:00',23,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(89,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-04 12:15:00',23,'Houston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(90,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-05 16:15:00',24,'Philadelphia Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(91,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-06 15:15:00',25,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(92,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-05 19:15:00',25,'Mexico City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(93,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-20 14:15:00',26,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(94,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-06 19:15:00',26,'Seattle Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(95,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-07 11:15:00',26,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(96,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'R16','2026-07-07 15:15:00',27,'BC Place Vancouver',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(97,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'QF','2026-07-09 15:15:00',28,'Boston Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(98,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'QF','2026-07-10 14:15:00',29,'Los Angeles Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(99,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'QF','2026-07-11 16:15:00',30,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(100,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'QF','2026-07-11 20:15:00',30,'Kansas City Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(101,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'SF','2026-07-14 14:15:00',31,'Dallas Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(102,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'SF','2026-07-15 14:15:00',32,'Atlanta Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(103,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3P','2026-07-18 16:15:00',33,'Miami Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55'),(104,101,102,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'F','2026-07-19 14:15:00',34,'New York/New Jersey Stadium',0,0,'2026-05-30 17:11:55','2026-05-30 17:11:55');
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `predictions`
--

DROP TABLE IF EXISTS `predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `match_id` int NOT NULL,
  `team1_score` int NOT NULL,
  `team2_score` int NOT NULL,
  `yellow_card_count` int NOT NULL,
  `red_card_count` int NOT NULL,
  `kick_off_team_id` int NOT NULL,
  `first_scoring_team_id` int DEFAULT NULL,
  `is_goal_in_first_half` tinyint(1) DEFAULT NULL,
  `match_duration` enum('90','120','PENALTY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `predicted_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_predictions_user_match` (`user_id`,`match_id`),
  KEY `ix_predictions_user_id` (`user_id`),
  KEY `ix_predictions_match_id` (`match_id`),
  KEY `ix_predictions_kick_off_team_id` (`kick_off_team_id`),
  KEY `ix_predictions_first_scoring_team_id` (`first_scoring_team_id`),
  KEY `ix_predictions_predicted_datetime` (`predicted_datetime`),
  CONSTRAINT `fk_predictions_first_scoring_team` FOREIGN KEY (`first_scoring_team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `fk_predictions_kick_off_team` FOREIGN KEY (`kick_off_team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `fk_predictions_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`),
  CONSTRAINT `fk_predictions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_predictions_red_card_count_nonnegative` CHECK ((`red_card_count` >= 0)),
  CONSTRAINT `ck_predictions_team1_score_nonnegative` CHECK ((`team1_score` >= 0)),
  CONSTRAINT `ck_predictions_team2_score_nonnegative` CHECK ((`team2_score` >= 0)),
  CONSTRAINT `ck_predictions_yellow_card_count_nonnegative` CHECK ((`yellow_card_count` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `friendly_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_settings_name` (`name`),
  CONSTRAINT `ck_settings_friendly_name_not_empty` CHECK ((char_length(`friendly_name`) > 0)),
  CONSTRAINT `ck_settings_name_not_empty` CHECK ((char_length(`name`) > 0)),
  CONSTRAINT `ck_settings_value_not_empty` CHECK ((char_length(`value`) > 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'score_rule','Score Rule','15 points for perfect prediction,5 points when only the winning team is correct','2026-05-30 00:41:39','2026-05-30 00:41:39'),(2,'goal_difference_rule','Goal Difference Rule','5 points for exact goal difference,3 points when goal difference misses by 1,2 points when goal difference misses by 2,1 point when goal difference misses by 3,0 when decided from the penalty','2026-05-30 00:41:39','2026-05-30 00:41:39'),(3,'yellow_card_rule','Yellow Card Rule','5 points for exact card prediction,3 points when card misses by 1,2 points when card difference misses by 2,1 point when card difference misses by 3','2026-05-30 00:41:39','2026-05-30 00:41:39'),(4,'red_card_rule','Red Card Rule','10 points for exact card prediction,5 points when card is predicted and also actually given,-2 points when predicted but not given','2026-05-30 00:41:39','2026-05-30 00:41:39'),(5,'first_scoring_team_rule','First Half Scoring Team Rule','5 points if the prediction is correct','2026-05-30 00:41:39','2026-05-30 00:41:39'),(6,'is_goal_in_first_half_rule','Goal Scored in First Half Rule','5 points if the prediction is correct','2026-05-30 00:41:39','2026-05-30 00:41:39'),(7,'match_duration_rile','Match Duration Rule','5 points for 90 minutes,10 points for 120 minutes,15 points for penalty shootout','2026-05-30 00:41:39','2026-05-30 00:41:39'),(8,'current_match_day','Current Match Day','1','2026-05-31 11:28:06','2026-05-31 11:28:06');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fifa_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fifa_rank` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_teams_name` (`name`),
  KEY `ix_teams_group` (`group`),
  KEY `ix_teams_fifa_code` (`fifa_code`),
  CONSTRAINT `ck_teams_fifa_code_length` CHECK ((char_length(`fifa_code`) between 2 and 3)),
  CONSTRAINT `ck_teams_group_not_empty` CHECK ((char_length(`group`) > 0)),
  CONSTRAINT `ck_teams_name_not_empty` CHECK ((char_length(`name`) > 0))
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'Argentina','J','ARG',3,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(2,'Belgium','G','BEL',9,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(3,'Brazil','C','BRA',6,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(4,'Canada','B','CAN',30,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(5,'England','L','ENG',4,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(6,'France','I','FRA',1,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(7,'Germany','E','GER',10,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(8,'Mexico','A','MEX',15,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(9,'Netherlands','F','NED',7,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(10,'Portugal','K','POR',5,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(11,'Spain','H','ESP',2,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(12,'USA','D','USA',16,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(13,'Algeria','J','ALG',28,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(14,'Cabo Verde','H','CPV',69,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(15,'Croatia','L','CRO',11,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(16,'Curaçao','E','CUW',82,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(17,'Egypt','G','EGY',29,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(18,'Congo DR','K','COD',46,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(19,'Japan','F','JPN',18,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(20,'Morocco','C','MAR',8,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(21,'Paraguay','D','PAR',40,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(22,'Senegal','I','SEN',14,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(23,'South Africa','A','RSA',60,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(24,'Bosnia and Herzegovina','B','BIH',65,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(25,'Australia','D','AUS',27,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(26,'Austria','J','AUT',24,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(27,'Côte d\'Ivoire','E','CIV',34,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(28,'Iraq','I','IRQ',57,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(29,'Ghana','L','GHA',74,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(30,'Haiti','C','HAI',83,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(31,'IR Iran','G','IRN',21,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(32,'Korea Republic','A','KOR',25,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(33,'Qatar','B','QAT',55,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(34,'Saudi Arabia','H','KSA',61,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(35,'Sweden','F','SWE',38,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(36,'Uzbekistan','K','UZB',50,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(37,'Colombia','K','COL',13,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(38,'Ecuador','E','ECU',23,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(39,'Jordan','J','JOR',63,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(40,'New Zealand','G','NZL',85,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(41,'Norway','I','NOR',31,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(42,'Panama','L','PAN',33,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(43,'Scotland','C','SCO',43,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(44,'Switzerland','B','SUI',19,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(45,'Tunisia','F','TUN',44,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(46,'Türkiye','D','TUR',22,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(47,'Czechia','A','CZE',41,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(48,'Uruguay','H','URU',17,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(101,'TBD-H','NA','NEP',0,'2026-05-30 08:39:28','2026-05-30 08:39:28'),(102,'TBD-A','NA','NEP',0,'2026-05-30 08:39:28','2026-05-30 08:39:28');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `mobile_no` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `ix_users_email` (`email`),
  KEY `ix_users_role` (`role`),
  KEY `ix_users_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-01  4:33:55

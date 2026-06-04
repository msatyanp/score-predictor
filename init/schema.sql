 -- MySQL dump 10.13  Distrib 9.6.0, for macos26.4 (arm64)
--
-- Host: localhost    Database: sp_db
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

--
-- Table structure for table `matches`
--

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
  `match_duration` enum('90','120','PENALTY') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `match_stage` enum('GROUP','R32','R16','QF','SF','3P','F') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `match_datetime` timestamp NOT NULL,
  `match_day` int NOT NULL,
  `venue_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `match_locked` tinyint(1) NOT NULL DEFAULT '0',
  `match_reminder_sent` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `first_goal_in` enum('1H','2H','ET') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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

CREATE TABLE `predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `match_id` int NOT NULL,
  `team1_score` int NOT NULL,
  `team2_score` int NOT NULL,
  `yellow_card_count` int NOT NULL,
  `red_card_count` int NOT NULL,
  `kick_off_team_id` int DEFAULT NULL,
  `first_scoring_team_id` int DEFAULT NULL,
  `match_duration` enum('90','120','PENALTY') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `predicted_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `first_goal_in` enum('1H','2H','ET') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



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



--
-- Table structure for table `users`
--

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


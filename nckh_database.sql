-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.27-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for tasks
DROP DATABASE IF EXISTS `tasks`;
CREATE DATABASE IF NOT EXISTS `tasks` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `tasks`;

-- Dumping structure for table tasks.events
DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `EventID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Type` varchar(50) NOT NULL,
  `Text` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`EventID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='để lưu nội dung thông báo';

-- Dumping data for table tasks.events: ~4 rows (approximately)
INSERT INTO `events` (`EventID`, `Type`, `Text`) VALUES
	(1, 'remind', 'sắp kết thúc!'),
	(2, 'create', 'đã thêm công việc mới'),
	(3, 'edit', 'đã cập nhật công việc'),
	(4, 'delete', 'đã xóa công việc');

-- Dumping structure for table tasks.groupmembers
DROP TABLE IF EXISTS `groupmembers`;
CREATE TABLE IF NOT EXISTS `groupmembers` (
  `GroupID` int(11) unsigned NOT NULL,
  `UserID` int(11) unsigned NOT NULL,
  `GroupMemberRole` tinyint(1) unsigned NOT NULL,
  KEY `FK_groupmembers_groups` (`GroupID`),
  KEY `FK_groupmembers_users` (`UserID`),
  CONSTRAINT `FK_groupmembers_groups` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`GroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_groupmembers_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.groupmembers: ~1 rows (approximately)
INSERT INTO `groupmembers` (`GroupID`, `UserID`, `GroupMemberRole`) VALUES
	(1, 2, 1);

-- Dumping structure for table tasks.groups
DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `GroupID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `GroupName` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  `PrivacySetting` enum('public','private','invite-only') NOT NULL,
  PRIMARY KEY (`GroupID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.groups: ~1 rows (approximately)
INSERT INTO `groups` (`GroupID`, `GroupName`, `Description`, `PrivacySetting`) VALUES
	(1, 'The first group ever', 'really', 'public');

-- Dumping structure for table tasks.notifications
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `NotificationID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserToNotify` int(11) unsigned NOT NULL DEFAULT 0,
  `UserWhoFiredEvent` int(11) unsigned NOT NULL DEFAULT 0,
  `EventID` int(11) unsigned NOT NULL DEFAULT 0,
  `DateCreated` datetime NOT NULL DEFAULT current_timestamp(),
  `SeenByUser` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`NotificationID`) USING BTREE,
  KEY `FK_notifications_events` (`EventID`),
  CONSTRAINT `FK_notifications_events` FOREIGN KEY (`EventID`) REFERENCES `events` (`EventID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='hiện nội dung thông báo';

-- Dumping data for table tasks.notifications: ~0 rows (approximately)
INSERT INTO `notifications` (`NotificationID`, `UserToNotify`, `UserWhoFiredEvent`, `EventID`, `DateCreated`, `SeenByUser`) VALUES
	(5, 0, 0, 1, '2024-03-31 14:56:37', 0);

-- Dumping structure for table tasks.recurringtasks
DROP TABLE IF EXISTS `recurringtasks`;
CREATE TABLE IF NOT EXISTS `recurringtasks` (
  `RecurringTaskID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `TaskID` int(11) unsigned NOT NULL,
  `OccurrenceDate` datetime DEFAULT NULL,
  PRIMARY KEY (`RecurringTaskID`),
  KEY `FK_recurringtasks_tasks` (`TaskID`),
  CONSTRAINT `FK_recurringtasks_tasks` FOREIGN KEY (`TaskID`) REFERENCES `tasks` (`TaskID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.recurringtasks: ~0 rows (approximately)
INSERT INTO `recurringtasks` (`RecurringTaskID`, `TaskID`, `OccurrenceDate`) VALUES
	(1, 1, '2024-03-31 15:00:33');

-- Dumping structure for table tasks.tasklists
DROP TABLE IF EXISTS `tasklists`;
CREATE TABLE IF NOT EXISTS `tasklists` (
  `TaskListID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ListName` varchar(50) NOT NULL,
  `GroupID` int(11) unsigned NOT NULL,
  `UserID` int(11) unsigned NOT NULL COMMENT 'Người tạo danh sách đó',
  PRIMARY KEY (`TaskListID`),
  KEY `FK_tasklists_groups` (`GroupID`),
  KEY `FK_tasklists_users` (`UserID`),
  CONSTRAINT `FK_tasklists_groups` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`GroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tasklists_users` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.tasklists: ~1 rows (approximately)
INSERT INTO `tasklists` (`TaskListID`, `ListName`, `GroupID`, `UserID`) VALUES
	(1, 'My list', 1, 2);

-- Dumping structure for table tasks.tasks
DROP TABLE IF EXISTS `tasks`;
CREATE TABLE IF NOT EXISTS `tasks` (
  `TaskID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  `DateCreate` datetime DEFAULT NULL,
  `DateEnd` datetime DEFAULT NULL,
  `RepeatInterval` enum('daily','weekly','monthly','yearly') DEFAULT NULL,
  `RepeatFrequency` int(11) DEFAULT NULL,
  `RepeatEndDate` date DEFAULT NULL,
  PRIMARY KEY (`TaskID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.tasks: ~0 rows (approximately)
INSERT INTO `tasks` (`TaskID`, `Title`, `Description`, `DateCreate`, `DateEnd`, `RepeatInterval`, `RepeatFrequency`, `RepeatEndDate`) VALUES
	(1, 'The first task ever', 'heh', '2024-03-31 14:57:40', '2024-04-07 14:57:35', 'weekly', 1, '2024-04-07');

-- Dumping structure for table tasks.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `UserPassword` varchar(100) NOT NULL,
  `UserRole` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tasks.users: ~2 rows (approximately)
INSERT INTO `users` (`UserID`, `Username`, `UserPassword`, `UserRole`) VALUES
	(1, 'abc', '222', 0),
	(2, 'def', '222', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

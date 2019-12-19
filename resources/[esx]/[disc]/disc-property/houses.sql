-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.37-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for essentialmode
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `essentialmode`;

-- Dumping structure for table essentialmode.disc_property
CREATE TABLE IF NOT EXISTS `disc_property` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `sold` tinyint(1) DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `locked` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Dumping data for table essentialmode.disc_property: ~5 rows (approximately)
/*!40000 ALTER TABLE `disc_property` DISABLE KEYS */;
INSERT INTO `disc_property` (`id`, `name`, `sold`, `price`, `locked`) VALUES
	(1, '3655 Wild Oats Drive', 0, 300000, 1),
	(2, '2044 North Conker Avenue', 0, 250000, 1),
	(3, '2044 Hillcrest Avenue', 0, 275000, 1),
	(4, '2862 Hillcrest Avenue', 0, 265000, 1),
	(5, '2868 Hillcrest Avenue', 0, 200000, 1),
	(6, '2045 North Conker Avenue', 0, 235000, 1),
	(7, '2677 Whispymound Drive', 0, 150000, 1),
	(8, '2133 Mad Wayne Thunder Drive', 0, 125000, 1),
	(9, '1052 Grove Street', 0, 65000, 1),
	(10, '3092 West Mirror Park Drive', 0, 105000, 1);
/*!40000 ALTER TABLE `disc_property` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

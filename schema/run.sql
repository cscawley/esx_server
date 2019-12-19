DROP DATABASE IF EXISTS `essentialmode`;
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;
USE `essentialmode`;

-- Dumping structure for table essentialmode.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `users`
	ADD COLUMN `name` VARCHAR(50) NULL DEFAULT '' AFTER `money`,
	ADD COLUMN `skin` LONGTEXT NULL AFTER `name`,
	ADD COLUMN `job` VARCHAR(50) NULL DEFAULT 'unemployed' AFTER `skin`,
	ADD COLUMN `job_grade` INT NULL DEFAULT 0 AFTER `job`,
	ADD COLUMN `loadout` LONGTEXT NULL AFTER `job_grade`,
	ADD COLUMN `position` VARCHAR(36) NULL AFTER `loadout`
;

DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`weight` INT(11) NOT NULL DEFAULT 1,
	`rare` TINYINT(1) NOT NULL DEFAULT 0,
	`can_remove` TINYINT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`name`)
);

DROP TABLE IF EXISTS `job_grades`;
CREATE TABLE `job_grades` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`job_name` VARCHAR(50) DEFAULT NULL,
	`grade` INT(11) NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`salary` INT(11) NOT NULL,
	`skin_male` LONGTEXT NOT NULL,
	`skin_female` LONGTEXT NOT NULL,
	PRIMARY KEY (`id`)
);

INSERT INTO `job_grades` VALUES (1,'unemployed',0,'unemployed','Unemployed',200,'{}','{}');

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) DEFAULT NULL,
	PRIMARY KEY (`name`)
);

INSERT INTO `jobs` VALUES ('unemployed','Unemployed');

DROP TABLE IF EXISTS `user_accounts`;
CREATE TABLE `user_accounts` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(22) NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`money` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `addon_account`;
CREATE TABLE `addon_account` (
	`name` VARCHAR(60) NOT NULL,
	`label` VARCHAR(100) NOT NULL,
	`shared` INT(11) NOT NULL,
	PRIMARY KEY (`name`)
);

DROP TABLE IF EXISTS `addon_account_data`;
CREATE TABLE `addon_account_data` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`account_name` VARCHAR(100) DEFAULT NULL,
	`money` INT(11) NOT NULL,
	`owner` VARCHAR(100) DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `index_addon_account_data_account_name_owner` (`account_name`, `owner`),
	INDEX `index_addon_account_data_account_name` (`account_name`)
);

DROP TABLE IF EXISTS `user_inventory`;
CREATE TABLE `user_inventory` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(22) NOT NULL,
	`item` VARCHAR(50) NOT NULL,
	`count` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `disc_inventory`;
create table `disc_inventory` (
    `id` int auto_increment primary key,
    `owner` text not null,
    `type` text null,
    `data` longtext not null
);

DROP TABLE IF EXISTS `disc_inventory_itemdata`;
create table `disc_inventory_itemdata`
(
    `id` bigint unsigned auto_increment,
    `name` text not null,
    `description` text null,
    `weight` int default 0 not null,
    `closeonuse` tinyint(1) default 0 not null,
    `max` int default 100 not null,
    UNIQUE KEY `id` (`id`)
);

INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_ADVANCEDRIFLE', 'Advanced Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_APPISTOL', 'AP Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_ASSAULTRIFLE', 'Assault Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_ASSAULTSHOTGUN', 'Assault Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_ASSAULTSMG', 'Assault SMG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_AUTOSHOTGUN', 'Auto Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BALL', 'Ball', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BAT', 'Bat', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BATTLEAXE', 'Battle Axe', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BOTTLE', 'Bottle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BULLPUPRIFLE', 'Bullpup Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BULLPUPSHOTGUN', 'Bullpup Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_BZGAS', 'BZ Gas', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_CARBINERIFLE', 'Carbine Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_COMBATMG', 'Combat MG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_COMBATPDW', 'Combat PDW', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_COMBATPISTOL', 'Combat Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_COMPACTLAUNCHER', 'Compact Launcher', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_COMPACTRIFLE', 'Compact Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_CROWBAR', 'Crowbar', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_DAGGER', 'Dagger', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_DBSHOTGUN', 'Double Barrel Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_DIGISCANNER', 'Digiscanner', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_DOUBLEACTION', 'Double Action Revolver', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_FIREEXTINGUISHER', 'Fire Extinguisher', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_FIREWORK', 'Firework Launcher', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_FLARE', 'Flare', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_FLAREGUN', 'Flare Gun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_FLASHLIGHT', 'Flashlight', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_GARBAGEBAG', 'Garbage Bag', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_GOLFCLUB', 'Golf Club', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_GRENADE', 'Grenade', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_GRENADELAUNCHER', 'Gernade Launcher', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_GUSENBERG', 'Gusenberg', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HAMMER', 'Hammer', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HANDCUFFS', 'Handcuffs', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HATCHET', 'Hatchet', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HEAVYPISTOL', 'Heavy Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HEAVYSHOTGUN', 'Heavy Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HEAVYSNIPER', 'Heavy Sniper', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_HOMINGLAUNCHER', 'Homing Launcher', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_KNIFE', 'Knife', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_KNUCKLE', 'Knuckle Dusters ', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MACHETE', 'Machete', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MACHINEPISTOL', 'Machine Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MARKSMANPISTOL', 'Marksman Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MARKSMANRIFLE', 'Marksman Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MG', 'MG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MICROSMG', 'Micro SMG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MINIGUN', 'Minigun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MINISMG', 'Mini SMG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MOLOTOV', 'Molotov', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_MUSKET', 'Musket', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_NIGHTSTICK', 'Police Baton', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PETROLCAN', 'Petrol Can', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PIPEBOMB', 'Pipe Bomb', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PISTOL', 'Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PISTOL50', 'Police .50', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_POOLCUE', 'Pool Cue', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PROXMINE', 'Proximity Mine', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_PUMPSHOTGUN', 'Pump Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_RAILGUN', 'Rail Gun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_REVOLVER', 'Revolver', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_RPG', 'RPG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SAWNOFFSHOTGUN', 'Sawn Off Shotgun', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SMG', 'SMG', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SMOKEGRENADE', 'Smoke Gernade', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SNIPERRIFLE', 'Sniper Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SNOWBALL', 'Snow Ball', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SNSPISTOL', 'SNS Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SPECIALCARBINE', 'Special Rifle', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_STICKYBOMB', 'Sticky Bombs', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_STINGER', 'Stinger', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_STUNGUN', 'Police Taser', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_SWITCHBLADE', 'Switch Blade', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_VINTAGEPISTOL', 'Vintage Pistol', 1, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('WEAPON_WRENCH', 'Wrench', 1, 0, 1);

DROP TABLE IF EXISTS `disc_ammo`;
create table `disc_ammo`
(
    id bigint unsigned auto_increment PRIMARY KEY,
    owner text not null,
    hash text not null,
    count int default 0 not null,
    constraint id
        unique (id)
);


INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_pistol', 'Pistol Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_pistol_large', 'Pistol Ammo Large', -10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_rifle', 'Rifle Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_rifle_large', 'Rifle Ammo Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_shotgun', 'Shotgun Shells', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_shotgun_large', 'Shotgun Shells Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_smg', 'SMG Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_smg_large', 'SMG Ammo Large', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_snp', 'Sniper Ammo', 10, 0, 1);
INSERT INTO essentialmode.items (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('disc_ammo_snp_large', 'Sniper Ammo Large', 10, 0, 1);

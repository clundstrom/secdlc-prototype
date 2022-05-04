DROP DATABASE IF EXISTS authio;
CREATE DATABASE IF NOT EXISTS authio;
USE authio;

CREATE TABLE IF NOT EXISTS `users` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `sha2` varchar(128) DEFAULT NULL,
    `salt` varchar(128) DEFAULT NULL,
    `privilege_level` int(10) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`name`),
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `inventory` (
    `id` int(10) NOT NULL  AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `count` varchar(128) DEFAULT NULL,
    `description` varchar(128) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`name`),
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DROP DATABASE IF EXISTS authio;
CREATE DATABASE IF NOT EXISTS authio;
USE authio;

CREATE TABLE IF NOT EXISTS `users` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `hash` varchar(60),
    `access` varchar(50) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`name`),
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `inventory` (
    `id` int(10) NOT NULL  AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `quantity` varchar(128) DEFAULT NULL,
    `type` int(10) DEFAULT NULL,
    `description` varchar(128) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`name`),
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
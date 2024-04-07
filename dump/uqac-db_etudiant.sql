-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (arm64)
--
-- Host: localhost    Database: uqac-db
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etudiant` (
  `id_etudiant` varchar(10) NOT NULL,
  `nom_etudiant` varchar(45) NOT NULL,
  `prenom_etudiant` varchar(60) NOT NULL,
  `code_permanent` varchar(15) NOT NULL COMMENT 'CONE31128105',
  `numero_plaque` varchar(10) NOT NULL,
  `courriel_etudiant` varchar(55) NOT NULL,
  `telephone_etudiant` varchar(10) NOT NULL,
  `supprime` tinyint unsigned NOT NULL DEFAULT '0',
  `id_universite` int NOT NULL,
  PRIMARY KEY (`id_etudiant`),
  UNIQUE KEY `courriel_etudiant_UNIQUE` (`courriel_etudiant`),
  UNIQUE KEY `telephone_etudiant_UNIQUE` (`telephone_etudiant`),
  UNIQUE KEY `code_permanent_UNIQUE` (`code_permanent`),
  KEY `universite_fk_idx` (`id_universite`),
  CONSTRAINT `universite_fk` FOREIGN KEY (`id_universite`) REFERENCES `universite` (`id_universite`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etudiant`
--

LOCK TABLES `etudiant` WRITE;
/*!40000 ALTER TABLE `etudiant` DISABLE KEYS */;
/*!40000 ALTER TABLE `etudiant` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-07 18:07:34

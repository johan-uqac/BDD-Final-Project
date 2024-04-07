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
-- Dumping events for database 'uqac-db'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `maj_places_reserves` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `maj_places_reserves` ON SCHEDULE EVERY 5 MINUTE STARTS '2024-04-07 18:06:40' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    UPDATE place_reservee
    SET id_etudiant = NULL, date_heure_arrivee = NULL, date_heure_depart = NULL
    WHERE date_heure_depart <= NOW();
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'uqac-db'
--
/*!50003 DROP FUNCTION IF EXISTS `generer_id_etudiant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `generer_id_etudiant`() RETURNS varchar(10) CHARSET utf8mb4
BEGIN
    DECLARE nouvel_id VARCHAR(10);
    SET nouvel_id = CONCAT('ETU-', LPAD((SELECT IFNULL(MAX(SUBSTRING(id_etudiant, 5)), 0) + 1 FROM etudiant), 6, '0'));
    RETURN nouvel_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `afficher_info_etudiant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `afficher_info_etudiant`(
    IN p_id_etudiant VARCHAR(10)
)
BEGIN
    SELECT * FROM etudiant WHERE id_etudiant = p_id_etudiant;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `configurer_nouvelle_aire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `configurer_nouvelle_aire`(
    IN p_nom_universite VARCHAR(45),
    IN p_sigle VARCHAR(10),
    IN p_numero_civique VARCHAR(5),
    IN p_nom_rue VARCHAR(15),
    IN p_ville VARCHAR(45),
    IN p_province ENUM('Alberta','Colombie-Britannique','Île-du-Prince-Édouard','Manitoba','Nouveau-Brunswick','Nouvelle-Écosse','Ontario','Québec','Saskatchewan','Terre-Neuve-et-Labrador','Territoires du Nord-Ouest','Nunavut','Yukon'),
    IN p_code_postal VARCHAR(7),
    IN p_designation_espace_stationnement VARCHAR(45)
)
BEGIN
    DECLARE new_universite_id INT;
    DECLARE new_espace_stationnement_id INT;
    DECLARE i INT;

    -- Vérification de l'existence de l'université
    SELECT id_universite INTO new_universite_id FROM universite WHERE nom_universite = p_nom_universite AND sigle = p_sigle LIMIT 1;

    IF new_universite_id IS NULL THEN
        -- Création de la nouvelle université
        INSERT INTO universite (nom_universite, sigle, numero_civique, nom_rue, ville, province, code_postal)
        VALUES (p_nom_universite, p_sigle, p_numero_civique, p_nom_rue, p_ville, p_province, p_code_postal);
        SET new_universite_id = LAST_INSERT_ID();
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''université spécifiée existe déjà.';
    END IF;

    -- Création du nouvel espace de stationnement rattaché à l'université
    INSERT INTO espace_stationnement (designation_espace_stationnement, id_universite)
    VALUES (p_designation_espace_stationnement, new_universite_id);
    SET new_espace_stationnement_id = LAST_INSERT_ID();

    -- Création de trois nouvelles allées reliées au nouvel espace de stationnement
    SET i = 1;
    WHILE i <= 3 DO
        INSERT INTO allee (id_espace_stationnement, designation_allee, sens_circulation, nombre_places_dispo, tarif_horaire)
        VALUES (new_espace_stationnement_id, CONCAT('Allee ', i), 
        CASE i 
            WHEN 1 THEN 'Entrée' 
            WHEN 2 THEN 'Sortie' 
            ELSE 'Bidirectionnel' 
        END, 10, 4.5);
        
        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `creer_etudiant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `creer_etudiant`(
    IN p_nom_etudiant VARCHAR(45),
    IN p_prenom_etudiant VARCHAR(60),
    IN p_code_permanent VARCHAR(15),
    IN p_numero_plaque VARCHAR(10),
    IN p_courriel_etudiant VARCHAR(55),
    IN p_telephone_etudiant VARCHAR(10),
    IN p_id_universite INT
)
BEGIN
    -- Validation des données fournies
    IF p_nom_etudiant IS NULL OR p_prenom_etudiant IS NULL OR p_code_permanent IS NULL OR p_numero_plaque IS NULL OR p_courriel_etudiant IS NULL OR p_telephone_etudiant IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Toutes les informations nécessaires doivent être fournies.';
    END IF;
    
    -- Validation du format du courriel
    IF p_courriel_etudiant NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format du courriel invalide.';
    END IF;
    
    -- Validation du format du numéro de téléphone
    IF p_telephone_etudiant NOT REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format du numéro de téléphone invalide.';
    END IF;
    
    -- Vérification de l'existence de l'étudiant dans la base de données
    IF EXISTS (SELECT 1 FROM etudiant WHERE code_permanent = p_code_permanent) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant avec ce code permanent existe déjà.';
    END IF;

    -- Création du nouvel étudiant
    INSERT INTO etudiant (nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite)
    VALUES (p_nom_etudiant, p_prenom_etudiant, p_code_permanent, p_numero_plaque, p_courriel_etudiant, p_telephone_etudiant, p_id_universite);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mettre_a_jour_info_etudiant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mettre_a_jour_info_etudiant`(
    IN p_id_etudiant VARCHAR(10),
    IN p_nom_etudiant VARCHAR(45),
    IN p_prenom_etudiant VARCHAR(60),
    IN p_code_permanent VARCHAR(15),
    IN p_numero_plaque VARCHAR(10),
    IN p_courriel_etudiant VARCHAR(55),
    IN p_telephone_etudiant VARCHAR(10),
    IN p_id_universite INT
)
BEGIN
    -- Sauvegarder les anciennes valeurs dans l'historique
    INSERT INTO historique_etudiant (id_etudiant, ancien_nom_etudiant, ancien_prenom_etudiant, ancien_code_permanent, ancien_numero_plaque, ancien_courriel_etudiant, ancien_telephone_etudiant, ancien_id_universite, date_modification)
    SELECT id_etudiant, nom_etudiant, prenom_etudiant, code_permanent, numero_plaque, courriel_etudiant, telephone_etudiant, id_universite, NOW()
    FROM etudiant
    WHERE id_etudiant = p_id_etudiant;

    -- Mettre à jour les informations de l'étudiant
    UPDATE etudiant
    SET nom_etudiant = p_nom_etudiant,
        prenom_etudiant = p_prenom_etudiant,
        code_permanent = p_code_permanent,
        numero_plaque = p_numero_plaque,
        courriel_etudiant = p_courriel_etudiant,
        telephone_etudiant = p_telephone_etudiant,
        id_universite = p_id_universite
    WHERE id_etudiant = p_id_etudiant;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rapport_statistique_aires_stationnement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rapport_statistique_aires_stationnement`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nom_universite VARCHAR(100);
    DECLARE nb_etudiants INT;
    DECLARE nb_espaces_stationnement INT;
    DECLARE nb_agents_surveillance INT;
    DECLARE nb_allees INT;
    DECLARE nb_places INT;
    DECLARE nb_places_handicapes INT;
    DECLARE nb_places_disponibles INT;
    DECLARE nb_places_reservees INT;
    DECLARE moyenne_reservations FLOAT;
    DECLARE date_plus_reservations DATE;
    DECLARE date_moins_reservations DATE;
    
    -- Déclaration d'un curseur pour parcourir les aires de stationnement
    DECLARE cur CURSOR FOR
        SELECT u.nom_universite, 
               COUNT(DISTINCT e.id_etudiant) AS nb_etudiants,
               COUNT(DISTINCT e.id_espace_stationnement) AS nb_espaces_stationnement,
               COUNT(DISTINCT es.id_agent) AS nb_agents_surveillance,
               COUNT(DISTINCT a.id_allee) AS nb_allees,
               COUNT(DISTINCT p.id_place) AS nb_places,
               SUM(CASE WHEN p.type_de_place = 'personnes à mobilité réduite' THEN 1 ELSE 0 END) AS nb_places_handicapes,
               SUM(CASE WHEN pr.id_etudiant IS NULL THEN 1 ELSE 0 END) AS nb_places_disponibles,
               SUM(CASE WHEN pr.id_etudiant IS NOT NULL THEN 1 ELSE 0 END) AS nb_places_reservees,
               AVG(CASE WHEN YEAR(pr.date_heure_debut) = 2023 THEN 1 ELSE 0 END) AS moyenne_reservations,
               MAX(pr.date_heure_debut) AS date_plus_reservations,
               MIN(pr.date_heure_debut) AS date_moins_reservations
        FROM universite u
        LEFT JOIN espace_stationnement e ON u.id_universite = e.id_universite
        LEFT JOIN espace_surveille es ON e.id_espace_stationnement = es.id_espace_stationnement
        LEFT JOIN allee a ON e.id_espace_stationnement = a.id_espace_stationnement
        LEFT JOIN place p ON a.id_allee = p.id_allee
        LEFT JOIN place_reservee pr ON p.id_place = pr.id_place
        GROUP BY u.nom_universite;

    -- Déclaration des handlers pour la gestion des erreurs
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Ouverture du curseur
    OPEN cur;
    
    -- Initialisation des variables
    SET nb_etudiants = 0;
    SET nb_espaces_stationnement = 0;
    SET nb_agents_surveillance = 0;
    SET nb_allees = 0;
    SET nb_places = 0;
    SET nb_places_handicapes = 0;
    SET nb_places_disponibles = 0;
    SET nb_places_reservees = 0;
    SET moyenne_reservations = 0;
    SET date_plus_reservations = NULL;
    SET date_moins_reservations = NULL;

    -- Boucle pour parcourir les résultats du curseur
    read_loop: LOOP
        FETCH cur INTO nom_universite, nb_etudiants, nb_espaces_stationnement, nb_agents_surveillance, nb_allees, nb_places, nb_places_handicapes, nb_places_disponibles, nb_places_reservees, moyenne_reservations, date_plus_reservations, date_moins_reservations;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Affichage des statistiques pour chaque université
        SELECT nom_universite, nb_etudiants, nb_espaces_stationnement, nb_agents_surveillance, nb_allees, nb_places, nb_places_handicapes, nb_places_disponibles, nb_places_reservees, moyenne_reservations, date_plus_reservations, date_moins_reservations;
    END LOOP;
    
    -- Fermeture du curseur
    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `supprimer_etudiant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `supprimer_etudiant`(
    IN p_id_etudiant VARCHAR(10)
)
BEGIN
    -- Vérification de l'existence de l'étudiant dans la base de données
    IF NOT EXISTS (SELECT 1 FROM etudiant WHERE id_etudiant = p_id_etudiant) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
    END IF;

    -- Supprimer l'étudiant en passant la valeur de la colonne 'supprime' de 0 à 1
    UPDATE etudiant
    SET supprime = 1
    WHERE id_etudiant = p_id_etudiant;
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

-- Dump completed on 2024-04-07 18:07:34

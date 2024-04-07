DELIMITER //

CREATE PROCEDURE rapport_statistique_aires_stationnement()
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
END;
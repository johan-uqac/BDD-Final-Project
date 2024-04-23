DELIMITER $$

CREATE PROCEDURE reserve_parking_spot(
    IN student_id VARCHAR(10),
    IN arrival_datetime DATETIME,
    IN departure_datetime DATETIME
)
BEGIN
    DECLARE parking_space_id INT;
    DECLARE parking_spot_id INT;
    DECLARE course_count INT;
    
    -- Validation des paramètres
    IF student_id IS NULL OR arrival_datetime IS NULL OR departure_datetime IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: All parameters must be provided.';
    END IF;

    -- Vérifie si un étudiant est inscrit à un cours pendant les heures de stationnement
    SET course_count = (
        SELECT COUNT(*)
        FROM cours_suivi cs
        WHERE cs.id_etudiant = student_id
        AND (arrival_datetime BETWEEN cs.heure_debut AND cs.heure_fin
             OR departure_datetime BETWEEN cs.heure_debut AND cs.heure_fin)
    );

    IF course_count = 0 THEN
        -- Enregistre la violation de stationnement
        INSERT INTO violation_stationnement (code_permanent, nom_etudiant, prenom_etudiant, numero_plaque, date_tentative_reservation)
        SELECT e.code_permanent, e.nom_etudiant, e.prenom_etudiant, e.numero_plaque, NOW()
        FROM etudiant e
        WHERE e.id_etudiant = student_id;

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Student is not enrolled in a course during parking hours.';
    END IF;

    -- Trouve un espace de stationnement avec des places disponibles
    SELECT p.id_espace_stationnement INTO parking_space_id
    FROM espace_stationnement p
    WHERE p.nombre_places_dispo > 0
    LIMIT 1;

    IF parking_space_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No available parking spots.';
    END IF;

    SELECT pl.id_place INTO parking_spot_id
    FROM place pl
    WHERE pl.id_allee IN (SELECT a.id_allee FROM allee a WHERE a.id_espace_stationnement = parking_space_id)
    AND pl.disponibilite = 'Oui'
    LIMIT 1;

    IF parking_spot_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No available parking spots.';
    END IF;

    -- Réserve une place de stationnement pour l'étudiant
    INSERT INTO place_reservee (id_place, id_etudiant, date_heure_debut, date_heure_fin)
    VALUES (parking_spot_id, student_id, arrival_datetime, departure_datetime);

    -- Met à jour le nombre de places de stationnement disponibles
    UPDATE allee a
    SET a.nombre_places_dispo = a.nombre_places_dispo - 1
    WHERE a.id_allee IN (SELECT pl.id_allee FROM place pl WHERE pl.id_place = parking_spot_id);

    -- Affiche les détails de la réservation
    SELECT es.designation_espace_stationnement, a.designation_allee, a.sens_circulation, pl.id_place, pl.type_de_place, 
           TIMEDIFF(departure_datetime, arrival_datetime) * es.tarif_horaire AS montant_a_payer, 
           arrival_datetime AS date_heure_arrivee, departure_datetime AS date_heure_depart
    FROM espace_stationnement es
    JOIN allee a ON es.id_espace_stationnement = a.id_espace_stationnement
    JOIN place pl ON a.id_allee = pl.id_allee
    WHERE pl.id_place = parking_spot_id;
END$$

DELIMITER ;

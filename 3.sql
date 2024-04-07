DELIMITER //

CREATE PROCEDURE reserver_place_stationnement(
    IN p_id_etudiant VARCHAR(10),
    IN p_date_heure_arrivee DATETIME,
    IN p_date_heure_depart DATETIME
)
BEGIN
    DECLARE id_place INT;
    DECLARE id_allee INT;
    DECLARE id_espace_stationnement INT;
    
    -- Validation des données fournies
    IF p_id_etudiant IS NULL OR p_date_heure_arrivee IS NULL OR p_date_heure_depart IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Toutes les informations nécessaires doivent être fournies.';
    END IF;
    
    -- Vérification de l'existence de l'étudiant
    IF NOT EXISTS (SELECT 1 FROM etudiant WHERE id_etudiant = p_id_etudiant) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''étudiant spécifié n''existe pas.';
    END IF;

    -- Vérifier si l'étudiant est inscrit à un cours pendant les heures de stationnement
    IF NOT EXISTS (
        SELECT 1 FROM cours_suivi cs
        JOIN cours c ON cs.id_cours = c.id_cours
        WHERE cs.id_etudiant = p_id_etudiant
        AND p_date_heure_arrivee BETWEEN cs.heure_debut AND cs.heure_fin
        AND p_date_heure_depart BETWEEN cs.heure_debut AND cs.heure_fin
    ) THEN
        -- Enregistrer une violation de stationnement
        INSERT INTO violation_stationnement (code_permanent, nom_etudiant, prenom_etudiant, plaque_vehicule, date_heure_tentative)
        SELECT code_permanent, nom_etudiant, prenom_etudiant, plaque_vehicule, NOW()
        FROM etudiant
        WHERE id_etudiant = p_id_etudiant;
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Aucun cours inscrit pendant les heures de stationnement.';
    END IF;

    -- Recherche d'une place disponible dans une allée de l'université de l'étudiant
    SELECT pr.id_place INTO id_place
    FROM place p
    JOIN allee a ON p.id_allee = a.id_allee
    JOIN espace_stationnement e ON a.id_espace_stationnement = e.id_espace_stationnement
    LEFT JOIN place_reservee pr ON p.id_place = pr.id_place
    WHERE e.id_universite = (SELECT id_universite FROM etudiant WHERE id_etudiant = p_id_etudiant)
    AND pr.id_etudiant IS NULL
    LIMIT 1;

    -- Si aucune place disponible n'est trouvée, retourner un message d'erreur
    IF id_place IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Aucune place disponible dans l''université de l''étudiant.';
    END IF;

    -- Obtenir l'ID de l'allée et de l'espace de stationnement pour affichage
    SELECT a.id_allee, e.id_espace_stationnement INTO id_allee, id_espace_stationnement
    FROM place p
    JOIN allee a ON p.id_allee = a.id_allee
    JOIN espace_stationnement e ON a.id_espace_stationnement = e.id_espace_stationnement
    WHERE p.id_place = id_place;

    -- Actualiser la disponibilité de la place réservée
    UPDATE place_reservee
    SET id_etudiant = p_id_etudiant, date_heure_arrivee = p_date_heure_arrivee, date_heure_depart = p_date_heure_depart
    WHERE id_place = id_place;
    
    -- Déclencheur pour actualiser le nombre de places disponibles dans l'allée de la place réservée
    CREATE TRIGGER update_places_disponibles
    AFTER UPDATE ON place_reservee
    FOR EACH ROW
    BEGIN
        UPDATE allee
        SET nombre_places_dispo = (SELECT COUNT(*) FROM place WHERE id_allee = NEW.id_place AND id_etudiant IS NULL)
        WHERE id_allee = NEW.id_place;
    END;
    
    -- Afficher les détails de la réservation
    SELECT e.designation_espace_stationnement, a.designation_allee, p.type_de_place, p.numero_place, p.tarif_horaire, p_date_heure_arrivee, p_date_heure_depart
    FROM place_reservee pr
    JOIN place p ON pr.id_place = p.id_place
    JOIN allee a ON p.id_allee = a.id_allee
    JOIN espace_stationnement e ON a.id_espace_stationnement = e.id_espace_stationnement
    WHERE pr.id_place = id_place;
END;
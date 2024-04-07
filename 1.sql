DELIMITER //

CREATE PROCEDURE configurer_nouvelle_aire(
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
END;

CREATE TRIGGER log_creation_espace_stationnement
AFTER INSERT ON espace_stationnement
FOR EACH ROW
BEGIN
    DECLARE university_name VARCHAR(45);
    DECLARE university_sigle VARCHAR(10);
    
    -- Obtenir le nom et le sigle de l'université associée à l'espace de stationnement nouvellement créé
    SELECT nom_universite, sigle INTO university_name, university_sigle
    FROM universite
    WHERE id_universite = NEW.id_universite;
    
    -- Insérer les données dans la table de journalisation
    INSERT INTO log_aire_stationnement (nom_universite, sigle_universite, date_heure_creation)
    VALUES (university_name, university_sigle, NOW());
END;


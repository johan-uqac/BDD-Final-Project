-- Création de la table pour l'historique des étudiants
CREATE TABLE historique_etudiant (
    id_historique INT AUTO_INCREMENT PRIMARY KEY,
    id_etudiant VARCHAR(10),
    ancien_nom_etudiant VARCHAR(45),
    ancien_prenom_etudiant VARCHAR(60),
    ancien_code_permanent VARCHAR(15),
    ancien_numero_plaque VARCHAR(10),
    ancien_courriel_etudiant VARCHAR(55),
    ancien_telephone_etudiant VARCHAR(10),
    ancien_id_universite INT,
    date_modification DATETIME
);

-- Procédure pour créer un nouvel étudiant
DELIMITER //
CREATE PROCEDURE creer_etudiant(
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
END //
DELIMITER ;

DELIMITER //

-- Procédure pour afficher les informations personnelles d'un étudiant
CREATE PROCEDURE afficher_info_etudiant(
    IN p_id_etudiant VARCHAR(10)
)
BEGIN
    SELECT * FROM etudiant WHERE id_etudiant = p_id_etudiant;
END;

-- Procédure pour mettre à jour les informations personnelles d'un étudiant
CREATE PROCEDURE mettre_a_jour_info_etudiant(
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
END;

-- Procédure pour supprimer un étudiant
CREATE PROCEDURE supprimer_etudiant(
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
END //
DELIMITER ;

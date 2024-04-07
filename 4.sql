-- 1. Création de la fonction pour générer l'identifiant unique de l'étudiant
DELIMITER //
CREATE FUNCTION generer_id_etudiant() RETURNS VARCHAR(10)
BEGIN
    DECLARE nouvel_id VARCHAR(10);
    SET nouvel_id = CONCAT('ETU-', LPAD((SELECT IFNULL(MAX(SUBSTRING(id_etudiant, 5)), 0) + 1 FROM etudiant), 6, '0'));
    RETURN nouvel_id;
END;

-- 2. Création de la vue pour retourner des informations sur toutes les aires de stationnement configurées
CREATE VIEW infos_aires_stationnement AS
SELECT u.nom_universite, e.designation_espace_stationnement, a.designation_allee, 
       COUNT(p.id_place) AS nombre_places_disponibles,
       (SELECT COUNT(*) FROM place_reservee pr WHERE pr.id_place = p.id_place) AS nombre_places_reservees
FROM universite u
JOIN espace_stationnement e ON u.id_universite = e.id_universite
JOIN allee a ON e.id_espace_stationnement = a.id_espace_stationnement
LEFT JOIN place p ON a.id_allee = p.id_allee
GROUP BY u.nom_universite, e.designation_espace_stationnement, a.designation_allee;

-- 3. Création de l'événement pour mettre à jour la disponibilité des places réservées
CREATE EVENT maj_places_reserves
ON SCHEDULE EVERY 5 MINUTE
DO
BEGIN
    UPDATE place_reservee
    SET id_etudiant = NULL, date_heure_arrivee = NULL, date_heure_depart = NULL
    WHERE date_heure_depart <= NOW();
END;

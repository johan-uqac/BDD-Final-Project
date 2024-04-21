DELIMITER $$

CREATE FUNCTION generate_student_id() RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
    DECLARE prefix VARCHAR(3);
    DECLARE unique_number INT;
    DECLARE formatted_id VARCHAR(10);
    
    SET prefix = 'ETU';
    SET unique_number = (SELECT IFNULL(MAX(SUBSTRING(id_etudiant, 5)), 0) + 1 FROM etudiant);
    SET formatted_id = CONCAT(prefix, LPAD(unique_number, 6, '0'));
    
    RETURN formatted_id;
END$$

CREATE VIEW parking_areas_info AS
SELECT u.nom_universite, es.designation_espace_stationnement, a.designation_allee,
       a.nombre_places_dispo, (COUNT(p.id_place) - COUNT(pr.id_place)) AS nombre_places_reservees
FROM universite u
JOIN espace_stationnement es ON u.id_universite = es.id_universite
JOIN allee a ON es.id_espace_stationnement = a.id_espace_stationnement
LEFT JOIN place p ON a.id_allee = p.id_allee
LEFT JOIN place_reservee pr ON p.id_place = pr.id_place
GROUP BY u.nom_universite, es.designation_espace_stationnement, a.designation_allee, a.nombre_places_dispo$$

CREATE EVENT update_reserved_places
ON SCHEDULE EVERY 5 MINUTE
DO
    UPDATE place_reservee
    SET disponibilite = 'Non'
    WHERE date_heure_fin <= NOW()$$

DELIMITER ;

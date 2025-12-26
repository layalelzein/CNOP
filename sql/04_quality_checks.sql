-- Nombre total d’officines
SELECT COUNT(*) AS nb_officines
FROM cnop_final.officines_master;

-- Officines sans commune (anomalie)
SELECT COUNT(*) AS officines_sans_commune
FROM cnop_final.officines_master
WHERE commune IS NULL OR commune = '';

-- Officines sans titulaires
SELECT COUNT(*) AS officines_sans_titulaire
FROM cnop_final.officines_master
WHERE nb_titulaires = 0;

-- Distribution du nombre de pharmaciens
SELECT
  nb_pharmaciens,
  COUNT(*) AS nb_officines
FROM cnop_final.officines_master
GROUP BY nb_pharmaciens
ORDER BY nb_pharmaciens;

-- Vérification doublons
SELECT id_etablissement, COUNT(*)
FROM cnop_final.officines_master
GROUP BY id_etablissement
HAVING COUNT(*) > 1;

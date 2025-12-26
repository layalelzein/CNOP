SET datestyle = 'DMY';


DROP TABLE IF EXISTS cnop_work.etablissements_clean;
CREATE TABLE cnop_work.etablissements_clean AS
SELECT
  col_1  AS cnop_n_etablissement,
  col_2  AS cnop_type_etablissement,
  col_3  AS cnop_denom_commerciale,
  col_4  AS cnop_raison_sociale,
  col_5  AS cnop_adresse,
  col_6  AS cnop_code_postal,
  col_7  AS cnop_commune,
  col_8  AS cnop_departement,
  col_9  AS cnop_region,
  NULLIF(regexp_replace(col_10, '\.0$', ''), '') AS cnop_telephone,
  NULLIF(regexp_replace(col_11, '\.0$', ''), '') AS cnop_fax
FROM cnop_raw.etablissements;

DROP TABLE IF EXISTS cnop_work.activites_clean;
CREATE TABLE cnop_work.activites_clean AS
SELECT
  col_1 AS cnop_rpps,
  col_2 AS cnop_n_etablissement,
  col_3 AS cnop_fonction,
  to_date(col_4, 'DD/MM/YY') AS cnop_date_inscription_officine,
  col_5 AS cnop_section,
  col_6 AS cnop_activite_principale
FROM cnop_raw.activites;

DROP TABLE IF EXISTS cnop_work.pharmaciens_clean;
CREATE TABLE cnop_work.pharmaciens_clean AS
SELECT
  col_1 AS cnop_rpps,
  col_2 AS cnop_titre,
  col_3 AS cnop_nom_exercice,
  col_4 AS cnop_nom_naissance,
  col_5 AS cnop_prenom,
  NULLIF(col_6, '')::date AS cnop_date_first_inscription
FROM cnop_raw.pharmaciens;

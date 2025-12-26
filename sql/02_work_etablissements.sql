DROP TABLE IF EXISTS cnop_work.etablissements;

CREATE TABLE cnop_work.etablissements AS
SELECT
  col_1  AS id_etablissement,
  col_2  AS type_etablissement,
  col_3  AS denomination_commerciale,
  col_4  AS raison_sociale,
  col_5  AS adresse,
  col_6  AS code_postal,
  col_7  AS commune,
  col_8  AS departement,
  col_9  AS region,
  col_10 AS telephone,
  col_11 AS fax
FROM cnop_raw.etablissements;

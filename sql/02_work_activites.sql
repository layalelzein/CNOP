DROP TABLE IF EXISTS cnop_work.activites;

CREATE TABLE cnop_work.activites AS
SELECT
  col_1 AS id_pharmacien,
  col_2 AS id_etablissement,
  col_3 AS fonction,
  col_4 AS date_debut_fonction,
  col_5 AS exercice_effectif,
  col_6 AS officine
FROM cnop_raw.activites;

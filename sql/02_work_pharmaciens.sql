DROP TABLE IF EXISTS cnop_work.pharmaciens;

CREATE TABLE cnop_work.pharmaciens AS
SELECT
  col_1 AS id_pharmacien,
  col_2 AS profession,
  col_3 AS nom,
  col_4 AS nom_usage,
  col_5 AS prenom,
  col_6 AS date_naissance
FROM cnop_raw.pharmaciens;

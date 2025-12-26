DROP TABLE IF EXISTS cnop_raw.activites;
CREATE TABLE cnop_raw.activites (
  col_1 TEXT,  
  col_2 TEXT,  
  col_3 TEXT,  
  col_4 TEXT,  
  col_5 TEXT,  
  col_6 TEXT   
);

DROP TABLE IF EXISTS cnop_raw.etablissements;
CREATE TABLE cnop_raw.etablissements (
  col_1 TEXT,
  col_2 TEXT,
  col_3 TEXT,
  col_4 TEXT,
  col_5 TEXT,
  col_6 TEXT,
  col_7 TEXT,
  col_8 TEXT,
  col_9 TEXT,
  col_10 TEXT,
  col_11 TEXT
);

DROP TABLE IF EXISTS cnop_raw.pharmaciens;
CREATE TABLE cnop_raw.pharmaciens (
  col_1 TEXT,
  col_2 TEXT,
  col_3 TEXT,
  col_4 TEXT,
  col_5 TEXT,
  col_6 TEXT
);



COPY cnop_raw.activites
FROM '/Users/layalelzein/Desktop/COURS/Master/M2/S1/BDD avancé/Projet/CNOP/data/activites_2025-11-07_03-31-18.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

COPY cnop_raw.etablissements
FROM '/Users/layalelzein/Desktop/COURS/Master/M2/S1/BDD avancé/Projet/CNOP/data/etablissements_2025-11-07_03-31-18.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

COPY cnop_raw.pharmaciens
FROM '/Users/layalelzein/Desktop/COURS/Master/M2/S1/BDD avancé/Projet/CNOP/data/pharmaciens_2025-11-07_03-31-18.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

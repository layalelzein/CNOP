DROP TABLE IF EXISTS cnop_work.population_brut;
DROP TABLE IF EXISTS cnop_work.population_dep;

CREATE TABLE cnop_work.population_brut (
    code_region TEXT,
    nom_region TEXT,
    code_departement TEXT,
    nom_departement TEXT,
    nb_arrondissements TEXT,
    nb_cantons TEXT,
    nb_communes TEXT,
    population_municipale BIGINT,
    population_totale BIGINT
);


COPY cnop_work.population_brut
FROM '/Users/layalelzein/Desktop/COURS/Master/M2/S1/BDD avancé/Projet/CNOP/data/donnees_departements.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);


CREATE TABLE cnop_work.population_dep AS
SELECT
    code_departement AS dep_code,
    nom_departement,
    population_totale AS population
FROM cnop_work.population_brut
WHERE population_totale IS NOT NULL;

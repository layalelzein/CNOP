DROP TABLE IF EXISTS cnop_final.officines_master;

CREATE TABLE cnop_final.officines_master AS
WITH titulaires AS (
    SELECT
        a.cnop_n_etablissement,
        a.cnop_rpps,
        a.cnop_fonction,
        a.cnop_date_inscription_officine,
        a.cnop_section,
        a.cnop_activite_principale,
        p.cnop_titre,
        p.cnop_nom_exercice,
        p.cnop_prenom,
        p.cnop_date_first_inscription,
        ROW_NUMBER() OVER (
            PARTITION BY a.cnop_n_etablissement
            ORDER BY a.cnop_date_inscription_officine ASC, p.cnop_nom_exercice ASC
        ) AS rn
    FROM cnop_work.activites_clean a
    JOIN cnop_work.pharmaciens_clean p
        ON a.cnop_rpps = p.cnop_rpps
    WHERE a.cnop_fonction ILIKE '%TITULAIRE%'
),

agregats AS (
    SELECT
        a.cnop_n_etablissement,
        COUNT(DISTINCT a.cnop_rpps) AS cnop_nb_pharma,
        COUNT(DISTINCT CASE
            WHEN a.cnop_fonction ILIKE '%TITULAIRE%' THEN a.cnop_rpps
        END) AS cnop_nb_titulaires,
        STRING_AGG(
            p.cnop_nom_exercice || ' ' || p.cnop_prenom || ' - ' || a.cnop_fonction,
            ' / '
            ORDER BY p.cnop_nom_exercice
        ) AS cnop_personnes_rattachees
    FROM cnop_work.activites_clean a
    LEFT JOIN cnop_work.pharmaciens_clean p
        ON a.cnop_rpps = p.cnop_rpps
    GROUP BY a.cnop_n_etablissement
)

SELECT
    e.cnop_n_etablissement,
    e.cnop_type_etablissement,
    e.cnop_denom_commerciale,
    e.cnop_raison_sociale,
    e.cnop_adresse,
    e.cnop_code_postal,
    e.cnop_commune,
    e.cnop_departement,
    e.cnop_region,
    e.cnop_telephone,
    e.cnop_fax,

    t1.cnop_rpps                AS cnop_titulaire1_rpps,
    t1.cnop_fonction            AS cnop_fonction,
    t1.cnop_date_inscription_officine AS cnop_titulaire1_date_inscription,
    t1.cnop_section,
    t1.cnop_activite_principale,
    t1.cnop_titre,
    t1.cnop_nom_exercice        AS cnop_titulaire1_nom,
    t1.cnop_prenom              AS cnop_titulaire1_prenom,
    t1.cnop_date_first_inscription AS cnop_date_first_inscription,

    t2.cnop_rpps                AS cnop_titulaire2_rpps,
    t2.cnop_date_inscription_officine AS cnop_titulaire2_date_inscription,
    t2.cnop_nom_exercice        AS cnop_titulaire2_nom,
    t2.cnop_prenom              AS cnop_titulaire2_prenom,

    a.cnop_nb_pharma,
    a.cnop_nb_titulaires,
    a.cnop_personnes_rattachees

FROM cnop_work.etablissements_clean e
LEFT JOIN titulaires t1
    ON e.cnop_n_etablissement = t1.cnop_n_etablissement
   AND t1.rn = 1
LEFT JOIN titulaires t2
    ON e.cnop_n_etablissement = t2.cnop_n_etablissement
   AND t2.rn = 2
LEFT JOIN agregats a
    ON e.cnop_n_etablissement = a.cnop_n_etablissement

WHERE e.cnop_type_etablissement IN (
    'OFFICINE',
    'PHARMACIE MUTUALISTE',
    'PHARMACIE DE SECOURS MINIER'
);

\echo 'A. Répartition des officines selon le nombre de titulaires'
SELECT
  cnop_nb_titulaires,
  COUNT(*) AS nb_officines
FROM cnop_final.officines_master
GROUP BY cnop_nb_titulaires
ORDER BY cnop_nb_titulaires;

-- =========================================================
-- B & Bbis. Âge médian des titulaires
-- =========================================================
-- IMPOSSIBLE À CALCULER
--
-- Justification :
-- Les données CNOP utilisées ne contiennent pas de date de naissance
-- exploitable pour les pharmaciens (champ absent de pharmaciens_clean).
-- En conséquence, le calcul d’un âge réel ou médian n’est pas possible
-- sans source externe supplémentaire, ce qui est interdit par la consigne
-- (hors partie couverture territoriale).
--
-- Ces indicateurs sont donc volontairement exclus du rendu BI.
-- =========================================================


\echo 'C. Top 10 départements en nombre d’officines'
SELECT
  cnop_departement,
  COUNT(*) AS nb_officines
FROM cnop_final.officines_master
GROUP BY cnop_departement
ORDER BY nb_officines DESC
LIMIT 10;

\echo 'D. Y a-t-il des officines sans titulaire ? (nb + liste limitée)'
SELECT
  COUNT(*) AS nb_officines_sans_titulaire
FROM cnop_final.officines_master
WHERE COALESCE(cnop_nb_titulaires,0) = 0;

SELECT
  cnop_n_etablissement,
  cnop_denom_commerciale,
  cnop_commune,
  cnop_departement,
  cnop_region
FROM cnop_final.officines_master
WHERE COALESCE(cnop_nb_titulaires,0) = 0
ORDER BY cnop_departement, cnop_commune
LIMIT 50;

\echo 'E. Durée moyenne d’inscription des titulaires à l’Ordre (en années)'

WITH titulaires AS (
  SELECT cnop_titulaire1_rpps AS cnop_rpps, cnop_titulaire1_date_inscription AS date_insc
  FROM cnop_final.officines_master
  WHERE cnop_titulaire1_rpps IS NOT NULL

  UNION ALL

  SELECT cnop_titulaire2_rpps, cnop_titulaire2_date_inscription
  FROM cnop_final.officines_master
  WHERE cnop_titulaire2_rpps IS NOT NULL
),
durees AS (
  SELECT
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_insc)) AS duree_annees
  FROM titulaires
  WHERE date_insc IS NOT NULL
)
SELECT
  ROUND(AVG(duree_annees)::numeric, 2) AS duree_moyenne_annees,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duree_annees) AS duree_mediane_annees
FROM durees;


\echo 'F. Distribution du nombre de pharmaciens rattachés par officine'
SELECT
  cnop_nb_pharma,
  COUNT(*) AS nb_officines
FROM cnop_final.officines_master
GROUP BY cnop_nb_pharma
ORDER BY cnop_nb_pharma;

\echo 'G. Top 10 départements avec le plus de multi-titulaires (>=2 titulaires)'
SELECT
  cnop_departement,
  COUNT(*) AS nb_officines_multititulaires
FROM cnop_final.officines_master
WHERE cnop_nb_titulaires >= 2
GROUP BY cnop_departement
ORDER BY nb_officines_multititulaires DESC
LIMIT 10;

\echo 'H. Officines avec effectif pharmaciens > moyenne régionale (TOP 5 par région)'

WITH region_avg AS (
  SELECT
    cnop_region,
    AVG(cnop_nb_pharma)::numeric AS avg_nb_pharma_region
  FROM cnop_final.officines_master
  GROUP BY cnop_region
),
ranked AS (
  SELECT
    m.*,
    r.avg_nb_pharma_region,
    DENSE_RANK() OVER (
      PARTITION BY m.cnop_region
      ORDER BY m.cnop_nb_pharma DESC
    ) AS rang_region
  FROM cnop_final.officines_master m
  JOIN region_avg r
    ON r.cnop_region = m.cnop_region
  WHERE m.cnop_nb_pharma > r.avg_nb_pharma_region
)
SELECT
  cnop_region,
  rang_region,
  cnop_n_etablissement,
  cnop_denom_commerciale,
  cnop_commune,
  cnop_departement,
  cnop_nb_pharma,
  avg_nb_pharma_region
FROM ranked
WHERE rang_region <= 5
ORDER BY cnop_region, rang_region;


\echo 'I. Officines avec effectif pharmaciens < moyenne régionale (TOP 5 par région – cible recrutement)'

WITH region_avg AS (
  SELECT
    cnop_region,
    AVG(cnop_nb_pharma)::numeric AS avg_nb_pharma_region
  FROM cnop_final.officines_master
  GROUP BY cnop_region
),
below_avg AS (
  SELECT
    m.cnop_region,
    m.cnop_n_etablissement,
    m.cnop_denom_commerciale,
    m.cnop_commune,
    m.cnop_departement,
    m.cnop_nb_pharma,
    r.avg_nb_pharma_region,
    DENSE_RANK() OVER (
      PARTITION BY m.cnop_region
      ORDER BY m.cnop_nb_pharma ASC
    ) AS rang_region
  FROM cnop_final.officines_master m
  JOIN region_avg r
    ON r.cnop_region = m.cnop_region
  WHERE m.cnop_nb_pharma < r.avg_nb_pharma_region
)
SELECT *
FROM below_avg
WHERE rang_region <= 5
ORDER BY cnop_region, rang_region;


-- =========================================
-- Analyse couverture territoriale
-- Indicateur : nombre d’officines pour 100 000 habitants par département
-- Source population : INSEE (donnees_departements.csv)
-- =========================================

\echo 'Couverture territoriale : départements les moins couverts'

WITH officines_dep AS (
    SELECT
        cnop_departement AS dep_code,
        COUNT(*)::numeric AS nb_officines
    FROM cnop_final.officines_master
    GROUP BY cnop_departement
),
couverture AS (
    SELECT
        o.dep_code,
        p.nom_departement,
        o.nb_officines,
        p.population,
        ROUND((o.nb_officines / NULLIF(p.population,0)) * 100000, 2) AS officines_pour_100k
    FROM officines_dep o
    JOIN cnop_work.population_dep p
        ON p.dep_code = o.dep_code
)
SELECT *
FROM couverture
ORDER BY officines_pour_100k ASC
LIMIT 20;

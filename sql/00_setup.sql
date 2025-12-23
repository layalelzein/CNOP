-- Connexion à PostgreSQL (base par défaut)
CREATE DATABASE cnop;

-- Puis connexion à cnop
\c cnop;

CREATE SCHEMA cnop_raw;
CREATE SCHEMA cnop_work;
CREATE SCHEMA cnop_final;

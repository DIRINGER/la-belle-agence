-- ============================================================
-- ERP LA BELLE AGENCE — Tables de saisie Jour 1
-- À exécuter dans l'éditeur SQL de Supabase
-- ============================================================

-- 1. CLIENTS
CREATE TABLE IF NOT EXISTS clients (
  id            SERIAL PRIMARY KEY,
  nom           VARCHAR(100) NOT NULL,
  prenom        VARCHAR(100) NOT NULL,
  budget        NUMERIC(12,2),
  type_recherche VARCHAR(50),   -- 'achat', 'location', 'investissement'
  telephone     VARCHAR(20),
  email         VARCHAR(255),
  created_at    TIMESTAMP DEFAULT NOW()
);

-- 2. BIENS IMMOBILIERS
CREATE TABLE IF NOT EXISTS biens (
  id            SERIAL PRIMARY KEY,
  adresse       VARCHAR(255) NOT NULL,
  type          VARCHAR(50),    -- 'appartement', 'maison', 'bureau', 'terrain'
  surface       NUMERIC(8,2),   -- en m²
  prix          NUMERIC(12,2),
  nb_pieces     INTEGER,
  description   TEXT,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- 3. SALARIÉS
CREATE TABLE IF NOT EXISTS salaries (
  id            SERIAL PRIMARY KEY,
  nom           VARCHAR(100) NOT NULL,
  prenom        VARCHAR(100) NOT NULL,
  poste         VARCHAR(100),
  service       VARCHAR(100),   -- 'RH', 'Finance', 'IT', etc.
  date_embauche DATE,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- 4. PROSPECTS
CREATE TABLE IF NOT EXISTS prospects (
  id            SERIAL PRIMARY KEY,
  nom           VARCHAR(100) NOT NULL,
  prenom        VARCHAR(100) NOT NULL,
  source        VARCHAR(100),   -- 'site web', 'bouche à oreille', 'publicité', etc.
  interet       TEXT,
  created_at    TIMESTAMP DEFAULT NOW()
);

-- Activer Row Level Security (accès public pour les élèves en anon)
ALTER TABLE clients  ENABLE ROW LEVEL SECURITY;
ALTER TABLE biens    ENABLE ROW LEVEL SECURITY;
ALTER TABLE salaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE prospects ENABLE ROW LEVEL SECURITY;

-- Politiques : lecture et écriture pour tous (anon key)
CREATE POLICY "Lecture publique clients"   ON clients   FOR SELECT USING (true);
CREATE POLICY "Ecriture publique clients"  ON clients   FOR INSERT WITH CHECK (true);

CREATE POLICY "Lecture publique biens"     ON biens     FOR SELECT USING (true);
CREATE POLICY "Ecriture publique biens"    ON biens     FOR INSERT WITH CHECK (true);

CREATE POLICY "Lecture publique salaries"  ON salaries  FOR SELECT USING (true);
CREATE POLICY "Ecriture publique salaries" ON salaries  FOR INSERT WITH CHECK (true);

CREATE POLICY "Lecture publique prospects"  ON prospects FOR SELECT USING (true);
CREATE POLICY "Ecriture publique prospects" ON prospects FOR INSERT WITH CHECK (true);

-- ============================================================
-- ERP — Mises à jour : colonnes supplémentaires + mandats + storage
-- À exécuter après erp_tables.sql
-- ============================================================

-- Colonnes supplémentaires
ALTER TABLE clients  ADD COLUMN IF NOT EXISTS document_url TEXT;
ALTER TABLE salaries ADD COLUMN IF NOT EXISTS cv_url TEXT;
ALTER TABLE biens    ADD COLUMN IF NOT EXISTS photos_urls JSONB DEFAULT '[]';

-- ============================================================
-- Table mandats
-- ============================================================
CREATE TABLE IF NOT EXISTS mandats (
  id          SERIAL PRIMARY KEY,
  client_id   INTEGER REFERENCES clients(id) ON DELETE SET NULL,
  bien_id     INTEGER REFERENCES biens(id) ON DELETE SET NULL,
  date_debut  DATE NOT NULL,
  date_fin    DATE NOT NULL,
  commission  NUMERIC(5,2) NOT NULL DEFAULT 5.00,
  statut      VARCHAR(30) DEFAULT 'actif',
  created_at  TIMESTAMP DEFAULT NOW()
);

-- RLS mandats : accès public (contexte pédagogique)
ALTER TABLE mandats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "mandats_select" ON mandats FOR SELECT USING (true);
CREATE POLICY "mandats_insert" ON mandats FOR INSERT WITH CHECK (true);
CREATE POLICY "mandats_update" ON mandats FOR UPDATE USING (true);
CREATE POLICY "mandats_delete" ON mandats FOR DELETE USING (true);

-- ============================================================
-- Buckets Supabase Storage (public=true)
-- À exécuter via Supabase Dashboard > Storage ou SQL Editor
-- ============================================================
INSERT INTO storage.buckets (id, name, public) VALUES
  ('documents-clients', 'documents-clients', true),
  ('cv-salaries',       'cv-salaries',       true),
  ('photos-biens',      'photos-biens',      true)
ON CONFLICT (id) DO NOTHING;

-- Policies storage : lecture et upload publics (contexte pédagogique)
CREATE POLICY "documents-clients_select"
  ON storage.objects FOR SELECT USING (bucket_id = 'documents-clients');

CREATE POLICY "documents-clients_insert"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'documents-clients');

CREATE POLICY "cv-salaries_select"
  ON storage.objects FOR SELECT USING (bucket_id = 'cv-salaries');

CREATE POLICY "cv-salaries_insert"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'cv-salaries');

CREATE POLICY "photos-biens_select"
  ON storage.objects FOR SELECT USING (bucket_id = 'photos-biens');

CREATE POLICY "photos-biens_insert"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'photos-biens');

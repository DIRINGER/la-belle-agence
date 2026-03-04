-- ============================================================
-- MIGRATION 002 — Fix assurances_rc & formations
-- Problème : ces tables n'affichaient ni le salarié ni le statut
-- dans l'interface ERP, contrairement à cartes_professionnelles.
--
-- Cause :
--   • assurances_rc  → pas de colonne salarie_nom, pas de statut
--   • formations     → pas de colonne statut
--
-- Solution : aligner sur le modèle de cartes_professionnelles
--   (salarie_nom VARCHAR NOT NULL + statut VARCHAR DEFAULT '...')
-- ============================================================

-- ============================================================
-- 1. ASSURANCES RC — Drop & Recreate
-- ============================================================

DROP TABLE IF EXISTS assurances_rc CASCADE;

CREATE TABLE assurances_rc (
  id               SERIAL PRIMARY KEY,
  salarie_nom      VARCHAR(200) NOT NULL,         -- même liaison que cartes_professionnelles
  compagnie        VARCHAR(200) NOT NULL,
  numero_police    VARCHAR(100),
  montant_garantie NUMERIC(14,2),
  date_debut       DATE,
  date_fin         DATE,
  statut           VARCHAR(50) DEFAULT 'valide'   -- 'valide' | 'expiré' | 'en renouvellement'
    CHECK (statut IN ('valide', 'expiré', 'en renouvellement')),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE assurances_rc ENABLE ROW LEVEL SECURITY;

CREATE POLICY "assurances_select" ON assurances_rc FOR SELECT USING (true);
CREATE POLICY "assurances_insert" ON assurances_rc FOR INSERT WITH CHECK (true);
CREATE POLICY "assurances_update" ON assurances_rc FOR UPDATE USING (true);
CREATE POLICY "assurances_delete" ON assurances_rc FOR DELETE USING (true);

-- ============================================================
-- 2. FORMATIONS — Drop & Recreate (ajout colonne statut)
-- ============================================================

DROP TABLE IF EXISTS formations CASCADE;

CREATE TABLE formations (
  id              SERIAL PRIMARY KEY,
  salarie_nom     VARCHAR(200) NOT NULL,           -- même liaison que cartes_professionnelles
  intitule        VARCHAR(255) NOT NULL,
  organisme       VARCHAR(200),
  date_formation  DATE,
  duree_heures    NUMERIC(6,2),
  type_formation  VARCHAR(50) DEFAULT 'facultatif'
    CHECK (type_formation IN ('DDA', 'obligatoire', 'facultatif')),
  statut          VARCHAR(50) DEFAULT 'validée'    -- 'validée' | 'en cours' | 'à planifier' | 'expirée'
    CHECK (statut IN ('validée', 'en cours', 'à planifier', 'expirée')),
  certificat_url  TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE formations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "formations_select" ON formations FOR SELECT USING (true);
CREATE POLICY "formations_insert" ON formations FOR INSERT WITH CHECK (true);
CREATE POLICY "formations_update" ON formations FOR UPDATE USING (true);
CREATE POLICY "formations_delete" ON formations FOR DELETE USING (true);

-- ============================================================
-- 3. SEED — Assurances RC (9 agents commerciaux, 1 RC par agence)
-- ============================================================

INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut) VALUES
-- Agence Colmar
('Fatima BENALI',   'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000.00, '2026-01-01', '2026-12-31', 'valide'),
('Pedro FERREIRA',  'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000.00, '2026-01-01', '2026-12-31', 'valide'),
('Léa KLEIN',       'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000.00, '2026-01-01', '2026-12-31', 'valide'),
-- Agence Mulhouse
('Gentian SHEHU',   'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000.00, '2025-09-01', '2026-08-31', 'valide'),
('Sofia COSTA',     'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000.00, '2025-09-01', '2026-08-31', 'valide'),
('Lucas WEBER',     'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000.00, '2025-09-01', '2026-08-31', 'valide'),
-- Agence Strasbourg
('David THOMAS',    'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000.00, '2026-01-01', '2026-12-31', 'valide'),
('Amina FASSI',     'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000.00, '2026-01-01', '2026-12-31', 'valide'),
('Hugo OLIVEIRA',   'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000.00, '2026-01-01', '2026-12-31', 'valide');

-- ============================================================
-- 4. SEED — Formations DDA (9 DDA + 5 complémentaires)
-- ============================================================

INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation, statut) VALUES
-- DDA obligatoire 15h/an — commerciaux
('Fatima BENALI',   'Réglementation DDA et distribution immobilière 2025',          'IFOCOP',           '2025-11-20', 15.0, 'DDA',         'validée'),
('Pedro FERREIRA',  'Réglementation DDA et pratique de la transaction',              'FNAIM Formation',  '2025-11-20', 15.0, 'DDA',         'validée'),
('Léa KLEIN',       'DDA : obligations, déontologie et pratique',                    'AUREP',            '2026-02-05', 15.0, 'DDA',         'validée'),
('Gentian SHEHU',   'Lutte anti-blanchiment, conformité et DDA 2025',               'IFOCOP',           '2025-10-15', 15.0, 'DDA',         'validée'),
('Sofia COSTA',     'Formation DDA + négociation commerciale avancée',               'FNAIM Formation',  '2025-11-20', 15.0, 'DDA',         'validée'),
('Lucas WEBER',     'DDA : réglementation immobilière et assurances',                'AF2I',             '2026-01-22', 15.0, 'DDA',         'validée'),
('David THOMAS',    'DDA Management agence + conformité réglementaire',              'IFOCOP',           '2025-10-08', 15.0, 'DDA',         'validée'),
('Amina FASSI',     'DDA et pratique du conseil patrimonial',                        'AUREP',            '2025-11-13', 15.0, 'DDA',         'validée'),
('Hugo OLIVEIRA',   'DDA Gestion de patrimoine + placements financiers',             'AF2I',             '2025-09-25', 15.0, 'DDA',         'validée'),
-- Formations complémentaires
('Pedro FERREIRA',  'Négociation avancée en immobilier résidentiel',                 'CEGOS',            '2025-03-10', 14.0, 'facultatif',  'validée'),
('Sofia COSTA',     'Photographie immobilière et home staging',                      'FNAIM Formation',  '2025-05-22',  7.0, 'facultatif',  'validée'),
('Hugo OLIVEIRA',   'Fiscalité du patrimoine 2025 : IFI, plus-values, assurance-vie','AUREP',            '2026-01-30',  7.0, 'obligatoire', 'validée'),
('Maria SILVA',     'Management RH et droit du travail 2025',                        'CEGOS',            '2025-06-12', 14.0, 'obligatoire', 'validée'),
('Arben HOXHA',     'Comptabilité immobilière et normes IFRS',                       'INTEC',            '2025-09-18', 21.0, 'obligatoire', 'validée');

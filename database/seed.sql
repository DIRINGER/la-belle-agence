-- ============================================================
-- LA BELLE AGENCE — Données initiales (seed)
-- À exécuter après schema.sql dans l'éditeur SQL Supabase
-- ============================================================

-- ----------------------------------------------------------
-- AGENCIES
-- ----------------------------------------------------------
INSERT INTO agencies (id, name, type, city) VALUES
  (1, 'Siège Social',       'siege',  'Saint-Louis'),
  (2, 'Agence Mulhouse',    'agence', 'Mulhouse'),
  (3, 'Agence Colmar',      'agence', 'Colmar'),
  (4, 'Agence Strasbourg',  'agence', 'Strasbourg')
ON CONFLICT (id) DO NOTHING;

-- Réinitialise la séquence après insertion manuelle des IDs
SELECT setval('agencies_id_seq', (SELECT MAX(id) FROM agencies));

-- ----------------------------------------------------------
-- DEPARTMENTS (siège uniquement)
-- ----------------------------------------------------------
INSERT INTO departments (id, name, code, agency_id) VALUES
  (1, 'Ressources Humaines', 'RH',  1),
  (2, 'Finance',             'FIN', 1),
  (3, 'Juridique',           'JUR', 1),
  (4, 'Informatique',        'IT',  1),
  (5, 'Marketing',           'MKT', 1),
  (6, 'Achats',              'ACH', 1),
  (7, 'Qualité',             'QUA', 1)
ON CONFLICT (code) DO NOTHING;

SELECT setval('departments_id_seq', (SELECT MAX(id) FROM departments));

-- ----------------------------------------------------------
-- ROLES
-- ----------------------------------------------------------
INSERT INTO roles (id, name, code, scope) VALUES
  (1,  'Direction Générale',       'DIRECTION_GENERALE',    'global'),
  (2,  'Directeur d''Agence',      'DIRECTEUR_AGENCE',      'agency'),
  (3,  'Responsable RH',           'RH_MANAGER',            'department'),
  (4,  'Responsable Finance',      'FINANCE_MANAGER',       'department'),
  (5,  'Responsable Juridique',    'JUR_MANAGER',           'department'),
  (6,  'Responsable IT',           'IT_MANAGER',            'department'),
  (7,  'Responsable Marketing',    'MKT_MANAGER',           'department'),
  (8,  'Responsable Achats',       'ACH_MANAGER',           'department'),
  (9,  'Responsable Qualité',      'QUA_MANAGER',           'department'),
  (10, 'Conseiller en Patrimoine', 'CONSEILLER_PATRIMOINE', 'agency'),
  (11, 'Agent Immobilier',         'AGENT_IMMOBILIER',      'agency')
ON CONFLICT (code) DO NOTHING;

SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));

-- ----------------------------------------------------------
-- BUDGET_ENVELOPES — Exemple pour l'exercice 2025
-- ----------------------------------------------------------
INSERT INTO budget_envelopes (entity_type, entity_id, fiscal_year, category, allocated, consumed) VALUES
  -- Siège (agency_id = 1)
  ('agency', 1, 2025, 'FONCTIONNEMENT',  50000, 0),
  ('agency', 1, 2025, 'INVESTISSEMENT',  80000, 0),
  ('agency', 1, 2025, 'RH',            200000, 0),
  -- Services du siège
  ('department', 1, 2025, 'FONCTIONNEMENT', 15000, 0),  -- RH
  ('department', 2, 2025, 'FONCTIONNEMENT', 10000, 0),  -- Finance
  ('department', 5, 2025, 'FONCTIONNEMENT', 25000, 0),  -- Marketing
  -- Agences
  ('agency', 2, 2025, 'FONCTIONNEMENT', 30000, 0),  -- Mulhouse
  ('agency', 2, 2025, 'RH',            120000, 0),
  ('agency', 3, 2025, 'FONCTIONNEMENT', 28000, 0),  -- Colmar
  ('agency', 3, 2025, 'RH',            115000, 0),
  ('agency', 4, 2025, 'FONCTIONNEMENT', 32000, 0),  -- Strasbourg
  ('agency', 4, 2025, 'RH',            130000, 0)
ON CONFLICT (entity_type, entity_id, fiscal_year, category) DO NOTHING;

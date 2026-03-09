-- ============================================================
-- MIGRATION 005 — Réponses élèves + données exercices enrichies
-- Date : 2026-03-07
--
-- 1. Table reponses_eleves (réponses individuelles par élève × mission)
-- 2. Exercice 1 — RC Pro expirée : données ERP à saisir + donnees_exercice
-- 3. Exercice 2 — Formation DDA obligatoire : insertion formation Thomas MEYER
-- 4. Exercice 5 — Renouvellement cartes pro : dates J+29/J+25 + donnees_exercice
-- 5. Exercice 3 — Marc Petit dossier partiel : documents_rh
-- ============================================================


-- ============================================================
-- 1. TABLE reponses_eleves
-- ============================================================

CREATE TABLE IF NOT EXISTS reponses_eleves (
  id            SERIAL PRIMARY KEY,
  mission_id    INTEGER NOT NULL,
  eleve_nom     VARCHAR(200) NOT NULL,
  reponse_texte TEXT,
  fichier_url   TEXT,           -- URL Supabase Storage (PDF/Word uploadé)
  lien_url      TEXT,           -- Google Doc, Drive, site web, etc.
  submitted_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (mission_id, eleve_nom)   -- upsert par élève × mission
);

ALTER TABLE reponses_eleves ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "rep_select" ON reponses_eleves;
DROP POLICY IF EXISTS "rep_insert" ON reponses_eleves;
DROP POLICY IF EXISTS "rep_update" ON reponses_eleves;

CREATE POLICY "rep_select" ON reponses_eleves FOR SELECT USING (true);
CREATE POLICY "rep_insert" ON reponses_eleves FOR INSERT WITH CHECK (true);
CREATE POLICY "rep_update" ON reponses_eleves FOR UPDATE USING (true);

-- Note : créer le bucket Storage 'reponses-eleves' (public: true) dans
--        Supabase Dashboard → Storage → New bucket


-- ============================================================
-- 2. EXERCICE 1 — RC Pro expirée
--    Données ERP fictives que les élèves doivent saisir
-- ============================================================

-- 2a. Deux salariés fictifs pour l'exercice
INSERT INTO salaries (
  nom, prenom, poste, service, agence, date_embauche, email, telephone
) VALUES
('DUMONT', 'Cédric',
  'Négociateur Immobilier', 'Commercial', 'Colmar',
  '2023-09-01', 'dumont.c@labelleagence.fr', '0643218765'),
('PERRIN', 'Alice',
  'Négociatrice Immobilière', 'Commercial', 'Mulhouse',
  '2022-03-14', 'perrin.a@labelleagence.fr', '0698123456')
ON CONFLICT DO NOTHING;

-- 2b. RC Pro : 1 valide (2027), 1 expirée (2025)
INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut) VALUES
('Cédric DUMONT', 'AXA Entreprises',   'AXA-RC-COL-2025-214',  500000, '2025-01-01', '2025-07-31', 'expiré'),
('Alice PERRIN',  'ALLIANZ Professionnels', 'ALLZ-RC-MLH-2025-330', 1000000, '2025-03-01', '2027-02-28', 'valide')
ON CONFLICT DO NOTHING;

-- 2c. Cartes professionnelles : 1 expirée, 1 valide
INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut) VALUES
('Cédric DUMONT', 'CPI-68-2022-4411', '2024-12-31', 'CCI Alsace',   'expiré'),
('Alice PERRIN',  'CPI-68-2023-8872', '2027-06-15', 'CCI Alsace',   'valide')
ON CONFLICT DO NOTHING;

-- 2d. Formations DDA : toutes deux validées
INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation, statut) VALUES
('Cédric DUMONT', 'DDA : conformité et pratique de la transaction', 'FNAIM Formation', '2025-01-10', 15.0, 'DDA', 'validée'),
('Alice PERRIN',  'Réglementation DDA et distribution immobilière',  'IFOCOP',          '2025-11-22', 15.0, 'DDA', 'validée')
ON CONFLICT DO NOTHING;

-- 2e. Mise à jour donnees_exercice de la mission RC Pro expirée
UPDATE missions SET donnees_exercice = '{
  "etape_1_saisie_erp": {
    "consigne": "Saisissez ces 4 enregistrements dans l''ERP (onglets Conformité) avant de continuer l''exercice",
    "salaries_a_saisir": [
      {
        "nom": "DUMONT",
        "prenom": "Cédric",
        "poste": "Négociateur Immobilier",
        "agence": "Colmar",
        "date_embauche": "2023-09-01",
        "email": "dumont.c@labelleagence.fr",
        "telephone": "06 43 21 87 65"
      },
      {
        "nom": "PERRIN",
        "prenom": "Alice",
        "poste": "Négociatrice Immobilière",
        "agence": "Mulhouse",
        "date_embauche": "2022-03-14",
        "email": "perrin.a@labelleagence.fr",
        "telephone": "06 98 12 34 56"
      }
    ],
    "rc_pro_a_saisir": [
      {
        "salarie": "Cédric DUMONT",
        "compagnie": "AXA Entreprises",
        "numero_police": "AXA-RC-COL-2025-214",
        "montant_garantie": 500000,
        "date_debut": "2025-01-01",
        "date_fin": "2025-07-31",
        "statut": "expiré"
      },
      {
        "salarie": "Alice PERRIN",
        "compagnie": "ALLIANZ Professionnels",
        "numero_police": "ALLZ-RC-MLH-2025-330",
        "montant_garantie": 1000000,
        "date_debut": "2025-03-01",
        "date_fin": "2027-02-28",
        "statut": "valide"
      }
    ],
    "cartes_a_saisir": [
      {
        "salarie": "Cédric DUMONT",
        "numero_carte": "CPI-68-2022-4411",
        "date_expiration": "2024-12-31",
        "organisme": "CCI Alsace",
        "statut": "expiré"
      },
      {
        "salarie": "Alice PERRIN",
        "numero_carte": "CPI-68-2023-8872",
        "date_expiration": "2027-06-15",
        "organisme": "CCI Alsace",
        "statut": "valide"
      }
    ],
    "formations_a_saisir": [
      {
        "salarie": "Cédric DUMONT",
        "intitule": "DDA : conformité et pratique de la transaction",
        "organisme": "FNAIM Formation",
        "date_formation": "2025-01-10",
        "duree_heures": 15,
        "type": "DDA"
      },
      {
        "salarie": "Alice PERRIN",
        "intitule": "Réglementation DDA et distribution immobilière",
        "organisme": "IFOCOP",
        "date_formation": "2025-11-22",
        "duree_heures": 15,
        "type": "DDA"
      }
    ]
  },
  "etape_2_verification": {
    "consigne": "Vérifiez dans l''ERP (Conformité → Assurances RC) s''il n''y a pas d''autres attestations expirées parmi tous les salariés de l''agence."
  },
  "instructions": [
    "1. Saisissez les 4 enregistrements de l''étape 1 dans l''ERP.",
    "2. Identifiez dans l''ERP quelle attestation RC Pro est expirée.",
    "3. Rédigez un email de relance au salarié concerné — délai de réponse : 15 jours.",
    "4. Rédigez un email à la compagnie d''assurance pour demander la transmission d''une nouvelle attestation — délai : 7 jours.",
    "5. Enregistrez la relance dans la table assurances_rc (champ statut → ''en renouvellement'')."
  ],
  "reglementation": {
    "obligation": "Tout agent immobilier doit disposer d''une RC Pro valide (Loi Hoguet Art. 3)",
    "montant_minimum": "Couverture minimale : 500 000 € par sinistre",
    "sanction": "Exercice illégal sans attestation valide — suspension carte CPI"
  }
}'::jsonb
WHERE id = (
  SELECT id FROM missions
  WHERE titre ILIKE '%rc%pro%'
     OR titre ILIKE '%rc expir%'
     OR titre ILIKE '%assurance%expir%'
  ORDER BY id
  LIMIT 1
);


-- ============================================================
-- 3. EXERCICE 2 — Formation DDA : Thomas MEYER (proche expiration)
-- ============================================================

-- 3a. Formation DDA pour Thomas MEYER avec date proche (J+8 = rouge)
INSERT INTO formations (
  salarie_nom, intitule, organisme,
  date_formation, duree_heures, type_formation, statut, certificat_url
) VALUES (
  'Thomas MEYER',
  'DDA — Réglementation distribution assurances et pratique',
  'FNAIM Formation',
  '2025-03-15',
  15.0,
  'DDA',
  'validée',
  'certificats/DDA_MEYER_Thomas_2025.pdf'
)
ON CONFLICT DO NOTHING;

-- 3b. Mise à jour donnees_exercice de la mission Formation obligatoire
UPDATE missions SET donnees_exercice = '{
  "contexte": "Thomas MEYER a rejoint l''agence Strasbourg le 1er mars 2026. Sa dernière formation DDA remonte au 15 mars 2025. La prochaine échéance est donc le 15 mars 2026 — soit dans 8 jours. Il faut agir immédiatement.",
  "formation_a_verifier": {
    "salarie": "Thomas MEYER",
    "intitule": "DDA — Réglementation distribution assurances et pratique",
    "organisme": "FNAIM Formation",
    "date_formation": "2025-03-15",
    "prochaine_echeance": "2026-03-15",
    "jours_restants": 8,
    "urgence": "CRITIQUE"
  },
  "instructions": [
    "1. Vérifiez dans l''ERP (Conformité → Formations DDA) la date de la dernière formation DDA de Thomas MEYER.",
    "2. Identifiez la colonne ''Prochaine DDA'' et constatez l''urgence (affichée en rouge).",
    "3. Contactez un organisme agréé pour planifier la formation avant expiration.",
    "4. Rédigez l''email de convocation à Thomas MEYER.",
    "5. Mettez à jour l''enregistrement une fois la formation réalisée (nouveau certificat_url)."
  ],
  "organismes_agrees": ["IFOCOP", "FNAIM Formation", "AUREP", "AF2I", "IFPASS"],
  "reglementation": {
    "heures_minimum": "14 heures par an (Directive Distribution Assurances)",
    "periodicite": "Renouvellement annuel obligatoire",
    "sanction": "Interdiction d''exercice sans attestation valide à jour"
  }
}'::jsonb
WHERE id = (
  SELECT id FROM missions
  WHERE titre ILIKE '%formation%oblig%'
     OR titre ILIKE '%dda%expir%'
     OR titre ILIKE '%formation%dda%'
  ORDER BY id
  LIMIT 1
);


-- ============================================================
-- 4. EXERCICE 5 — Renouvellement cartes pro (J+29 et J+25)
-- ============================================================

-- 4a. WEBER Lucas : carte expirée dans 29 jours (2026-04-05)
UPDATE cartes_professionnelles
SET date_expiration = '2026-04-05',
    statut          = 'valide'
WHERE salarie_nom = 'Lucas WEBER';

-- 4b. THOMAS David : carte expirée dans 25 jours (2026-04-01)
UPDATE cartes_professionnelles
SET date_expiration = '2026-04-01',
    statut          = 'valide'
WHERE salarie_nom = 'David THOMAS';

-- 4c. Mise à jour donnees_exercice de la mission Renouvellement cartes pro
UPDATE missions SET donnees_exercice = '{
  "contexte": "Vous êtes assistante conformité au siège. Vous devez identifier les cartes professionnelles arrivant à expiration dans moins de 30 jours et lancer les procédures de renouvellement.",
  "instructions": [
    "1. Consultez l''ERP (Conformité → Cartes pro) et identifiez les cartes expirant dans moins de 30 jours.",
    "2. Pour chaque carte identifiée, vérifiez que le salarié dispose bien de 14h de formation DDA et d''une RC Pro valide.",
    "3. Rédigez le courrier de demande de renouvellement à la CCI compétente.",
    "4. Envoyez un email d''alerte au salarié concerné avec la liste des documents à fournir.",
    "5. Mettez à jour le statut dans l''ERP à ''en renouvellement''."
  ],
  "cartes_proches_expiration": [
    {
      "salarie": "Lucas WEBER",
      "agence": "Mulhouse",
      "numero_carte": "CPI-68-2023-2345",
      "date_expiration": "2026-04-05",
      "jours_restants": 29,
      "organisme": "CCI Alsace",
      "email_salarie": "weber.l@labelleagence.fr"
    },
    {
      "salarie": "David THOMAS",
      "agence": "Strasbourg",
      "numero_carte": "CPI-67-2023-6789",
      "date_expiration": "2026-04-01",
      "jours_restants": 25,
      "organisme": "CCI Bas-Rhin",
      "email_salarie": "thomas.d@labelleagence.fr"
    }
  ],
  "pieces_a_fournir_renouvellement": [
    "Attestation de 14h de formation DDA (organisme agréé Qualiopi)",
    "Attestation RC Professionnelle en cours de validité",
    "Justificatif de domicile (< 3 mois)",
    "Photo d''identité",
    "Formulaire de renouvellement CCI complété"
  ],
  "reglementation": {
    "loi": "Loi Hoguet — Art. 3 et 4",
    "organisme_delivreur": "CCI (Chambre de Commerce et d''Industrie)",
    "duree_validite": "3 ans renouvelables",
    "delai_renouvellement": "Dossier à déposer au moins 3 mois avant expiration"
  }
}'::jsonb
WHERE id = (
  SELECT id FROM missions
  WHERE titre ILIKE '%renouvell%'
     OR titre ILIKE '%carte%pro%'
     OR (titre ILIKE '%conformit%' AND titre ILIKE '%carte%')
  ORDER BY id
  LIMIT 1
);


-- ============================================================
-- 5. EXERCICE 3 — Marc Petit : dossier partiel (3 présents, 2 manquants)
-- ============================================================

-- Supprimer les éventuelles entrées existantes (idempotence)
DELETE FROM documents_rh WHERE salarie_nom = 'Marc Petit'
  AND type_document IN (
    'CV', 'Diplôme BTS Professions Immobilières', 'Casier judiciaire bulletin B3',
    'Carte professionnelle CPI (ORIAS)', 'Attestation RC Professionnelle 2026'
  );

-- 5a. Documents présents (3)
INSERT INTO documents_rh (salarie_nom, type_document, url, date_expiration, alerte_active) VALUES
('Marc Petit', 'CV',
  'dossiers/PETIT_Marc/CV_PETIT_Marc_2024.pdf',         NULL,         FALSE),
('Marc Petit', 'Diplôme BTS Professions Immobilières',
  'dossiers/PETIT_Marc/Diplome_BTS_PI_PETIT.pdf',       NULL,         FALSE),
('Marc Petit', 'Casier judiciaire bulletin B3',
  'dossiers/PETIT_Marc/Casier_B3_PETIT_Marc_2024.pdf',  '2024-12-01', FALSE);

-- 5b. Documents manquants (2)
INSERT INTO documents_rh (salarie_nom, type_document, url, date_expiration, alerte_active) VALUES
('Marc Petit', 'Carte professionnelle CPI (ORIAS)',  NULL, NULL, TRUE),
('Marc Petit', 'Attestation RC Professionnelle 2026', NULL, NULL, TRUE);


-- ============================================================
-- FIN MIGRATION 005
-- ============================================================

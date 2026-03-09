-- ============================================================
-- MIGRATION 003 — Exercice Conformité : Dossier ORIAS Thomas MEYER
-- Difficulté : moyen • Durée estimée : 25 min
--
-- Ce fichier est autonome : il crée les tables manquantes
-- si services_tables.sql n'a pas encore été exécuté.
-- ============================================================

-- ============================================================
-- TABLES — Création si inexistantes
-- ============================================================

-- Colonnes étendues sur salaries
ALTER TABLE salaries
  ADD COLUMN IF NOT EXISTS age          INTEGER,
  ADD COLUMN IF NOT EXISTS origine      VARCHAR(100),
  ADD COLUMN IF NOT EXISTS email        VARCHAR(255),
  ADD COLUMN IF NOT EXISTS telephone    VARCHAR(20),
  ADD COLUMN IF NOT EXISTS adresse      TEXT,
  ADD COLUMN IF NOT EXISTS agence       VARCHAR(100),
  ADD COLUMN IF NOT EXISTS salaire_brut NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS type_contrat VARCHAR(50) DEFAULT 'CDI';

CREATE TABLE IF NOT EXISTS documents_rh (
  id              SERIAL PRIMARY KEY,
  salarie_nom     VARCHAR(200) NOT NULL,
  type_document   VARCHAR(100),
  url             TEXT,
  date_expiration DATE,
  alerte_active   BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cartes_professionnelles (
  id                  SERIAL PRIMARY KEY,
  salarie_nom         VARCHAR(200) NOT NULL,
  numero_carte        VARCHAR(100),
  date_expiration     DATE,
  organisme_delivreur VARCHAR(200),
  statut              VARCHAR(50) DEFAULT 'valide',
  created_at          TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assurances_rc (
  id               SERIAL PRIMARY KEY,
  salarie_nom      VARCHAR(200) NOT NULL,
  compagnie        VARCHAR(200) NOT NULL,
  numero_police    VARCHAR(100),
  montant_garantie NUMERIC(14,2),
  date_debut       DATE,
  date_fin         DATE,
  statut           VARCHAR(50) DEFAULT 'valide'
    CHECK (statut IN ('valide', 'expiré', 'en renouvellement')),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE documents_rh          ENABLE ROW LEVEL SECURITY;
ALTER TABLE cartes_professionnelles ENABLE ROW LEVEL SECURITY;
ALTER TABLE assurances_rc          ENABLE ROW LEVEL SECURITY;

-- Policies (DROP IF EXISTS pour idempotence)
DROP POLICY IF EXISTS "documents_rh_select" ON documents_rh;
DROP POLICY IF EXISTS "documents_rh_insert" ON documents_rh;
DROP POLICY IF EXISTS "documents_rh_update" ON documents_rh;
DROP POLICY IF EXISTS "documents_rh_delete" ON documents_rh;
CREATE POLICY "documents_rh_select" ON documents_rh FOR SELECT USING (true);
CREATE POLICY "documents_rh_insert" ON documents_rh FOR INSERT WITH CHECK (true);
CREATE POLICY "documents_rh_update" ON documents_rh FOR UPDATE USING (true);
CREATE POLICY "documents_rh_delete" ON documents_rh FOR DELETE USING (true);

DROP POLICY IF EXISTS "cartes_pro_select" ON cartes_professionnelles;
DROP POLICY IF EXISTS "cartes_pro_insert" ON cartes_professionnelles;
DROP POLICY IF EXISTS "cartes_pro_update" ON cartes_professionnelles;
DROP POLICY IF EXISTS "cartes_pro_delete" ON cartes_professionnelles;
CREATE POLICY "cartes_pro_select" ON cartes_professionnelles FOR SELECT USING (true);
CREATE POLICY "cartes_pro_insert" ON cartes_professionnelles FOR INSERT WITH CHECK (true);
CREATE POLICY "cartes_pro_update" ON cartes_professionnelles FOR UPDATE USING (true);
CREATE POLICY "cartes_pro_delete" ON cartes_professionnelles FOR DELETE USING (true);

DROP POLICY IF EXISTS "assurances_select" ON assurances_rc;
DROP POLICY IF EXISTS "assurances_insert" ON assurances_rc;
DROP POLICY IF EXISTS "assurances_update" ON assurances_rc;
DROP POLICY IF EXISTS "assurances_delete" ON assurances_rc;
CREATE POLICY "assurances_select" ON assurances_rc FOR SELECT USING (true);
CREATE POLICY "assurances_insert" ON assurances_rc FOR INSERT WITH CHECK (true);
CREATE POLICY "assurances_update" ON assurances_rc FOR UPDATE USING (true);
CREATE POLICY "assurances_delete" ON assurances_rc FOR DELETE USING (true);

-- ============================================================
-- 1. SALARIÉ — Thomas MEYER, Agent Immobilier Strasbourg
-- ============================================================

INSERT INTO salaries (
  nom, prenom, age, origine, email, telephone, adresse,
  poste, service, agence, date_embauche, salaire_brut, type_contrat
)
VALUES (
  'MEYER', 'Thomas', 28, 'Alsacien',
  'meyer.t@labelleagence.fr', '0672345621',
  '14 rue des Artisans, 67000 Strasbourg',
  'Agent Immobilier', 'Commercial', 'Strasbourg',
  '2026-03-01', 2350.00, 'CDI'
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. DOCUMENTS RH — 3 fournis ✅ + 3 manquants ❌
-- ============================================================

INSERT INTO documents_rh (salarie_nom, type_document, url, date_expiration, alerte_active) VALUES
('Thomas MEYER', 'CV',
  'dossiers/MEYER_Thomas/CV_MEYER_Thomas_2026.pdf',     NULL,         FALSE),
('Thomas MEYER', 'Diplôme BTS Professions Immobilières',
  'dossiers/MEYER_Thomas/Diplome_BTS_PI_MEYER.pdf',     NULL,         FALSE),
('Thomas MEYER', 'Casier judiciaire bulletin B3',
  'dossiers/MEYER_Thomas/Casier_B3_MEYER_Thomas_2026.pdf', '2026-06-01', FALSE),
('Thomas MEYER', 'Carte professionnelle CPI (ORIAS)',   NULL,         NULL, TRUE),
('Thomas MEYER', 'Attestation RC Professionnelle',      NULL,         NULL, TRUE),
('Thomas MEYER', 'Justificatif de domicile (< 3 mois)', NULL,         NULL, TRUE);

-- ============================================================
-- 3. CARTE PROFESSIONNELLE — Dossier CPI à constituer
-- ============================================================

ALTER TABLE cartes_professionnelles
  ADD COLUMN IF NOT EXISTS organisme_delivreur VARCHAR(200);

INSERT INTO cartes_professionnelles (
  salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut
)
VALUES (
  'Thomas MEYER',
  NULL,
  NULL,
  'CCI Alsace — Délégation Bas-Rhin',
  'en renouvellement'
);

-- ============================================================
-- 4. ASSURANCE RC PRO — À souscrire
-- ============================================================

INSERT INTO assurances_rc (
  salarie_nom, compagnie, numero_police,
  montant_garantie, date_debut, date_fin, statut
)
VALUES (
  'Thomas MEYER',
  'MAIF Professionnels',
  NULL, NULL, NULL, NULL,
  'en renouvellement'
);

-- ============================================================
-- 5. MISSION — donnees_exercice (UPDATE si la mission existe)
-- ============================================================

UPDATE missions SET
  donnees_exercice = '{
    "contexte": "Thomas MEYER vient d''être embauché comme agent immobilier à l''agence Strasbourg le 1er mars 2026. Vous êtes assistante conformité au siège. Vous devez constituer son dossier ORIAS complet avant qu''il puisse exercer légalement. Par ailleurs, Marc PETIT (agent Strasbourg depuis 2018) a un dossier incomplet à régulariser.",

    "profil_nouveau_salarie": {
      "nom": "MEYER",
      "prenom": "Thomas",
      "age": 28,
      "poste": "Agent Immobilier",
      "agence": "Strasbourg",
      "date_embauche": "2026-03-01",
      "email": "meyer.t@labelleagence.fr",
      "telephone": "06 72 34 56 21",
      "adresse": "14 rue des Artisans, 67000 Strasbourg"
    },

    "checklist_orias": [
      {"document": "CV à jour",                            "obligatoire": true, "statut": "fourni",   "commentaire": null},
      {"document": "Diplôme BTS Professions Immobilières", "obligatoire": true, "statut": "fourni",   "commentaire": "Équivalence acceptée : BTS PI ou Licence Droit/Éco"},
      {"document": "Casier judiciaire bulletin B3",        "obligatoire": true, "statut": "fourni",   "commentaire": "Doit dater de moins de 3 mois"},
      {"document": "Carte professionnelle CPI",            "obligatoire": true, "statut": "manquant", "commentaire": "À demander à la CCI Alsace — délai : 15 jours ouvrés"},
      {"document": "Attestation RC Professionnelle",       "obligatoire": true, "statut": "manquant", "commentaire": "Doit couvrir au minimum 500 000 € par sinistre"},
      {"document": "Justificatif de domicile (< 3 mois)",  "obligatoire": true, "statut": "manquant", "commentaire": "Quittance EDF, loyer ou relevé bancaire acceptés"}
    ],

    "documents_fournis": [
      "CV_MEYER_Thomas_2026.pdf",
      "Diplome_BTS_PI_MEYER.pdf",
      "Casier_B3_MEYER_Thomas_2026.pdf"
    ],

    "documents_manquants": [
      {
        "document": "Carte professionnelle CPI",
        "organisme": "CCI Alsace — Délégation Bas-Rhin",
        "adresse_depot": "10 Place Gutenberg, 67000 Strasbourg",
        "delai_traitement": "15 jours ouvrés",
        "frais": "130 € (prise en charge par l''agence)",
        "pieces_a_fournir_pour_cpi": [
          "Diplôme BTS PI ou équivalent",
          "Casier judiciaire bulletin B3 (< 3 mois)",
          "Justificatif de domicile (< 3 mois)",
          "Photo d''identité",
          "Formulaire cerfa N°15925*01 complété",
          "Attestation d''assurance RC Pro (à fournir en parallèle)"
        ]
      },
      {
        "document": "Attestation RC Professionnelle",
        "organisme": "MAIF Professionnels",
        "note": "Thomas doit être rattaché à la police collective de l''agence Strasbourg (MAIF-RC-STR-2026-332)",
        "montant_minimum": "500 000 € par sinistre (Loi Hoguet)"
      },
      {
        "document": "Justificatif de domicile (< 3 mois)",
        "exemples_acceptes": ["Quittance de loyer", "Facture EDF/GDF", "Relevé bancaire"]
      }
    ],

    "reglementation": {
      "loi_reference": "Loi Hoguet — Art. 3 et 4",
      "condition_exercice": "Aucun acte de transaction immobilière ne peut être réalisé sans carte professionnelle CPI valide",
      "organisme_delivreur": "CCI (Chambre de Commerce et d''Industrie) — délégation territoriale",
      "duree_validite_carte": "3 ans renouvelables",
      "obligation_dda": "14 heures de formation continue par an (Directive Distribution Assurances)"
    },

    "marc_petit_dossier_partiel": {
      "nom": "PETIT",
      "prenom": "Marc",
      "poste": "Agent Immobilier",
      "agence": "Strasbourg",
      "date_embauche": "2018-04-15",
      "email": "petit.m@labelleagence.fr",
      "statut_dossier": "partiel",
      "documents_presents": [
        "CV (2024)",
        "Diplôme BTS Professions Immobilières",
        "Casier judiciaire bulletin B3 (2024)"
      ],
      "documents_manquants": [
        {
          "document": "Carte professionnelle CPI",
          "statut": "expirée depuis le 30/09/2024",
          "numero_carte": "CPI-67-2020-007654",
          "action": "Dossier de renouvellement à constituer et déposer à la CCI Bas-Rhin"
        },
        {
          "document": "Attestation RC Professionnelle 2026",
          "statut": "non renseignée dans l''ERP",
          "action": "Vérifier auprès de MAIF Professionnels si Marc est bien couvert par la police collective STR"
        }
      ],
      "notes": "Marc exerce depuis 2018 mais sa carte CPI est expirée. Il ne peut pas légalement signer de compromis tant que le renouvellement n''est pas finalisé."
    },

    "consignes": [
      "1. Saisissez Thomas MEYER dans l''ERP (onglet RH → Salariés) et complétez sa checklist ORIAS.",
      "2. Rédigez un email à Thomas MEYER pour lui demander les 3 documents manquants.",
      "3. Rédigez le courrier de demande de carte CPI à la CCI Alsace (utilisez le template Conformité).",
      "4. Vérifiez le dossier de Marc PETIT dans l''ERP et identifiez les documents manquants.",
      "5. Enregistrez les documents reçus dans la table documents_rh de l''ERP."
    ],

    "email_destinataire": "meyer.t@labelleagence.fr",
    "email_objet": "Constitution de votre dossier ORIAS — pièces manquantes"
  }'::jsonb,
  fichiers_annexes = ARRAY[
    'annexes/Fiche_ORIAS_documents_requis.pdf',
    'annexes/Formulaire_demande_CPI_CCI_Alsace.pdf',
    'annexes/Modele_email_demande_pieces.txt'
  ]
WHERE id = (
  SELECT id FROM missions
  WHERE titre ILIKE '%conformit%'
     OR titre ILIKE '%orias%'
     OR titre ILIKE '%thomas meyer%'
  ORDER BY id
  LIMIT 1
);

-- ============================================================
-- FIN MIGRATION 003
-- ============================================================

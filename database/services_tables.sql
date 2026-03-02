-- ============================================================
-- ERP LA BELLE AGENCE — Tables services métier
-- À exécuter dans l'éditeur SQL de Supabase
-- ============================================================

-- ============================================================
-- ALTER TABLE missions : nouvelles colonnes
-- ============================================================
ALTER TABLE missions ADD COLUMN IF NOT EXISTS donnees_exercice JSONB DEFAULT '{}';
ALTER TABLE missions ADD COLUMN IF NOT EXISTS reponse_eleve TEXT;
ALTER TABLE missions ADD COLUMN IF NOT EXISTS fichiers_annexes TEXT[] DEFAULT '{}';

-- ============================================================
-- Templates de documents
-- ============================================================
CREATE TABLE IF NOT EXISTS templates_documents (
  id               SERIAL PRIMARY KEY,
  type             VARCHAR(50),   -- 'email', 'contrat', 'facture', 'courrier', 'rh'
  service          VARCHAR(50),   -- 'RH', 'Marketing', 'Finance', 'Commercial', 'Conformité'
  nom              VARCHAR(200) NOT NULL,
  contenu_template TEXT,
  exemple_rempli   TEXT,
  created_at       TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables RH
-- ============================================================
CREATE TABLE IF NOT EXISTS conges (
  id           SERIAL PRIMARY KEY,
  salarie_nom  VARCHAR(200) NOT NULL,
  type         VARCHAR(50) DEFAULT 'CP',   -- 'CP', 'RTT', 'maladie', 'autre'
  date_debut   DATE NOT NULL,
  date_fin     DATE NOT NULL,
  jours        INTEGER,
  statut       VARCHAR(30) DEFAULT 'en attente',  -- 'en attente', 'approuvé', 'refusé'
  created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS formations (
  id              SERIAL PRIMARY KEY,
  salarie_nom     VARCHAR(200) NOT NULL,
  intitule        VARCHAR(255) NOT NULL,
  organisme       VARCHAR(200),
  date_formation  DATE,
  duree_heures    NUMERIC(6,2),
  type_formation  VARCHAR(50) DEFAULT 'facultatif',  -- 'DDA', 'obligatoire', 'facultatif'
  certificat_url  TEXT,
  created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS documents_rh (
  id              SERIAL PRIMARY KEY,
  salarie_nom     VARCHAR(200) NOT NULL,
  type_document   VARCHAR(100),
  url             TEXT,
  date_expiration DATE,
  alerte_active   BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables Conformité
-- ============================================================
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
  compagnie        VARCHAR(200) NOT NULL,
  numero_police    VARCHAR(100),
  montant_garantie NUMERIC(14,2),
  date_debut       DATE,
  date_fin         DATE,
  created_at       TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables Marketing
-- ============================================================
CREATE TABLE IF NOT EXISTS campagnes_marketing (
  id           SERIAL PRIMARY KEY,
  nom          VARCHAR(200) NOT NULL,
  canal        VARCHAR(100),   -- 'réseaux sociaux', 'email', 'print', 'événement'
  budget       NUMERIC(12,2),
  date_debut   DATE,
  date_fin     DATE,
  statut       VARCHAR(50) DEFAULT 'en préparation',
  objectif     TEXT,
  created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS posts_sociaux (
  id                SERIAL PRIMARY KEY,
  plateforme        VARCHAR(100),
  contenu           TEXT,
  date_publication  DATE,
  statut            VARCHAR(50) DEFAULT 'brouillon',  -- 'brouillon', 'planifié', 'publié'
  engagement_likes  INTEGER DEFAULT 0,
  created_at        TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables Finance
-- ============================================================
CREATE TABLE IF NOT EXISTS factures_fournisseurs (
  id               SERIAL PRIMARY KEY,
  numero_facture   VARCHAR(100) NOT NULL,
  fournisseur      VARCHAR(200) NOT NULL,
  montant_ht       NUMERIC(12,2),
  tva              NUMERIC(5,2) DEFAULT 20.00,
  montant_ttc      NUMERIC(12,2),
  date_facture     DATE,
  date_echeance    DATE,
  statut           VARCHAR(50) DEFAULT 'reçue',  -- 'reçue', 'validée', 'payée', 'litigieuse'
  anomalie         TEXT,
  created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS factures_clients (
  id               SERIAL PRIMARY KEY,
  numero_facture   VARCHAR(100) NOT NULL,
  client_nom       VARCHAR(200),
  bien_ref         VARCHAR(100),
  montant_ht       NUMERIC(12,2),
  tva              NUMERIC(5,2) DEFAULT 20.00,
  montant_ttc      NUMERIC(12,2),
  date_facture     DATE,
  statut           VARCHAR(50) DEFAULT 'émise',
  created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ecritures_comptables (
  id                  SERIAL PRIMARY KEY,
  date_ecriture       DATE NOT NULL,
  libelle             VARCHAR(255) NOT NULL,
  compte_debit        VARCHAR(50),
  compte_credit       VARCHAR(50),
  montant             NUMERIC(12,2) NOT NULL,
  piece_justificative TEXT,
  created_at          TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables Gestion Patrimoine
-- ============================================================
CREATE TABLE IF NOT EXISTS dossiers_patrimoniaux (
  id                      SERIAL PRIMARY KEY,
  client_id               INTEGER REFERENCES clients(id) ON DELETE SET NULL,
  conseiller_nom          VARCHAR(200),
  date_entree             DATE,
  objectif_patrimoine     TEXT,
  montant_patrimoine_brut NUMERIC(14,2),
  revenus_annuels         NUMERIC(12,2),
  profil_risque           VARCHAR(50) DEFAULT 'équilibré',  -- 'prudent', 'équilibré', 'dynamique'
  statut                  VARCHAR(50) DEFAULT 'actif',       -- 'actif', 'clôturé'
  created_at              TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables Commercial Immobilier
-- ============================================================
CREATE TABLE IF NOT EXISTS visites (
  id         SERIAL PRIMARY KEY,
  bien_id    INTEGER REFERENCES biens(id) ON DELETE SET NULL,
  client_nom VARCHAR(200) NOT NULL,
  date_visite DATE NOT NULL,
  heure      TIME,
  agent_nom  VARCHAR(200),
  statut     VARCHAR(50) DEFAULT 'planifiée',  -- 'planifiée', 'réalisée', 'annulée'
  feedback   TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS offres (
  id           SERIAL PRIMARY KEY,
  bien_id      INTEGER REFERENCES biens(id) ON DELETE SET NULL,
  acheteur_nom VARCHAR(200) NOT NULL,
  vendeur_nom  VARCHAR(200),
  montant_offre NUMERIC(12,2) NOT NULL,
  date_offre   DATE NOT NULL,
  statut       VARCHAR(50) DEFAULT 'en cours',  -- 'en cours', 'acceptée', 'refusée', 'contre-offre'
  created_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ventes (
  id                SERIAL PRIMARY KEY,
  bien_id           INTEGER REFERENCES biens(id) ON DELETE SET NULL,
  acheteur_nom      VARCHAR(200) NOT NULL,
  vendeur_nom       VARCHAR(200),
  prix_vente        NUMERIC(12,2) NOT NULL,
  date_compromis    DATE,
  date_acte         DATE,
  notaire           VARCHAR(200),
  commission_agence NUMERIC(12,2),
  statut            VARCHAR(50) DEFAULT 'en cours',  -- 'en cours', 'signée', 'annulée'
  created_at        TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- Tables IT
-- ============================================================
CREATE TABLE IF NOT EXISTS tickets_support (
  id             SERIAL PRIMARY KEY,
  demandeur_nom  VARCHAR(200) NOT NULL,
  titre          VARCHAR(255) NOT NULL,
  description    TEXT,
  priorite       VARCHAR(50) DEFAULT 'normale',  -- 'basse', 'normale', 'haute', 'critique'
  statut         VARCHAR(50) DEFAULT 'ouvert',   -- 'ouvert', 'en cours', 'résolu', 'fermé'
  agent_it       VARCHAR(200),
  created_at     TIMESTAMP DEFAULT NOW(),
  resolved_at    TIMESTAMP
);

CREATE TABLE IF NOT EXISTS materiel_informatique (
  id             SERIAL PRIMARY KEY,
  designation    VARCHAR(200) NOT NULL,
  marque         VARCHAR(100),
  numero_serie   VARCHAR(100),
  utilisateur_nom VARCHAR(200),
  date_achat     DATE,
  garantie_fin   DATE,
  statut         VARCHAR(50) DEFAULT 'opérationnel',  -- 'opérationnel', 'panne', 'réforme'
  created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS licences_logiciels (
  id              SERIAL PRIMARY KEY,
  logiciel        VARCHAR(200) NOT NULL,
  editeur         VARCHAR(200),
  nombre_postes   INTEGER DEFAULT 1,
  date_expiration DATE,
  cout_annuel     NUMERIC(10,2),
  statut          VARCHAR(50) DEFAULT 'active',  -- 'active', 'expiree', 'renouvellement'
  created_at      TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- RLS : activer sur toutes les nouvelles tables
-- ============================================================
ALTER TABLE templates_documents      ENABLE ROW LEVEL SECURITY;
ALTER TABLE conges                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE formations               ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents_rh             ENABLE ROW LEVEL SECURITY;
ALTER TABLE cartes_professionnelles  ENABLE ROW LEVEL SECURITY;
ALTER TABLE assurances_rc            ENABLE ROW LEVEL SECURITY;
ALTER TABLE campagnes_marketing      ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts_sociaux            ENABLE ROW LEVEL SECURITY;
ALTER TABLE factures_fournisseurs    ENABLE ROW LEVEL SECURITY;
ALTER TABLE factures_clients         ENABLE ROW LEVEL SECURITY;
ALTER TABLE ecritures_comptables     ENABLE ROW LEVEL SECURITY;
ALTER TABLE dossiers_patrimoniaux    ENABLE ROW LEVEL SECURITY;
ALTER TABLE visites                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE offres                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventes                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets_support          ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiel_informatique    ENABLE ROW LEVEL SECURITY;
ALTER TABLE licences_logiciels       ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- Policies publiques (accès anon pédagogique)
-- ============================================================

-- templates_documents
CREATE POLICY "templates_select" ON templates_documents FOR SELECT USING (true);
CREATE POLICY "templates_insert" ON templates_documents FOR INSERT WITH CHECK (true);
CREATE POLICY "templates_update" ON templates_documents FOR UPDATE USING (true);
CREATE POLICY "templates_delete" ON templates_documents FOR DELETE USING (true);

-- conges
CREATE POLICY "conges_select" ON conges FOR SELECT USING (true);
CREATE POLICY "conges_insert" ON conges FOR INSERT WITH CHECK (true);
CREATE POLICY "conges_update" ON conges FOR UPDATE USING (true);
CREATE POLICY "conges_delete" ON conges FOR DELETE USING (true);

-- formations
CREATE POLICY "formations_select" ON formations FOR SELECT USING (true);
CREATE POLICY "formations_insert" ON formations FOR INSERT WITH CHECK (true);
CREATE POLICY "formations_update" ON formations FOR UPDATE USING (true);
CREATE POLICY "formations_delete" ON formations FOR DELETE USING (true);

-- documents_rh
CREATE POLICY "documents_rh_select" ON documents_rh FOR SELECT USING (true);
CREATE POLICY "documents_rh_insert" ON documents_rh FOR INSERT WITH CHECK (true);
CREATE POLICY "documents_rh_update" ON documents_rh FOR UPDATE USING (true);
CREATE POLICY "documents_rh_delete" ON documents_rh FOR DELETE USING (true);

-- cartes_professionnelles
CREATE POLICY "cartes_pro_select" ON cartes_professionnelles FOR SELECT USING (true);
CREATE POLICY "cartes_pro_insert" ON cartes_professionnelles FOR INSERT WITH CHECK (true);
CREATE POLICY "cartes_pro_update" ON cartes_professionnelles FOR UPDATE USING (true);
CREATE POLICY "cartes_pro_delete" ON cartes_professionnelles FOR DELETE USING (true);

-- assurances_rc
CREATE POLICY "assurances_select" ON assurances_rc FOR SELECT USING (true);
CREATE POLICY "assurances_insert" ON assurances_rc FOR INSERT WITH CHECK (true);
CREATE POLICY "assurances_update" ON assurances_rc FOR UPDATE USING (true);
CREATE POLICY "assurances_delete" ON assurances_rc FOR DELETE USING (true);

-- campagnes_marketing
CREATE POLICY "campagnes_select" ON campagnes_marketing FOR SELECT USING (true);
CREATE POLICY "campagnes_insert" ON campagnes_marketing FOR INSERT WITH CHECK (true);
CREATE POLICY "campagnes_update" ON campagnes_marketing FOR UPDATE USING (true);
CREATE POLICY "campagnes_delete" ON campagnes_marketing FOR DELETE USING (true);

-- posts_sociaux
CREATE POLICY "posts_select" ON posts_sociaux FOR SELECT USING (true);
CREATE POLICY "posts_insert" ON posts_sociaux FOR INSERT WITH CHECK (true);
CREATE POLICY "posts_update" ON posts_sociaux FOR UPDATE USING (true);
CREATE POLICY "posts_delete" ON posts_sociaux FOR DELETE USING (true);

-- factures_fournisseurs
CREATE POLICY "fact_fourn_select" ON factures_fournisseurs FOR SELECT USING (true);
CREATE POLICY "fact_fourn_insert" ON factures_fournisseurs FOR INSERT WITH CHECK (true);
CREATE POLICY "fact_fourn_update" ON factures_fournisseurs FOR UPDATE USING (true);
CREATE POLICY "fact_fourn_delete" ON factures_fournisseurs FOR DELETE USING (true);

-- factures_clients
CREATE POLICY "fact_cli_select" ON factures_clients FOR SELECT USING (true);
CREATE POLICY "fact_cli_insert" ON factures_clients FOR INSERT WITH CHECK (true);
CREATE POLICY "fact_cli_update" ON factures_clients FOR UPDATE USING (true);
CREATE POLICY "fact_cli_delete" ON factures_clients FOR DELETE USING (true);

-- ecritures_comptables
CREATE POLICY "ecritures_select" ON ecritures_comptables FOR SELECT USING (true);
CREATE POLICY "ecritures_insert" ON ecritures_comptables FOR INSERT WITH CHECK (true);
CREATE POLICY "ecritures_update" ON ecritures_comptables FOR UPDATE USING (true);
CREATE POLICY "ecritures_delete" ON ecritures_comptables FOR DELETE USING (true);

-- dossiers_patrimoniaux
CREATE POLICY "dossiers_select" ON dossiers_patrimoniaux FOR SELECT USING (true);
CREATE POLICY "dossiers_insert" ON dossiers_patrimoniaux FOR INSERT WITH CHECK (true);
CREATE POLICY "dossiers_update" ON dossiers_patrimoniaux FOR UPDATE USING (true);
CREATE POLICY "dossiers_delete" ON dossiers_patrimoniaux FOR DELETE USING (true);

-- visites
CREATE POLICY "visites_select" ON visites FOR SELECT USING (true);
CREATE POLICY "visites_insert" ON visites FOR INSERT WITH CHECK (true);
CREATE POLICY "visites_update" ON visites FOR UPDATE USING (true);
CREATE POLICY "visites_delete" ON visites FOR DELETE USING (true);

-- offres
CREATE POLICY "offres_select" ON offres FOR SELECT USING (true);
CREATE POLICY "offres_insert" ON offres FOR INSERT WITH CHECK (true);
CREATE POLICY "offres_update" ON offres FOR UPDATE USING (true);
CREATE POLICY "offres_delete" ON offres FOR DELETE USING (true);

-- ventes
CREATE POLICY "ventes_select" ON ventes FOR SELECT USING (true);
CREATE POLICY "ventes_insert" ON ventes FOR INSERT WITH CHECK (true);
CREATE POLICY "ventes_update" ON ventes FOR UPDATE USING (true);
CREATE POLICY "ventes_delete" ON ventes FOR DELETE USING (true);

-- tickets_support
CREATE POLICY "tickets_select" ON tickets_support FOR SELECT USING (true);
CREATE POLICY "tickets_insert" ON tickets_support FOR INSERT WITH CHECK (true);
CREATE POLICY "tickets_update" ON tickets_support FOR UPDATE USING (true);
CREATE POLICY "tickets_delete" ON tickets_support FOR DELETE USING (true);

-- materiel_informatique
CREATE POLICY "materiel_select" ON materiel_informatique FOR SELECT USING (true);
CREATE POLICY "materiel_insert" ON materiel_informatique FOR INSERT WITH CHECK (true);
CREATE POLICY "materiel_update" ON materiel_informatique FOR UPDATE USING (true);
CREATE POLICY "materiel_delete" ON materiel_informatique FOR DELETE USING (true);

-- licences_logiciels
CREATE POLICY "licences_select" ON licences_logiciels FOR SELECT USING (true);
CREATE POLICY "licences_insert" ON licences_logiciels FOR INSERT WITH CHECK (true);
CREATE POLICY "licences_update" ON licences_logiciels FOR UPDATE USING (true);
CREATE POLICY "licences_delete" ON licences_logiciels FOR DELETE USING (true);

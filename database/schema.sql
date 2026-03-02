-- ============================================================
-- LA BELLE AGENCE — Schéma Supabase
-- À exécuter dans l'éditeur SQL Supabase (dashboard.supabase.com)
-- ============================================================

-- ----------------------------------------------------------
-- AGENCIES — Entités organisationnelles
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS agencies (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  type       VARCHAR(20) NOT NULL CHECK (type IN ('siege', 'agence')),
  city       VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- DEPARTMENTS — Services du siège uniquement
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS departments (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  code       VARCHAR(20) NOT NULL UNIQUE,
  agency_id  INTEGER REFERENCES agencies(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- ROLES — Rôles applicatifs
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS roles (
  id    SERIAL PRIMARY KEY,
  name  VARCHAR(100) NOT NULL,
  code  VARCHAR(50) NOT NULL UNIQUE,
  scope VARCHAR(20) DEFAULT 'global' CHECK (scope IN ('global', 'agency', 'department'))
);

-- ----------------------------------------------------------
-- USERS — Profils liés aux comptes Supabase Auth
-- L'id correspond à auth.users.id (UUID)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         VARCHAR(255) NOT NULL UNIQUE,
  first_name    VARCHAR(100) NOT NULL,
  last_name     VARCHAR(100) NOT NULL,
  role_id       INTEGER REFERENCES roles(id),
  agency_id     INTEGER REFERENCES agencies(id),
  department_id INTEGER REFERENCES departments(id),
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- WORKFLOW_REQUESTS — Toutes les demandes (Budget/RH/Événement)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS workflow_requests (
  id            SERIAL PRIMARY KEY,
  type          VARCHAR(50) NOT NULL CHECK (type IN ('BUDGET', 'RECRUITMENT', 'EVENT')),
  title         VARCHAR(255) NOT NULL,
  description   TEXT,
  status        VARCHAR(50) NOT NULL DEFAULT 'SUBMITTED'
                CHECK (status IN ('DRAFT','SUBMITTED','PENDING_APPROVAL','APPROVED','REJECTED','CANCELLED','CLOSED_FILLED')),
  requester_id  UUID REFERENCES users(id),
  agency_id     INTEGER REFERENCES agencies(id),
  department_id INTEGER REFERENCES departments(id),
  data          JSONB NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- WORKFLOW_APPROVALS — Étapes de validation par demande
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS workflow_approvals (
  id            SERIAL PRIMARY KEY,
  request_id    INTEGER REFERENCES workflow_requests(id) ON DELETE CASCADE,
  step_order    INTEGER NOT NULL,
  step_name     VARCHAR(100) NOT NULL,
  approver_role VARCHAR(50) NOT NULL,
  approver_id   UUID REFERENCES users(id),
  status        VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED')),
  comment       TEXT,
  decided_at    TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- NOTIFICATIONS — Notifications in-app
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS notifications (
  id              SERIAL PRIMARY KEY,
  user_id         UUID REFERENCES users(id) ON DELETE CASCADE,
  title           VARCHAR(255) NOT NULL,
  message         TEXT,
  type            VARCHAR(30) DEFAULT 'INFO' CHECK (type IN ('INFO','ACTION_REQUIRED','SUCCESS','WARNING')),
  is_read         BOOLEAN DEFAULT FALSE,
  related_request INTEGER REFERENCES workflow_requests(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------------------------------------------------
-- BUDGET_ENVELOPES — Enveloppes budgétaires annuelles
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS budget_envelopes (
  id          SERIAL PRIMARY KEY,
  entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('agency','department')),
  entity_id   INTEGER NOT NULL,
  fiscal_year INTEGER NOT NULL,
  category    VARCHAR(50) NOT NULL CHECK (category IN ('FONCTIONNEMENT','INVESTISSEMENT','RH')),
  allocated   NUMERIC(12,2) NOT NULL DEFAULT 0,
  consumed    NUMERIC(12,2) NOT NULL DEFAULT 0,
  UNIQUE (entity_type, entity_id, fiscal_year, category),
  CONSTRAINT consumed_lte_allocated CHECK (consumed >= 0)
);

-- ----------------------------------------------------------
-- INDEXES
-- ----------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_workflow_requests_type        ON workflow_requests (type);
CREATE INDEX IF NOT EXISTS idx_workflow_requests_status      ON workflow_requests (status);
CREATE INDEX IF NOT EXISTS idx_workflow_requests_requester   ON workflow_requests (requester_id);
CREATE INDEX IF NOT EXISTS idx_workflow_requests_agency      ON workflow_requests (agency_id);
CREATE INDEX IF NOT EXISTS idx_workflow_approvals_request    ON workflow_approvals (request_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user            ON notifications (user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread          ON notifications (user_id, is_read);

-- ----------------------------------------------------------
-- ROW LEVEL SECURITY
-- Toutes les RLS sont permissives : le serveur Express utilise
-- la service_role_key qui bypass les RLS.
-- On les active pour sécuriser les éventuels accès directs.
-- ----------------------------------------------------------
ALTER TABLE agencies           ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE roles              ENABLE ROW LEVEL SECURITY;
ALTER TABLE users              ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_requests  ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_approvals ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications      ENABLE ROW LEVEL SECURITY;
ALTER TABLE budget_envelopes   ENABLE ROW LEVEL SECURITY;

-- Politique lecture publique pour les référentiels (agences, rôles, départements)
CREATE POLICY "Lecture agences" ON agencies FOR SELECT USING (true);
CREATE POLICY "Lecture departments" ON departments FOR SELECT USING (true);
CREATE POLICY "Lecture roles" ON roles FOR SELECT USING (true);

-- Un utilisateur peut lire son propre profil
CREATE POLICY "Lecture profil" ON users FOR SELECT USING (auth.uid() = id);

-- Un utilisateur voit ses propres notifications
CREATE POLICY "Lecture notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);

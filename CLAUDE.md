# LA BELLE AGENCE — Documentation Projet

## Vue d'ensemble

Application web de simulation d'entreprise destinée aux élèves. Elle reproduit fidèlement le fonctionnement d'une agence immobilière et patrimoniale avec un siège social et trois agences commerciales régionales.

**Objectif pédagogique** : Permettre aux élèves d'incarner différents rôles (direction, RH, conseiller, agent) et de vivre des situations professionnelles réalistes (recrutement, budget, gestion client, événements).

---

## Organisation de l'entreprise

### Siège social — Saint-Louis

Services et leurs responsabilités :

| Service | Rôle principal |
|---|---|
| **RH** | Recrutement, contrats, fiches de poste, suivi collaborateurs |
| **Finance** | Budget, validation dépenses, reporting financier |
| **Juridique** | Contrats, conformité, litiges |
| **IT** | Infrastructure, outils, support technique |
| **Marketing** | Campagnes, événements, supports commerciaux |
| **Achats** | Commandes, fournisseurs, appels d'offres |
| **Qualité** | Procédures, audits, satisfaction client |

### Agences commerciales (3)

Chaque agence dispose des mêmes profils :

| Profil | Rôle |
|---|---|
| **Directeur d'agence** | Management local, validation locale, reporting siège |
| **Conseiller en patrimoine** | Gestion portefeuille clients, placements, conseil financier |
| **Agent immobilier** | Prospection, mandats, transactions immobilières |

**Agences** :
- Agence Mulhouse
- Agence Colmar
- Agence Strasbourg

---

## Stack technique

| Couche | Technologie |
|---|---|
| Frontend | React (Vite) |
| Backend | Express.js (Node.js) |
| Base de données | PostgreSQL |
| Auth | JWT (access + refresh tokens) |
| ORM | Prisma (recommandé) ou pg direct |

---

## Structure des dossiers

```
la-belle-agence/
├── CLAUDE.md
├── .env.example
├── .gitignore
│
├── client/                          # Frontend React
│   ├── public/
│   ├── src/
│   │   ├── main.jsx
│   │   ├── App.jsx
│   │   ├── assets/
│   │   ├── components/              # Composants réutilisables
│   │   │   ├── ui/                  # Boutons, inputs, modals, badges
│   │   │   ├── layout/              # Header, Sidebar, PageWrapper
│   │   │   ├── forms/               # Formulaires génériques
│   │   │   └── workflows/           # Composants spécifiques aux workflows
│   │   ├── pages/                   # Pages par rôle / fonctionnalité
│   │   │   ├── auth/
│   │   │   │   └── LoginPage.jsx
│   │   │   ├── dashboard/
│   │   │   │   └── DashboardPage.jsx
│   │   │   ├── budget/
│   │   │   │   ├── BudgetRequestPage.jsx
│   │   │   │   └── BudgetApprovalPage.jsx
│   │   │   ├── recruitment/
│   │   │   │   ├── RecruitmentRequestPage.jsx
│   │   │   │   └── RecruitmentPipelinePage.jsx
│   │   │   ├── events/
│   │   │   │   ├── EventRequestPage.jsx
│   │   │   │   └── EventManagementPage.jsx
│   │   │   ├── employees/
│   │   │   │   └── EmployeeDirectoryPage.jsx
│   │   │   └── admin/
│   │   │       └── AdminPage.jsx
│   │   ├── hooks/                   # Custom hooks React
│   │   │   ├── useAuth.js
│   │   │   ├── useWorkflow.js
│   │   │   └── useNotifications.js
│   │   ├── context/
│   │   │   └── AuthContext.jsx
│   │   ├── services/                # Appels API axios
│   │   │   ├── api.js               # Instance axios + intercepteurs
│   │   │   ├── auth.service.js
│   │   │   ├── budget.service.js
│   │   │   ├── recruitment.service.js
│   │   │   └── events.service.js
│   │   └── utils/
│   │       ├── permissions.js       # Logique RBAC côté client
│   │       └── formatters.js
│   ├── index.html
│   ├── vite.config.js
│   └── package.json
│
├── server/                          # Backend Express
│   ├── src/
│   │   ├── index.js                 # Point d'entrée, config Express
│   │   ├── config/
│   │   │   ├── db.js                # Connexion PostgreSQL
│   │   │   └── env.js               # Validation variables d'environnement
│   │   ├── middleware/
│   │   │   ├── auth.middleware.js   # Vérification JWT
│   │   │   ├── rbac.middleware.js   # Contrôle d'accès par rôle
│   │   │   └── errorHandler.js
│   │   ├── routes/
│   │   │   ├── auth.routes.js
│   │   │   ├── users.routes.js
│   │   │   ├── budget.routes.js
│   │   │   ├── recruitment.routes.js
│   │   │   ├── events.routes.js
│   │   │   └── agencies.routes.js
│   │   ├── controllers/
│   │   │   ├── auth.controller.js
│   │   │   ├── budget.controller.js
│   │   │   ├── recruitment.controller.js
│   │   │   └── events.controller.js
│   │   ├── services/                # Logique métier
│   │   │   ├── workflow.service.js  # Moteur de workflow générique
│   │   │   ├── notification.service.js
│   │   │   └── permissions.service.js
│   │   └── utils/
│   │       └── validators.js
│   └── package.json
│
└── database/
    ├── schema.sql                   # Schéma complet
    ├── seed.sql                     # Données initiales (agences, services, rôles)
    └── migrations/                  # Migrations versionnées
        └── 001_initial.sql
```

---

## Schéma de base de données

### Table `agencies` — Entités organisationnelles

```sql
CREATE TABLE agencies (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,          -- Ex: "Agence Mulhouse"
  type        VARCHAR(20) NOT NULL,           -- 'siege' | 'agence'
  city        VARCHAR(100) NOT NULL,          -- Ex: "Mulhouse"
  created_at  TIMESTAMP DEFAULT NOW()
);

-- Données initiales
INSERT INTO agencies (name, type, city) VALUES
  ('Siège Social', 'siege', 'Saint-Louis'),
  ('Agence Mulhouse', 'agence', 'Mulhouse'),
  ('Agence Colmar', 'agence', 'Colmar'),
  ('Agence Strasbourg', 'agence', 'Strasbourg');
```

### Table `departments` — Services du siège

```sql
CREATE TABLE departments (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,          -- Ex: "Ressources Humaines"
  code        VARCHAR(20) NOT NULL UNIQUE,    -- Ex: "RH", "FIN", "IT"
  agency_id   INTEGER REFERENCES agencies(id),
  created_at  TIMESTAMP DEFAULT NOW()
);

-- Uniquement pour le siège (agency_id = 1)
INSERT INTO departments (name, code, agency_id) VALUES
  ('Ressources Humaines', 'RH', 1),
  ('Finance', 'FIN', 1),
  ('Juridique', 'JUR', 1),
  ('Informatique', 'IT', 1),
  ('Marketing', 'MKT', 1),
  ('Achats', 'ACH', 1),
  ('Qualité', 'QUA', 1);
```

### Table `roles` — Rôles applicatifs

```sql
CREATE TABLE roles (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  code        VARCHAR(50) NOT NULL UNIQUE,
  -- Exemples de codes :
  -- 'DIRECTION_GENERALE', 'RH_MANAGER', 'FINANCE_MANAGER',
  -- 'IT_MANAGER', 'MKT_MANAGER', 'ACH_MANAGER', 'JUR_MANAGER', 'QUA_MANAGER'
  -- 'DIRECTEUR_AGENCE', 'CONSEILLER_PATRIMOINE', 'AGENT_IMMOBILIER'
  -- 'ELEVE_RH', 'ELEVE_FINANCE', etc.
  scope       VARCHAR(20) DEFAULT 'global'    -- 'global' | 'agency' | 'department'
);
```

### Table `users` — Utilisateurs (élèves et enseignants)

```sql
CREATE TABLE users (
  id              SERIAL PRIMARY KEY,
  email           VARCHAR(255) NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  first_name      VARCHAR(100) NOT NULL,
  last_name       VARCHAR(100) NOT NULL,
  role_id         INTEGER REFERENCES roles(id),
  agency_id       INTEGER REFERENCES agencies(id),   -- Agence ou siège d'affectation
  department_id   INTEGER REFERENCES departments(id), -- NULL pour les agences
  is_active       BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);
```

### Table `workflow_requests` — Toutes les demandes (budget, recrutement, événement)

```sql
CREATE TABLE workflow_requests (
  id              SERIAL PRIMARY KEY,
  type            VARCHAR(50) NOT NULL,          -- 'BUDGET' | 'RECRUITMENT' | 'EVENT'
  title           VARCHAR(255) NOT NULL,
  description     TEXT,
  status          VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
  -- Statuts : DRAFT | SUBMITTED | PENDING_APPROVAL | APPROVED | REJECTED | CANCELLED
  requester_id    INTEGER REFERENCES users(id),
  agency_id       INTEGER REFERENCES agencies(id),
  department_id   INTEGER REFERENCES departments(id),
  data            JSONB NOT NULL DEFAULT '{}',   -- Données spécifiques au type
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);
```

### Table `workflow_approvals` — Étapes de validation

```sql
CREATE TABLE workflow_approvals (
  id              SERIAL PRIMARY KEY,
  request_id      INTEGER REFERENCES workflow_requests(id) ON DELETE CASCADE,
  step_order      INTEGER NOT NULL,              -- Ordre de l'étape (1, 2, 3...)
  step_name       VARCHAR(100) NOT NULL,         -- Ex: "Validation Directeur Agence"
  approver_role   VARCHAR(50) NOT NULL,          -- Code du rôle requis pour valider
  approver_id     INTEGER REFERENCES users(id),  -- NULL jusqu'à validation
  status          VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING' | 'APPROVED' | 'REJECTED'
  comment         TEXT,
  decided_at      TIMESTAMP,
  created_at      TIMESTAMP DEFAULT NOW()
);
```

### Table `notifications` — Notifications in-app

```sql
CREATE TABLE notifications (
  id              SERIAL PRIMARY KEY,
  user_id         INTEGER REFERENCES users(id) ON DELETE CASCADE,
  title           VARCHAR(255) NOT NULL,
  message         TEXT,
  type            VARCHAR(30) DEFAULT 'INFO',    -- 'INFO' | 'ACTION_REQUIRED' | 'SUCCESS' | 'WARNING'
  is_read         BOOLEAN DEFAULT FALSE,
  related_request INTEGER REFERENCES workflow_requests(id),
  created_at      TIMESTAMP DEFAULT NOW()
);
```

### Table `budget_envelopes` — Enveloppes budgétaires par service / agence

```sql
CREATE TABLE budget_envelopes (
  id              SERIAL PRIMARY KEY,
  entity_type     VARCHAR(20) NOT NULL,          -- 'agency' | 'department'
  entity_id       INTEGER NOT NULL,              -- agency_id ou department_id
  fiscal_year     INTEGER NOT NULL,              -- Ex: 2025
  category        VARCHAR(50) NOT NULL,          -- 'FONCTIONNEMENT' | 'INVESTISSEMENT' | 'RH'
  allocated       NUMERIC(12,2) NOT NULL,        -- Montant alloué
  consumed        NUMERIC(12,2) DEFAULT 0,       -- Montant consommé
  UNIQUE(entity_type, entity_id, fiscal_year, category)
);
```

---

## Workflows

### 1. Demande de budget

**Déclencheur** : Un directeur d'agence ou responsable de service souhaite engager une dépense hors budget courant.

```
[Demandeur] Crée la demande (titre, montant, justification, catégorie)
      |
      v
[Statut : SUBMITTED]
      |
      v — Si demande agence
[Directeur Agence] Valide ou rejette
      |
      v — Si montant > seuil (ex: 5 000€)
[Finance Siège] Valide ou rejette avec commentaire
      |
      v — Si impact RH ou achat matériel
[RH / Achats] Avis consultatif (optionnel selon règles)
      |
      v
[Statut : APPROVED / REJECTED]
      |
      v — Si approuvé
[budget_envelopes.consumed] mis à jour
[Notification] envoyée au demandeur
```

**Données JSONB pour type=BUDGET** :
```json
{
  "amount": 3500.00,
  "category": "FONCTIONNEMENT",
  "fiscal_year": 2025,
  "supplier": "Nom fournisseur optionnel",
  "urgency": "NORMAL"
}
```

---

### 2. Demande de recrutement

**Déclencheur** : Un directeur d'agence ou responsable RH identifie un besoin en personnel.

```
[Demandeur] Crée la fiche de besoin
  (intitulé poste, type contrat, profil recherché, date souhaitée, agence/service)
      |
      v
[Statut : SUBMITTED]
      |
      v
[Directeur Agence / Resp. Service] Valide le besoin métier
      |
      v
[RH Siège] Analyse, crée la fiche de poste officielle
      |
      v
[Finance Siège] Valide l'impact budgétaire (masse salariale)
      |
      v
[Statut : APPROVED] → Publication offre + début processus candidature (hors scope V1)
      |
      v
[RH Siège] Marque le recrutement comme "Pourvu" quand embauche faite
  → Création du user dans le système si élève rejoint
```

**Données JSONB pour type=RECRUITMENT** :
```json
{
  "position_title": "Agent Immobilier",
  "contract_type": "CDI",
  "target_agency_id": 2,
  "profile_description": "Expérience 2 ans souhaitée...",
  "desired_start_date": "2025-09-01",
  "salary_range_min": 28000,
  "salary_range_max": 35000,
  "headcount_justification": "Départ en retraite de M. Dupont"
}
```

---

### 3. Demande d'événement

**Déclencheur** : Une agence ou le marketing siège souhaite organiser un événement (portes ouvertes, séminaire, conférence client).

```
[Demandeur] Crée la demande d'événement
  (nom, date, lieu, public cible, budget estimé, services impliqués)
      |
      v
[Statut : SUBMITTED]
      |
      v
[Directeur Agence] Valide la pertinence locale
      |
      v
[Marketing Siège] Valide la cohérence avec la stratégie de marque
      |
      v
[Finance Siège] Valide le budget événementiel
      |
      v
[Statut : APPROVED]
      |
      v — Services sollicités notifiés
[IT] Logistique technique si besoin
[Achats] Commande matériel / prestataires
[Qualité] Brief qualité si événement client
      |
      v
[Post-événement] Demandeur soumet un compte-rendu → archivé sur la demande
```

**Données JSONB pour type=EVENT** :
```json
{
  "event_name": "Portes Ouvertes Agence Mulhouse",
  "event_date": "2025-10-15",
  "location": "Agence Mulhouse",
  "target_audience": "Prospects et clients",
  "estimated_budget": 2000.00,
  "expected_attendees": 50,
  "involved_departments": ["MKT", "IT", "ACH"],
  "catering_required": true
}
```

---

## Contrôle d'accès (RBAC)

Les permissions sont définies par `role.code`. Règles générales :

| Action | Rôles autorisés |
|---|---|
| Créer une demande budget | `DIRECTEUR_AGENCE`, `*_MANAGER` (tout responsable) |
| Valider étape agence | `DIRECTEUR_AGENCE` de l'agence concernée |
| Valider étape Finance | `FINANCE_MANAGER` |
| Valider étape RH | `RH_MANAGER` |
| Valider étape Marketing | `MKT_MANAGER` |
| Voir toutes les demandes | `DIRECTION_GENERALE` |
| Voir demandes de son agence | `DIRECTEUR_AGENCE` |
| Voir ses propres demandes | Tout utilisateur authentifié |
| Gérer les utilisateurs | `RH_MANAGER`, `DIRECTION_GENERALE` |
| Accès admin | `DIRECTION_GENERALE` uniquement |

Le middleware `rbac.middleware.js` vérifie `req.user.role.code` et, pour les ressources d'agence, que `req.user.agency_id` correspond à la ressource demandée.

---

## Variables d'environnement

Fichier `.env` attendu à la racine de `server/` :

```env
# Base de données
DATABASE_URL=postgresql://user:password@localhost:5432/la_belle_agence

# Auth
JWT_SECRET=changeme_secret_key
JWT_EXPIRES_IN=15m
JWT_REFRESH_SECRET=changeme_refresh_key
JWT_REFRESH_EXPIRES_IN=7d

# Serveur
PORT=3000
NODE_ENV=development

# Frontend (pour CORS)
CLIENT_URL=http://localhost:5173
```

---

## Conventions de code

- **API REST** : Routes préfixées `/api/v1/`
- **Réponses** : Format `{ success, data, message, pagination? }`
- **Erreurs** : Format `{ success: false, error: { code, message } }`
- **Nommage** : `camelCase` JS, `snake_case` SQL
- **Validation** : Côté serveur obligatoire sur tous les endpoints mutants
- **Pagination** : Paramètres `?page=1&limit=20` sur les listes
- **Dates** : ISO 8601 (`YYYY-MM-DD` ou `YYYY-MM-DDTHH:mm:ssZ`)

---

## Commandes de développement

```bash
# Installation
cd client && npm install
cd server && npm install

# Base de données
psql -U postgres -c "CREATE DATABASE la_belle_agence;"
psql -U postgres -d la_belle_agence -f database/schema.sql
psql -U postgres -d la_belle_agence -f database/seed.sql

# Développement (depuis la racine)
cd client && npm run dev        # Frontend sur :5173
cd server && npm run dev        # Backend sur :3000

# Build production
cd client && npm run build
```

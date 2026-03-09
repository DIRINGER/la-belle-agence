-- ============================================================
-- MIGRATION 007 — Documents ORIAS + Progression élèves
-- Date : 2026-03-09
--
-- 1. Nouveaux salariés (Julie BERNARD, Sophie LAURENT)
-- 2. RC Pro + Cartes pro pour les salariés des exercices
-- 3. Table documents_orias (vue consolidée conformité)
-- 4. Table progression_eleves (suivi pédagogique)
-- 5. Données ORIAS pour les salariés des exercices
-- 6. Mise à jour missions (indice + correction_detaillee)
-- ============================================================


-- ============================================================
-- 1. NOUVEAUX SALARIÉS
-- ============================================================

INSERT INTO salaries (
  nom, prenom, email, telephone, adresse,
  poste, service, agence, date_embauche, salaire_brut, type_contrat
) VALUES
('BERNARD', 'Julie',
  'bernard.j@labelleagence.fr', '0612345606',
  '12 rue des Lilas, 68000 Colmar',
  'Conseillère Gestion Patrimoine', 'Patrimoine', 'Colmar',
  '2023-03-01', 3200.00, 'CDI'),

('LAURENT', 'Sophie',
  'laurent.s@labelleagence.fr', '0698765432',
  '8 avenue de la République, 68100 Mulhouse',
  'Conseillère en assurance vie', 'Patrimoine', 'Siège',
  '2021-06-15', 3400.00, 'CDI')

ON CONFLICT DO NOTHING;


-- ============================================================
-- 1b. COLONNES MANQUANTES (sécurité si migrations précédentes incomplètes)
-- ============================================================

ALTER TABLE cartes_professionnelles
  ADD COLUMN IF NOT EXISTS organisme_delivreur VARCHAR(200);

-- ============================================================
-- 2. RC PRO + CARTES PRO pour les salariés des exercices
-- ============================================================

-- Julie BERNARD : RC Pro expire dans 15 jours (EXERCICE 1 — situation critique)
INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut)
VALUES ('Julie BERNARD', 'Generali Professionnels', 'RC-2025-CGP-456', 500000, '2025-03-10', '2026-03-24', 'valide')
ON CONFLICT DO NOTHING;

INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES ('Julie BERNARD', 'CP-456-C', '2027-03-19', 'CCI Alsace', 'valide')
ON CONFLICT DO NOTHING;

-- Sophie LAURENT : Carte pro + RC Pro valides, DDA récente (EXERCICE 2)
INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut)
VALUES ('Sophie LAURENT', 'ALLIANZ Professionnels', 'ALLZ-RC-STR-2025-612', 500000, '2025-09-01', '2026-08-31', 'valide')
ON CONFLICT DO NOTHING;

INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES ('Sophie LAURENT', 'CP-234-M', '2027-01-15', 'CCI Alsace', 'valide')
ON CONFLICT DO NOTHING;

INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation, statut)
VALUES ('Sophie LAURENT', 'Formation DDA — Directive Distribution Assurances', 'IFOCOP Formation',
        '2026-02-15', 15.0, 'DDA', 'validée')
ON CONFLICT DO NOTHING;

-- Marc PETIT : carte pro expirée (dossier partiel exercice 3)
INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES ('Marc PETIT', 'CPI-67-2020-007654', '2024-09-30', 'CCI Bas-Rhin', 'expiré')
ON CONFLICT DO NOTHING;


-- ============================================================
-- 3. TABLE documents_orias
-- Vue consolidée conformité par salarié
-- ============================================================

CREATE TABLE IF NOT EXISTS documents_orias (
  id                           SERIAL PRIMARY KEY,
  salarie_nom                  VARCHAR(200) NOT NULL,
  salarie_prenom               VARCHAR(200),
  poste                        VARCHAR(200),
  agence                       VARCHAR(100),

  -- Carte professionnelle CPI
  carte_pro_numero             VARCHAR(100),
  carte_pro_date_delivrance    DATE,
  carte_pro_date_expiration    DATE,
  carte_pro_organisme          VARCHAR(200),
  carte_pro_url                TEXT,
  carte_pro_statut             VARCHAR(50) DEFAULT 'manquant',
    CHECK (carte_pro_statut IN ('valide', 'expire_bientot', 'expiré', 'manquant', 'en_renouvellement')),

  -- RC Professionnelle
  rc_pro_assureur              VARCHAR(200),
  rc_pro_numero_contrat        VARCHAR(100),
  rc_pro_montant_garantie      NUMERIC(12,2),
  rc_pro_date_debut            DATE,
  rc_pro_date_expiration       DATE,
  rc_pro_url                   TEXT,
  rc_pro_statut                VARCHAR(50) DEFAULT 'manquant',
    CHECK (rc_pro_statut IN ('valide', 'expire_bientot', 'expiré', 'manquant', 'en_renouvellement')),

  -- Formation DDA
  formation_dda_derniere_date  DATE,
  formation_dda_heures         INTEGER,
  formation_dda_organisme      VARCHAR(200),
  formation_dda_prochaine_echeance DATE,
  formation_dda_url            TEXT,
  formation_dda_statut         VARCHAR(50) DEFAULT 'manquant',
    CHECK (formation_dda_statut IN ('valide', 'expire_bientot', 'expiré', 'manquant')),

  -- Autres documents
  casier_judiciaire_url        TEXT,
  casier_judiciaire_date       DATE,
  diplome_url                  TEXT,
  justificatif_domicile_url    TEXT,

  -- Alertes
  alerte_carte_pro             BOOLEAN DEFAULT false,
  alerte_rc_pro                BOOLEAN DEFAULT false,
  alerte_formation_dda         BOOLEAN DEFAULT false,

  -- Audit
  derniere_verification        DATE,
  verifie_par                  VARCHAR(200),
  commentaires                 TEXT,

  created_at                   TIMESTAMPTZ DEFAULT NOW(),
  updated_at                   TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE (salarie_nom, salarie_prenom)
);

ALTER TABLE documents_orias ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "orias_all" ON documents_orias;
CREATE POLICY "orias_all" ON documents_orias FOR ALL USING (true) WITH CHECK (true);


-- ============================================================
-- 4. TABLE progression_eleves
-- ============================================================

CREATE TABLE IF NOT EXISTS progression_eleves (
  id                     SERIAL PRIMARY KEY,
  eleve_nom              VARCHAR(200) NOT NULL,
  mission_id             INTEGER REFERENCES missions(id),

  date_ouverture         TIMESTAMPTZ,
  date_completion        TIMESTAMPTZ,
  temps_passe_minutes    INTEGER,

  statut                 VARCHAR(50) DEFAULT 'non_commence',
    CHECK (statut IN ('non_commence', 'en_cours', 'termine', 'valide')),

  a_consulte_indice      BOOLEAN DEFAULT false,
  a_consulte_correction  BOOLEAN DEFAULT false,

  commentaire_prof       TEXT,
  note_prof              INTEGER CHECK (note_prof >= 0 AND note_prof <= 20),

  created_at             TIMESTAMPTZ DEFAULT NOW(),
  updated_at             TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE (eleve_nom, mission_id)
);

ALTER TABLE progression_eleves ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "prog_all" ON progression_eleves;
CREATE POLICY "prog_all" ON progression_eleves FOR ALL USING (true) WITH CHECK (true);


-- ============================================================
-- 5. DONNÉES documents_orias pour les salariés des exercices
-- ============================================================

-- Marc PETIT — Carte pro expirée (exercice 3)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_assureur, rc_pro_numero_contrat, rc_pro_date_expiration, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_heures, formation_dda_organisme,
  formation_dda_prochaine_echeance, formation_dda_statut,
  alerte_carte_pro, alerte_rc_pro,
  derniere_verification, commentaires
) VALUES (
  'PETIT', 'Marc', 'Agent Immobilier', 'Strasbourg',
  'CPI-67-2020-007654', '2024-09-30', 'CCI Bas-Rhin', 'expiré',
  'MAIF Professionnels', 'MAIF-RC-STR-2026-332', '2026-09-30', 'valide',
  '2025-11-20', 15, 'FNAIM Formation', '2026-11-20', 'valide',
  true, false,
  '2026-03-01', 'Carte pro expirée depuis le 30/09/2024. Dossier de renouvellement à constituer urgemment.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  carte_pro_statut = 'expiré',
  alerte_carte_pro = true,
  commentaires = EXCLUDED.commentaires,
  updated_at = NOW();

-- Julie BERNARD — RC Pro expire dans 15 jours (EXERCICE 1 — situation critique)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_assureur, rc_pro_numero_contrat, rc_pro_montant_garantie,
  rc_pro_date_debut, rc_pro_date_expiration, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_heures, formation_dda_organisme,
  formation_dda_prochaine_echeance, formation_dda_statut,
  alerte_rc_pro,
  derniere_verification, commentaires
) VALUES (
  'BERNARD', 'Julie', 'Conseillère Gestion Patrimoine', 'Colmar',
  'CP-456-C', '2027-03-19', 'CCI Alsace', 'valide',
  'Generali Professionnels', 'RC-2025-CGP-456', 500000,
  '2025-03-10', '2026-03-24', 'expire_bientot',
  '2025-09-10', 14, 'FNAIM Formation', '2026-09-10', 'valide',
  true,
  '2026-03-09', 'RC Pro expire le 24/03/2026 — J-15 — URGENT : relance immédiate à envoyer.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  rc_pro_statut = 'expire_bientot',
  rc_pro_date_expiration = '2026-03-24',
  alerte_rc_pro = true,
  commentaires = EXCLUDED.commentaires,
  updated_at = NOW();

-- Sophie LAURENT — DDA récente, tous documents valides (EXERCICE 2)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_assureur, rc_pro_numero_contrat, rc_pro_montant_garantie,
  rc_pro_date_debut, rc_pro_date_expiration, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_heures, formation_dda_organisme,
  formation_dda_prochaine_echeance, formation_dda_statut,
  derniere_verification, commentaires
) VALUES (
  'LAURENT', 'Sophie', 'Conseillère en assurance vie', 'Siège',
  'CP-234-M', '2027-01-15', 'CCI Alsace', 'valide',
  'ALLIANZ Professionnels', 'ALLZ-RC-STR-2025-612', 500000,
  '2025-09-01', '2026-08-31', 'valide',
  '2026-02-15', 15, 'IFOCOP Formation', '2027-02-15', 'valide',
  '2026-03-09', 'Dossier complet et à jour. Formation DDA enregistrée le 15/02/2026.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  formation_dda_derniere_date = '2026-02-15',
  formation_dda_prochaine_echeance = '2027-02-15',
  commentaires = EXCLUDED.commentaires,
  updated_at = NOW();

-- Thomas MEYER — Nouveau salarié, dossier en cours (EXERCICE 3/ORIAS)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_statut, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_heures, formation_dda_organisme,
  formation_dda_prochaine_echeance, formation_dda_statut,
  casier_judiciaire_date, diplome_url,
  alerte_carte_pro, alerte_rc_pro,
  derniere_verification, commentaires
) VALUES (
  'MEYER', 'Thomas', 'Agent Immobilier', 'Strasbourg',
  'en_renouvellement', 'en_renouvellement',
  '2025-03-15', 15, 'FNAIM Formation', '2026-03-15', 'expire_bientot',
  '2026-03-01', 'dossiers/MEYER_Thomas/Diplome_BTS_PI_MEYER.pdf',
  true, true,
  '2026-03-09', 'Nouveau salarié embauché le 01/03/2026. Dossier ORIAS en cours de constitution.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  carte_pro_statut = 'en_renouvellement',
  rc_pro_statut = 'en_renouvellement',
  commentaires = EXCLUDED.commentaires,
  updated_at = NOW();

-- Lucas WEBER — Carte pro expire dans 29 jours (exercice 5)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_date_expiration, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_prochaine_echeance, formation_dda_statut,
  alerte_carte_pro,
  commentaires
) VALUES (
  'WEBER', 'Lucas', 'Agent Immobilier', 'Mulhouse',
  'CPI-68-2023-2345', '2026-04-05', 'CCI Alsace', 'expire_bientot',
  '2026-11-30', 'valide',
  '2025-10-15', '2026-10-15', 'valide',
  true,
  'Carte pro expire le 05/04/2026 — J-27 — Dossier de renouvellement à lancer.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  carte_pro_statut = 'expire_bientot',
  alerte_carte_pro = true,
  updated_at = NOW();

-- David THOMAS — Carte pro expire dans 25 jours (exercice 5)
INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_date_expiration, rc_pro_statut,
  formation_dda_derniere_date, formation_dda_prochaine_echeance, formation_dda_statut,
  alerte_carte_pro,
  commentaires
) VALUES (
  'THOMAS', 'David', 'Agent Immobilier', 'Strasbourg',
  'CPI-67-2023-6789', '2026-04-01', 'CCI Bas-Rhin', 'expire_bientot',
  '2026-12-15', 'valide',
  '2025-11-08', '2026-11-08', 'valide',
  true,
  'Carte pro expire le 01/04/2026 — J-23 — Renouvellement urgent.'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  carte_pro_statut = 'expire_bientot',
  alerte_carte_pro = true,
  updated_at = NOW();


-- ============================================================
-- 6. MISE À JOUR MISSIONS — Indice + Correction détaillée
-- ============================================================

-- EXERCICE 1 — RC Pro expirée (Julie BERNARD — J-15)
UPDATE missions SET
  indice = '💡 INDICE : La RC Pro (Responsabilité Civile Professionnelle) est OBLIGATOIRE pour tout conseiller en patrimoine (Article L.512-6 du Code des assurances). La RC Pro de Julie BERNARD expire le 24/03/2026, soit dans 15 jours. Votre email doit être ferme mais courtois : indiquez l''urgence (15 jours !), les conséquences (suspension d''activité), un délai de réponse précis (7 jours max). Pensez à mettre la direction en copie pour traçabilité.',

  correction_detaillee = '✅ CORRECTION — Relance RC Pro Julie BERNARD

ANALYSE DE LA SITUATION :
• Salariée : Julie BERNARD, Conseillère Gestion Patrimoine — Agence Colmar
• RC Pro actuelle (Generali) : expire le 24/03/2026
• Date du jour : 09/03/2026 → 15 jours restants ⚠️ URGENT

EMAIL DE RELANCE TYPE :
De : conformite@labelleagence.fr
À : bernard.j@labelleagence.fr
Cc : direction@labelleagence.fr
Objet : URGENT — Renouvellement RC Pro — Échéance 24/03/2026

Bonjour Julie,

Nous avons constaté que votre attestation de Responsabilité Civile Professionnelle (Generali, n° RC-2025-CGP-456) arrive à expiration le 24 mars 2026, soit dans 15 jours.

RAPPEL RÉGLEMENTAIRE
La RC Pro est une obligation légale pour exercer en qualité de Conseillère en Gestion de Patrimoine (Art. L.512-6 Code des assurances). Sans attestation valide, vous ne pouvez plus signer de mandats ni conseiller vos clients.

CONSÉQUENCES EN CAS DE NON-RENOUVELLEMENT
• Suspension immédiate de votre activité de conseil
• Non-conformité ORIAS signalée à la CCI
• Risque de sanction disciplinaire

ACTION REQUISE — Avant le 16/03/2026 (7 jours)
Contactez votre assureur Generali au 01 XX XX XX XX et demandez le renouvellement de votre police. Transmettez la nouvelle attestation à : conformite@labelleagence.fr

En vous remerciant par avance de votre réactivité,
[Nom] — Assistante Conformité — La Belle Agence

ENREGISTREMENT ERP :
→ Conformité → Dossiers ORIAS → Julie BERNARD
→ Mettre à jour : rc_pro_statut → ''en_renouvellement''
→ Ajouter commentaire avec date de relance

CHECKLIST :
✅ Email professionnel avec urgence clairement indiquée
✅ Conséquences légales explicitées
✅ Délai de réponse précis (7 jours)
✅ Direction en copie (traçabilité)
✅ Mise à jour ERP effectuée
✅ Numéro de police indiqué pour faciliter le renouvellement'

WHERE id = (
  SELECT id FROM missions
  WHERE (profil_code ILIKE '%conf%' OR titre ILIKE '%rc%pro%' OR titre ILIKE '%rc%expir%' OR titre ILIKE '%assurance%expir%')
  ORDER BY id LIMIT 1
);


-- EXERCICE 2 — Formation DDA (Sophie LAURENT)
UPDATE missions SET
  indice = '💡 INDICE : La formation DDA (Directive sur la Distribution d''Assurances) est obligatoire CHAQUE ANNÉE pour les personnes qui vendent des produits d''assurance. Elle doit durer minimum 14 heures. Sophie LAURENT a fait sa formation le 15/02/2026 (15h, IFOCOP) → prochaine échéance : 15/02/2027. Pour l''enregistrer correctement : vérifiez les 15h validées, notez la date, calculez l''échéance (+1 an), et mettez à jour le dossier ORIAS dans l''ERP.',

  correction_detaillee = '✅ CORRECTION — Enregistrement Formation DDA Sophie LAURENT

ÉTAPE 1 : VÉRIFICATION DE L''ATTESTATION
• Salariée : Sophie LAURENT, Conseillère en assurance vie
• Organisme : IFOCOP Formation (agréé Qualiopi)
• Date : 15/02/2026 ✅
• Durée : 15 heures ✅ (minimum légal : 14h)
• N° attestation : DDA-2026-IFOCOP-8745 ✅
• Thèmes : Réglementation DDA, Produits assurance-vie, Déontologie, LCB-FT ✅

ÉTAPE 2 : ENREGISTREMENT DANS L''ERP
→ Conformité → Formations DDA → + Nouvelle entrée
• Salarié : Sophie LAURENT
• Intitulé : Formation DDA — Directive Distribution Assurances
• Organisme : IFOCOP Formation
• Date : 15/02/2026
• Durée : 15h
• Statut : validée

→ Conformité → Dossiers ORIAS → Sophie LAURENT
• formation_dda_derniere_date : 15/02/2026
• formation_dda_prochaine_echeance : 15/02/2027 (date + 1 an)
• formation_dda_statut : valide

ÉTAPE 3 : CALCUL PROCHAINE ÉCHÉANCE
Date formation : 15/02/2026
Prochaine formation obligatoire avant le : 15/02/2027
→ Programmer une alerte de rappel pour le 15/12/2026 (J-60)

NOMMAGE FICHIER : 2026_02_15_DDA_15h_Sophie_LAURENT.pdf

CHECKLIST :
✅ Attestation vérifiée (15h, organisme agréé, thèmes couverts)
✅ Enregistrée dans ERP — onglet Formations DDA
✅ Dossier ORIAS mis à jour
✅ Prochaine échéance calculée : 15/02/2027
✅ Fichier classé avec nomenclature normalisée
✅ Alerte J-60 programmée (15/12/2026)'

WHERE id = (
  SELECT id FROM missions
  WHERE titre ILIKE '%formation%oblig%' OR titre ILIKE '%dda%expir%' OR titre ILIKE '%formation%dda%'
  ORDER BY id LIMIT 1
);


-- ============================================================
-- FIN MIGRATION 007
-- ============================================================

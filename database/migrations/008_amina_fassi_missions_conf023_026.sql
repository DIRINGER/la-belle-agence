-- ============================================================
-- MIGRATION 008 — Amina FASSI + Missions CONF_023 à CONF_026
-- Date : 2026-03-09
--
-- 1. Amina FASSI (salarié + carte pro + RC pro)
-- 2. Colonne statut_dossier sur documents_orias
-- 3. Dossier ORIAS Amina FASSI
-- 4. Archivage Thomas MEYER dans documents_orias
-- 5. Mission CONF_023 — Créer dossier ORIAS Amina FASSI
-- 6. Mission CONF_024 — Audit alertes ORIAS
-- 7. Mission CONF_025 — Renouvellement RC Pro Julie BERNARD
-- 8. Mission CONF_026 — Archiver le dossier Thomas MEYER
-- ============================================================


-- ============================================================
-- 1. AMINA FASSI — Nouvelle salariée
-- ============================================================

INSERT INTO salaries (
  nom, prenom, email, telephone, adresse,
  poste, service, agence, date_embauche, salaire_brut, type_contrat
) VALUES (
  'FASSI', 'Amina', 'fassi.a@labelleagence.fr', '0612345618',
  '15 rue du Maréchal Foch, 67000 Strasbourg',
  'Négociatrice Immobilière', 'Commercial', 'Strasbourg',
  '2026-03-01', 2800.00, 'CDI'
) ON CONFLICT DO NOTHING;

-- Carte professionnelle Amina FASSI
INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES ('Amina FASSI', 'CP-STR-2026-042', '2029-02-20', 'CCI Alsace', 'valide')
ON CONFLICT DO NOTHING;

-- RC Professionnelle Amina FASSI
INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut)
VALUES ('Amina FASSI', 'Allianz', 'RC-IMMO-2026-8934', 500000, '2026-03-01', '2027-03-01', 'valide')
ON CONFLICT DO NOTHING;


-- ============================================================
-- 2. COLONNE statut_dossier SUR documents_orias
-- ============================================================

ALTER TABLE documents_orias
  ADD COLUMN IF NOT EXISTS statut_dossier VARCHAR(20) DEFAULT 'actif';

-- Initialiser les enregistrements existants
UPDATE documents_orias SET statut_dossier = 'actif' WHERE statut_dossier IS NULL;


-- ============================================================
-- 3. DOSSIER ORIAS AMINA FASSI
-- ============================================================

INSERT INTO documents_orias (
  salarie_nom, salarie_prenom, poste, agence,
  carte_pro_numero, carte_pro_date_expiration, carte_pro_organisme, carte_pro_statut,
  rc_pro_assureur, rc_pro_numero_contrat, rc_pro_montant_garantie,
  rc_pro_date_debut, rc_pro_date_expiration, rc_pro_statut,
  formation_dda_statut,
  alerte_carte_pro, alerte_rc_pro, alerte_formation_dda,
  derniere_verification, verifie_par,
  commentaires, statut_dossier
) VALUES (
  'FASSI', 'Amina', 'Négociatrice Immobilière', 'Strasbourg',
  'CP-STR-2026-042', '2029-02-20', 'CCI Alsace', 'valide',
  'Allianz', 'RC-IMMO-2026-8934', 500000,
  '2026-03-01', '2027-03-01', 'valide',
  'manquant',
  false, false, false,
  '2026-03-09', 'Système ERP',
  'Formation DDA non applicable — poste de Négociatrice Immobilière (ne distribue pas de produits d''assurance). Documents complémentaires à collecter : casier judiciaire B3, diplôme BTS PI, justificatif de domicile.',
  'actif'
) ON CONFLICT (salarie_nom, salarie_prenom) DO UPDATE SET
  poste                     = EXCLUDED.poste,
  agence                    = EXCLUDED.agence,
  carte_pro_numero          = EXCLUDED.carte_pro_numero,
  carte_pro_date_expiration = EXCLUDED.carte_pro_date_expiration,
  carte_pro_organisme       = EXCLUDED.carte_pro_organisme,
  carte_pro_statut          = EXCLUDED.carte_pro_statut,
  rc_pro_assureur           = EXCLUDED.rc_pro_assureur,
  rc_pro_numero_contrat     = EXCLUDED.rc_pro_numero_contrat,
  rc_pro_montant_garantie   = EXCLUDED.rc_pro_montant_garantie,
  rc_pro_date_debut         = EXCLUDED.rc_pro_date_debut,
  rc_pro_date_expiration    = EXCLUDED.rc_pro_date_expiration,
  rc_pro_statut             = EXCLUDED.rc_pro_statut,
  formation_dda_statut      = EXCLUDED.formation_dda_statut,
  commentaires              = EXCLUDED.commentaires,
  statut_dossier            = EXCLUDED.statut_dossier,
  updated_at                = NOW();


-- ============================================================
-- 4. ARCHIVAGE THOMAS MEYER
-- ============================================================

UPDATE documents_orias
SET
  statut_dossier = 'archivé',
  commentaires   = COALESCE(commentaires || ' | ', '') ||
                   'Départ le 28/02/2026 (fin de période d''essai). Dossier archivé le 09/03/2026. Conservation légale 5 ans jusqu''au 28/02/2031 — Art. L.123-22 Code de commerce.',
  updated_at     = NOW()
WHERE salarie_nom = 'MEYER' AND salarie_prenom = 'Thomas';


-- ============================================================
-- 5. COLONNES MISSIONS (si services_tables.sql n'a pas été exécuté)
-- ============================================================

ALTER TABLE missions ADD COLUMN IF NOT EXISTS donnees_exercice     JSONB DEFAULT '{}';
ALTER TABLE missions ADD COLUMN IF NOT EXISTS fichiers_annexes     TEXT[] DEFAULT '{}';
ALTER TABLE missions ADD COLUMN IF NOT EXISTS reponse_eleve        TEXT;
ALTER TABLE missions ADD COLUMN IF NOT EXISTS indice               TEXT;
ALTER TABLE missions ADD COLUMN IF NOT EXISTS correction_detaillee TEXT;
ALTER TABLE missions ADD COLUMN IF NOT EXISTS difficulte           VARCHAR(50);
ALTER TABLE missions ADD COLUMN IF NOT EXISTS duree_minutes        INTEGER;


-- ============================================================
-- 6. MISSION CONF_023 — Créer le dossier ORIAS Amina FASSI
-- ============================================================

INSERT INTO missions (
  titre, profil_code, contexte, instructions, donnees_exercice,
  indice, correction_detaillee, difficulte, duree_minutes
)
SELECT
  'CONF_023 — Créer le dossier ORIAS Amina FASSI',
  COALESCE((SELECT profil_code FROM missions WHERE profil_code ILIKE '%conf%' LIMIT 1), 'CONF'),
  'Amina FASSI vient d''être embauchée comme Négociatrice Immobilière à l''agence de Strasbourg (01/03/2026). Elle vous a remis ses documents réglementaires. Vous devez créer son dossier ORIAS complet de A à Z dans le module Conformité de l''ERP.',
  '1. Accéder au module Conformité → Dossiers ORIAS
2. Vérifier qu''aucun dossier n''existe déjà pour Amina FASSI avant d''en créer un nouveau
3. Créer le dossier et saisir la carte professionnelle : n° CP-STR-2026-042, délivrée par CCI Alsace, expiration 20/02/2029
4. Saisir la RC Professionnelle : assureur ALLIANZ, n° RC-IMMO-2026-8934, garantie 500 000€, valable du 01/03/2026 au 01/03/2027
5. Indiquer que la formation DDA est non applicable (Négociatrice Immobilière — ne distribue pas de produits d''assurance)
6. Vérifier que le statut global du dossier = CONFORME
7. Ajouter un commentaire justifiant l''exemption DDA
8. Valider le dossier',
  '{
  "nouvelle_salariee": {
    "nom": "FASSI",
    "prenom": "Amina",
    "poste": "Négociatrice Immobilière",
    "agence": "Strasbourg",
    "date_embauche": "2026-03-01"
  },
  "carte_professionnelle": {
    "numero": "CP-STR-2026-042",
    "date_expiration": "2029-02-20",
    "organisme": "CCI Alsace",
    "statut": "valide"
  },
  "rc_professionnelle": {
    "assureur": "Allianz",
    "numero_contrat": "RC-IMMO-2026-8934",
    "montant_garantie": 500000,
    "date_debut": "2026-03-01",
    "date_expiration": "2027-03-01",
    "statut": "valide"
  },
  "formation_dda": {
    "applicable": false,
    "raison": "Négociatrice Immobilière — ne distribue pas de produits d''assurance"
  },
  "documents_a_collecter": [
    "Casier judiciaire B3 (à demander à Amina FASSI)",
    "Diplôme BTS Professions Immobilières (à scanner et archiver)",
    "Justificatif de domicile récent (à scanner et archiver)"
  ]
}'::jsonb,
  '💡 INDICE : Un dossier ORIAS pour une Négociatrice Immobilière doit contenir : 1) La carte CPI valide, 2) La RC Professionnelle en cours de validité. La formation DDA (Directive sur la Distribution d''Assurances) n''est obligatoire QUE pour les personnes qui distribuent des produits d''assurance. Une négociatrice immobilière sans vente d''assurance en est exemptée — mais cette exemption doit être explicitement notée dans le dossier avec une justification.',
  '✅ CORRECTION — Création dossier ORIAS Amina FASSI

CARTE PROFESSIONNELLE :
→ N° : CP-STR-2026-042
→ Organisme délivreur : CCI Alsace
→ Date d''expiration : 20/02/2029 ✅ (3 ans, valide)
→ Statut : VALIDE ✅

RC PROFESSIONNELLE :
→ Assureur : Allianz
→ N° de contrat : RC-IMMO-2026-8934
→ Montant de garantie : 500 000€ ✅
→ Validité : 01/03/2026 → 01/03/2027 ✅
→ Statut : VALIDE ✅

FORMATION DDA :
→ Non applicable ✅
→ Justification : poste de Négociatrice Immobilière sans distribution d''assurance (Art. L.521-2 Code des assurances)
→ Commentaire à saisir : "DDA non applicable — NI sans distribution assurance"

STATUT GLOBAL : ✅ CONFORME

DOCUMENTS COMPLÉMENTAIRES À COLLECTER :
• Casier judiciaire B3 (demander à Amina FASSI)
• Diplôme BTS PI (scanner et archiver)
• Justificatif de domicile (scanner et archiver)

CHECKLIST :
✅ Dossier créé dans l''ERP avec toutes les informations
✅ Carte pro saisie avec date d''expiration correcte
✅ RC Pro saisie avec bon numéro de contrat
✅ DDA indiquée comme non applicable avec justification
✅ Statut global = CONFORME
✅ Commentaire explicatif ajouté',
  'Intermédiaire',
  25
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE titre ILIKE '%FASSI%' OR titre ILIKE '%CONF_023%');


-- ============================================================
-- 7. MISSION CONF_024 — Audit alertes ORIAS
-- ============================================================

INSERT INTO missions (
  titre, profil_code, contexte, instructions, donnees_exercice,
  indice, correction_detaillee, difficulte, duree_minutes
)
SELECT
  'CONF_024 — Audit des alertes ORIAS',
  COALESCE((SELECT profil_code FROM missions WHERE profil_code ILIKE '%conf%' LIMIT 1), 'CONF'),
  'En date du 09/03/2026, le directeur vous demande de réaliser un audit complet du tableau de bord ORIAS. Vous devez identifier tous les dossiers en situation d''alerte ou de non-conformité et préparer un rapport de synthèse avec un plan d''action prioritaire.',
  '1. Accéder au module Conformité → Dossiers ORIAS
2. Activer le filtre "Alertes actives" pour ne voir que les dossiers URGENTS et BLOQUANTS
3. Identifier tous les dossiers en niveau URGENT (expiration < 30 jours) ou BLOQUANT (document expiré ou manquant)
4. Pour chaque dossier en alerte : noter le nom du salarié, le document concerné, la date d''expiration, le niveau d''urgence
5. Rédiger un tableau de synthèse des alertes prioritaires
6. Proposer un plan d''action daté pour chaque situation identifiée',
  '{
  "contexte_audit": {
    "date_audit": "2026-03-09",
    "auditeur": "Assistante Conformité — La Belle Agence"
  },
  "resultats_attendus": {
    "alertes_urgentes": [
      {
        "salarie": "Julie BERNARD",
        "document": "RC Pro — Generali RC-2025-CGP-456",
        "expiration": "2026-03-24",
        "jours_restants": 15,
        "niveau": "URGENT — relance sous 7 jours"
      }
    ],
    "surveillance_renforcee": [
      {
        "salarie": "Lucas WEBER",
        "document": "Carte CPI",
        "expiration": "2026-04-05",
        "jours_restants": 27
      },
      {
        "salarie": "David THOMAS",
        "document": "Carte CPI",
        "expiration": "2026-04-01",
        "jours_restants": 23
      }
    ],
    "dossiers_conformes": ["Sophie LAURENT", "Amina FASSI"],
    "dossiers_archives": ["Thomas MEYER"]
  },
  "plan_action": {
    "priorite_1": "Cette semaine : email relance Julie BERNARD pour RC Pro",
    "priorite_2": "Avant le 15/03 : anticiper renouvellements cartes WEBER et THOMAS",
    "priorite_3": "Janvier 2027 : rappel renouvellement DDA Sophie LAURENT"
  }
}'::jsonb,
  '💡 INDICE : Le tableau de bord ORIAS utilise 4 niveaux : 🟢 CONFORME, 🟠 URGENT (expiration < 30 jours), 🔴 BLOQUANT (document expiré ou manquant), 🔵 EN COURS DE RENOUVELLEMENT. Concentrez-vous d''abord sur les niveaux BLOQUANT puis URGENT. Pour l''audit du 09/03/2026 : la RC Pro de Julie BERNARD expire le 24/03/2026 (J-15) → URGENT. Les cartes pro de WEBER (J-27) et THOMAS (J-23) approchent du seuil de 30 jours → à surveiller de près.',
  '✅ CORRECTION — Audit alertes ORIAS du 09/03/2026

🟠 ALERTE URGENTE — 1 dossier :
• Julie BERNARD — RC Pro Generali (RC-2025-CGP-456)
  Expiration : 24/03/2026 (J-15) ⚠️
  Action : Email de relance immédiat — délai réponse 7 jours

📊 SURVEILLANCE RENFORCÉE — 2 cartes pro :
• Lucas WEBER — Carte CPI expire 05/04/2026 (J-27)
• David THOMAS — Carte CPI expire 01/04/2026 (J-23)
  Action : Contacter CCI Alsace pour renouvellements anticipés

🟢 DOSSIERS CONFORMES — 2 :
• Sophie LAURENT (DDA valide, prochaine échéance 15/02/2027)
• Amina FASSI (dossier complet, tous documents valides)

🔵 DOSSIER ARCHIVÉ — 1 :
• Thomas MEYER (départ 28/02/2026 — conservation jusqu''au 28/02/2031)

PLAN D''ACTION :
1. IMMÉDIAT : Email relance Julie BERNARD pour RC Pro (cette semaine)
2. AVANT LE 15/03 : Anticiper renouvellements cartes WEBER et THOMAS (CCI Alsace)
3. JANVIER 2027 : Rappel renouvellement DDA Sophie LAURENT

CHECKLIST :
✅ Tableau de bord ORIAS consulté avec filtre alertes actif
✅ Julie BERNARD identifiée (RC Pro J-15) → URGENT
✅ WEBER et THOMAS identifiés (cartes J-27 et J-23) → surveillance
✅ Dossiers conformes et archivés recensés
✅ Plan d''action documenté et daté',
  'Avancé',
  35
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE titre ILIKE '%audit%alerte%ORIAS%' OR titre ILIKE '%CONF_024%');


-- ============================================================
-- 8. MISSION CONF_025 — Renouvellement RC Pro Julie BERNARD
-- ============================================================

INSERT INTO missions (
  titre, profil_code, contexte, instructions, donnees_exercice,
  indice, correction_detaillee, difficulte, duree_minutes
)
SELECT
  'CONF_025 — Renouvellement RC Pro Julie BERNARD',
  COALESCE((SELECT profil_code FROM missions WHERE profil_code ILIKE '%conf%' LIMIT 1), 'CONF'),
  'Suite à la relance de l''exercice CONF_023, Julie BERNARD vous a transmis sa nouvelle attestation de RC Professionnelle (reçue le 20/03/2026). Vous devez mettre à jour son dossier ORIAS dans l''ERP avec les nouveaux éléments contractuels et lever l''alerte.',
  '1. Accéder au module Conformité → Dossiers ORIAS → Julie BERNARD
2. Ouvrir la section RC Professionnelle du dossier
3. Mettre à jour avec la nouvelle attestation : AXA FRANCE, n° RC-2026-CGP-789, 500 000€, du 25/03/2026 au 24/03/2027
4. Changer le statut RC Pro de "en_renouvellement" à "valide"
5. Désactiver l''alerte RC Pro
6. Vérifier que le statut global repasse à CONFORME
7. Ajouter un commentaire avec la date de réception de la nouvelle attestation (20/03/2026)',
  '{
  "situation_initiale": {
    "salarie": "Julie BERNARD",
    "rc_pro_ancienne": {
      "assureur": "Generali Professionnels",
      "numero": "RC-2025-CGP-456",
      "expiration": "2026-03-24",
      "statut": "en_renouvellement"
    }
  },
  "nouvelle_attestation": {
    "assureur": "AXA FRANCE",
    "numero_contrat": "RC-2026-CGP-789",
    "montant_garantie": 500000,
    "date_debut": "2026-03-25",
    "date_expiration": "2027-03-24",
    "date_reception": "2026-03-20"
  },
  "actions_erp_attendues": [
    "rc_pro_assureur → AXA FRANCE",
    "rc_pro_numero_contrat → RC-2026-CGP-789",
    "rc_pro_date_debut → 2026-03-25",
    "rc_pro_date_expiration → 2027-03-24",
    "rc_pro_statut → valide",
    "alerte_rc_pro → false",
    "Commentaire avec date de reception"
  ]
}'::jsonb,
  '💡 INDICE : Lors de la mise à jour d''un document ORIAS, vérifiez toujours : (1) le NOUVEAU numéro de contrat (différent de l''ancien), (2) les dates de début ET de fin de validité (le nouveau contrat commence le lendemain de l''expiration de l''ancien), (3) que le statut repasse bien à ''valide'' et non à ''expire_bientot''. N''oubliez pas de désactiver l''alerte et d''ajouter un commentaire daté pour la traçabilité.',
  '✅ CORRECTION — Mise à jour RC Pro Julie BERNARD

SITUATION INITIALE :
• RC Pro Generali (RC-2025-CGP-456) : expirée le 24/03/2026
• Statut dans l''ERP : en_renouvellement

NOUVELLE ATTESTATION REÇUE (20/03/2026) :
→ Assureur : AXA FRANCE ✅ (changement d''assureur)
→ N° contrat : RC-2026-CGP-789 ✅ (nouveau numéro)
→ Garantie : 500 000€ ✅ (maintenue)
→ Validité : 25/03/2026 → 24/03/2027 ✅ (continuité de couverture)

MISE À JOUR ERP — Dossier ORIAS Julie BERNARD :
→ rc_pro_assureur : Generali → AXA FRANCE ✅
→ rc_pro_numero_contrat : RC-2025-CGP-456 → RC-2026-CGP-789 ✅
→ rc_pro_date_debut : 2025-03-10 → 2026-03-25 ✅
→ rc_pro_date_expiration : 2026-03-24 → 2027-03-24 ✅
→ rc_pro_statut : en_renouvellement → valide ✅
→ alerte_rc_pro : true → false ✅
→ Commentaire : "RC Pro renouvelée — AXA FRANCE RC-2026-CGP-789 — reçue le 20/03/2026" ✅

STATUT GLOBAL DOSSIER : ✅ CONFORME

CHECKLIST :
✅ Nouveau numéro de contrat saisi (RC-2026-CGP-789)
✅ Nouvelles dates de validité saisies (25/03/2026 → 24/03/2027)
✅ Statut RC Pro = valide
✅ Alerte RC Pro désactivée
✅ Commentaire avec date de réception ajouté
✅ Statut global = CONFORME',
  'Intermédiaire',
  20
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE titre ILIKE '%CONF_025%' OR (titre ILIKE '%renouvellement%' AND titre ILIKE '%BERNARD%'));


-- ============================================================
-- 9. MISSION CONF_026 — Archiver le dossier Thomas MEYER
-- ============================================================

INSERT INTO missions (
  titre, profil_code, contexte, instructions, donnees_exercice,
  indice, correction_detaillee, difficulte, duree_minutes
)
SELECT
  'CONF_026 — Archiver le dossier Thomas MEYER',
  COALESCE((SELECT profil_code FROM missions WHERE profil_code ILIKE '%conf%' LIMIT 1), 'CONF'),
  'Thomas MEYER a quitté l''agence le 28/02/2026 (fin de période d''essai non renouvelée). Conformément à la réglementation, son dossier ORIAS doit être archivé tout en conservant toutes les données pendant la durée légale de 5 ans. Procédez à l''archivage dans l''ERP.',
  '1. Accéder au module Conformité → Dossiers ORIAS
2. Localiser le dossier de Thomas MEYER
3. Avant d''archiver : vérifier que tous les documents sont bien enregistrés dans le dossier
4. Changer le statut du dossier de "actif" à "archivé"
5. Ajouter un commentaire précisant : date de départ (28/02/2026), motif, et date limite de conservation légale (28/02/2031)
6. Vérifier que le dossier n''apparaît plus dans les alertes actives
7. Confirmer que le dossier reste accessible et consultable via le filtre "Archivés"',
  '{
  "salarie_concerne": {
    "nom": "MEYER",
    "prenom": "Thomas",
    "poste": "Négociateur Immobilier",
    "agence": "Mulhouse",
    "date_depart": "2026-02-28",
    "motif": "Fin de période d''essai non renouvelée"
  },
  "reglementation": {
    "texte": "Art. L.123-22 Code de commerce",
    "duree_conservation": "5 ans après fin du contrat",
    "date_limite_conservation": "2031-02-28",
    "documents_a_conserver": [
      "Numéro de carte CPI et dates de validité",
      "Attestations RC Pro (toutes)",
      "Formations DDA suivies",
      "Tous documents ORIAS déposés"
    ]
  },
  "actions_erp_attendues": [
    "statut_dossier → archivé",
    "Commentaire avec date de départ + date de conservation légale",
    "Vérification absence dans alertes actives",
    "Vérification accessibilité via filtre Archivés"
  ]
}'::jsonb,
  '💡 INDICE : L''archivage d''un dossier ORIAS ne signifie PAS sa suppression ! La loi impose une conservation de 5 ans minimum pour les documents professionnels (Art. L.123-22 Code de commerce). Dans l''ERP, l''archivage doit : 1) Retirer le dossier de la liste active (plus d''alertes), 2) Conserver toutes les données en lecture seule, 3) Indiquer explicitement la date limite de conservation. Ne supprimez JAMAIS un dossier archivé — il peut être requis lors d''un contrôle ORIAS ou d''un litige professionnel.',
  '✅ CORRECTION — Archivage dossier ORIAS Thomas MEYER

CONTEXTE DU DÉPART :
• Thomas MEYER — Négociateur Immobilier — Agence Mulhouse
• Date de départ : 28/02/2026
• Motif : Fin de période d''essai non renouvelée

RÉGLEMENTATION APPLICABLE :
→ Art. L.123-22 Code de commerce
→ Conservation minimum : 5 ans après fin du contrat
→ Date limite de conservation : 28/02/2031
→ Les documents ORIAS peuvent être requis en cas de litige ou contrôle

PROCÉDURE D''ARCHIVAGE DANS L''ERP :
→ statut_dossier : actif → archivé ✅
→ Commentaire : "Départ le 28/02/2026 — fin de période d''essai.
   Archivé le 09/03/2026. Conservation légale jusqu''au 28/02/2031." ✅
→ Dossier retiré de la liste des alertes actives ✅
→ Données conservées et accessibles en consultation ✅

VÉRIFICATIONS POST-ARCHIVAGE :
• Tableau de bord actif : Thomas MEYER n''apparaît plus ✅
• Filtre "Archivés" : Thomas MEYER visible et consultable ✅
• Données ORIAS intactes (carte CPI, RC Pro) ✅

CHECKLIST :
✅ Date de départ notée dans le commentaire (28/02/2026)
✅ Statut = archivé
✅ Date limite de conservation indiquée (28/02/2031)
✅ Dossier hors des alertes actives
✅ Dossier accessible pour audit éventuel',
  'Débutant',
  15
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE titre ILIKE '%CONF_026%' OR (titre ILIKE '%archiv%' AND titre ILIKE '%MEYER%'));

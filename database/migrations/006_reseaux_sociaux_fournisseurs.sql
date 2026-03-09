-- ============================================================
-- MIGRATION 006 — Réseaux Sociaux + Fournisseurs & Partenaires
-- Date : 2026-03-08
--
-- 1. Tables réseaux sociaux (comptes, posts, calendrier)
-- 2. Tables fournisseurs (partenaires, évaluations, historique)
-- 3. Seed : 5 comptes sociaux + 20 posts
-- 4. Seed : 15 fournisseurs + évaluations + historique
-- ============================================================


-- ============================================================
-- PARTIE 1 — RÉSEAUX SOCIAUX
-- ============================================================

CREATE TABLE IF NOT EXISTS reseaux_sociaux_comptes (
  id          SERIAL PRIMARY KEY,
  plateforme  VARCHAR(50) NOT NULL,   -- instagram, facebook, linkedin, tiktok, youtube
  nom_compte  VARCHAR(200) NOT NULL,
  url_profil  TEXT,
  abonnes     INTEGER DEFAULT 0,
  statut      VARCHAR(20) DEFAULT 'actif',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reseaux_sociaux_posts (
  id                       SERIAL PRIMARY KEY,
  compte_id                INTEGER REFERENCES reseaux_sociaux_comptes(id),
  plateforme               VARCHAR(50),
  contenu                  TEXT NOT NULL,
  hashtags                 TEXT,
  url_media                TEXT,
  date_publication         TIMESTAMPTZ,
  statut                   VARCHAR(30) DEFAULT 'brouillon',
    CHECK (statut IN ('brouillon', 'planifie', 'publie', 'archive')),
  engagement_likes         INTEGER DEFAULT 0,
  engagement_commentaires  INTEGER DEFAULT 0,
  engagement_partages      INTEGER DEFAULT 0,
  auteur                   VARCHAR(100),
  created_at               TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS calendrier_editorial (
  id            SERIAL PRIMARY KEY,
  titre         VARCHAR(200) NOT NULL,
  plateforme    VARCHAR(50),
  type_contenu  VARCHAR(100),   -- photo, video, carousel, story, reels
  date_prevue   DATE,
  statut        VARCHAR(30) DEFAULT 'a_planifier',
    CHECK (statut IN ('a_planifier', 'en_creation', 'valide', 'publie')),
  responsable   VARCHAR(100),
  notes         TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE reseaux_sociaux_comptes   ENABLE ROW LEVEL SECURITY;
ALTER TABLE reseaux_sociaux_posts     ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendrier_editorial      ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "rs_comptes_all"   ON reseaux_sociaux_comptes;
DROP POLICY IF EXISTS "rs_posts_select"  ON reseaux_sociaux_posts;
DROP POLICY IF EXISTS "rs_posts_insert"  ON reseaux_sociaux_posts;
DROP POLICY IF EXISTS "rs_posts_update"  ON reseaux_sociaux_posts;
DROP POLICY IF EXISTS "rs_posts_delete"  ON reseaux_sociaux_posts;
DROP POLICY IF EXISTS "cal_ed_all"       ON calendrier_editorial;

CREATE POLICY "rs_comptes_all"  ON reseaux_sociaux_comptes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "rs_posts_select" ON reseaux_sociaux_posts   FOR SELECT USING (true);
CREATE POLICY "rs_posts_insert" ON reseaux_sociaux_posts   FOR INSERT WITH CHECK (true);
CREATE POLICY "rs_posts_update" ON reseaux_sociaux_posts   FOR UPDATE USING (true);
CREATE POLICY "rs_posts_delete" ON reseaux_sociaux_posts   FOR DELETE USING (true);
CREATE POLICY "cal_ed_all"      ON calendrier_editorial     FOR ALL USING (true) WITH CHECK (true);


-- ────────────────────────────────────────────────────────────
-- SEED — 5 comptes sociaux
-- ────────────────────────────────────────────────────────────

INSERT INTO reseaux_sociaux_comptes (plateforme, nom_compte, url_profil, abonnes, statut) VALUES
('instagram', '@labelleagence',         'https://instagram.com/labelleagence',         3420, 'actif'),
('facebook',  'La Belle Agence',         'https://facebook.com/labelleagence',          2180, 'actif'),
('linkedin',  'La Belle Agence Alsace',  'https://linkedin.com/company/labelleagence',  1340, 'actif'),
('tiktok',    '@labelleagence',          'https://tiktok.com/@labelleagence',            890, 'actif'),
('youtube',   'La Belle Agence TV',      'https://youtube.com/@labelleagentetv',         560, 'actif')
ON CONFLICT DO NOTHING;


-- ────────────────────────────────────────────────────────────
-- SEED — 20 posts réseaux sociaux
-- ────────────────────────────────────────────────────────────

INSERT INTO reseaux_sociaux_posts
  (plateforme, contenu, hashtags, date_publication, statut,
   engagement_likes, engagement_commentaires, engagement_partages, auteur)
VALUES

-- INSTAGRAM (6 posts)
('instagram',
 'Coup de cœur du moment 😍 Cette magnifique villa contemporaine à Mulhouse avec piscine et vue dégagée vous attend. 280 m² de bonheur — ref. MULT-2026-041.',
 '#immobilier #mulhouse #villa #luxe #labelleagence #alsace',
 '2026-02-28 09:00:00+01', 'publie', 287, 34, 12, 'Sophie Martin'),

('instagram',
 'Astuce déco du jour : misez sur les matières naturelles pour valoriser votre bien avant une visite. Parquet chêne, lin, céramique... des petits détails qui font la différence lors de l''estimation.',
 '#homestaging #decorinterieur #conseils #immobilier #alsace',
 '2026-02-21 11:30:00+01', 'publie', 412, 58, 29, 'Sophie Martin'),

('instagram',
 'Notre équipe Strasbourg est là pour vous ! De gauche à droite : Amina (conseillère), Thomas (agent), Béatrice (directrice). N''hésitez pas à passer nous voir au 4 rue des Brasseurs.',
 '#teamlabelleagence #strasbourg #agenceimmobiliere #immobilier',
 '2026-02-14 10:00:00+01', 'publie', 531, 72, 8, 'Béatrice Keller'),

('instagram',
 'Marché immobilier alsacien — Bilan T4 2025 📊 Prix moyen au m² : Strasbourg +4,2%, Mulhouse -1,1%, Colmar stable. Demandez notre analyse complète en DM !',
 '#marche #immobilier #statistiques #alsace #strasbourg #prix',
 '2026-01-15 08:00:00+01', 'publie', 344, 47, 89, 'Direction Marketing'),

('instagram',
 'Appartement T3 en plein cœur de Colmar — 68 m², parquet, double vitrage, cave. Idéal primo-accédants. Prix : 189 000 €. 📍 Centre historique.',
 '#colmar #appartement #premierlogement #labelleagence #alsace',
 '2026-03-05 09:00:00+01', 'planifie', 0, 0, 0, 'Sophie Martin'),

('instagram',
 'Avant / Après — La rénovation de cette longère alsacienne nous a bluffés 🏚️➡️🏡 100 m² entièrement refaits par nos clients. Bravo à eux !',
 '#renovation #avantapres #longere #alsace #immobilier #inspiration',
 '2026-03-12 11:00:00+01', 'planifie', 0, 0, 0, 'Direction Marketing'),

-- FACEBOOK (5 posts)
('facebook',
 'NOUVEAU — Nous venons de mettre en ligne un exceptionnel loft industriel à Mulhouse. 95 m², hauteur sous plafond 4m, mezzanine. Prix : 245 000 €. Visitez le en ligne ou prenez rdv au 03 89 XX XX XX.',
 '#loft #mulhouse #nouveau #immobilier',
 '2026-03-01 10:00:00+01', 'publie', 98, 23, 41, 'Sophie Martin'),

('facebook',
 'Témoignage client ⭐⭐⭐⭐⭐ — "Merci à toute l''équipe de Colmar pour leur réactivité et leur professionnalisme. Nous avons vendu notre maison en 3 semaines !" — Famille BECK, Colmar.',
 '#avis #temoignage #client #agenceimmobiliere',
 '2026-02-20 15:00:00+01', 'publie', 134, 19, 27, 'Directrice Colmar'),

('facebook',
 '🏡 PORTES OUVERTES — Samedi 15 mars de 10h à 17h à notre agence Strasbourg. Estimations gratuites, conseils financement, présentation de nos exclusivités. Venez nombreux !',
 '#portesouvertes #strasbourg #gratuit #estimation #immobilier',
 '2026-03-10 08:00:00+01', 'planifie', 0, 0, 0, 'Béatrice Keller'),

('facebook',
 '🎂 La Belle Agence fête ses 15 ans ! Depuis 2011, nous avons accompagné plus de 2 400 familles alsaciennes dans leur projet immobilier. Merci à tous nos clients et partenaires de confiance.',
 '#anniversaire #labelleagence #alsace #immobilier #15ans',
 '2026-01-10 09:00:00+01', 'publie', 312, 87, 54, 'Direction Générale'),

('facebook',
 'Comprendre le PTZ en 2026 : qui peut en bénéficier ? Quelles zones ? Quel montant ? Notre guide complet disponible sur notre site. Partagez avec vos proches qui envisagent d''acheter !',
 '#ptz #pretatzero #immobilier #conseils #financement',
 '2026-02-05 12:00:00+01', 'publie', 201, 44, 112, 'Direction Marketing'),

-- LINKEDIN (4 posts)
('linkedin',
 'Analyse du marché immobilier alsacien — Q4 2025. Nos observations terrain confirment une stabilisation des prix à Mulhouse, une légère progression à Strasbourg et Colmar. Nous partageons notre lecture des tendances pour 2026.',
 '#immobilier #alsace #marche #analyse #tendances',
 '2026-01-20 09:00:00+01', 'publie', 187, 31, 62, 'Direction Générale'),

('linkedin',
 'Nous sommes ravis d''accueillir cette année une promotion de 12 étudiants BTS Professions Immobilières au sein de nos agences. La transmission des savoirs est au cœur de notre projet d''entreprise.',
 '#bts #immobilier #formation #alternance #labelleagence',
 '2026-02-03 10:00:00+01', 'publie', 243, 28, 19, 'Direction RH'),

('linkedin',
 'Notre agence Strasbourg remporte pour la 2e année consécutive le trophée FNAIM Alsace "Excellence Client 2025". Fierté pour toute l''équipe — continuons à mériter cette confiance.',
 '#trophee #fnaim #excellence #alsace #immobilier',
 '2026-01-28 11:00:00+01', 'publie', 398, 52, 34, 'Béatrice Keller'),

('linkedin',
 'La loi Hoguet a 50 ans. Retour sur une réglementation fondamentale pour notre profession. Interview de notre responsable conformité sur les évolutions attendues en 2026.',
 '#loihoguet #conformite #immobilier #reglementation',
 '2026-02-15 14:00:00+01', 'publie', 156, 22, 41, 'Responsable Conformité'),

-- TIKTOK (3 posts)
('tiktok',
 'Visite virtuelle — Appartement panoramique à Strasbourg ! 4e étage, terrasse 20m², vue sur la cathédrale. On vous emmène en visite 🎥 (lien dans la bio).',
 '#visite #strasbourg #appartement #panoramique #tiktokimmobilier',
 '2026-02-25 17:00:00+01', 'publie', 1823, 234, 89, 'Direction Marketing'),

('tiktok',
 '5 erreurs à éviter quand vous vendez votre maison 🚨 (thread vidéo — partie 1). Mauvaises photos, prix trop élevé, absence de home staging... on vous dit tout !',
 '#conseils #vente #immobilier #erreurs #astuces',
 '2026-02-10 18:00:00+01', 'publie', 4210, 387, 521, 'Sophie Martin'),

('tiktok',
 'Le saviez-vous ? La carte professionnelle CPI est obligatoire pour tout agent immobilier. Elle se renouvelle tous les 3 ans. On vous explique pourquoi en 60 secondes.',
 '#immobilier #cpi #reglementation #saviez_vous #loi',
 '2026-01-30 16:00:00+01', 'publie', 2940, 198, 310, 'Responsable Conformité'),

-- YOUTUBE (2 posts)
('youtube',
 'VISITE COMPLÈTE — Belle maison de maître 5 pièces à Colmar. 180 m², jardin, double garage, cave à vin. Prix : 520 000 €. Vidéo 360° et plan disponibles. Ref : COLM-2026-017.',
 '#colmar #maisondemaitre #immobilier #visite #youtube',
 '2026-02-18 10:00:00+01', 'publie', 892, 67, 43, 'Direction Marketing'),

('youtube',
 'INTERVIEW — "Comment bien estimer son bien en 2026 ?" Nos experts répondent à vos questions les plus fréquentes : surface, emplacement, rénovation, marché local. Durée : 22 minutes.',
 '#estimation #immobilier #conseils #expertise #alsace',
 '2026-01-25 09:00:00+01', 'publie', 1240, 89, 31, 'Direction Générale')

ON CONFLICT DO NOTHING;


-- ────────────────────────────────────────────────────────────
-- SEED — Calendrier éditorial (6 entrées mars 2026)
-- ────────────────────────────────────────────────────────────

INSERT INTO calendrier_editorial (titre, plateforme, type_contenu, date_prevue, statut, responsable, notes) VALUES
('Exclusivité Strasbourg — Penthouse vue cathédrale', 'instagram', 'carousel', '2026-03-10', 'en_creation', 'Sophie Martin', 'Photos professionnelles prévues le 7 mars'),
('Portes ouvertes Strasbourg — Rappel J-3',           'facebook',  'photo',    '2026-03-12', 'valide',      'Béatrice Keller', NULL),
('Guide : comprendre les frais de notaire',            'linkedin',  'carrousel', '2026-03-14', 'a_planifier', 'Direction Marketing', 'Article blog à rédiger en amont'),
('Visite TikTok — Loft Mulhouse',                     'tiktok',    'video',     '2026-03-15', 'en_creation', 'Sophie Martin', 'Tournage prévu le 11 mars'),
('Résultats portes ouvertes Strasbourg',               'facebook',  'photo',    '2026-03-17', 'a_planifier', 'Béatrice Keller', NULL),
('Trophée FNAIM — Coulisses de la cérémonie',         'youtube',   'video',     '2026-03-20', 'a_planifier', 'Direction Marketing', 'Rushes disponibles')
ON CONFLICT DO NOTHING;


-- ============================================================
-- PARTIE 2 — FOURNISSEURS & PARTENAIRES
-- ============================================================

CREATE TABLE IF NOT EXISTS fournisseurs_partenaires (
  id                      SERIAL PRIMARY KEY,
  code_fournisseur        VARCHAR(50) UNIQUE,
  nom                     VARCHAR(200) NOT NULL,
  type                    VARCHAR(50),
    CHECK (type IN ('portail_annonces', 'courtier_credit', 'assurance', 'promoteur', 'diagnostiqueur', 'apporteur_affaires')),
  contact_nom             VARCHAR(200),
  contact_email           VARCHAR(255),
  contact_telephone       VARCHAR(20),
  site_web                TEXT,
  conditions_commerciales TEXT,
  commission_taux         NUMERIC(5,2),
  contrat_debut           DATE,
  contrat_fin             DATE,
  note_globale            NUMERIC(3,1),
  statut                  VARCHAR(30) DEFAULT 'actif',
    CHECK (statut IN ('actif', 'suspendu', 'inactif')),
  created_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS evaluations_fournisseurs (
  id              SERIAL PRIMARY KEY,
  fournisseur_id  INTEGER REFERENCES fournisseurs_partenaires(id),
  fournisseur_nom VARCHAR(200),
  date_evaluation DATE,
  note_qualite    INTEGER CHECK (note_qualite BETWEEN 1 AND 5),
  note_delais     INTEGER CHECK (note_delais BETWEEN 1 AND 5),
  note_prix       INTEGER CHECK (note_prix BETWEEN 1 AND 5),
  commentaire     TEXT,
  evaluateur      VARCHAR(100),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS historique_fournisseurs (
  id              SERIAL PRIMARY KEY,
  fournisseur_id  INTEGER REFERENCES fournisseurs_partenaires(id),
  fournisseur_nom VARCHAR(200),
  type_operation  VARCHAR(50),
  montant         NUMERIC(12,2),
  date_operation  DATE,
  description     TEXT,
  statut          VARCHAR(30) DEFAULT 'réalisé',
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE fournisseurs_partenaires  ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluations_fournisseurs  ENABLE ROW LEVEL SECURITY;
ALTER TABLE historique_fournisseurs   ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "fourn_all"  ON fournisseurs_partenaires;
DROP POLICY IF EXISTS "eval_all"   ON evaluations_fournisseurs;
DROP POLICY IF EXISTS "histo_all"  ON historique_fournisseurs;

CREATE POLICY "fourn_all" ON fournisseurs_partenaires FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "eval_all"  ON evaluations_fournisseurs  FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "histo_all" ON historique_fournisseurs   FOR ALL USING (true) WITH CHECK (true);


-- ────────────────────────────────────────────────────────────
-- SEED — 15 fournisseurs & partenaires
-- ────────────────────────────────────────────────────────────

INSERT INTO fournisseurs_partenaires
  (code_fournisseur, nom, type, contact_nom, contact_email, contact_telephone,
   site_web, conditions_commerciales, commission_taux, contrat_debut, contrat_fin, note_globale, statut)
VALUES

-- Portails annonces
('PORTAIL-001', 'SeLoger Professionnels',
 'portail_annonces', 'Marc Duval', 'mduval@seloger.com', '01 53 44 40 40',
 'https://pro.seloger.com',
 'Abonnement mensuel 890 €/mois — diffusion illimitée — toutes agences',
 NULL, '2025-01-01', '2025-12-31', 4.2, 'actif'),

('PORTAIL-002', 'Leboncoin Immobilier',
 'portail_annonces', 'Carole Renard', 'crenard@leboncoin.fr', '01 70 39 09 00',
 'https://pro.leboncoin.fr',
 'Pack Expert 350 €/mois — 150 annonces simultanées — badge Pro',
 NULL, '2025-01-01', '2025-12-31', 3.8, 'actif'),

('PORTAIL-003', 'PAP.fr',
 'portail_annonces', 'Julien Morin', 'jmorin@pap.fr', '01 40 27 40 00',
 'https://pro.pap.fr',
 'Formule Pro 180 €/mois — annonces entre particuliers avec mention agence',
 NULL, '2025-03-01', '2026-02-28', 3.5, 'actif'),

-- Courtiers crédit
('COURT-001', 'CAFPI Alsace',
 'courtier_credit', 'Pierre Schwartz', 'pschwartz@cafpi.fr', '03 89 66 00 00',
 'https://www.cafpi.fr',
 'Convention partenariat — apport réciproque de clients — commission 0,5% sur dossiers finalisés',
 0.50, '2024-07-01', '2026-06-30', 4.5, 'actif'),

('COURT-002', 'VOUSFINANCER Mulhouse',
 'courtier_credit', 'Stéphanie Hug', 'shug@vousfinancer.com', '03 89 36 12 80',
 'https://www.vousfinancer.com',
 'Convention partenariat — commission 300 € par dossier abouti',
 NULL, '2025-01-15', '2026-01-14', 4.1, 'actif'),

('COURT-003', 'EMPRUNTIS Online',
 'courtier_credit', 'Nicolas Perrot', 'nperrot@empruntis.com', '01 77 50 40 00',
 'https://www.empruntis.com',
 'Plateforme digitale — redirection leads qualifiés — 150 € par mise en relation',
 NULL, '2025-04-01', '2026-03-31', 3.7, 'actif'),

-- Promoteurs
('PROMO-001', 'Kaufman & Broad Alsace',
 'promoteur', 'Isabelle Vogel', 'ivogel@kb.fr', '03 88 23 45 67',
 'https://www.kaufmanbroad.fr',
 'Convention mandataire — commercialisation programmes neufs — commission 3% TTC sur vente',
 3.00, '2024-01-01', '2026-12-31', 4.0, 'actif'),

('PROMO-002', 'NEXITY Grand Est',
 'promoteur', 'François Bauer', 'fbauer@nexity.fr', '03 88 75 12 00',
 'https://www.nexity.fr',
 'Convention mandataire — programmes Strasbourg et Mulhouse — commission 2,8% TTC',
 2.80, '2025-01-01', '2026-12-31', 4.3, 'actif'),

('PROMO-003', 'Bouygues Immobilier Alsace',
 'promoteur', 'Anne Schneider', 'ascheid@bouygues-immo.fr', '03 88 21 55 00',
 'https://www.bouygues-immobilier.com',
 'Convention mandataire — commission 2,5% — exclusivité sur 2 programmes par an',
 2.50, '2025-06-01', '2027-05-31', 3.9, 'actif'),

-- Assurances
('ASSUR-001', 'AXA Courtage Alsace',
 'assurance', 'Bruno Jacquet', 'bjacquet@axa.fr', '03 89 44 77 00',
 'https://www.axa.fr',
 'Contrat cadre RC Pro + PNO — tarifs négociés pour nos clients — commission 8% sur primes',
 8.00, '2025-01-01', '2025-12-31', 4.4, 'actif'),

('ASSUR-002', 'ALLIANZ Immobilier Pro',
 'assurance', 'Céline Dreyer', 'cdreyer@allianz.fr', '03 88 33 11 22',
 'https://www.allianz.fr',
 'Contrat cadre assurances habitation et GLI — commission 7% sur primes encaissées',
 7.00, '2024-09-01', '2026-08-31', 4.2, 'actif'),

-- Diagnostiqueurs
('DIAG-001', 'DEKRA Inspection Alsace',
 'diagnostiqueur', 'Laurent Kieffer', 'lkieffer@dekra.fr', '03 89 55 78 90',
 'https://www.dekra.fr',
 'Tarifs préférentiels : DPE 90€, amiante 120€, plomb 110€, lot complet 290€',
 NULL, '2025-01-01', '2026-12-31', 4.6, 'actif'),

('DIAG-002', 'SOCOTEC Diagnostics',
 'diagnostiqueur', 'Marie Hoffmann', 'mhoffmann@socotec.fr', '03 88 20 40 50',
 'https://www.socotec.fr',
 'Tarifs préférentiels : lot complet 320€ — intervention sous 48h garantie',
 NULL, '2025-03-01', '2027-02-28', 4.3, 'actif'),

-- Apporteurs d'affaires
('APPORT-001', 'Cabinet Durand & Associés',
 'apporteur_affaires', 'Gérard Durand', 'contact@cabinet-durand.fr', '03 89 60 22 44',
 NULL,
 'Contrat apporteur — 1% TTC du prix de vente par affaire apportée et conclue',
 1.00, '2024-04-01', '2026-03-31', 4.0, 'actif'),

('APPORT-002', 'FIDUCIA Conseils Patrimoniaux',
 'apporteur_affaires', 'Patricia Heim', 'pheim@fiducia-conseils.fr', '03 88 37 15 60',
 'https://www.fiducia-conseils.fr',
 'Contrat apporteur — 0,8% du prix de vente — spécialisé clientèle patrimoniale haut de gamme',
 0.80, '2025-01-01', '2026-12-31', 4.7, 'actif')

ON CONFLICT (code_fournisseur) DO NOTHING;


-- ────────────────────────────────────────────────────────────
-- SEED — Évaluations fournisseurs
-- ────────────────────────────────────────────────────────────

INSERT INTO evaluations_fournisseurs
  (fournisseur_nom, date_evaluation, note_qualite, note_delais, note_prix, commentaire, evaluateur)
VALUES
('SeLoger Professionnels', '2025-12-15', 4, 5, 3, 'Excellente visibilité, bon taux de contact. Tarif en hausse mais ROI positif.', 'Direction Marketing'),
('Leboncoin Immobilier',   '2025-12-15', 4, 4, 4, 'Bon volume de leads. Interface back-office améliorée en 2025.', 'Direction Marketing'),
('CAFPI Alsace',           '2026-01-10', 5, 5, 4, 'Partenaire exemplaire. 12 dossiers financés en 2025, taux refus < 5%.', 'Direction Commerciale'),
('VOUSFINANCER Mulhouse',  '2026-01-10', 4, 4, 4, 'Bons délais, accompagnement client apprécié. Renouveler convention.', 'Direction Commerciale'),
('Kaufman & Broad Alsace', '2025-11-20', 4, 3, 4, 'Programme Strasbourg bien vendu. Délais livraison parfois tendus.', 'Direction Commerciale'),
('NEXITY Grand Est',       '2025-11-20', 5, 4, 3, 'Excellent accompagnement commercial. Programmes de qualité mais prix élevés.', 'Direction Commerciale'),
('AXA Courtage Alsace',    '2026-01-20', 4, 5, 4, 'Réactivité exemplaire pour les RC Pro. Très bon interlocuteur dédié.', 'Responsable Conformité'),
('DEKRA Inspection Alsace','2026-02-01', 5, 5, 5, 'Meilleur rapport qualité/prix du marché. Rapports clairs, délais tenus.', 'Directrice Strasbourg'),
('FIDUCIA Conseils Patrimoniaux', '2026-01-05', 5, 5, 5, '3 affaires apportées en Q4 2025, toutes conclues. Clientèle très qualifiée.', 'Direction Générale')
ON CONFLICT DO NOTHING;


-- ────────────────────────────────────────────────────────────
-- SEED — Historique opérations fournisseurs
-- ────────────────────────────────────────────────────────────

INSERT INTO historique_fournisseurs
  (fournisseur_nom, type_operation, montant, date_operation, description, statut)
VALUES
('SeLoger Professionnels', 'abonnement',        890.00, '2026-01-01', 'Abonnement mensuel janvier 2026 — 3 agences', 'réalisé'),
('SeLoger Professionnels', 'abonnement',        890.00, '2026-02-01', 'Abonnement mensuel février 2026 — 3 agences', 'réalisé'),
('SeLoger Professionnels', 'abonnement',        890.00, '2026-03-01', 'Abonnement mensuel mars 2026 — 3 agences', 'réalisé'),
('Leboncoin Immobilier',   'abonnement',        350.00, '2026-01-01', 'Pack Expert janvier 2026', 'réalisé'),
('Leboncoin Immobilier',   'abonnement',        350.00, '2026-02-01', 'Pack Expert février 2026', 'réalisé'),
('CAFPI Alsace',           'commission',        1875.00,'2026-01-28', 'Commission 0,5% — vente Strasbourg 375 000€ — dossier LAMBERT', 'réalisé'),
('CAFPI Alsace',           'commission',        1125.00,'2026-02-15', 'Commission 0,5% — vente Mulhouse 225 000€ — dossier NGUYEN', 'réalisé'),
('VOUSFINANCER Mulhouse',  'commission',         300.00,'2026-02-20', 'Commission 300€ — dossier abouti KLEIN — achat F3 Colmar', 'réalisé'),
('Kaufman & Broad Alsace', 'commission',       12000.00,'2026-01-15', 'Commission 3% — vente programme neuf Strasbourg 400 000€ — M. FISCHER', 'réalisé'),
('NEXITY Grand Est',       'commission',        8400.00,'2026-02-28', 'Commission 2,8% — vente programme Mulhouse 300 000€ — Mme BRANDT', 'réalisé'),
('AXA Courtage Alsace',    'commission',         720.00,'2026-01-31', 'Commission 8% — primes RC Pro T1 2026 — 9 000€ de primes', 'réalisé'),
('DEKRA Inspection Alsace','diagnostics',        870.00,'2026-02-10', 'Lots complets × 3 dossiers (ventes Strasbourg) — tarif préférentiel', 'réalisé'),
('SOCOTEC Diagnostics',    'diagnostics',        640.00,'2026-02-22', 'Lots complets × 2 dossiers (ventes Colmar)', 'réalisé'),
('Cabinet Durand & Associés', 'commission',     3500.00,'2026-01-20', 'Commission 1% — affaire apportée — vente maison Mulhouse 350 000€', 'réalisé'),
('FIDUCIA Conseils Patrimoniaux', 'commission', 4800.00,'2026-02-05', 'Commission 0,8% — affaire patrimoine — villa Colmar 600 000€', 'réalisé'),
('PAP.fr',                 'abonnement',         180.00,'2026-03-01', 'Abonnement mensuel mars 2026', 'réalisé'),
('EMPRUNTIS Online',       'mise_en_relation',   450.00,'2026-02-28', 'Commission 3 mises en relation qualifiées × 150€', 'réalisé')
ON CONFLICT DO NOTHING;


-- ============================================================
-- FIN MIGRATION 006
-- ============================================================

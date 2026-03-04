-- ============================================================
-- DONNÉES RÉALISTES — LA BELLE AGENCE
-- Diversité : Alsacien · Français · Italien · Portugais · Marocain · Albanais
-- 20 salariés | 30 clients | 30 biens | 20 mandats | 15 prospects
-- ============================================================

-- ============================================================
-- 0. EXTENSION DU SCHÉMA
-- ============================================================

ALTER TABLE salaries
  ADD COLUMN IF NOT EXISTS age          INTEGER,
  ADD COLUMN IF NOT EXISTS origine      VARCHAR(100),
  ADD COLUMN IF NOT EXISTS email        VARCHAR(255),
  ADD COLUMN IF NOT EXISTS telephone    VARCHAR(20),
  ADD COLUMN IF NOT EXISTS adresse      TEXT,
  ADD COLUMN IF NOT EXISTS agence       VARCHAR(100),
  ADD COLUMN IF NOT EXISTS salaire_brut NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS type_contrat VARCHAR(50) DEFAULT 'CDI';

ALTER TABLE clients
  ADD COLUMN IF NOT EXISTS age                  INTEGER,
  ADD COLUMN IF NOT EXISTS adresse              TEXT,
  ADD COLUMN IF NOT EXISTS budget_min           NUMERIC(12,2),
  ADD COLUMN IF NOT EXISTS budget_max           NUMERIC(12,2),
  ADD COLUMN IF NOT EXISTS type_recherche       VARCHAR(50),
  ADD COLUMN IF NOT EXISTS nb_pieces            INTEGER,
  ADD COLUMN IF NOT EXISTS agent_referent       INTEGER,
  ADD COLUMN IF NOT EXISTS date_premier_contact DATE,
  ADD COLUMN IF NOT EXISTS statut               VARCHAR(50) DEFAULT 'actif',
  ADD COLUMN IF NOT EXISTS profession           VARCHAR(200),
  ADD COLUMN IF NOT EXISTS situation_familiale  VARCHAR(100);

ALTER TABLE biens
  ADD COLUMN IF NOT EXISTS reference          VARCHAR(20),
  ADD COLUMN IF NOT EXISTS ville              VARCHAR(100),
  ADD COLUMN IF NOT EXISTS surface_habitable  NUMERIC(8,2),
  ADD COLUMN IF NOT EXISTS surface_terrain    NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS nb_chambres        INTEGER,
  ADD COLUMN IF NOT EXISTS nb_sdb             INTEGER,
  ADD COLUMN IF NOT EXISTS annee_construction INTEGER,
  ADD COLUMN IF NOT EXISTS dpe                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS ges                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS chauffage          VARCHAR(100),
  ADD COLUMN IF NOT EXISTS lien_maps          TEXT,
  ADD COLUMN IF NOT EXISTS statut             VARCHAR(50) DEFAULT 'en vente',
  ADD COLUMN IF NOT EXISTS agent_id           INTEGER,
  ADD COLUMN IF NOT EXISTS vendeur_id         INTEGER,
  ADD COLUMN IF NOT EXISTS date_mise_vente    DATE,
  ADD COLUMN IF NOT EXISTS commission         NUMERIC(4,2) DEFAULT 5.00;

ALTER TABLE prospects
  ADD COLUMN IF NOT EXISTS telephone       VARCHAR(20),
  ADD COLUMN IF NOT EXISTS statut_prospect VARCHAR(50) DEFAULT 'tiède',
  ADD COLUMN IF NOT EXISTS ville           VARCHAR(100),
  ADD COLUMN IF NOT EXISTS budget          NUMERIC(12,2);

-- ============================================================
-- 1. NETTOYAGE (respecte les dépendances FK)
-- ============================================================

DELETE FROM ventes;
DELETE FROM offres;
DELETE FROM visites;
DELETE FROM mandats;
DELETE FROM dossiers_patrimoniaux;
DELETE FROM formations;
DELETE FROM conges;
DELETE FROM documents_rh;
DELETE FROM cartes_professionnelles;
DELETE FROM assurances_rc;
DELETE FROM factures_fournisseurs;
DELETE FROM factures_clients;
DELETE FROM ecritures_comptables;
DELETE FROM tickets_support;
DELETE FROM materiel_informatique;
DELETE FROM licences_logiciels;
DELETE FROM campagnes_marketing;
DELETE FROM posts_sociaux;
DELETE FROM templates_documents;
DELETE FROM prospects;
DELETE FROM biens;
DELETE FROM clients;
DELETE FROM salaries;

-- ============================================================
-- 2. SALARIÉS (20)
-- IDs SERIAL attendus : 1-10 Siège · 11-13 Colmar · 14-16 Mulhouse · 17-20 Strasbourg
-- ============================================================

INSERT INTO salaries (nom, prenom, age, origine, email, telephone, adresse, poste, service, agence, date_embauche, salaire_brut, type_contrat) VALUES
-- ─── SIÈGE MULHOUSE — Direction (1-2) ────────────────────────────────────
('DIRINGER',  'Christophe', 55, 'Alsacien',   'diringer.c@labelleagence.fr',  '0612345601', '15 rue du Sapin, 68100 Mulhouse',                    'Directeur Général',          'Direction',  'Siège',            '2010-01-15', 6200, 'CDI'),
('ROSSI',     'Elena',      48, 'Italienne',  'rossi.e@labelleagence.fr',     '0612345602', '8 avenue de Colmar, 68200 Mulhouse',                 'Directrice Adjointe',        'Direction',  'Siège',            '2012-03-01', 5100, 'CDI'),
-- ─── RH (3-4) ─────────────────────────────────────────────────────────────
('SILVA',     'Maria',      42, 'Portugaise', 'silva.m@labelleagence.fr',     '0612345603', '22 rue des Tilleuls, 68200 Mulhouse',                'Responsable RH',             'RH',         'Siège',            '2014-06-01', 3900, 'CDI'),
('MEYER',     'Laura',      28, 'Alsacienne', 'meyer.l@labelleagence.fr',     '0612345604', '5 allée des Roses, 68100 Mulhouse',                  'Assistante RH',              'RH',         'Siège',            '2022-09-05', 2300, 'CDI'),
-- ─── Conformité & Juridique (5-6) ────────────────────────────────────────
('ALAMI',     'Youssef',    38, 'Marocain',   'alami.y@labelleagence.fr',     '0612345605', '14 rue de Bâle, 68200 Mulhouse',                     'Compliance Officer',         'Conformité', 'Siège',            '2017-01-03', 3700, 'CDI'),
('BERNARD',   'Julie',      26, 'Française',  'bernard.j@labelleagence.fr',   '0612345606', '3 impasse des Lilas, 68100 Mulhouse',                'Assistante Conformité',      'Conformité', 'Siège',            '2023-02-01', 2100, 'CDI'),
-- ─── Finance & Comptabilité (7-8) ────────────────────────────────────────
('HOXHA',     'Arben',      45, 'Albanais',   'hoxha.a@labelleagence.fr',     '0612345607', '31 rue du Rhône, 68200 Mulhouse',                    'Responsable Comptable',      'Finance',    'Siège',            '2015-09-01', 4100, 'CDI'),
('SANTOS',    'Carla',      32, 'Portugaise', 'santos.c@labelleagence.fr',    '0612345608', '17 avenue du Président Wilson, 68100 Mulhouse',      'Comptable',                  'Finance',    'Siège',            '2019-04-01', 2800, 'CDI'),
-- ─── Marketing (9) ────────────────────────────────────────────────────────
('MARTIN',    'Claire',     35, 'Française',  'martin.c@labelleagence.fr',    '0612345609', '9 rue des Fleurs, 68200 Mulhouse',                   'Responsable Marketing',      'Marketing',  'Siège',            '2016-03-15', 3600, 'CDI'),
-- ─── IT (10) ──────────────────────────────────────────────────────────────
('GRECO',     'Marco',      30, 'Italien',    'greco.m@labelleagence.fr',     '0612345610', '26 boulevard de l''Europe, 68100 Mulhouse',           'Technicien IT',              'IT',         'Siège',            '2021-02-01', 2700, 'CDI'),
-- ─── AGENCE COLMAR (11-13) ────────────────────────────────────────────────
('BENALI',    'Fatima',     40, 'Marocaine',  'benali.f@labelleagence.fr',    '0612345611', '7 rue du Ladhof, 68000 Colmar',                      'Responsable Agence Colmar',  'Commercial', 'Agence Colmar',    '2013-05-01', 4300, 'CDI'),
('FERREIRA',  'Pedro',      33, 'Portugais',  'ferreira.p@labelleagence.fr',  '0612345612', '19 allée des Marronniers, 68000 Colmar',             'Négociateur Immobilier',     'Commercial', 'Agence Colmar',    '2020-09-15', 2500, 'CDI'),
('KLEIN',     'Léa',        25, 'Alsacienne', 'klein.l@labelleagence.fr',     '0612345613', '4 rue des Cigognes, 68000 Colmar',                   'Assistante Commerciale',     'Commercial', 'Agence Colmar',    '2024-01-09', 2050, 'CDI'),
-- ─── AGENCE MULHOUSE (14-16) ──────────────────────────────────────────────
('SHEHU',     'Gentian',    43, 'Albanais',   'shehu.g@labelleagence.fr',     '0612345614', '43 avenue de la Marseillaise, 68100 Mulhouse',       'Responsable Agence Mulhouse','Commercial', 'Agence Mulhouse',  '2014-02-17', 4300, 'CDI'),
('COSTA',     'Sofia',      29, 'Italienne',  'costa.s@labelleagence.fr',     '0612345615', '12 rue Saint-Louis, 68200 Mulhouse',                 'Négociatrice Immobilière',   'Commercial', 'Agence Mulhouse',  '2021-03-01', 2500, 'CDI'),
('WEBER',     'Lucas',      27, 'Alsacien',   'weber.l@labelleagence.fr',     '0612345616', '8 cité des Fleurs, 68100 Mulhouse',                  'Assistant Commercial',       'Commercial', 'Agence Mulhouse',  '2022-06-20', 2050, 'CDI'),
-- ─── AGENCE STRASBOURG (17-19) ────────────────────────────────────────────
('THOMAS',    'David',      39, 'Français',   'thomas.d@labelleagence.fr',    '0612345617', '55 avenue des Vosges, 67000 Strasbourg',             'Responsable Agence Strasb.', 'Commercial', 'Agence Strasbourg','2016-07-04', 4300, 'CDI'),
('FASSI',     'Amina',      31, 'Marocaine',  'fassi.a@labelleagence.fr',     '0612345618', '18 rue du Faubourg National, 67000 Strasbourg',      'Négociatrice Immobilière',   'Commercial', 'Agence Strasbourg','2021-09-01', 2500, 'CDI'),
('OLIVEIRA',  'Hugo',       34, 'Portugais',  'oliveira.h@labelleagence.fr',  '0612345619', '7 place de la Cathédrale, 67000 Strasbourg',         'Conseiller Gestion Patrimoine','Commercial','Agence Strasbourg','2019-11-01', 3300, 'CDI'),
-- ─── Siège — Marketing 20ème ──────────────────────────────────────────────
('ROMANO',    'Valentina',  26, 'Italienne',  'romano.v@labelleagence.fr',    '0612345620', '11 rue des Acacias, 68200 Mulhouse',                 'Community Manager',          'Marketing',  'Siège',            '2024-01-15', 2200, 'CDI');

-- ============================================================
-- 3. CLIENTS (30)
-- agent_referent : ID entier du salarié commercial référent
--   Colmar  → 11 BENALI · 12 FERREIRA · 13 KLEIN
--   Mulhouse→ 14 SHEHU  · 15 COSTA    · 16 WEBER
--   Strasb. → 17 THOMAS · 18 FASSI    · 19 OLIVEIRA
-- ============================================================

INSERT INTO clients (nom, prenom, age, email, telephone, adresse, budget_min, budget_max, type_recherche, nb_pieces, agent_referent, date_premier_contact, statut, profession, situation_familiale) VALUES
-- ─── COLMAR (10 clients) ──────────────────────────────────────────────────
('FERRARI',   'Giovanni & Laura',   45, 'ferrari.giovanni@gmail.com',    '0623456701', '25 rue des Vignes, 68000 Colmar',              350000, 450000, 'maison',      5, 12, '2025-11-15', 'actif', 'Cadre supérieur / Enseignante',          'Marié, 2 enfants'),
('CHAKIR',    'Ahmed',              62, 'a.chakir@yahoo.fr',             '0623456702', '8 rue du Marché, 68000 Colmar',                220000, 280000, 'appartement', 3, 11, '2025-10-20', 'actif', 'Commerçant retraité',                    'Marié, 4 enfants'),
('RODRIGUES', 'Ana',                33, 'ana.rodrigues@hotmail.com',     '0623456703', '34 allée des Châtaigniers, 68000 Colmar',      160000, 200000, 'appartement', 2, 12, '2025-12-01', 'actif', 'Infirmière',                              'Célibataire'),
('SCHMIDT',   'Jean-Pierre & Marie',50, 'schmidt.jp@orange.fr',          '0623456704', '16 rue des Cigognes, 68000 Colmar',            280000, 360000, 'maison',      4, 13, '2025-09-10', 'actif', 'Artisan / Secrétaire médicale',           'Marié, 3 enfants'),
('KRASNIQI',  'Leonit & Liris',     40, 'leonit.krasniqi@gmail.com',     '0623456705', '22 avenue d''Alsace, 68000 Colmar',            240000, 320000, 'maison',      4, 12, '2025-11-28', 'actif', 'Gérant d''entreprise / Comptable',       'Marié, 2 enfants'),
('ROBERT',    'Sophie',             38, 'sophie.robert@sfr.fr',          '0623456706', '5 rue de la Gare, 68000 Colmar',               180000, 220000, 'appartement', 3, 11, '2026-01-05', 'actif', 'Pharmacienne',                           'Divorcée, 1 enfant'),
('IDRISSI',   'Karim & Leila',      35, 'k.idrissi@outlook.fr',          '0623456707', '11 boulevard Charles de Gaulle, 68000 Colmar', 300000, 400000, 'maison',      5, 12, '2025-10-15', 'actif', 'Ingénieur / Kinésithérapeute',           'Marié, 1 enfant'),
('SANTOS',    'Carlos',             47, 'carlos.santos@gmail.com',       '0623456708', '3 rue du Ladhof, 68000 Colmar',                200000, 250000, 'appartement', 2, 11, '2025-12-10', 'actif', 'Chef de projet IT',                      'Célibataire'),
('GRECO',     'Elena',              29, 'elena.greco@yahoo.it',          '0623456709', '28 rue de Turenne, 68000 Colmar',              130000, 170000, 'appartement', 2, 13, '2026-01-20', 'actif', 'Graphiste freelance',                    'En couple'),
('MULLER',    'Thomas',             55, 't.muller@wanadoo.fr',           '0623456710', '42 route de Rouffach, 68000 Colmar',           400000, 500000, 'maison',      6, 12, '2025-09-05', 'actif', 'Directeur commercial',                   'Marié, 2 enfants'),
-- ─── MULHOUSE (10 clients) ────────────────────────────────────────────────
('LEKA',      'Besnik & Drita',     38, 'besnik.leka@gmail.com',         '0623456711', '14 rue des Marronniers, 68100 Mulhouse',       300000, 400000, 'maison',      5, 14, '2025-11-03', 'actif', 'Électricien indépendant / Aide-soignante','Marié, 3 enfants'),
('ALAMI',     'Fatima',             50, 'f.alami@hotmail.fr',            '0623456712', '7 avenue de Colmar, 68100 Mulhouse',           170000, 230000, 'appartement', 3, 15, '2025-10-08', 'actif', 'Éducatrice spécialisée',                 'Veuve, 2 enfants'),
('SILVA',     'João & Maria',       43, 'joao.silva@gmail.com',          '0623456713', '33 rue de Bâle, 68200 Mulhouse',               260000, 340000, 'maison',      4, 14, '2025-09-22', 'actif', 'Technicien maintenance / Agent de service','Marié, 2 enfants'),
('ROMANO',    'Pietro',             35, 'pietro.romano@libero.it',       '0623456714', '19 allée Steinlen, 68100 Mulhouse',            150000, 210000, 'appartement', 2, 15, '2026-01-12', 'actif', 'Cuisinier',                              'Célibataire'),
('BERBERI',   'Elira',              41, 'elira.berberi@outlook.com',     '0623456715', '6 cité des Fleurs, 68200 Mulhouse',            230000, 310000, 'maison',      4, 16, '2025-12-15', 'actif', 'Directrice de crèche',                   'Divorcée, 2 enfants'),
('MARTIN',    'Lucas & Emma',       32, 'lucas.martin@free.fr',          '0623456716', '45 rue Vauban, 68100 Mulhouse',                210000, 290000, 'appartement', 3, 14, '2026-01-07', 'actif', 'Développeur web / Orthophoniste',        'Pacsé, sans enfant'),
('BENALI',    'Youssef',            48, 'y.benali@gmail.com',            '0623456717', '8 avenue de la Marseillaise, 68200 Mulhouse',  350000, 450000, 'maison',      6, 15, '2025-08-20', 'actif', 'Chef d''entreprise BTP',                 'Marié, 4 enfants'),
('FERREIRA',  'Teresa',             37, 'teresa.ferreira@sapo.pt',       '0623456718', '25 rue du Maréchal Joffre, 68100 Mulhouse',    160000, 220000, 'appartement', 2, 16, '2025-12-20', 'actif', 'Aide à domicile',                        'Célibataire, 1 enfant'),
('KLEIN',     'Sophie & Marc',      44, 'sophie.klein@orange.fr',        '0623456719', '17 chemin de la Forêt, 68200 Mulhouse',        320000, 420000, 'maison',      5, 14, '2025-10-30', 'actif', 'Médecin généraliste / Expert-comptable', 'Marié, 2 enfants'),
('COSTA',     'Michele',            52, 'michele.costa@gmail.com',       '0623456720', '9 rue du Raisin, 68100 Mulhouse',              280000, 360000, 'maison',      5, 15, '2025-11-18', 'actif', 'Architecte',                             'Marié, 3 enfants'),
-- ─── STRASBOURG / SAINT-LOUIS (10 clients) ───────────────────────────────
('HOXHA',     'Erion & Anjeza',     42, 'erion.hoxha@gmail.com',         '0623456721', '62 avenue des Vosges, 67000 Strasbourg',       450000, 550000, 'maison',      6, 17, '2025-09-01', 'actif', 'Directeur logistique / Responsable RH',  'Marié, 3 enfants'),
('FASSI',     'Mohammed',           35, 'm.fassi@hotmail.fr',            '0623456722', '14 rue du Faubourg National, 67000 Strasbourg',240000, 320000, 'maison',      4, 18, '2025-10-25', 'actif', 'Technicien télécom',                     'Marié, 2 enfants'),
('OLIVEIRA',  'Ricardo & Ana',      39, 'ricardo.oliveira@gmail.com',    '0623456723', '33 boulevard de la Marne, 67000 Strasbourg',   280000, 360000, 'maison',      4, 19, '2025-11-10', 'actif', 'Ingénieur civil / Professeure',          'Marié, 2 enfants'),
('ROSSI',     'Valentina',          31, 'vale.rossi@yahoo.it',           '0623456724', '8 rue des Écrivains, 67000 Strasbourg',        180000, 240000, 'appartement', 3, 17, '2026-01-15', 'actif', 'Designer graphique',                     'En couple'),
('SHEHU',     'Lorik & Flutura',    46, 'lorik.shehu@outlook.com',       '0623456725', '27 route de la Wantzenau, 67000 Strasbourg',   380000, 460000, 'maison',      6, 18, '2025-08-15', 'actif', 'Restaurateur / Assistante dentaire',     'Marié, 3 enfants'),
('BERNARD',   'Claire & Thomas',    36, 'claire.bernard@sfr.fr',         '0623456726', '5 allée des Saules, 68300 Saint-Louis',        250000, 330000, 'maison',      4, 17, '2025-12-05', 'actif', 'Juriste / Consultant',                   'Pacsé, 1 enfant'),
('SANTOS',    'Joaquim',            40, 'joaquim.santos@gmail.com',      '0623456727', '19 rue des Alpes, 67000 Strasbourg',           300000, 400000, 'appartement', 3, 19, '2025-11-22', 'actif', 'Investisseur immobilier',                'Marié, 2 enfants'),
('WEBER',     'Céline',             29, 'celine.weber@orange.fr',        '0623456728', '11 rue du Parchemin, 67000 Strasbourg',        140000, 200000, 'appartement', 2, 17, '2026-02-01', 'actif', 'Infirmière',                             'Célibataire'),
('CHAKIR',    'Nadia & Omar',       44, 'nadia.chakir@yahoo.fr',         '0623456729', '44 boulevard Wilson, 67000 Strasbourg',        340000, 420000, 'maison',      5, 18, '2025-09-18', 'actif', 'Chirurgienne / Entrepreneur',            'Marié, 2 enfants'),
('MEYER',     'François',           58, 'f.meyer@wanadoo.fr',            '0623456730', '3 chemin du Schloessel, 67400 Illkirch',       400000, 500000, 'maison',      6, 17, '2025-07-10', 'actif', 'Chef d''entreprise retraité',            'Marié');

-- ============================================================
-- 4. BIENS IMMOBILIERS (30)
-- agent_id : ID entier du salarié · vendeur_id : NULL (vendeur externe)
-- ============================================================

INSERT INTO biens (reference, adresse, ville, type, surface_habitable, surface_terrain, nb_chambres, nb_sdb, prix, annee_construction, dpe, ges, chauffage, description, lien_maps, statut, agent_id, vendeur_id, date_mise_vente, commission) VALUES
-- ─── COLMAR (COL-001 à COL-010) ──────────────────────────────────────────
('COL-001', '12 rue des Vignes, 68000 Colmar',            'Colmar', 'Maison',       125, 450,  4, 2, 385000, 1995,'C','D','Gaz',
 'Belle maison familiale en excellent état. Cuisine équipée moderne, séjour lumineux 35m², garage double. Jardin arboré sans vis-à-vis.',
 'https://maps.google.com/?q=12+rue+des+Vignes+68000+Colmar',
 'en vente', 12, NULL, '2026-01-15', 6.00),

('COL-002', '28 allée des Châtaigniers, 68000 Colmar',    'Colmar', 'Maison',        95, 280,  3, 1, 265000, 1978,'D','E','Fioul',
 'Maison mitoyenne avec potentiel. Séjour cathédrale, 3 chambres, jardin clôturé. Travaux de rénovation à prévoir (double vitrage, isolation).',
 'https://maps.google.com/?q=28+allee+des+Chataigniers+68000+Colmar',
 'en vente', 12, NULL, '2025-12-01', 5.50),

('COL-003', '5 impasse du Moulin, 68000 Colmar',          'Colmar', 'Maison',       165, 620,  5, 2, 495000, 2005,'B','C','Pompe à chaleur',
 'Propriété contemporaine haut de gamme. Double séjour 50m², cuisine professionnelle, 5 chambres. Pool house, terrasse 60m². Domotique complète.',
 'https://maps.google.com/?q=5+impasse+du+Moulin+68000+Colmar',
 'en vente', 11, NULL, '2025-09-20', 5.00),

('COL-004', '14 rue du Marché, 68000 Colmar',             'Colmar', 'Appartement',   72,NULL,  2, 1, 198000, 2012,'B','C','Collectif gaz',
 'T3 lumineux en plein centre de Colmar. Parquet chêne, cuisine ouverte équipée, 2 chambres avec placards. Cave et parking souterrain inclus.',
 'https://maps.google.com/?q=14+rue+du+Marche+68000+Colmar',
 'en vente', 13, NULL, '2026-01-20', 5.50),

('COL-005', '8 place de la Cathédrale, 68000 Colmar',     'Colmar', 'Appartement',   55,NULL,  1, 1, 165000, 2001,'C','C','Électrique',
 'T2 avec vue imprenable sur la cathédrale Saint-Martin. Séjour spacieux, cuisine aménagée, balcon. Idéal primo-accédant ou investisseur (rendement 4,5%).',
 'https://maps.google.com/?q=8+place+de+la+Cathedrale+68000+Colmar',
 'en vente', 13, NULL, '2026-02-05', 5.00),

('COL-006', '32 boulevard du Champ de Mars, 68000 Colmar','Colmar', 'Appartement',   90,NULL,  3, 1, 248000, 1985,'D','E','Collectif gaz',
 'Grand T4 familial. 3 chambres, double séjour, cuisine indépendante. Immeuble bien entretenu, gardien. Cave, parking. Travaux de rafraîchissement.',
 'https://maps.google.com/?q=32+boulevard+du+Champ+de+Mars+68000+Colmar',
 'en vente', 12, NULL, '2025-10-10', 5.00),

('COL-007', '3 rue des Tanneurs, 68000 Colmar',           'Colmar', 'Appartement',   42,NULL,  1, 1, 125000, 2018,'A','A','Électrique',
 'Studio premium neuf, finitions luxe. Coin nuit séparé, salle de douche à l''italienne. Résidence sécurisée, ascenseur. Parfait investissement locatif.',
 'https://maps.google.com/?q=3+rue+des+Tanneurs+68000+Colmar',
 'en vente', 13, NULL, '2025-11-15', 5.00),

('COL-008', '45 route d''Ingersheim, 68000 Colmar',       'Colmar', 'Maison',       140, 520,  4, 2, 420000, 2000,'C','D','Gaz',
 'Maison de caractère à 5 min du centre. Salon 40m², 4 chambres dont suite parentale. Garage, jardin paysagé 520m², pergola.',
 'https://maps.google.com/?q=45+route+d+Ingersheim+68000+Colmar',
 'en vente', 12, NULL, '2025-12-15', 5.50),

('COL-009', 'Route de Ribeauvillé, 68000 Colmar',         'Colmar', 'Terrain',     NULL, 800,  0, 0,  95000, NULL, NULL,NULL,NULL,
 'Terrain constructible viabilisé (eau, électricité, gaz en limite). CU positif en cours. Zonage UC. Vue sur vignobles.',
 'https://maps.google.com/?q=Route+de+Ribeauville+68000+Colmar',
 'en vente', 11, NULL, '2025-08-01', 5.00),

('COL-010', '7 rue du Logelbach, 68000 Colmar',           'Colmar', 'Immeuble',     350,NULL,  0, 0, 650000, 1935,'E','E','Collectif gaz',
 'Immeuble de rapport : 6 appartements (4×T2, 2×T3), pleinement loués. Rendement brut 6,2%. Travaux de façade récents. Caves individuelles, cour intérieure.',
 'https://maps.google.com/?q=7+rue+du+Logelbach+68000+Colmar',
 'en vente', 11, NULL, '2025-07-15', 4.50),

-- ─── MULHOUSE (MLH-001 à MLH-010) ────────────────────────────────────────
('MLH-001', '22 rue des Fleurs, 68100 Mulhouse',          'Mulhouse','Maison',       110, 350,  4, 2, 295000, 1990,'D','D','Gaz',
 'Maison semi-individuelle dans quartier résidentiel calme. Séjour 30m², cuisine équipée, 4 chambres. Garage, cave, jardin 350m². Proche tram.',
 'https://maps.google.com/?q=22+rue+des+Fleurs+68100+Mulhouse',
 'en vente', 14, NULL, '2026-01-10', 5.50),

('MLH-002', '15 avenue du Rhin, 68100 Mulhouse',          'Mulhouse','Maison',        85, 200,  3, 1, 235000, 1975,'E','E','Fioul',
 'Maison familiale à rénover. Structure saine, charpente récente. 3 chambres, jardin clôturé. Budget travaux estimé : 40 000€ (isolation, chauffage, cuisine).',
 'https://maps.google.com/?q=15+avenue+du+Rhin+68100+Mulhouse',
 'en vente', 15, NULL, '2025-11-25', 5.50),

('MLH-003', '55 rue de Bâle, 68200 Mulhouse',             'Mulhouse','Maison',       155, 480,  5, 3, 450000, 2010,'B','C','Pompe à chaleur',
 'Belle villa contemporaine. Double séjour 55m², cuisine ouverte îlot central, 5 chambres, 2 salles de bain + SDE. Piscine chauffée 8×4m, carport 2 places.',
 'https://maps.google.com/?q=55+rue+de+Bale+68200+Mulhouse',
 'en vente', 14, NULL, '2025-10-05', 5.00),

('MLH-004', '12 place de la République, 68100 Mulhouse',  'Mulhouse','Appartement',   65,NULL,  2, 1, 175000, 1998,'C','D','Collectif gaz',
 'T3 rénové, vue sur la place. Séjour avec parquet, 2 chambres, salle de bain refaite. Gardien, ascenseur. Cave et parking en option (15 000€).',
 'https://maps.google.com/?q=12+place+de+la+Republique+68100+Mulhouse',
 'en vente', 15, NULL, '2026-01-08', 5.50),

('MLH-005', '89 route de Colmar, 68100 Mulhouse',         'Mulhouse','Maison',       120, 400,  4, 2, 310000, 1995,'C','D','Gaz',
 'Maison individuelle classique très bien entretenue. Cuisine semi-ouverte, living 35m², 4 chambres dont 1 en rez-de-jardin. Garage, atelier, potager.',
 'https://maps.google.com/?q=89+route+de+Colmar+68100+Mulhouse',
 'en vente', 14, NULL, '2025-12-20', 5.50),

('MLH-006', '3 quai de l''Ill, 68100 Mulhouse',           'Mulhouse','Appartement',   78,NULL,  2, 1, 210000, 2008,'B','C','Collectif gaz',
 'T3 vue canal, immeuble récent. Séjour 25m² avec loggia, 2 chambres, double vasque. Digicode, visiophone, ascenseur. Parking inclus, cave.',
 'https://maps.google.com/?q=3+quai+de+l+Ill+68100+Mulhouse',
 'en vente', 16, NULL, '2025-11-01', 5.00),

('MLH-007', '47 avenue des Trois Rois, 68200 Mulhouse',   'Mulhouse','Appartement',   52,NULL,  1, 1, 148000, 2015,'A','B','Électrique',
 'T2 BBC idéal investisseur (rendement 5,1%). Résidence récente, balcon, parking. Actuellement loué 620€/mois. Bail en cours jusqu''en juin 2026.',
 'https://maps.google.com/?q=47+avenue+des+Trois+Rois+68200+Mulhouse',
 'en vente', 16, NULL, '2025-09-15', 5.00),

('MLH-008', '18 impasse des Lilas, 68200 Mulhouse',       'Mulhouse','Maison',       200, 800,  6, 3, 580000, 2018,'A','A','Géothermie',
 'Propriété d''exception en impasse privée. Architecture bioclimatique, matériaux nobles. 6 chambres dont 2 suites, home cinema, cave à vins. Paysagiste professionnel.',
 'https://maps.google.com/?q=18+impasse+des+Lilas+68200+Mulhouse',
 'en vente', 14, NULL, '2025-08-30', 4.50),

('MLH-009', 'Avenue de Colmar, 68100 Mulhouse',           'Mulhouse','Terrain',     NULL, 600,  0, 0,  78000, NULL, NULL,NULL,NULL,
 'Terrain viabilisé zone UB. Idéal construction individuelle R+1. Mitoyenneté possible. Étude de sol disponible.',
 'https://maps.google.com/?q=Avenue+de+Colmar+68100+Mulhouse',
 'en vente', 15, NULL, '2025-10-25', 5.00),

('MLH-010', '65 rue du Sauvage, 68100 Mulhouse',          'Mulhouse','Appartement',   88,NULL,  3, 1, 238000, 2005,'C','C','Collectif gaz',
 'Grand T4 au 4ème étage avec ascenseur. Lumineux, double orientation E/O. 3 chambres dont 1 master suite. Cave, box fermé 2 voitures.',
 'https://maps.google.com/?q=65+rue+du+Sauvage+68100+Mulhouse',
 'en vente', 16, NULL, '2025-12-08', 5.00),

-- ─── STRASBOURG (STR-001 à STR-010) ──────────────────────────────────────
('STR-001', '14 rue des Acacias, 67000 Strasbourg',       'Strasbourg','Maison',      135, 400,  5, 2, 495000, 2003,'B','C','Gaz',
 'Maison de standing secteur prisé. Séjour cathédrale 45m², cuisine ilôt équipée Siemens. 5 chambres, 2 salles de bain. Garage 2 voitures, terrasse bois.',
 'https://maps.google.com/?q=14+rue+des+Acacias+67000+Strasbourg',
 'en vente', 17, NULL, '2025-11-05', 5.00),

('STR-002', '26 quai des Bateliers, 67000 Strasbourg',    'Strasbourg','Appartement',  95,NULL,  3, 1, 385000, 1880,'D','E','Collectif vapeur',
 'Appartement haussmannien Grand Ile UNESCO. Plafonds 3,20m, moulures, parquet point de Hongrie, cheminées de marbre. 3 chambres, vue Ill.',
 'https://maps.google.com/?q=26+quai+des+Bateliers+67000+Strasbourg',
 'en vente', 18, NULL, '2025-09-10', 5.00),

('STR-003', '7 allée des Cerisiers, 67200 Strasbourg',    'Strasbourg','Maison',      175, 700,  6, 3, 650000, 2015,'A','A','Pompe à chaleur',
 'Villa contemporaine d''architecte. Smart home complet, volets motorisés, alarme connectée. 6 chambres, home office, SPA privatif.',
 'https://maps.google.com/?q=7+allee+des+Cerisiers+67200+Strasbourg',
 'en vente', 17, NULL, '2025-07-20', 4.00),

('STR-004', '38 rue du Faubourg National, 67000 Strasbourg','Strasbourg','Appartement', 60,NULL, 2, 1, 220000, 2010,'B','B','Collectif gaz',
 'T3 moderne en hypercentre. Résidence BBC 2010, faibles charges. Séjour traversant, cuisine ouverte, 2 chambres. Cave et parking.',
 'https://maps.google.com/?q=38+rue+du+Faubourg+National+67000+Strasbourg',
 'en vente', 18, NULL, '2026-01-25', 5.50),

('STR-005', '5 place Broglie, 67000 Strasbourg',          'Strasbourg','Appartement',  45,NULL,  1, 1, 195000, 1950,'E','F','Collectif vapeur',
 'T2 Centre historique classé UNESCO. Charme de l''ancien (poutres, tomettes). Idéal investissement Airbnb ou résidence pied-à-terre.',
 'https://maps.google.com/?q=5+place+Broglie+67000+Strasbourg',
 'en vente', 17, NULL, '2025-10-18', 5.00),

('STR-006', '82 route de la Wantzenau, 67000 Strasbourg', 'Strasbourg','Maison',      160, 600,  5, 2, 520000, 1992,'C','C','Gaz',
 'Grande maison résidentielle prisée. Salon double 50m² avec cheminée, 5 chambres, bureau. Sous-sol aménagé (salle de jeux, cave). Piscine hors-sol.',
 'https://maps.google.com/?q=82+route+de+la+Wantzenau+67000+Strasbourg',
 'en vente', 18, NULL, '2025-12-12', 5.00),

('STR-007', '19 avenue des Vosges, 67000 Strasbourg',     'Strasbourg','Appartement', 120,NULL,  4, 2, 480000, 2001,'B','C','Collectif gaz',
 'Grand T5 avenue des Vosges. Parquet massif, double séjour 45m², 4 chambres, suite parentale avec dressing. 2 boxes fermés, 2 caves. Résidence gardée.',
 'https://maps.google.com/?q=19+avenue+des+Vosges+67000+Strasbourg',
 'en vente', 19, NULL, '2025-11-28', 4.50),

('STR-008', '33 rue des Roses, 67100 Strasbourg',         'Strasbourg','Maison',       95, 250,  3, 1, 360000, 1985,'D','D','Fioul',
 'Maison individuelle quartier Neudorf. Entrée, séjour 28m², cuisine indépendante. 3 chambres, grenier aménageable 40m². Garage, jardin 250m².',
 'https://maps.google.com/?q=33+rue+des+Roses+67100+Strasbourg',
 'en vente', 18, NULL, '2025-10-01', 5.50),

('STR-009', 'Rue de la Paix, 67000 Strasbourg',           'Strasbourg','Terrain',     NULL, 450,  0, 0, 120000, NULL, NULL,NULL,NULL,
 'Terrain constructible secteur Cronenbourg. Viabilisé all-réseaux. Surface 450m², forme régulière. Zone UBa, constructibilité R+2.',
 'https://maps.google.com/?q=Rue+de+la+Paix+67000+Strasbourg',
 'en vente', 19, NULL, '2025-09-05', 5.00),

('STR-010', '4 impasse des Tilleuls, 67540 Ostwald',      'Strasbourg','Maison',      210,1200,  7, 4, 780000, 2020,'A','A','Géothermie',
 'Propriété d''exception récente. Entrée monumentale, salon 70m² avec verrière, cuisine de chef équipée. 7 chambres en suite. Piscine olympique, court de tennis privé.',
 'https://maps.google.com/?q=4+impasse+des+Tilleuls+67540+Ostwald',
 'en vente', 17, NULL, '2025-06-15', 4.00);

-- ============================================================
-- 5. MANDATS DE VENTE (20)
-- ============================================================

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='FERRARI'  LIMIT 1),                      (SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), '2026-01-15','2027-01-15', 6.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='CHAKIR' AND prenom='Ahmed' LIMIT 1),     (SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), '2025-12-01','2026-12-01', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='COL-003' LIMIT 1), '2025-09-20','2026-09-20', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SCHMIDT' LIMIT 1),                       (SELECT id FROM biens WHERE reference='COL-004' LIMIT 1), '2026-01-20','2027-01-20', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='COL-005' LIMIT 1), '2026-02-05','2027-02-05', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='COL-006' LIMIT 1), '2025-10-10','2026-10-10', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='COL-007' LIMIT 1), '2025-11-15','2026-11-15', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='MULLER' LIMIT 1),                        (SELECT id FROM biens WHERE reference='COL-008' LIMIT 1), '2025-12-15','2026-12-15', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='COL-009' LIMIT 1), '2025-08-01','2026-02-01', 5.00,'expiré');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='MLH-001' LIMIT 1), '2026-01-10','2027-01-10', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='LEKA' LIMIT 1),                          (SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), '2025-10-05','2026-10-05', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='MLH-004' LIMIT 1), '2026-01-08','2027-01-08', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SILVA' AND prenom='João & Maria' LIMIT 1),(SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), '2025-12-20','2026-12-20', 5.50,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='MLH-006' LIMIT 1), '2025-11-01','2026-11-01', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='MLH-007' LIMIT 1), '2025-09-15','2026-09-15', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='HOXHA' AND prenom='Erion & Anjeza' LIMIT 1),(SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), '2025-11-05','2026-11-05', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='STR-002' LIMIT 1), '2025-09-10','2026-09-10', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='STR-003' LIMIT 1), '2025-07-20','2026-07-20', 4.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SHEHU' AND prenom='Lorik & Flutura' LIMIT 1),(SELECT id FROM biens WHERE reference='STR-006' LIMIT 1), '2025-12-12','2026-12-12', 5.00,'actif');
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL,                                                                        (SELECT id FROM biens WHERE reference='STR-010' LIMIT 1), '2025-06-15','2026-06-15', 4.00,'actif');

-- ============================================================
-- 6. PROSPECTS (15)
-- ============================================================

INSERT INTO prospects (nom, prenom, telephone, source, interet, statut_prospect, ville, budget)
VALUES
('KRASNIQI',  'Elton',            '0634567801', 'site web',         'Recherche T3 min, Colmar, parking indispensable.',                                           'tiède',  'Colmar',      270000),
('SILVA',     'Tiago',            '0634567802', 'téléphone entrant','Maison 4 pièces Mulhouse, jardin, budget max 310k€. Très motivé, pré-accord bancaire.',     'chaud',  'Mulhouse',    310000),
('ALAMI',     'Zineb',            '0634567803', 'SeLoger',          'Appartement T2/T3 centre Colmar. Peu disponible, à relancer dans 1 mois.',                   'froid',  'Colmar',      190000),
('HOXHA',     'Ilir & Mimoza',    '0634567804', 'portail leboncoin','Villa haut standing Strasbourg, 5+ pièces, jardin. Acheteurs sérieux, visite sous 2 sem.',  'chaud',  'Strasbourg',  520000),
('ROSSI',     'Francesco',        '0634567805', 'recommandation',   'Investisseur, cherche appartement à rénover Strasbourg, rendement > 5%.',                   'tiède',  'Strasbourg',  250000),
('FERREIRA',  'Goncalo & Rita',   '0634567806', 'site web',         'Première maison, Mulhouse ou périphérie, max 280k€. Enfant prévu, écoles importantes.',     'chaud',  'Mulhouse',    280000),
('BENALI',    'Omar',             '0634567807', 'réseau',           'Appartement investissement locatif Colmar centre. Contacté par SANTOS Carlos.',              'tiède',  'Colmar',      175000),
('SCHMIDT',   'Céline',           '0634567808', 'SeLoger',          'Studio ou T2, Strasbourg hypercentre. Budget serré, financement à confirmer.',               'froid',  'Strasbourg',  155000),
('BERBERI',   'Arben & Flutura',  '0634567809', 'téléphone entrant','Grande maison 6+ pièces, secteur Strasbourg Nord. Très intéressés par STR-006.',            'chaud',  'Strasbourg',  530000),
('OLIVEIRA',  'Cristiana',        '0634567810', 'Facebook',         'T3/T4 Colmar, max 230k€. Employée CHR Colmar, proche hôpital souhaité.',                    'tiède',  'Colmar',      230000),
('THOMAS',    'Éric & Caroline',  '0634567811', 'portail immo',     'Maison plain-pied, Mulhouse agglo, PMR obligatoire. Budget 250-300k.',                       'tiède',  'Mulhouse',    295000),
('IDRISSI',   'Nadia',            '0634567812', 'recommandation',   'Appartement T2 neuf ou récent Strasbourg, DPE A ou B. Primo-accédant.',                     'froid',  'Strasbourg',  200000),
('MULLER',    'Klaus & Ingrid',   '0634567813', 'vitrine agence',   'Propriété de prestige Colmar ou vignoble, budget 600-800k€. Patrimoine familial.',           'chaud',  'Colmar',      750000),
('GRECO',     'Valentino',        '0634567814', 'site web',         'Studio ou T2 investissement, toutes villes, rendement > 4,5%. Professionnel libéral.',      'tiède',  'Mulhouse',    160000),
('COSTA',     'Ana Beatriz',      '0634567815', 'SeLoger',          'T3 avec balcon ou terrasse, Mulhouse quartier calme, proche transport. Locataire actuelle.', 'froid',  'Mulhouse',    210000);

-- ============================================================
-- 7. VISITES (8)
-- ============================================================

INSERT INTO visites (bien_id, client_nom, date_visite, heure, agent_nom, statut, feedback)
VALUES
((SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), 'FERRARI Giovanni & Laura', '2025-11-18','10:00','FERREIRA Pedro', 'réalisée', 'Coup de cœur. Souhaite une 2ème visite avec l''architecte pour évaluer extension possible.'),
((SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), 'KRASNIQI Leonit & Liris',  '2025-12-05','14:30','FERREIRA Pedro', 'réalisée', 'Intéressés mais veulent renégocier le prix. Offre envisagée à 255 000€.'),
((SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), 'LEKA Besnik & Drita',      '2026-03-05','14:00','SHEHU Gentian',  'réalisée', '2ème visite. Très intéressés, demande de simulation crédit en cours.'),
((SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), 'SILVA João & Maria',       '2025-12-15','11:00','SHEHU Gentian',  'réalisée', 'Coup de foudre pour le jardin et l''atelier. Offre d''achat déposée le lendemain.'),
((SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), 'HOXHA Erion & Anjeza',     '2025-12-02','09:30','THOMAS David',   'réalisée', 'Bien correspond aux attentes. Budget légèrement en-dessous du prix affiché.'),
((SELECT id FROM biens WHERE reference='STR-002' LIMIT 1), 'SHEHU Lorik & Flutura',    '2026-01-10','10:00','FASSI Amina',    'réalisée', 'Charmés par le caractère haussmannien. Inquiets sur les charges de copropriété.'),
((SELECT id FROM biens WHERE reference='COL-004' LIMIT 1), 'RODRIGUES Ana',             '2026-01-22','14:00','KLEIN Léa',      'planifiée',NULL),
((SELECT id FROM biens WHERE reference='MLH-008' LIMIT 1), 'BENALI Youssef',            '2026-03-08','11:00','SHEHU Gentian',  'planifiée',NULL);

-- ============================================================
-- 8. OFFRES D'ACHAT (5)
-- ============================================================

INSERT INTO offres (bien_id, acheteur_nom, vendeur_nom, montant_offre, date_offre, statut)
VALUES
((SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), 'KRASNIQI Leonit & Liris', 'Propriétaire COL-002', 255000, '2025-12-20', 'en cours'),
((SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), 'SILVA João & Maria',       'Propriétaire MLH-005', 295000, '2025-12-16', 'acceptée'),
((SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), 'HOXHA Erion & Anjeza',     'Propriétaire STR-001', 475000, '2026-01-08', 'contre-offre'),
((SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), 'FERRARI Giovanni & Laura', 'Propriétaire COL-001', 370000, '2026-01-25', 'en cours'),
((SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), 'LEKA Besnik & Drita',      'Propriétaire MLH-003', 430000, '2026-03-07', 'en cours');

-- ============================================================
-- 9. VENTES CONCLUES (3)
-- ============================================================

INSERT INTO ventes (bien_id, acheteur_nom, vendeur_nom, prix_vente, date_compromis, date_acte, notaire, commission_agence, statut)
VALUES
((SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1),
 'SILVA João & Maria', 'Propriétaire MLH-005', 295000, '2026-01-15', '2026-04-15',
 'Me DURAND — Office notarial Mulhouse', 16225.00, 'en cours'),

((SELECT id FROM biens WHERE reference='COL-007' LIMIT 1),
 'SANTOS Carlos', 'Propriétaire COL-007', 120000, '2026-02-01', '2026-05-01',
 'Me GRUBER — Notaires Associés Colmar', 6000.00, 'en cours'),

((SELECT id FROM biens WHERE reference='STR-005' LIMIT 1),
 'ROSSI Valentina', 'Propriétaire STR-005', 188000, '2026-01-20', '2026-04-20',
 'Me KLEIN — Notaire Strasbourg', 9400.00, 'en cours');

-- ============================================================
-- 10. FACTURES FOURNISSEURS (10 dont 2 avec anomalies)
-- ============================================================

INSERT INTO factures_fournisseurs (numero_facture, fournisseur, montant_ht, tva, montant_ttc, date_facture, date_echeance, statut, anomalie)
VALUES
('F-2026-001', 'PRINTEX COMMUNICATION',      500.00,  20.00,  600.00, '2026-01-15','2026-02-15','litigieuse','Adresse de facturation absente — à régulariser avant tout paiement'),
('F-2026-002', 'EDF ENTREPRISES — Colmar', 1000.00,  20.00, 1200.00, '2026-01-20','2026-02-20','validée',   NULL),
('F-2026-003', 'ORANGE BUSINESS',           450.00,  20.00,  540.00, '2026-01-25','2026-02-25','validée',   NULL),
('F-2026-004', 'SELOGER ANNONCES',          800.00,  20.00,  960.00, '2026-02-01','2026-03-01','reçue',     NULL),
('F-2026-005', 'RAPIDO NETTOYAGE',          350.00,  15.00,  402.50, '2026-02-05','2026-03-05','litigieuse','TVA calculée à 15% au lieu de 20% — montant TTC incorrect, écart de 17,50€'),
('F-2026-006', 'AGENCE PUBLICITAIRE LBA', 2400.00,  20.00, 2880.00, '2026-02-10','2026-03-10','reçue',     NULL),
('F-2026-007', 'ASSUR IMMO PLUS',         5400.00,  20.00, 6480.00, '2026-02-15','2026-03-15','reçue',     NULL),
('F-2026-008', 'FORMATIONS IMMO CONSEIL', 1800.00,  20.00, 2160.00, '2026-02-20','2026-03-20','validée',   NULL),
('F-2026-009', 'EXPERT COMPTABLE HUBER',  1200.00,  20.00, 1440.00, '2026-03-01','2026-04-01','reçue',     NULL),
('F-2026-010', 'LOGICIELS CRM APIMO',     4800.00,  20.00, 5760.00, '2026-03-01','2026-04-01','reçue',     NULL);

-- ============================================================
-- 11. FORMATIONS DDA (9 commerciaux + formations diverses)
-- ============================================================

INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation, statut)
VALUES
('Fatima BENALI',   'Réglementation DDA et distribution immobilière 2025',          'IFOCOP',           '2025-11-20', 15.0, 'DDA',         'validée'),
('Pedro FERREIRA',  'Réglementation DDA et pratique de la transaction',              'FNAIM Formation',  '2025-11-20', 15.0, 'DDA',         'validée'),
('Léa KLEIN',       'DDA : obligations, déontologie et pratique',                    'AUREP',            '2026-02-05', 15.0, 'DDA',         'validée'),
('Gentian SHEHU',   'Lutte anti-blanchiment, conformité et DDA 2025',               'IFOCOP',           '2025-10-15', 15.0, 'DDA',         'validée'),
('Sofia COSTA',     'Formation DDA + négociation commerciale avancée',               'FNAIM Formation',  '2025-11-20', 15.0, 'DDA',         'validée'),
('Lucas WEBER',     'DDA : réglementation immobilière et assurances',                'AF2I',             '2026-01-22', 15.0, 'DDA',         'validée'),
('David THOMAS',    'DDA Management agence + conformité réglementaire',              'IFOCOP',           '2025-10-08', 15.0, 'DDA',         'validée'),
('Amina FASSI',     'DDA et pratique du conseil patrimonial',                        'AUREP',            '2025-11-13', 15.0, 'DDA',         'validée'),
('Hugo OLIVEIRA',   'DDA Gestion de patrimoine + placements financiers',             'AF2I',             '2025-09-25', 15.0, 'DDA',         'validée'),
('Pedro FERREIRA',  'Négociation avancée en immobilier résidentiel',                 'CEGOS',            '2025-03-10', 14.0, 'facultatif',  'validée'),
('Sofia COSTA',     'Photographie immobilière et home staging',                      'FNAIM Formation',  '2025-05-22',  7.0, 'facultatif',  'validée'),
('Hugo OLIVEIRA',   'Fiscalité du patrimoine 2025 : IFI, plus-values, assurance-vie','AUREP',            '2026-01-30',  7.0, 'obligatoire', 'validée'),
('Maria SILVA',     'Management RH et droit du travail 2025',                        'CEGOS',            '2025-06-12', 14.0, 'obligatoire', 'validée'),
('Arben HOXHA',     'Comptabilité immobilière et normes IFRS',                       'INTEC',            '2025-09-18', 21.0, 'obligatoire', 'validée');

-- ============================================================
-- 12. CONGÉS (20 — un par salarié)
-- ============================================================

INSERT INTO conges (salarie_nom, type, date_debut, date_fin, jours, statut)
VALUES
('Christophe DIRINGER', 'CP',      '2026-07-14','2026-08-01', 14, 'approuvé'),
('Elena ROSSI',          'CP',      '2026-08-03','2026-08-21', 14, 'en attente'),
('Maria SILVA',          'CP',      '2026-07-06','2026-07-18',  9, 'approuvé'),
('Laura MEYER',          'CP',      '2026-08-10','2026-08-21',  8, 'en attente'),
('Youssef ALAMI',        'RTT',     '2026-06-02','2026-06-06',  5, 'approuvé'),
('Julie BERNARD',        'CP',      '2026-07-06','2026-07-18',  9, 'approuvé'),
('Arben HOXHA',          'CP',      '2026-08-17','2026-08-28',  8, 'en attente'),
('Carla SANTOS',         'maladie', '2026-02-10','2026-02-14',  5, 'approuvé'),
('Claire MARTIN',        'CP',      '2026-07-20','2026-08-07', 13, 'approuvé'),
('Marco GRECO',          'RTT',     '2026-05-30','2026-06-03',  5, 'approuvé'),
('Fatima BENALI',        'CP',      '2026-08-03','2026-08-14',  8, 'approuvé'),
('Pedro FERREIRA',       'CP',      '2026-07-27','2026-08-07',  8, 'en attente'),
('Léa KLEIN',            'CP',      '2026-08-24','2026-09-04',  8, 'en attente'),
('Gentian SHEHU',        'CP',      '2026-07-20','2026-08-07', 13, 'approuvé'),
('Sofia COSTA',          'CP',      '2026-08-10','2026-08-21',  8, 'en attente'),
('Lucas WEBER',          'CP',      '2026-08-17','2026-08-21',  5, 'en attente'),
('David THOMAS',         'CP',      '2026-07-06','2026-07-24', 13, 'approuvé'),
('Amina FASSI',          'RTT',     '2026-06-15','2026-06-19',  5, 'approuvé'),
('Hugo OLIVEIRA',        'CP',      '2026-08-10','2026-08-28', 14, 'en attente'),
('Valentina ROMANO',     'CP',      '2026-08-03','2026-08-14',  8, 'en attente');

-- ============================================================
-- 13. CARTES PROFESSIONNELLES (9 commerciaux)
-- ============================================================

INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES
('Fatima BENALI',   'CCI-68-2024-1234', '2027-03-01', 'CCI Alsace (Mulhouse)',    'valide'),
('Pedro FERREIRA',  'CCI-68-2023-5678', '2026-09-15', 'CCI Alsace (Mulhouse)',    'valide'),
('Léa KLEIN',       'CCI-68-2025-9012', '2028-01-09', 'CCI Alsace (Mulhouse)',    'valide'),
('Gentian SHEHU',   'CCI-68-2022-3456', '2025-02-17', 'CCI Alsace (Mulhouse)',    'expiré'),
('Sofia COSTA',     'CCI-68-2024-7890', '2027-03-01', 'CCI Alsace (Mulhouse)',    'valide'),
('Lucas WEBER',     'CCI-68-2025-2345', '2028-06-20', 'CCI Alsace (Mulhouse)',    'valide'),
('David THOMAS',    'CCI-67-2023-6789', '2026-07-04', 'CCI Bas-Rhin (Strasbourg)','valide'),
('Amina FASSI',     'CCI-67-2024-0123', '2027-09-01', 'CCI Bas-Rhin (Strasbourg)','valide'),
('Hugo OLIVEIRA',   'CCI-67-2022-4567', '2025-11-01', 'CCI Bas-Rhin (Strasbourg)','en renouvellement');

-- ============================================================
-- 14. ASSURANCES RC PROFESSIONNELLES (9 — une par agent commercial)
-- Structure alignée sur cartes_professionnelles : salarie_nom + statut
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
-- 15. TICKETS IT (3 tickets réalistes)
-- ============================================================

INSERT INTO tickets_support (demandeur_nom, titre, description, priorite, statut, agent_it)
VALUES
('Pedro FERREIRA',  'Accès CRM APIMO impossible',
 'Depuis la mise à jour du navigateur, l''accès au CRM renvoie une erreur SSL. Empêche toute saisie client.',
 'haute',   'résolu',   'Marco GRECO'),
('Léa KLEIN',       'Imprimante A3 Agence Colmar hors service',
 'Imprimante HP LaserJet 400 MFP affiche "Bourrage papier" en continu. Pas de bourrage visible. Affecte l''impression des plans.',
 'normale', 'en cours', 'Marco GRECO'),
('Claire MARTIN',   'Accès Canva Pro pour l''équipe marketing',
 'Besoin d''un compte Canva Pro (3 licences) pour la création des visuels campagnes LinkedIn et print.',
 'basse',   'ouvert',   NULL);

-- ============================================================
-- 16. MATÉRIEL INFORMATIQUE (5 équipements)
-- ============================================================

INSERT INTO materiel_informatique (designation, marque, numero_serie, utilisateur_nom, date_achat, garantie_fin, statut)
VALUES
('Laptop 15" Pro',         'Dell',    'DL-XPS15-2023-44721', 'Hugo OLIVEIRA',  '2023-02-15','2026-02-15','opérationnel'),
('Laptop 14" Pro',         'Lenovo',  'LNV-T14-2022-33981',  'Amina FASSI',    '2022-09-01','2025-09-01','opérationnel'),
('Imprimante Laser A4/A3', 'HP',      'HP-LASERJET-21-83654','Agence Colmar',  '2021-06-01','2024-06-01','panne'),
('Tablette iPad 12.9"',    'Apple',   'APL-IPAD-2022-99001', 'Pedro FERREIRA', '2022-09-01','2024-09-01','opérationnel'),
('Serveur NAS 4 baies',    'Synology','SYN-NAS-2020-11230',  'Siège Mulhouse', '2020-03-01','2023-03-01','opérationnel');

-- ============================================================
-- 17. LICENCES LOGICIELS (4 licences)
-- ============================================================

INSERT INTO licences_logiciels (logiciel, editeur, nombre_postes, date_expiration, cout_annuel, statut)
VALUES
('Microsoft 365 Business Standard', 'Microsoft',  20, '2026-01-31', 3600.00, 'active'),
('CRM APIMO Immobilier',            'APIMO',       8, '2026-06-30', 4800.00, 'active'),
('Adobe Creative Cloud',            'Adobe',       3, '2026-03-31',  840.00, 'renouvellement'),
('Docusign eSignature',             'Docusign',   10, '2025-12-31', 1200.00, 'expiree');

-- ============================================================
-- 18. CAMPAGNES MARKETING (3)
-- ============================================================

INSERT INTO campagnes_marketing (nom, canal, budget, date_debut, date_fin, statut, objectif)
VALUES
('Printemps Immobilier 2026',   'print',          9500.00, '2026-03-01','2026-05-31','en préparation',
 'Générer 60 nouveaux mandats exclusifs, print Alsace + publicité JDD régional'),
('LinkedIn Patrimoine Q1 2026', 'réseaux sociaux',3500.00, '2026-01-02','2026-03-31','active',
 'Attirer 20 clients patrimoniaux ≥ 500k€ via LinkedIn Ads ciblage cadres 40-60 ans'),
('Portes Ouvertes Colmar mars', 'événement',      4800.00, '2026-03-14','2026-03-15','en préparation',
 'Présenter 10 biens exclusifs, objectif : 25 visites programmées en 2 jours');

-- ============================================================
-- FIN DU FICHIER SEED_REALISTIC_DATA.SQL
-- Ordre d''exécution recommandé dans Supabase :
--   1. erp_tables.sql
--   2. erp_updates.sql
--   3. services_tables.sql
--   4. seed_realistic_data.sql
-- ============================================================

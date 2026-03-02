-- ============================================================
-- DONNÉES RÉALISTES — LA BELLE AGENCE
-- Diversité : Alsacien · Français · Italien · Portugais · Marocain · Albanais
-- 20 salariés | 30 clients | 30 biens | 20 mandats | 15 prospects
-- 9 formations DDA | 20 congés | 9 cartes pro | 3 RC Pro | 10 factures
-- ============================================================

-- ============================================================
-- 0. EXTENSION DU SCHÉMA (colonnes supplémentaires)
-- ============================================================

ALTER TABLE salaries
  ADD COLUMN IF NOT EXISTS email          VARCHAR(255),
  ADD COLUMN IF NOT EXISTS telephone      VARCHAR(20),
  ADD COLUMN IF NOT EXISTS adresse        TEXT,
  ADD COLUMN IF NOT EXISTS agence         VARCHAR(100),
  ADD COLUMN IF NOT EXISTS salaire_brut   NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS type_contrat   VARCHAR(50) DEFAULT 'CDI',
  ADD COLUMN IF NOT EXISTS origine        VARCHAR(100);

ALTER TABLE clients
  ADD COLUMN IF NOT EXISTS adresse              TEXT,
  ADD COLUMN IF NOT EXISTS age                  INTEGER,
  ADD COLUMN IF NOT EXISTS statut_client        VARCHAR(50) DEFAULT 'actif',
  ADD COLUMN IF NOT EXISTS agent_referent       VARCHAR(200),
  ADD COLUMN IF NOT EXISTS date_premier_contact DATE,
  ADD COLUMN IF NOT EXISTS profession           VARCHAR(200),
  ADD COLUMN IF NOT EXISTS situation_familiale  VARCHAR(100);

ALTER TABLE biens
  ADD COLUMN IF NOT EXISTS reference          VARCHAR(20),
  ADD COLUMN IF NOT EXISTS ville              VARCHAR(100),
  ADD COLUMN IF NOT EXISTS surface_terrain    NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS nb_chambres        INTEGER,
  ADD COLUMN IF NOT EXISTS nb_sdb             INTEGER,
  ADD COLUMN IF NOT EXISTS annee_construction INTEGER,
  ADD COLUMN IF NOT EXISTS dpe                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS ges                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS chauffage          VARCHAR(100),
  ADD COLUMN IF NOT EXISTS lien_maps          TEXT,
  ADD COLUMN IF NOT EXISTS statut_bien        VARCHAR(50) DEFAULT 'en vente',
  ADD COLUMN IF NOT EXISTS agent_referent     VARCHAR(200),
  ADD COLUMN IF NOT EXISTS date_mise_vente    DATE,
  ADD COLUMN IF NOT EXISTS commission_taux    NUMERIC(4,2) DEFAULT 5.00;

ALTER TABLE prospects
  ADD COLUMN IF NOT EXISTS telephone        VARCHAR(20),
  ADD COLUMN IF NOT EXISTS statut_prospect  VARCHAR(50) DEFAULT 'tiède',
  ADD COLUMN IF NOT EXISTS ville            VARCHAR(100),
  ADD COLUMN IF NOT EXISTS budget           NUMERIC(12,2);

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
-- ============================================================

INSERT INTO salaries
  (nom, prenom, poste, service, date_embauche,
   email, telephone, adresse, agence, salaire_brut, type_contrat, origine)
VALUES
-- ─── SIÈGE MULHOUSE — Direction ───────────────────────────────────────────
('DIRINGER',  'Christophe', 'Directeur Général',          'Direction',  '2010-01-15',
 'diringer.c@labelleagence.fr',  '0612345601', '15 rue du Sapin, 68100 Mulhouse',
 'Siège', 6000.00, 'CDI', 'Alsacien'),

('ROSSI',     'Elena',      'Directrice Adjointe',         'Direction',  '2012-03-01',
 'rossi.e@labelleagence.fr',     '0612345602', '8 avenue de Colmar, 68200 Mulhouse',
 'Siège', 5000.00, 'CDI', 'Italienne'),

-- ─── RH ───────────────────────────────────────────────────────────────────
('SILVA',     'Maria',      'Responsable RH',              'RH',         '2014-06-01',
 'silva.m@labelleagence.fr',     '0612345603', '22 rue des Tilleuls, 68200 Mulhouse',
 'Siège', 3800.00, 'CDI', 'Portugaise'),

('MEYER',     'Laura',      'Assistante RH',               'RH',         '2022-09-05',
 'meyer.l@labelleagence.fr',     '0612345604', '5 allée des Roses, 68100 Mulhouse',
 'Siège', 2300.00, 'CDI', 'Alsacienne'),

-- ─── Conformité & Juridique ───────────────────────────────────────────────
('ALAMI',     'Youssef',    'Compliance Officer',          'Conformité', '2017-01-03',
 'alami.y@labelleagence.fr',     '0612345605', '14 rue de Bâle, 68200 Mulhouse',
 'Siège', 3600.00, 'CDI', 'Marocain'),

('BERNARD',   'Julie',      'Assistante Conformité',       'Conformité', '2023-02-01',
 'bernard.j@labelleagence.fr',   '0612345606', '3 impasse des Lilas, 68100 Mulhouse',
 'Siège', 2100.00, 'CDI', 'Française'),

-- ─── Finance & Comptabilité ───────────────────────────────────────────────
('HOXHA',     'Arben',      'Responsable Comptable',       'Finance',    '2015-09-01',
 'hoxha.a@labelleagence.fr',     '0612345607', '31 rue du Rhône, 68200 Mulhouse',
 'Siège', 4000.00, 'CDI', 'Albanais'),

('SANTOS',    'Carla',      'Comptable',                   'Finance',    '2019-04-01',
 'santos.c@labelleagence.fr',    '0612345608', '17 avenue du Président Wilson, 68100 Mulhouse',
 'Siège', 2800.00, 'CDI', 'Portugaise'),

-- ─── Marketing ────────────────────────────────────────────────────────────
('MARTIN',    'Claire',     'Responsable Marketing',       'Marketing',  '2016-03-15',
 'martin.c@labelleagence.fr',    '0612345609', '9 rue des Fleurs, 68200 Mulhouse',
 'Siège', 3500.00, 'CDI', 'Française'),

-- ─── IT ───────────────────────────────────────────────────────────────────
('GRECO',     'Marco',      'Technicien IT',               'IT',         '2020-11-02',
 'greco.m@labelleagence.fr',     '0612345610', '26 boulevard de l''Europe, 68100 Mulhouse',
 'Siège', 2600.00, 'CDI', 'Italien'),

-- ─── AGENCE COLMAR ────────────────────────────────────────────────────────
('BENALI',    'Fatima',     'Responsable Agence Colmar',   'Commercial', '2013-05-01',
 'benali.f@labelleagence.fr',    '0612345611', '7 rue du Ladhof, 68000 Colmar',
 'Agence Colmar', 4200.00, 'CDI', 'Marocaine'),

('FERREIRA',  'Pedro',      'Négociateur Immobilier',      'Commercial', '2020-09-15',
 'ferreira.p@labelleagence.fr',  '0612345612', '19 allée des Marronniers, 68000 Colmar',
 'Agence Colmar', 2400.00, 'CDI', 'Portugais'),

('KLEIN',     'Léa',        'Assistante Commerciale',      'Commercial', '2023-01-09',
 'klein.l@labelleagence.fr',     '0612345613', '4 rue des Cigognes, 68000 Colmar',
 'Agence Colmar', 2000.00, 'CDI', 'Alsacienne'),

-- ─── AGENCE MULHOUSE ──────────────────────────────────────────────────────
('SHEHU',     'Gentian',    'Responsable Agence Mulhouse', 'Commercial', '2014-02-17',
 'shehu.g@labelleagence.fr',     '0612345614', '43 avenue de la Marseillaise, 68100 Mulhouse',
 'Agence Mulhouse', 4200.00, 'CDI', 'Albanais'),

('COSTA',     'Sofia',      'Négociatrice Immobilière',    'Commercial', '2021-03-01',
 'costa.s@labelleagence.fr',     '0612345615', '12 rue Saint-Louis, 68200 Mulhouse',
 'Agence Mulhouse', 2400.00, 'CDI', 'Italienne'),

('WEBER',     'Lucas',      'Assistant Commercial',        'Commercial', '2022-06-20',
 'weber.l@labelleagence.fr',     '0612345616', '8 cité des Fleurs, 68100 Mulhouse',
 'Agence Mulhouse', 2000.00, 'CDI', 'Alsacien'),

-- ─── AGENCE STRASBOURG ────────────────────────────────────────────────────
('THOMAS',    'David',      'Responsable Agence Strasbourg','Commercial', '2016-07-04',
 'thomas.d@labelleagence.fr',    '0612345617', '55 avenue des Vosges, 67000 Strasbourg',
 'Agence Strasbourg', 4200.00, 'CDI', 'Français'),

('FASSI',     'Amina',      'Négociatrice Immobilière',    'Commercial', '2021-09-01',
 'fassi.a@labelleagence.fr',     '0612345618', '18 rue du Faubourg National, 67000 Strasbourg',
 'Agence Strasbourg', 2400.00, 'CDI', 'Marocaine'),

('OLIVEIRA',  'Hugo',       'Conseiller en Patrimoine',    'Commercial', '2019-11-01',
 'oliveira.h@labelleagence.fr',  '0612345619', '7 place de la Cathédrale, 67000 Strasbourg',
 'Agence Strasbourg', 3200.00, 'CDI', 'Portugais'),

-- ─── Siège — Marketing (20ème) ────────────────────────────────────────────
('ROMANO',    'Valentina',  'Community Manager',           'Marketing',  '2024-01-15',
 'romano.v@labelleagence.fr',    '0612345620', '11 rue des Acacias, 68200 Mulhouse',
 'Siège', 2200.00, 'CDI', 'Italienne');

-- ============================================================
-- 3. CLIENTS (30)
-- ============================================================

INSERT INTO clients
  (nom, prenom, budget, type_recherche, telephone, email,
   adresse, age, agent_referent, date_premier_contact, profession, situation_familiale, statut_client)
VALUES
-- ─── COLMAR (10 clients) ──────────────────────────────────────────────────
('FERRARI',    'Giovanni & Laura',  400000, 'achat', '0623456701', 'ferrari.giovanni@gmail.com',
 '25 rue des Vignes, 68000 Colmar',            45, 'FERREIRA Pedro',  '2025-11-15', 'Cadre supérieur / Enseignante',             'Marié, 2 enfants', 'actif'),

('CHAKIR',     'Ahmed',             250000, 'achat', '0623456702', 'a.chakir@yahoo.fr',
 '8 rue du Marché, 68000 Colmar',              62, 'BENALI Fatima',   '2025-10-20', 'Commerçant retraité',                       'Marié, 4 enfants', 'actif'),

('RODRIGUES',  'Ana',               180000, 'achat', '0623456703', 'ana.rodrigues@hotmail.com',
 '34 allée des Châtaigniers, 68000 Colmar',    33, 'FERREIRA Pedro',  '2025-12-01', 'Infirmière',                                'Célibataire',      'actif'),

('SCHMIDT',    'Jean-Pierre & Marie',320000,'achat', '0623456704', 'schmidt.jp@orange.fr',
 '16 rue des Cigognes, 68000 Colmar',          50, 'KLEIN Léa',       '2025-09-10', 'Artisan / Secrétaire médicale',             'Marié, 3 enfants', 'actif'),

('KRASNIQI',   'Leonit & Liris',    280000, 'achat', '0623456705', 'leonit.krasniqi@gmail.com',
 '22 avenue d''Alsace, 68000 Colmar',          40, 'FERREIRA Pedro',  '2025-11-28', 'Gérant d''entreprise / Comptable',          'Marié, 2 enfants', 'actif'),

('ROBERT',     'Sophie',            200000, 'achat', '0623456706', 'sophie.robert@sfr.fr',
 '5 rue de la Gare, 68000 Colmar',             38, 'BENALI Fatima',   '2026-01-05', 'Pharmacienne',                              'Divorcée, 1 enfant','actif'),

('IDRISSI',    'Karim & Leila',     350000, 'achat', '0623456707', 'k.idrissi@outlook.fr',
 '11 boulevard Charles de Gaulle, 68000 Colmar',35,'FERREIRA Pedro',  '2025-10-15', 'Ingénieur / Kinésithérapeute',              'Marié, 1 enfant',  'actif'),

('SANTOS',     'Carlos',            220000, 'investissement','0623456708','carlos.santos@gmail.com',
 '3 rue du Ladhof, 68000 Colmar',              47, 'BENALI Fatima',   '2025-12-10', 'Chef de projet IT',                         'Célibataire',      'actif'),

('GRECO',      'Elena',             150000, 'achat', '0623456709', 'elena.greco@yahoo.it',
 '28 rue de Turenne, 68000 Colmar',            29, 'KLEIN Léa',       '2026-01-20', 'Graphiste freelance',                       'En couple',        'actif'),

('MULLER',     'Thomas',            450000, 'achat', '0623456710', 't.muller@wanadoo.fr',
 '42 route de Rouffach, 68000 Colmar',         55, 'FERREIRA Pedro',  '2025-09-05', 'Directeur commercial',                      'Marié, 2 enfants', 'actif'),

-- ─── MULHOUSE (10 clients) ────────────────────────────────────────────────
('LEKA',       'Besnik & Drita',    350000, 'achat', '0623456711', 'besnik.leka@gmail.com',
 '14 rue des Marronniers, 68100 Mulhouse',     38, 'SHEHU Gentian',   '2025-11-03', 'Électricien indépendant / Aide-soignante',  'Marié, 3 enfants', 'actif'),

('ALAMI',      'Fatima',            200000, 'achat', '0623456712', 'f.alami@hotmail.fr',
 '7 avenue de Colmar, 68100 Mulhouse',         50, 'COSTA Sofia',     '2025-10-08', 'Éducatrice spécialisée',                    'Veuve, 2 enfants', 'actif'),

('SILVA',      'João & Maria',      300000, 'achat', '0623456713', 'joao.silva@gmail.com',
 '33 rue de Bâle, 68200 Mulhouse',             43, 'SHEHU Gentian',   '2025-09-22', 'Technicien maintenance / Agent de service', 'Marié, 2 enfants', 'actif'),

('ROMANO',     'Pietro',            180000, 'achat', '0623456714', 'pietro.romano@libero.it',
 '19 allée Steinlen, 68100 Mulhouse',          35, 'COSTA Sofia',     '2026-01-12', 'Cuisinier',                                 'Célibataire',      'actif'),

('BERBERI',    'Elira',             270000, 'achat', '0623456715', 'elira.berberi@outlook.com',
 '6 cité des Fleurs, 68200 Mulhouse',          41, 'WEBER Lucas',     '2025-12-15', 'Directrice de crèche',                      'Divorcée, 2 enfants','actif'),

('MARTIN',     'Lucas & Emma',      250000, 'achat', '0623456716', 'lucas.martin@free.fr',
 '45 rue Vauban, 68100 Mulhouse',              32, 'SHEHU Gentian',   '2026-01-07', 'Développeur web / Orthophoniste',           'Pacsé, sans enfant','actif'),

('BENALI',     'Youssef',           400000, 'achat', '0623456717', 'y.benali@gmail.com',
 '8 avenue de la Marseillaise, 68200 Mulhouse',48, 'COSTA Sofia',     '2025-08-20', 'Chef d''entreprise BTP',                    'Marié, 4 enfants', 'actif'),

('FERREIRA',   'Teresa',            190000, 'achat', '0623456718', 'teresa.ferreira@sapo.pt',
 '25 rue du Maréchal Joffre, 68100 Mulhouse',  37, 'WEBER Lucas',     '2025-12-20', 'Aide à domicile',                           'Célibataire, 1 enfant','actif'),

('KLEIN',      'Sophie & Marc',     380000, 'achat', '0623456719', 'sophie.klein@orange.fr',
 '17 chemin de la Forêt, 68200 Mulhouse',      44, 'SHEHU Gentian',   '2025-10-30', 'Médecin généraliste / Expert-comptable',    'Marié, 2 enfants', 'actif'),

('COSTA',      'Michele',           330000, 'achat', '0623456720', 'michele.costa@gmail.com',
 '9 rue du Raisin, 68100 Mulhouse',            52, 'COSTA Sofia',     '2025-11-18', 'Architecte',                                'Marié, 3 enfants', 'actif'),

-- ─── STRASBOURG / SAINT-LOUIS (10 clients) ───────────────────────────────
('HOXHA',      'Erion & Anjeza',    500000, 'achat', '0623456721', 'erion.hoxha@gmail.com',
 '62 avenue des Vosges, 67000 Strasbourg',     42, 'THOMAS David',    '2025-09-01', 'Directeur logistique / Responsable RH',     'Marié, 3 enfants', 'actif'),

('FASSI',      'Mohammed',          280000, 'achat', '0623456722', 'm.fassi@hotmail.fr',
 '14 rue du Faubourg National, 67000 Strasbourg',35,'FASSI Amina',    '2025-10-25', 'Technicien télécommunications',             'Marié, 2 enfants', 'actif'),

('OLIVEIRA',   'Ricardo & Ana',     320000, 'achat', '0623456723', 'ricardo.oliveira@gmail.com',
 '33 boulevard de la Marne, 67000 Strasbourg', 39, 'OLIVEIRA Hugo',   '2025-11-10', 'Ingénieur civil / Professeure',             'Marié, 2 enfants', 'actif'),

('ROSSI',      'Valentina',         210000, 'achat', '0623456724', 'vale.rossi@yahoo.it',
 '8 rue des Écrivains, 67000 Strasbourg',      31, 'THOMAS David',    '2026-01-15', 'Designer graphique',                        'En couple',        'actif'),

('SHEHU',      'Lorik & Flutura',   420000, 'achat', '0623456725', 'lorik.shehu@outlook.com',
 '27 route de la Wantzenau, 67000 Strasbourg', 46, 'FASSI Amina',     '2025-08-15', 'Restaurateur / Assistante dentaire',        'Marié, 3 enfants', 'actif'),

('BERNARD',    'Claire & Thomas',   290000, 'achat', '0623456726', 'claire.bernard@sfr.fr',
 '5 allée des Saules, 68300 Saint-Louis',      36, 'THOMAS David',    '2025-12-05', 'Juriste / Consultant',                      'Pacsé, 1 enfant',  'actif'),

('SANTOS',     'Joaquim',           350000, 'investissement','0623456727','joaquim.santos@gmail.com',
 '19 rue des Alpes, 67000 Strasbourg',         40, 'OLIVEIRA Hugo',   '2025-11-22', 'Investisseur immobilier',                   'Marié, 2 enfants', 'actif'),

('WEBER',      'Céline',            170000, 'achat', '0623456728', 'celine.weber@orange.fr',
 '11 rue du Parchemin, 67000 Strasbourg',      29, 'THOMAS David',    '2026-02-01', 'Infirmière',                                'Célibataire',      'actif'),

('CHAKIR',     'Nadia & Omar',      380000, 'achat', '0623456729', 'nadia.chakir@yahoo.fr',
 '44 boulevard Wilson, 67000 Strasbourg',      44, 'FASSI Amina',     '2025-09-18', 'Chirurgienne / Entrepreneur',               'Marié, 2 enfants', 'actif'),

('MEYER',      'François',          450000, 'achat', '0623456730', 'f.meyer@wanadoo.fr',
 '3 chemin du Schloessel, 67400 Illkirch',     58, 'THOMAS David',    '2025-07-10', 'Chef d''entreprise retraité',               'Marié',            'actif');

-- ============================================================
-- 4. BIENS IMMOBILIERS (30 — référence COL/MLH/STR)
-- ============================================================

INSERT INTO biens
  (reference, adresse, ville, type, surface, surface_terrain, prix, nb_pieces, nb_chambres, nb_sdb,
   annee_construction, dpe, ges, chauffage, description, lien_maps,
   statut_bien, agent_referent, date_mise_vente, commission_taux)
VALUES
-- ─── COLMAR (COL-001 à COL-010) ──────────────────────────────────────────
('COL-001', '12 rue des Vignes, 68000 Colmar',           'Colmar', 'maison',      125, 450,  385000,  5,4,2, 1995,'C','D','Gaz',
 'Belle maison familiale en excellent état. Cuisine équipée moderne, séjour lumineux 35m², garage double. Jardin arboré sans vis-à-vis.',
 'https://www.google.com/maps/search/?api=1&query=12+rue+des+Vignes+68000+Colmar',
 'en vente', 'FERREIRA Pedro', '2026-01-15', 6.00),

('COL-002', '28 allée des Châtaigniers, 68000 Colmar',   'Colmar', 'maison',       95, 280,  265000,  4,3,1, 1978,'D','E','Fioul',
 'Maison mitoyenne avec potentiel. Séjour cathédrale, 3 chambres, jardin clôturé. Travaux de rénovation à prévoir (double vitrage, isolation).',
 'https://www.google.com/maps/search/?api=1&query=28+allee+des+Chataigniers+68000+Colmar',
 'en vente', 'FERREIRA Pedro', '2025-12-01', 5.50),

('COL-003', '5 impasse du Moulin, 68000 Colmar',         'Colmar', 'maison',      165, 620,  495000,  7,5,2, 2005,'B','C','Pompe à chaleur',
 'Propriété contemporaine haut de gamme. Double séjour 50m², cuisine professionnelle, 5 chambres. Pool house, terrasse 60m². Domotique complète.',
 'https://www.google.com/maps/search/?api=1&query=5+impasse+du+Moulin+68000+Colmar',
 'en vente', 'BENALI Fatima', '2025-09-20', 5.00),

('COL-004', '14 rue du Marché, 68000 Colmar',            'Colmar', 'appartement',  72,NULL,  198000,  3,2,1, 2012,'B','C','Collectif gaz',
 'T3 lumineux en plein centre de Colmar. Parquet chêne, cuisine ouverte équipée, 2 chambres avec placards. Cave et parking souterrain inclus.',
 'https://www.google.com/maps/search/?api=1&query=14+rue+du+Marche+68000+Colmar',
 'en vente', 'KLEIN Léa', '2026-01-20', 5.50),

('COL-005', '8 place de la Cathédrale, 68000 Colmar',    'Colmar', 'appartement',  55,NULL,  165000,  2,1,1, 2001,'C','C','Électrique',
 'T2 avec vue imprenable sur la cathédrale Saint-Martin. Séjour spacieux, cuisine aménagée, balcon. Idéal primo-accédant ou investisseur (rendement 4,5%).',
 'https://www.google.com/maps/search/?api=1&query=8+place+de+la+Cathedrale+68000+Colmar',
 'en vente', 'KLEIN Léa', '2026-02-05', 5.00),

('COL-006', '32 boulevard du Champ de Mars, 68000 Colmar','Colmar','appartement',  90,NULL,  248000,  4,3,1, 1985,'D','E','Collectif gaz',
 'Grand T4 familial. 3 chambres, double séjour, cuisine indépendante. Immeuble bien entretenu, gardien. Cave, parking. Travaux de rafraîchissement.',
 'https://www.google.com/maps/search/?api=1&query=32+boulevard+du+Champ+de+Mars+68000+Colmar',
 'en vente', 'FERREIRA Pedro', '2025-10-10', 5.00),

('COL-007', '3 rue des Tanneurs, 68000 Colmar',          'Colmar', 'appartement',  42,NULL,  125000,  1,1,1, 2018,'A','A','Électrique',
 'Studio premium neuf, finitions luxe. Coin nuit séparé, salle de douche à l''italienne. Résidence sécurisée, ascenseur. Parfait investissement locatif.',
 'https://www.google.com/maps/search/?api=1&query=3+rue+des+Tanneurs+68000+Colmar',
 'en vente', 'KLEIN Léa', '2025-11-15', 5.00),

('COL-008', '45 route d''Ingersheim, 68000 Colmar',      'Colmar', 'maison',      140, 520,  420000,  6,4,2, 2000,'C','D','Gaz',
 'Maison de caractère à 5 min du centre. Salon 40m², 4 chambres dont suite parentale. Garage, jardin paysagé 520m², pergola.',
 'https://www.google.com/maps/search/?api=1&query=45+route+d+Ingersheim+68000+Colmar',
 'en vente', 'FERREIRA Pedro', '2025-12-15', 5.50),

('COL-009', 'Route de Ribeauvillé, 68000 Colmar',        'Colmar', 'terrain',    NULL, 800,   95000,  0,0,0, NULL, NULL,NULL,NULL,
 'Terrain constructible viabilisé (eau, électricité, gaz en limite). CU positif en cours. Zonage UC. Vue sur vignobles.',
 'https://www.google.com/maps/search/?api=1&query=Route+de+Ribeauville+68000+Colmar',
 'en vente', 'BENALI Fatima', '2025-08-01', 5.00),

('COL-010', '7 rue du Logelbach, 68000 Colmar',          'Colmar', 'appartement', 350,NULL,  650000,  0,0,0, 1935,'E','E','Collectif gaz',
 'Immeuble de rapport : 6 appartements (4×T2, 2×T3), pleinement loués. Rendement brut 6,2%. Travaux de façade récents. Caves individuelles, cour intérieure.',
 'https://www.google.com/maps/search/?api=1&query=7+rue+du+Logelbach+68000+Colmar',
 'en vente', 'BENALI Fatima', '2025-07-15', 4.50),

-- ─── MULHOUSE (MLH-001 à MLH-010) ────────────────────────────────────────
('MLH-001', '22 rue des Fleurs, 68100 Mulhouse',         'Mulhouse','maison',      110, 350,  295000,  5,4,2, 1990,'D','D','Gaz',
 'Maison semi-individuelle dans quartier résidentiel calme. Séjour 30m², cuisine équipée, 4 chambres. Garage, cave, jardin 350m². Proche tram.',
 'https://www.google.com/maps/search/?api=1&query=22+rue+des+Fleurs+68100+Mulhouse',
 'en vente', 'SHEHU Gentian', '2026-01-10', 5.50),

('MLH-002', '15 avenue du Rhin, 68100 Mulhouse',         'Mulhouse','maison',       85, 200,  235000,  4,3,1, 1975,'E','E','Fioul',
 'Maison familiale à rénover. Structure saine, charpente récente. 3 chambres, jardin clôturé. Budget travaux estimé : 40 000€ (isolation, chauffage, cuisine).',
 'https://www.google.com/maps/search/?api=1&query=15+avenue+du+Rhin+68100+Mulhouse',
 'en vente', 'COSTA Sofia', '2025-11-25', 5.50),

('MLH-003', '55 rue de Bâle, 68200 Mulhouse',            'Mulhouse','maison',      155, 480,  450000,  7,5,3, 2010,'B','C','Pompe à chaleur',
 'Belle villa contemporaine. Double séjour 55m², cuisine ouverte îlot central, 5 chambres, 2 salles de bain + SDE. Piscine chauffée 8×4m, carport 2 places.',
 'https://www.google.com/maps/search/?api=1&query=55+rue+de+Bale+68200+Mulhouse',
 'en vente', 'SHEHU Gentian', '2025-10-05', 5.00),

('MLH-004', '12 place de la République, 68100 Mulhouse', 'Mulhouse','appartement',  65,NULL,  175000,  3,2,1, 1998,'C','D','Collectif gaz',
 'T3 rénové, vue sur la place. Séjour avec parquet, 2 chambres, salle de bain refaite. Gardien, ascenseur. Cave et parking en option (15 000€).',
 'https://www.google.com/maps/search/?api=1&query=12+place+de+la+Republique+68100+Mulhouse',
 'en vente', 'COSTA Sofia', '2026-01-08', 5.50),

('MLH-005', '89 route de Colmar, 68100 Mulhouse',        'Mulhouse','maison',      120, 400,  310000,  5,4,2, 1995,'C','D','Gaz',
 'Maison individuelle classique très bien entretenue. Cuisine semi-ouverte, living 35m², 4 chambres dont 1 en rez-de-jardin. Garage, atelier, potager.',
 'https://www.google.com/maps/search/?api=1&query=89+route+de+Colmar+68100+Mulhouse',
 'en vente', 'SHEHU Gentian', '2025-12-20', 5.50),

('MLH-006', '3 quai de l''Ill, 68100 Mulhouse',          'Mulhouse','appartement',  78,NULL,  210000,  3,2,1, 2008,'B','C','Collectif gaz',
 'T3 vue canal, immeuble récent. Séjour 25m² avec loggia, 2 chambres, double vasque. Digicode, visiophone, ascenseur. Parking inclus, cave.',
 'https://www.google.com/maps/search/?api=1&query=3+quai+de+l+Ill+68100+Mulhouse',
 'en vente', 'WEBER Lucas', '2025-11-01', 5.00),

('MLH-007', '47 avenue des Trois Rois, 68200 Mulhouse',  'Mulhouse','appartement',  52,NULL,  148000,  2,1,1, 2015,'A','B','Électrique',
 'T2 BBC idéal investisseur (rendement 5,1%). Résidence récente, balcon, parking. Actuellement loué 620€/mois. Bail en cours jusqu''en juin 2026.',
 'https://www.google.com/maps/search/?api=1&query=47+avenue+des+Trois+Rois+68200+Mulhouse',
 'en vente', 'WEBER Lucas', '2025-09-15', 5.00),

('MLH-008', '18 impasse des Lilas, 68200 Mulhouse',      'Mulhouse','maison',      200, 800,  580000,  8,6,3, 2018,'A','A','Géothermie',
 'Propriété d''exception en impasse privée. Architecture bioclimatique, matériaux nobles. 6 chambres dont 2 suites, home cinema, cave à vins. Paysagiste professionnel.',
 'https://www.google.com/maps/search/?api=1&query=18+impasse+des+Lilas+68200+Mulhouse',
 'en vente', 'SHEHU Gentian', '2025-08-30', 4.50),

('MLH-009', 'Avenue de Colmar, 68100 Mulhouse',          'Mulhouse','terrain',    NULL, 600,   78000,  0,0,0, NULL,NULL,NULL,NULL,
 'Terrain viabilisé zone UB. Idéal construction individuelle R+1. Mitoyenneté possible. Étude de sol disponible.',
 'https://www.google.com/maps/search/?api=1&query=Avenue+de+Colmar+68100+Mulhouse',
 'en vente', 'COSTA Sofia', '2025-10-25', 5.00),

('MLH-010', '65 rue du Sauvage, 68100 Mulhouse',         'Mulhouse','appartement',  88,NULL,  238000,  4,3,1, 2005,'C','C','Collectif gaz',
 'Grand T4 au 4ème étage avec ascenseur. Lumineux, double orientation E/O. 3 chambres dont 1 master suite. Cave, box fermé 2 voitures.',
 'https://www.google.com/maps/search/?api=1&query=65+rue+du+Sauvage+68100+Mulhouse',
 'en vente', 'WEBER Lucas', '2025-12-08', 5.00),

-- ─── STRASBOURG (STR-001 à STR-010) ──────────────────────────────────────
('STR-001', '14 rue des Acacias, 67000 Strasbourg',      'Strasbourg','maison',     135, 400,  495000,  6,5,2, 2003,'B','C','Gaz',
 'Maison de standing secteur prisé. Séjour cathédrale 45m², cuisine ilôt équipée Siemens. 5 chambres, 2 salles de bain. Garage 2 voitures, terrasse bois.',
 'https://www.google.com/maps/search/?api=1&query=14+rue+des+Acacias+67000+Strasbourg',
 'en vente', 'THOMAS David', '2025-11-05', 5.00),

('STR-002', '26 quai des Bateliers, 67000 Strasbourg',   'Strasbourg','appartement', 95,NULL,  385000,  4,3,1, 1880,'D','E','Collectif vapeur',
 'Appartement haussmannien Grand Ile UNESCO. Plafonds 3,20m, moulures, parquet point de Hongrie, cheminées de marbre. 3 chambres, vue Ill.',
 'https://www.google.com/maps/search/?api=1&query=26+quai+des+Bateliers+67000+Strasbourg',
 'en vente', 'FASSI Amina', '2025-09-10', 5.00),

('STR-003', '7 allée des Cerisiers, 67200 Strasbourg',   'Strasbourg','maison',     175, 700,  650000,  8,6,3, 2015,'A','A','Pompe à chaleur',
 'Villa contemporaine d''architecte. Smart home complet, volets motorisés, alarme connectée. 6 chambres, home office, SPA privatif.',
 'https://www.google.com/maps/search/?api=1&query=7+allee+des+Cerisiers+67200+Strasbourg',
 'en vente', 'THOMAS David', '2025-07-20', 4.00),

('STR-004', '38 rue du Faubourg National, 67000 Strasbourg','Strasbourg','appartement',60,NULL, 220000,  3,2,1, 2010,'B','B','Collectif gaz',
 'T3 moderne en hypercentre. Résidence BBC 2010, faibles charges. Séjour traversant, cuisine ouverte, 2 chambres. Cave et parking.',
 'https://www.google.com/maps/search/?api=1&query=38+rue+du+Faubourg+National+67000+Strasbourg',
 'en vente', 'FASSI Amina', '2026-01-25', 5.50),

('STR-005', '5 place Broglie, 67000 Strasbourg',         'Strasbourg','appartement', 45,NULL,  195000,  2,1,1, 1950,'E','F','Collectif vapeur',
 'T2 Centre historique classé UNESCO. Charme de l''ancien (poutres, tomettes). Idéal investissement Airbnb ou résidence pied-à-terre.',
 'https://www.google.com/maps/search/?api=1&query=5+place+Broglie+67000+Strasbourg',
 'en vente', 'THOMAS David', '2025-10-18', 5.00),

('STR-006', '82 route de la Wantzenau, 67000 Strasbourg','Strasbourg','maison',      160, 600,  520000,  7,5,2, 1992,'C','C','Gaz',
 'Grande maison résidentielle prisée. Salon double 50m² avec cheminée, 5 chambres, bureau. Sous-sol aménagé (salle de jeux, cave). Piscine hors-sol.',
 'https://www.google.com/maps/search/?api=1&query=82+route+de+la+Wantzenau+67000+Strasbourg',
 'en vente', 'FASSI Amina', '2025-12-12', 5.00),

('STR-007', '19 avenue des Vosges, 67000 Strasbourg',    'Strasbourg','appartement',120,NULL,  480000,  5,4,2, 2001,'B','C','Collectif gaz',
 'Grand T5 avenue des Vosges. Parquet massif, double séjour 45m², 4 chambres, suite parentale avec dressing. 2 boxes fermés, 2 caves. Résidence gardée.',
 'https://www.google.com/maps/search/?api=1&query=19+avenue+des+Vosges+67000+Strasbourg',
 'en vente', 'OLIVEIRA Hugo', '2025-11-28', 4.50),

('STR-008', '33 rue des Roses, 67100 Strasbourg',        'Strasbourg','maison',       95, 250,  360000,  4,3,1, 1985,'D','D','Fioul',
 'Maison individuelle quartier Neudorf. Entrée, séjour 28m², cuisine indépendante. 3 chambres, grenier aménageable 40m². Garage, jardin 250m².',
 'https://www.google.com/maps/search/?api=1&query=33+rue+des+Roses+67100+Strasbourg',
 'en vente', 'FASSI Amina', '2025-10-01', 5.50),

('STR-009', 'Rue de la Paix, 67000 Strasbourg',          'Strasbourg','terrain',    NULL, 450,  120000,  0,0,0, NULL,NULL,NULL,NULL,
 'Terrain constructible secteur Cronenbourg. Viabilisé all-réseaux. Surface 450m², forme régulière. Zone UBa, constructibilité R+2.',
 'https://www.google.com/maps/search/?api=1&query=Rue+de+la+Paix+67000+Strasbourg',
 'en vente', 'OLIVEIRA Hugo', '2025-09-05', 5.00),

('STR-010', '4 impasse des Tilleuls, 67540 Ostwald',     'Strasbourg','maison',      210,1200,  780000,  9,7,4, 2020,'A','A','Géothermie',
 'Propriété d''exception récente. Entrée monumentale, salon 70m² avec verrière, cuisine de chef équipée. 7 chambres en suite. Piscine olympique, court de tennis privé.',
 'https://www.google.com/maps/search/?api=1&query=4+impasse+des+Tilleuls+67540+Ostwald',
 'en vente', 'THOMAS David', '2025-06-15', 4.00);

-- ============================================================
-- 5. MANDATS DE VENTE (20 — subqueries sur reference + nom)
-- ============================================================

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='FERRARI'  LIMIT 1), (SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), '2026-01-15','2027-01-15', 6.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='CHAKIR' AND prenom='Ahmed' LIMIT 1), (SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), '2025-12-01','2026-12-01', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='COL-003' LIMIT 1), '2025-09-20','2026-09-20', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SCHMIDT' LIMIT 1), (SELECT id FROM biens WHERE reference='COL-004' LIMIT 1), '2026-01-20','2027-01-20', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='COL-005' LIMIT 1), '2026-02-05','2027-02-05', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='COL-006' LIMIT 1), '2025-10-10','2026-10-10', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='COL-007' LIMIT 1), '2025-11-15','2026-11-15', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='MULLER' LIMIT 1), (SELECT id FROM biens WHERE reference='COL-008' LIMIT 1), '2025-12-15','2026-12-15', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='COL-009' LIMIT 1), '2025-08-01','2026-02-01', 5.00,'expiré');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='MLH-001' LIMIT 1), '2026-01-10','2027-01-10', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='LEKA' LIMIT 1), (SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), '2025-10-05','2026-10-05', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='MLH-004' LIMIT 1), '2026-01-08','2027-01-08', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SILVA' AND prenom='João & Maria' LIMIT 1), (SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), '2025-12-20','2026-12-20', 5.50,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='MLH-006' LIMIT 1), '2025-11-01','2026-11-01', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='MLH-007' LIMIT 1), '2025-09-15','2026-09-15', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='HOXHA' AND prenom='Erion & Anjeza' LIMIT 1), (SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), '2025-11-05','2026-11-05', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='STR-002' LIMIT 1), '2025-09-10','2026-09-10', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='STR-003' LIMIT 1), '2025-07-20','2026-07-20', 4.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES ((SELECT id FROM clients WHERE nom='SHEHU' AND prenom='Lorik & Flutura' LIMIT 1), (SELECT id FROM biens WHERE reference='STR-006' LIMIT 1), '2025-12-12','2026-12-12', 5.00,'actif');

INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut)
VALUES (NULL, (SELECT id FROM biens WHERE reference='STR-010' LIMIT 1), '2025-06-15','2026-06-15', 4.00,'actif');

-- ============================================================
-- 6. PROSPECTS (15)
-- ============================================================

INSERT INTO prospects (nom, prenom, telephone, source, interet, statut_prospect, ville, budget)
VALUES
('KRASNIQI',    'Elton',            '0634567801', 'site web',         'Recherche T3 min, Colmar, parking indispensable.',                                          'tiède',  'Colmar',      270000),
('SILVA',       'Tiago',            '0634567802', 'téléphone entrant','Maison 4 pièces Mulhouse, jardin, budget max 310k€. Très motivé, pré-accord bancaire.',    'chaud',  'Mulhouse',    310000),
('ALAMI',       'Zineb',            '0634567803', 'SeLoger',          'Appartement T2/T3 centre Colmar. Peu disponible, à relancer dans 1 mois.',                  'froid',  'Colmar',      190000),
('HOXHA',       'Ilir & Mimoza',    '0634567804', 'portail leboncoin','Villa haut standing Strasbourg, 5+ pièces, jardin. Acheteurs sérieux, visite sous 2 sem.', 'chaud',  'Strasbourg',  520000),
('ROSSI',       'Francesco',        '0634567805', 'recommandation',   'Investisseur, cherche appartement à rénover Strasbourg, rendement > 5%.',                  'tiède',  'Strasbourg',  250000),
('FERREIRA',    'Goncalo & Rita',   '0634567806', 'site web',         'Première maison, Mulhouse ou périphérie, max 280k€. Enfant prévu, écoles importantes.',    'chaud',  'Mulhouse',    280000),
('BENALI',      'Omar',             '0634567807', 'réseau',           'Appartement investissement locatif Colmar centre. Contacté par SANTOS Carlos.',             'tiède',  'Colmar',      175000),
('SCHMIDT',     'Céline',           '0634567808', 'SeLoger',          'Studio ou T2, Strasbourg hypercentre. Budget serré, financement à confirmer.',              'froid',  'Strasbourg',  155000),
('BERBERI',     'Arben & Flutura',  '0634567809', 'téléphone entrant','Grande maison 6+ pièces, secteur Strasbourg Nord. Très intéressés par STR-006.',           'chaud',  'Strasbourg',  530000),
('OLIVEIRA',    'Cristiana',        '0634567810', 'Facebook',         'T3/T4 Colmar, max 230k€. Employée CHR Colmar, proche hôpital souhaité.',                   'tiède',  'Colmar',      230000),
('THOMAS',      'Éric & Caroline',  '0634567811', 'portail immo',     'Maison plain-pied, Mulhouse agglo, plain-pied obligatoire (PMR). Budget 250-300k.',        'tiède',  'Mulhouse',    295000),
('IDRISSI',     'Nadia',            '0634567812', 'recommandation',   'Appartement T2 neuf ou récent Strasbourg, DPE A ou B. Primo-accédant.',                    'froid',  'Strasbourg',  200000),
('MULLER',      'Klaus & Ingrid',   '0634567813', 'vitrine agence',   'Propriété de prestige Colmar ou vignoble, budget 600-800k€. Patrimoine family.',           'chaud',  'Colmar',      750000),
('GRECO',       'Valentino',        '0634567814', 'site web',         'Studio ou T2 investissement, toutes villes, rendement > 4,5%. Professionnel libéral.',     'tiède',  'Mulhouse',    160000),
('COSTA',       'Ana Beatriz',      '0634567815', 'SeLoger',          'T3 avec balcon ou terrasse, Mulhouse quartier calme, proche transport. Locataire actuelle.','froid', 'Mulhouse',    210000);

-- ============================================================
-- 7. VISITES (8)
-- ============================================================

INSERT INTO visites (bien_id, client_nom, date_visite, heure, agent_nom, statut, feedback)
VALUES
((SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), 'FERRARI Giovanni & Laura',   '2025-11-18','10:00','FERREIRA Pedro', 'réalisée', 'Coup de cœur. Souhaite une 2ème visite avec l''architecte pour évaluer extension possible.'),
((SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), 'KRASNIQI Leonit & Liris',    '2025-12-05','14:30','FERREIRA Pedro', 'réalisée', 'Intéressés mais veulent renégocier le prix. Offre envisagée à 255 000€.'),
((SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), 'LEKA Besnik & Drita',        '2026-03-05','14:00','SHEHU Gentian',  'réalisée', '2ème visite. Très intéressés, demande de simulation crédit en cours.'),
((SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), 'SILVA João & Maria',         '2025-12-15','11:00','SHEHU Gentian',  'réalisée', 'Coup de foudre pour le jardin et l''atelier. Offre d''achat déposée le lendemain.'),
((SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), 'HOXHA Erion & Anjeza',       '2025-12-02','09:30','THOMAS David',   'réalisée', 'Bien correspond aux attentes. Budget légèrement en-dessous du prix affiché.'),
((SELECT id FROM biens WHERE reference='STR-002' LIMIT 1), 'SHEHU Lorik & Flutura',      '2026-01-10','10:00','FASSI Amina',    'réalisée', 'Charmés par le caractère haussmannien. Inquiets sur les charges de copropriété.'),
((SELECT id FROM biens WHERE reference='COL-004' LIMIT 1), 'RODRIGUES Ana',              '2026-01-22','14:00','KLEIN Léa',      'planifiée',NULL),
((SELECT id FROM biens WHERE reference='MLH-008' LIMIT 1), 'BENALI Youssef',             '2026-03-08','11:00','SHEHU Gentian',  'planifiée',NULL);

-- ============================================================
-- 8. OFFRES D'ACHAT (5)
-- ============================================================

INSERT INTO offres (bien_id, acheteur_nom, vendeur_nom, montant_offre, date_offre, statut)
VALUES
((SELECT id FROM biens WHERE reference='COL-002' LIMIT 1), 'KRASNIQI Leonit & Liris',  'Propriétaire COL-002',      255000, '2025-12-20', 'en cours'),
((SELECT id FROM biens WHERE reference='MLH-005' LIMIT 1), 'SILVA João & Maria',        'Propriétaire MLH-005',      295000, '2025-12-16', 'acceptée'),
((SELECT id FROM biens WHERE reference='STR-001' LIMIT 1), 'HOXHA Erion & Anjeza',      'Propriétaire STR-001',      475000, '2026-01-08', 'contre-offre'),
((SELECT id FROM biens WHERE reference='COL-001' LIMIT 1), 'FERRARI Giovanni & Laura',  'Propriétaire COL-001',      370000, '2026-01-25', 'en cours'),
((SELECT id FROM biens WHERE reference='MLH-003' LIMIT 1), 'LEKA Besnik & Drita',       'Propriétaire MLH-003',      430000, '2026-03-07', 'en cours');

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

INSERT INTO factures_fournisseurs
  (numero_facture, fournisseur, montant_ht, tva, montant_ttc,
   date_facture, date_echeance, statut, anomalie)
VALUES
('F-2026-001', 'PRINTEX COMMUNICATION',        500.00,  20.00,  600.00, '2026-01-15','2026-02-15','litigieuse',
 'Adresse de facturation absente — à régulariser avant tout paiement'),

('F-2026-002', 'EDF ENTREPRISES — Colmar',    1000.00,  20.00, 1200.00, '2026-01-20','2026-02-20','validée',   NULL),
('F-2026-003', 'ORANGE BUSINESS',              450.00,  20.00,  540.00, '2026-01-25','2026-02-25','validée',   NULL),
('F-2026-004', 'SELOGER ANNONCES',             800.00,  20.00,  960.00, '2026-02-01','2026-03-01','reçue',     NULL),
('F-2026-005', 'RAPIDO NETTOYAGE',             350.00,  15.00,  402.50, '2026-02-05','2026-03-05','litigieuse',
 'TVA calculée à 15% au lieu de 20% — montant TTC incorrect, écart de 17,50€'),

('F-2026-006', 'AGENCE PUBLICITAIRE LBA',     2400.00,  20.00, 2880.00, '2026-02-10','2026-03-10','reçue',     NULL),
('F-2026-007', 'ASSUR IMMO PLUS',            5400.00,  20.00, 6480.00, '2026-02-15','2026-03-15','reçue',     NULL),
('F-2026-008', 'FORMATIONS IMMO CONSEIL',    1800.00,  20.00, 2160.00, '2026-02-20','2026-03-20','validée',   NULL),
('F-2026-009', 'EXPERT COMPTABLE HUBER',     1200.00,  20.00, 1440.00, '2026-03-01','2026-04-01','reçue',     NULL),
('F-2026-010', 'LOGICIELS CRM APIMO',        4800.00,  20.00, 5760.00, '2026-03-01','2026-04-01','reçue',     NULL);

-- ============================================================
-- 11. FORMATIONS DDA (9 commerciaux + formations diverses)
-- ============================================================

INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation)
VALUES
-- DDA obligatoire (15h/an) — commerciaux
('Fatima BENALI',   'Réglementation DDA et distribution immobilière 2025',     'IFOCOP',           '2025-11-20', 15.0, 'DDA'),
('Pedro FERREIRA',  'Réglementation DDA et pratique de la transaction',         'FNAIM Formation',  '2025-11-20', 15.0, 'DDA'),
('Léa KLEIN',       'DDA : obligations, déontologie et pratique',               'AUREP',            '2026-02-05', 15.0, 'DDA'),
('Gentian SHEHU',   'Lutte anti-blanchiment, conformité et DDA 2025',           'IFOCOP',           '2025-10-15', 15.0, 'DDA'),
('Sofia COSTA',     'Formation DDA + négociation commerciale avancée',           'FNAIM Formation',  '2025-11-20', 15.0, 'DDA'),
('Lucas WEBER',     'DDA : réglementation immobilière et assurances',            'AF2I',             '2026-01-22', 15.0, 'DDA'),
('David THOMAS',    'DDA Management agence + conformité réglementaire',          'IFOCOP',           '2025-10-08', 15.0, 'DDA'),
('Amina FASSI',     'DDA et pratique du conseil patrimonial',                    'AUREP',            '2025-11-13', 15.0, 'DDA'),
('Hugo OLIVEIRA',   'DDA Gestion de patrimoine + placements financiers',         'AF2I',             '2025-09-25', 15.0, 'DDA'),
-- Formations complémentaires
('Pedro FERREIRA',  'Négociation avancée en immobilier résidentiel',             'CEGOS',            '2025-03-10',  14.0, 'facultatif'),
('Sofia COSTA',     'Photographie immobilière et home staging',                  'FNAIM Formation',  '2025-05-22',   7.0, 'facultatif'),
('Hugo OLIVEIRA',   'Fiscalité du patrimoine 2025 : IFI, plus-values, assurance-vie','AUREP',        '2026-01-30',   7.0, 'obligatoire'),
('Maria SILVA',     'Management RH et droit du travail 2025',                    'CEGOS',            '2025-06-12',  14.0, 'obligatoire'),
('Arben HOXHA',     'Comptabilité immobilière et normes IFRS',                   'INTEC',            '2025-09-18',  21.0, 'obligatoire');

-- ============================================================
-- 12. CONGÉS (20 — un par salarié)
-- ============================================================

INSERT INTO conges (salarie_nom, type, date_debut, date_fin, jours, statut)
VALUES
('Christophe DIRINGER', 'CP',     '2026-07-14','2026-08-01', 14, 'approuvé'),
('Elena ROSSI',          'CP',     '2026-08-03','2026-08-21', 14, 'en attente'),
('Maria SILVA',          'CP',     '2026-07-06','2026-07-18',  9, 'approuvé'),
('Laura MEYER',          'CP',     '2026-08-10','2026-08-21',  8, 'en attente'),
('Youssef ALAMI',        'RTT',    '2026-06-02','2026-06-06',  5, 'approuvé'),
('Julie BERNARD',        'CP',     '2026-07-06','2026-07-18',  9, 'approuvé'),
('Arben HOXHA',          'CP',     '2026-08-17','2026-08-28',  8, 'en attente'),
('Carla SANTOS',         'maladie','2026-02-10','2026-02-14',  5, 'approuvé'),
('Claire MARTIN',        'CP',     '2026-07-20','2026-08-07', 13, 'approuvé'),
('Marco GRECO',          'RTT',    '2026-05-30','2026-06-03',  5, 'approuvé'),
('Fatima BENALI',        'CP',     '2026-08-03','2026-08-14',  8, 'approuvé'),
('Pedro FERREIRA',       'CP',     '2026-07-27','2026-08-07',  8, 'en attente'),
('Léa KLEIN',            'CP',     '2026-08-24','2026-09-04',  8, 'en attente'),
('Gentian SHEHU',        'CP',     '2026-07-20','2026-08-07', 13, 'approuvé'),
('Sofia COSTA',          'CP',     '2026-08-10','2026-08-21',  8, 'en attente'),
('Lucas WEBER',          'CP',     '2026-08-17','2026-08-21',  5, 'en attente'),
('David THOMAS',         'CP',     '2026-07-06','2026-07-24', 13, 'approuvé'),
('Amina FASSI',          'RTT',    '2026-06-15','2026-06-19',  5, 'approuvé'),
('Hugo OLIVEIRA',        'CP',     '2026-08-10','2026-08-28', 14, 'en attente'),
('Valentina ROMANO',     'CP',     '2026-08-03','2026-08-14',  8, 'en attente');

-- ============================================================
-- 13. CARTES PROFESSIONNELLES (9 commerciaux)
-- ============================================================

INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut)
VALUES
('Fatima BENALI',   'CCI-68-2024-1234', '2027-03-01', 'CCI Alsace (Mulhouse)',   'valide'),
('Pedro FERREIRA',  'CCI-68-2023-5678', '2026-09-15', 'CCI Alsace (Mulhouse)',   'valide'),
('Léa KLEIN',       'CCI-68-2025-9012', '2028-01-09', 'CCI Alsace (Mulhouse)',   'valide'),
('Gentian SHEHU',   'CCI-68-2022-3456', '2025-02-17', 'CCI Alsace (Mulhouse)',   'expiré'),
('Sofia COSTA',     'CCI-68-2024-7890', '2027-03-01', 'CCI Alsace (Mulhouse)',   'valide'),
('Lucas WEBER',     'CCI-68-2025-2345', '2028-06-20', 'CCI Alsace (Mulhouse)',   'valide'),
('David THOMAS',    'CCI-67-2023-6789', '2026-07-04', 'CCI Bas-Rhin (Strasbourg)','valide'),
('Amina FASSI',     'CCI-67-2024-0123', '2027-09-01', 'CCI Bas-Rhin (Strasbourg)','valide'),
('Hugo OLIVEIRA',   'CCI-67-2022-4567', '2025-11-01', 'CCI Bas-Rhin (Strasbourg)','en renouvellement');

-- ============================================================
-- 14. ASSURANCES RC PROFESSIONNELLES (3 contrats)
-- ============================================================

INSERT INTO assurances_rc (compagnie, numero_police, montant_garantie, date_debut, date_fin)
VALUES
('ALLIANZ Professionnels',   'ALLZ-RC-2026-00145', 1500000.00, '2026-01-01', '2026-12-31'),
('AXA Entreprises',          'AXA-PRO-2025-08872',  500000.00, '2025-09-01', '2026-08-31'),
('MAIF Professionnels',      'MAIF-RC-2026-33291',  750000.00, '2026-01-01', '2026-12-31');

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
('Laptop 15" Pro',         'Dell',   'DL-XPS15-2023-44721', 'Hugo OLIVEIRA',   '2023-02-15','2026-02-15','opérationnel'),
('Laptop 14" Pro',         'Lenovo', 'LNV-T14-2022-33981',  'Amina FASSI',     '2022-09-01','2025-09-01','opérationnel'),
('Imprimante Laser A4/A3', 'HP',     'HP-LASERJET-21-83654','Agence Colmar',   '2021-06-01','2024-06-01','panne'),
('Tablette iPad 12.9"',    'Apple',  'APL-IPAD-2022-99001', 'Pedro FERREIRA',  '2022-09-01','2024-09-01','opérationnel'),
('Serveur NAS 4 baies',    'Synology','SYN-NAS-2020-11230', 'Siège Mulhouse',  '2020-03-01','2023-03-01','opérationnel');

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
('Printemps Immobilier 2026',    'print',          9500.00, '2026-03-01','2026-05-31','en préparation',
 'Générer 60 nouveaux mandats exclusifs, print Alsace + publicité JDD régional'),
('LinkedIn Patrimoine Q1 2026',  'réseaux sociaux',3500.00, '2026-01-02','2026-03-31','active',
 'Attirer 20 clients patrimoniaux ≥ 500k€ via LinkedIn Ads ciblage cadres 40-60 ans'),
('Portes Ouvertes Colmar mars',  'événement',      4800.00, '2026-03-14','2026-03-15','en préparation',
 'Présenter 10 biens exclusifs, objectif : 25 visites programmées en 2 jours');

-- ============================================================
-- FIN DU FICHIER SEED_REALISTIC_DATA.SQL
-- Ordre d''exécution recommandé dans Supabase :
--   1. erp_tables.sql
--   2. erp_updates.sql
--   3. services_tables.sql
--   4. seed_realistic_data.sql
-- ============================================================

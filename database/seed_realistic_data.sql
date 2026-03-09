-- ========================================
-- DONNÉES RÉALISTES LA BELLE AGENCE
-- Diversité : Italien, Portugais, Marocain, Albanais, Français, Alsacien
-- ========================================

-- Nettoyage (ordre FK safe)
DELETE FROM ventes;
DELETE FROM offres;
DELETE FROM visites;
DELETE FROM mandats;
DELETE FROM dossiers_patrimoniaux;
DELETE FROM factures_clients;
DELETE FROM factures_fournisseurs;
DELETE FROM ecritures_comptables;
DELETE FROM formations;
DELETE FROM conges;
DELETE FROM documents_rh;
DELETE FROM cartes_professionnelles;
DELETE FROM assurances_rc;
DELETE FROM prospects;
DELETE FROM biens;
DELETE FROM clients;
DELETE FROM salaries;

-- ============================================================
-- Colonnes étendues
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
  ADD COLUMN IF NOT EXISTS surface_terrain    NUMERIC(8,2),
  ADD COLUMN IF NOT EXISTS nb_chambres        INTEGER,
  ADD COLUMN IF NOT EXISTS nb_sdb             INTEGER,
  ADD COLUMN IF NOT EXISTS annee_construction INTEGER,
  ADD COLUMN IF NOT EXISTS dpe                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS ges                VARCHAR(5),
  ADD COLUMN IF NOT EXISTS chauffage          VARCHAR(50),
  ADD COLUMN IF NOT EXISTS lien_maps          TEXT,
  ADD COLUMN IF NOT EXISTS agent_id           INTEGER,
  ADD COLUMN IF NOT EXISTS vendeur_id         INTEGER,
  ADD COLUMN IF NOT EXISTS date_mise_vente    DATE,
  ADD COLUMN IF NOT EXISTS commission         NUMERIC(5,2);

ALTER TABLE cartes_professionnelles
  ADD COLUMN IF NOT EXISTS organisme_delivreur VARCHAR(200);

-- ============================================================
-- SALARIÉS (20)
-- ============================================================
INSERT INTO salaries (nom, prenom, age, origine, email, telephone, adresse, poste, service, agence, date_embauche, salaire_brut, type_contrat) VALUES
-- Siège Mulhouse — Direction
('DIRINGER', 'Christophe', 55, 'Alsacien',   'diringer.c@labelleagence.fr', '0612345601', '15 rue du Sapin, 68100 Mulhouse',          'Directeur Général',        'Direction',  'Siège',       '2010-01-15', 6200.00, 'CDI'),
('ROSSI',    'Elena',       48, 'Italienne',  'rossi.e@labelleagence.fr',    '0612345602', '8 avenue de Colmar, 68200 Mulhouse',        'Directrice Adjointe',      'Direction',  'Siège',       '2012-03-01', 5100.00, 'CDI'),
-- Siège — RH
('SILVA',    'Maria',       42, 'Portugaise', 'silva.m@labelleagence.fr',    '0612345603', '22 rue de Bâle, 68100 Mulhouse',            'Responsable RH',           'RH',         'Siège',       '2015-06-01', 3800.00, 'CDI'),
('MEYER',    'Laura',       28, 'Alsacienne', 'meyer.l@labelleagence.fr',    '0612345604', '5 rue des Lilas, 68200 Mulhouse',           'Assistante RH',            'RH',         'Siège',       '2022-09-01', 2200.00, 'CDI'),
-- Siège — Conformité
('ALAMI',    'Youssef',     38, 'Marocain',   'alami.y@labelleagence.fr',    '0612345605', '14 rue Lefebvre, 68100 Mulhouse',           'Compliance Officer',       'Conformité', 'Siège',       '2018-04-15', 3900.00, 'CDI'),
('BERNARD',  'Julie',       26, 'Française',  'bernard.j@labelleagence.fr',  '0612345606', '3 rue des Pins, 68200 Mulhouse',            'Assistante Conformité',    'Conformité', 'Siège',       '2023-09-01', 2100.00, 'CDI'),
-- Siège — Finance
('HOXHA',    'Arben',       45, 'Albanais',   'hoxha.a@labelleagence.fr',    '0612345607', '9 allée des Acacias, 68100 Mulhouse',       'Responsable Comptable',    'Finance',    'Siège',       '2013-02-01', 4100.00, 'CDI'),
('SANTOS',   'Carla',       32, 'Portugaise', 'santos.c@labelleagence.fr',   '0612345608', '17 rue du Canal, 68200 Mulhouse',           'Comptable',                'Finance',    'Siège',       '2020-01-15', 2700.00, 'CDI'),
-- Siège — Marketing & IT
('MARTIN',   'Claire',      35, 'Française',  'martin.c@labelleagence.fr',   '0612345609', '6 rue des Roses, 68100 Mulhouse',           'Responsable Marketing',    'Marketing',  'Siège',       '2017-07-01', 3600.00, 'CDI'),
('GRECO',    'Marco',       30, 'Italien',    'greco.m@labelleagence.fr',    '0612345610', '11 rue des Tilleuls, 68200 Mulhouse',       'Technicien IT',            'IT',         'Siège',       '2021-03-15', 2900.00, 'CDI'),
-- Agence Colmar
('BENALI',   'Fatima',      40, 'Marocaine',  'benali.f@labelleagence.fr',   '0612345611', '7 rue des Vignes, 68000 Colmar',            'Responsable Agence',       'Commercial', 'Colmar',      '2016-09-01', 4200.00, 'CDI'),
('FERREIRA', 'Pedro',       33, 'Portugais',  'ferreira.p@labelleagence.fr', '0612345612', '15 allée du Staufen, 68000 Colmar',         'Négociateur Immobilier',   'Commercial', 'Colmar',      '2020-02-15', 2500.00, 'CDI'),
('KLEIN',    'Léa',         25, 'Alsacienne', 'klein.l@labelleagence.fr',    '0612345613', '4 rue Turenne, 68000 Colmar',               'Assistante Commerciale',   'Commercial', 'Colmar',      '2023-06-01', 2000.00, 'CDI'),
-- Agence Mulhouse
('SHEHU',    'Gentian',     43, 'Albanais',   'shehu.g@labelleagence.fr',    '0612345614', '23 rue de Thann, 68100 Mulhouse',           'Responsable Agence',       'Commercial', 'Mulhouse',    '2014-11-01', 4300.00, 'CDI'),
('COSTA',    'Sofia',       29, 'Italienne',  'costa.s@labelleagence.fr',    '0612345615', '8 rue Laplace, 68100 Mulhouse',             'Négociatrice Immobilière', 'Commercial', 'Mulhouse',    '2021-08-16', 2450.00, 'CDI'),
('WEBER',    'Lucas',       27, 'Alsacien',   'weber.l@labelleagence.fr',    '0612345616', '31 rue du Maréchal Joffre, 68200 Mulhouse', 'Assistant Commercial',     'Commercial', 'Mulhouse',    '2023-01-09', 2050.00, 'CDI'),
-- Agence Strasbourg
('THOMAS',   'David',       39, 'Français',   'thomas.d@labelleagence.fr',   '0612345617', '18 rue des Bouchers, 67000 Strasbourg',     'Responsable Agence',       'Commercial', 'Strasbourg',  '2015-03-01', 4400.00, 'CDI'),
('FASSI',    'Amina',       31, 'Marocaine',  'fassi.a@labelleagence.fr',    '0612345618', '5 rue de la Mésange, 67000 Strasbourg',     'Négociatrice Immobilière', 'Commercial', 'Strasbourg',  '2019-10-01', 2550.00, 'CDI'),
('OLIVEIRA', 'Hugo',        34, 'Portugais',  'oliveira.h@labelleagence.fr', '0612345619', '29 quai des Bateliers, 67000 Strasbourg',   'Conseiller Patrimoine',    'Patrimoine', 'Strasbourg',  '2018-06-15', 3200.00, 'CDI'),
-- Siège — Marketing (20e)
('ROMANO',   'Valentina',   33, 'Italienne',  'romano.v@labelleagence.fr',   '0612345620', '12 rue du Raisin, 68100 Mulhouse',          'Community Manager',        'Marketing',  'Siège',       '2022-05-02', 2600.00, 'CDI');

-- ============================================================
-- CLIENTS (30)
-- agent_referent IDs : BENALI=11, FERREIRA=12, KLEIN=13
--                      SHEHU=14, COSTA=15, WEBER=16
--                      THOMAS=17, FASSI=18, OLIVEIRA=19
-- ============================================================
INSERT INTO clients (nom, prenom, age, email, telephone, adresse, budget_min, budget_max, type_recherche, nb_pieces, agent_referent, date_premier_contact, statut, profession, situation_familiale) VALUES
-- Colmar
('FERRARI',   'Giovanni & Laura', 45, 'ferrari.giovanni@gmail.com', '0623456701', '25 rue des Vignes, 68000 Colmar',          350000, 450000, 'maison',       5, 12, '2025-11-15', 'actif', 'Cadre supérieur / Enseignante',    'Marié, 2 enfants'),
('CHAKIR',    'Ahmed',            62, 'a.chakir@yahoo.fr',          '0623456702', '14 rue du Vignoble, 68000 Colmar',         200000, 280000, 'appartement',  3, 11, '2025-10-20', 'actif', 'Retraité',                         'Veuf'),
('RODRIGUES', 'Ana',              33, 'ana.rodrigues@hotmail.com',  '0623456703', '8 cité des Fleurs, 68000 Colmar',          150000, 200000, 'appartement',  2, 12, '2025-12-05', 'actif', 'Infirmière',                       'Célibataire'),
('SCHMIDT',   'Jean-Pierre',      50, 'schmidt.jp@orange.fr',       '0623456704', '5 rue Kleber, 68000 Colmar',               280000, 350000, 'maison',       4, 13, '2026-01-10', 'actif', 'Artisan / Employée',               'Marié, 3 enfants'),
('KRASNIQI',  'Leonit & Liris',   40, 'leonit.krasniqi@gmail.com',  '0623456705', '19 rue des Tanneurs, 68000 Colmar',        250000, 320000, 'maison',       4, 12, '2025-09-30', 'actif', 'Chauffeur / Aide-soignante',        'Marié, 2 enfants'),
('ROBERT',    'Sophie',           38, 'sophie.robert@sfr.fr',       '0623456706', '2 allée des Cerisiers, 68000 Colmar',      170000, 220000, 'appartement',  3, 11, '2025-11-25', 'actif', 'Enseignante',                      'Divorcée, 1 enfant'),
('IDRISSI',   'Karim & Leila',    35, 'k.idrissi@outlook.fr',       '0623456707', '33 rue des Marchands, 68000 Colmar',       300000, 400000, 'maison',       5, 12, '2026-01-20', 'actif', 'Chef d''entreprise / Comptable',   'Marié, 2 enfants'),
('SANTOS',    'Carlos',           47, 'carlos.santos@gmail.com',    '0623456708', '7 rue Rapp, 68000 Colmar',                 180000, 240000, 'appartement',  3, 11, '2025-10-15', 'actif', 'Technicien',                       'Marié, 1 enfant'),
('GRECO',     'Elena',            29, 'elena.greco@yahoo.it',       '0623456709', '11 rue des Bateliers, 68000 Colmar',       120000, 160000, 'appartement',  2, 13, '2026-02-01', 'actif', 'Doctorante',                       'Célibataire'),
('MULLER',    'Thomas',           55, 't.muller@wanadoo.fr',        '0623456710', '45 route du Vin, 68000 Colmar',            380000, 500000, 'maison',       6, 12, '2025-08-10', 'actif', 'Médecin',                          'Marié, 4 enfants'),
-- Mulhouse
('LEKA',      'Besnik & Drita',   38, 'besnik.leka@gmail.com',      '0623456711', '12 rue de Bâle, 68100 Mulhouse',           300000, 400000, 'maison',       5, 14, '2025-10-05', 'actif', 'Gérant / Comptable',               'Marié, 3 enfants'),
('ALAMI',     'Fatima',           50, 'f.alami@hotmail.fr',         '0623456712', '6 rue de Metz, 68100 Mulhouse',            170000, 220000, 'appartement',  3, 15, '2025-11-10', 'actif', 'Retraitée',                        'Veuve'),
('SILVA',     'João & Maria',     43, 'joao.silva@gmail.com',       '0623456713', '28 avenue de Colmar, 68100 Mulhouse',      260000, 330000, 'maison',       4, 14, '2025-12-15', 'actif', 'Ingénieur / Assistante',           'Marié, 2 enfants'),
('ROMANO',    'Pietro',           35, 'pietro.romano@libero.it',    '0623456714', '3 rue Lefebvre, 68100 Mulhouse',           150000, 200000, 'appartement',  2, 15, '2026-01-08', 'actif', 'Cuisinier',                        'Célibataire'),
('BERBERI',   'Elira',            41, 'elira.berberi@outlook.com',  '0623456715', '17 rue de la Paix, 68100 Mulhouse',        230000, 300000, 'maison',       4, 16, '2025-09-20', 'actif', 'Pharmacienne',                     'Mariée, 2 enfants'),
('MARTIN',    'Lucas & Emma',     32, 'lucas.martin@free.fr',       '0623456716', '9 rue des Lilas, 68200 Mulhouse',          220000, 280000, 'maison',       3, 14, '2026-01-25', 'actif', 'Informaticien / Graphiste',         'Marié, 1 enfant'),
('BENALI',    'Youssef',          48, 'y.benali@gmail.com',         '0623456717', '22 allée des Tilleuls, 68100 Mulhouse',    350000, 450000, 'maison',       5, 15, '2025-07-30', 'actif', 'Chef d''entreprise',                'Marié, 3 enfants'),
('FERREIRA',  'Teresa',           37, 'teresa.ferreira@sapo.pt',    '0623456718', '4 rue du Logelbach, 68200 Mulhouse',       160000, 210000, 'appartement',  3, 16, '2025-11-20', 'actif', 'Infirmière',                       'Divorcée'),
('KLEIN',     'Sophie & Marc',    44, 'sophie.klein@orange.fr',     '0623456719', '8 rue des Peupliers, 68100 Mulhouse',      330000, 420000, 'maison',       5, 14, '2025-10-30', 'actif', 'Avocate / Commerçant',              'Marié, 2 enfants'),
('COSTA',     'Michele',          52, 'michele.costa@gmail.com',    '0623456720', '15 boulevard de l''Europe, 68100 Mulhouse',280000, 360000, 'maison',       4, 15, '2025-08-25', 'actif', 'Directeur commercial',             'Marié'),
-- Strasbourg
('HOXHA',     'Erion & Anjeza',   42, 'erion.hoxha@gmail.com',      '0623456721', '14 quai des Bateliers, 67000 Strasbourg',  420000, 550000, 'maison',       6, 17, '2025-11-05', 'actif', 'Entrepreneur / Juriste',           'Marié, 3 enfants'),
('FASSI',     'Mohammed',         35, 'm.fassi@hotmail.fr',          '0623456722', '6 rue du 22 Novembre, 67000 Strasbourg',   240000, 310000, 'maison',       4, 18, '2025-12-20', 'actif', 'Kinésithérapeute',                 'Marié, 2 enfants'),
('OLIVEIRA',  'Ricardo & Ana',    39, 'ricardo.oliveira@gmail.com', '0623456723', '20 rue des Hallebardes, 67000 Strasbourg', 280000, 360000, 'maison',       4, 19, '2026-01-15', 'actif', 'Ingénieur / Professeure',          'Marié, 2 enfants'),
('ROSSI',     'Valentina',        31, 'vale.rossi@yahoo.it',        '0623456724', '3 rue du Fossé des Tailleurs, 67000 Strasbourg', 180000, 240000, 'appartement', 3, 17, '2026-02-01', 'actif', 'Designer',               'Célibataire'),
('SHEHU',     'Lorik & Flutura',  46, 'lorik.shehu@outlook.com',    '0623456725', '18 route du Rhin, 67100 Strasbourg',       370000, 480000, 'maison',       5, 18, '2025-10-10', 'actif', 'Transporteur / Commerciale',       'Marié, 3 enfants'),
('BERNARD',   'Claire & Thomas',  36, 'claire.bernard@sfr.fr',      '0623456726', '9 rue des Frères, 67000 Strasbourg',       250000, 320000, 'maison',       4, 17, '2025-11-30', 'actif', 'Médecin / Architecte',             'Marié, 1 enfant'),
('SANTOS',    'Joaquim',          40, 'joaquim.santos@gmail.com',   '0623456727', '31 avenue des Vosges, 67000 Strasbourg',   300000, 400000, 'maison',       4, 19, '2025-09-15', 'actif', 'Gérant de restaurant',             'Marié, 2 enfants'),
('WEBER',     'Céline',           29, 'celine.weber@orange.fr',     '0623456728', '7 rue de la Nuée Bleue, 67000 Strasbourg', 145000, 190000, 'appartement',  2, 17, '2026-02-10', 'actif', 'Juriste',                          'Célibataire'),
('CHAKIR',    'Nadia & Omar',     44, 'nadia.chakir@yahoo.fr',      '0623456729', '25 rue du Maréchal Foch, 67000 Strasbourg',330000, 430000, 'maison',       5, 18, '2025-10-25', 'actif', 'Pharmacienne / Cadre',             'Marié, 3 enfants'),
('MEYER',     'François',         58, 'f.meyer@wanadoo.fr',         '0623456730', '12 rue des Orfèvres, 67000 Strasbourg',    400000, 520000, 'maison',       5, 17, '2025-07-20', 'actif', 'Notaire',                          'Marié, 4 enfants');

-- ============================================================
-- BIENS (30) — surface = surface_habitable, nb_pieces = nb_chambres+1
-- ============================================================
INSERT INTO biens (reference, adresse, ville, type, surface_habitable, surface, surface_terrain, nb_chambres, nb_sdb, nb_pieces, prix, annee_construction, dpe, ges, chauffage, description, lien_maps, statut, agent_id, vendeur_id, date_mise_vente, commission) VALUES
-- Colmar (COL-001 à COL-010)
('COL-001', '12 rue des Vignes, 68000 Colmar',          'Colmar',      'Maison',      125, 125,   450, 4, 2, 5, 385000, 1995, 'C', 'D', 'Gaz',          'Belle maison familiale en excellent état. Cuisine équipée moderne, séjour lumineux 35m², garage double. Jardin arboré sans vis-à-vis. Proche écoles et commerces.',  'https://maps.google.com/?q=12+rue+des+Vignes+68000+Colmar',            'en vente', 12, 1,  '2026-01-15', 6.00),
('COL-002', '8 allée du Staufen, 68000 Colmar',          'Colmar',      'Maison',       98,  98,   280, 3, 1, 4, 275000, 1988, 'D', 'E', 'Fuel',         'Maison de plain-pied, séjour cathédrale, cave, garage. Quartier résidentiel calme.',                                                                                 'https://maps.google.com/?q=8+allée+du+Staufen+68000+Colmar',           'en vente', 12, 2,  '2026-01-20', 5.50),
('COL-003', '24 rue des Marchands, 68000 Colmar',        'Colmar',      'Appartement',  72,  72,     0, 2, 1, 3, 195000, 2005, 'B', 'C', 'Pompe chaleur','Appartement en plein cœur de la vieille ville, vue sur canal, cave et parking.',                                                                                    'https://maps.google.com/?q=24+rue+des+Marchands+68000+Colmar',         'en vente', 11, 3,  '2025-11-10', 5.00),
('COL-004', '45 route du Vin, 68000 Colmar',             'Colmar',      'Maison',      155, 155,   600, 5, 2, 6, 480000, 2000, 'C', 'C', 'Gaz',          'Superbe villa avec piscine, double garage, cave à vins, pergola. Vue vignobles.',                                                                                  'https://maps.google.com/?q=45+route+du+Vin+68000+Colmar',              'en vente', 12, 4,  '2025-10-05', 6.00),
('COL-005', '3 rue Turenne, 68000 Colmar',               'Colmar',      'Appartement',  45,  45,     0, 1, 1, 2, 128000, 1975, 'E', 'F', 'Électrique',   'Studio rénové proche gare, idéal investissement locatif. Bon rendement.',                                                                                            'https://maps.google.com/?q=3+rue+Turenne+68000+Colmar',                'en vente', 13, 5,  '2026-02-01', 5.00),
('COL-006', '18 cité des Fleurs, 68000 Colmar',          'Colmar',      'Appartement',  88,  88,     0, 3, 2, 4, 245000, 2015, 'A', 'B', 'Pompe chaleur','Grand F4 neuf résidence sécurisée, terrasse 15m², parking double.',                                                                                                 'https://maps.google.com/?q=18+cité+des+Fleurs+68000+Colmar',           'en vente', 11, 6,  '2025-12-15', 5.50),
('COL-007', '7 rue des Tanneurs, 68000 Colmar',          'Colmar',      'Maison',      110, 110,   350, 3, 1, 4, 320000, 1960, 'D', 'D', 'Gaz',          'Maison alsacienne à colombages entièrement rénovée, jardin paysager, garage.',                                                                                      'https://maps.google.com/?q=7+rue+des+Tanneurs+68000+Colmar',           'en vente', 12, 7,  '2026-01-08', 6.00),
('COL-008', '32 avenue de la République, 68000 Colmar',  'Colmar',      'Appartement',  62,  62,     0, 2, 1, 3, 172000, 1985, 'D', 'D', 'Collectif gaz','F3 bien exposé, balcon filant, cave, parking. Proche toutes commodités.',                                                                                           'https://maps.google.com/?q=32+avenue+de+la+République+68000+Colmar',   'en vente', 13, 8,  '2026-02-10', 5.00),
('COL-009', '56 route de Fribourg, 68000 Colmar',        'Colmar',      'Terrain',       0,   0,   800, 0, 0, 1,  89000,    0,  NULL, NULL,'Sans',       'Terrain constructible viabilisé, CU positif, zone pavillonnaire.',                                                                                                    'https://maps.google.com/?q=56+route+de+Fribourg+68000+Colmar',         'en vente', 11, 9,  '2025-09-20', 4.50),
('COL-010', '2 rue des Boulangers, 68000 Colmar',        'Colmar',      'Immeuble',    280, 280,   120, 0, 4, 1, 450000, 1930, 'E', 'E', 'Gaz',          'Immeuble de rapport 4 appartements + local commercial. Rénové 2020. Rendement 6.2%.',                                                                              'https://maps.google.com/?q=2+rue+des+Boulangers+68000+Colmar',         'vendu',    11, 10, '2025-08-15', 5.50),
-- Mulhouse (MLH-001 à MLH-010)
('MLH-001', '5 rue de Thann, 68100 Mulhouse',            'Mulhouse',    'Maison',      130, 130,   480, 4, 2, 5, 340000, 1998, 'C', 'D', 'Gaz',          'Maison familiale avec grand jardin, garage double, cuisine ouverte. Quartier paisible.',                                                                             'https://maps.google.com/?q=5+rue+de+Thann+68100+Mulhouse',             'en vente', 14, 11, '2025-12-20', 5.50),
('MLH-002', '14 allée des Acacias, 68100 Mulhouse',      'Mulhouse',    'Appartement',  68,  68,     0, 2, 1, 3, 179000, 2010, 'C', 'C', 'Collectif gaz','F3 au 4ème étage avec ascenseur, balcon, cave, garage. Résidence récente.',                                                                                          'https://maps.google.com/?q=14+allée+des+Acacias+68100+Mulhouse',       'en vente', 15, 12, '2026-01-05', 5.00),
('MLH-003', '29 rue de Bâle, 68100 Mulhouse',            'Mulhouse',    'Maison',      145, 145,   550, 5, 2, 6, 398000, 2003, 'B', 'C', 'Pompe chaleur','Villa contemporaine BBC, panneaux solaires, piscine couverte, triple garage.',                                                                                         'https://maps.google.com/?q=29+rue+de+Bâle+68100+Mulhouse',             'en vente', 14, 13, '2025-11-15', 6.00),
('MLH-004', '8 boulevard de l''Europe, 68100 Mulhouse',  'Mulhouse',    'Appartement',  55,  55,     0, 2, 1, 3, 149000, 1972, 'E', 'F', 'Électrique',   'F2 au 2ème, vue dégagée, digicode, caves. Idéal premier achat ou locatif.',                                                                                          'https://maps.google.com/?q=8+boulevard+de+l''Europe+68100+Mulhouse',   'en vente', 16, 14, '2026-02-15', 5.00),
('MLH-005', '3 rue du Logelbach, 68200 Mulhouse',        'Mulhouse',    'Maison',      115, 115,   320, 4, 2, 5, 295000, 1992, 'D', 'D', 'Gaz',          'Maison de ville avec cour, cave, garage. Proche école et transports.',                                                                                               'https://maps.google.com/?q=3+rue+du+Logelbach+68200+Mulhouse',         'en vente', 14, 15, '2025-10-20', 5.50),
('MLH-006', '21 rue des Roses, 68200 Mulhouse',          'Mulhouse',    'Appartement',  95,  95,     0, 3, 2, 4, 232000, 2018, 'A', 'B', 'Pompe chaleur','Grand F4 neuf, terrasse 20m², parking 2 places, cave. Résidence gardée.',                                                                                             'https://maps.google.com/?q=21+rue+des+Roses+68200+Mulhouse',           'en vente', 15, 16, '2025-09-05', 5.50),
('MLH-007', '44 route de Colmar, 68100 Mulhouse',        'Mulhouse',    'Maison',      168, 168,   700, 5, 3, 6, 520000, 2012, 'B', 'B', 'Géothermie',   'Maison architecte, matériaux nobles, piscine, domotique, garage 3 voitures.',                                                                                         'https://maps.google.com/?q=44+route+de+Colmar+68100+Mulhouse',         'en vente', 14, 17, '2025-07-10', 6.50),
('MLH-008', '6 rue du Maréchal Joffre, 68200 Mulhouse',  'Mulhouse',    'Appartement',  48,  48,     0, 1, 1, 2, 125000, 1965, 'F', 'F', 'Électrique',   'Studio rénové centre-ville, parquet, double vitrage. Investisseur ou résidence.',                                                                                    'https://maps.google.com/?q=6+rue+du+Maréchal+Joffre+68200+Mulhouse',   'en vente', 16, 18, '2026-01-22', 4.50),
('MLH-009', '11 allée des Peupliers, 68100 Mulhouse',    'Mulhouse',    'Terrain',       0,   0,   650, 0, 0, 1,  75000,    0,  NULL, NULL,'Sans',       'Terrain à bâtir dans lotissement, toutes voiries, permis constructible.',                                                                                             'https://maps.google.com/?q=11+allée+des+Peupliers+68100+Mulhouse',     'en vente', 15, 19, '2025-11-30', 4.00),
('MLH-010', '37 rue de Metz, 68100 Mulhouse',            'Mulhouse',    'Appartement',  78,  78,     0, 3, 1, 4, 198000, 2000, 'C', 'D', 'Collectif gaz','F3 lumineux, 3ème étage, 2 balcons, cave, parking. Centre-ville.',                                                                                                   'https://maps.google.com/?q=37+rue+de+Metz+68100+Mulhouse',             'vendu',    15, 20, '2025-12-10', 5.00),
-- Strasbourg (STR-001 à STR-010)
('STR-001', '8 quai des Bateliers, 67000 Strasbourg',    'Strasbourg',  'Appartement',  85,  85,     0, 2, 1, 3, 315000, 1900, 'D', 'D', 'Collectif gaz','Appartement haussmannien rénové, parquet chêne, moulures, vue canal.',                                                                                                'https://maps.google.com/?q=8+quai+des+Bateliers+67000+Strasbourg',     'en vente', 17, 21, '2025-10-15', 5.50),
('STR-002', '22 rue des Hallebardes, 67000 Strasbourg',  'Strasbourg',  'Maison',      120, 120,   300, 4, 2, 5, 460000, 2008, 'B', 'C', 'Pompe chaleur','Maison contemporaine centre-ville, terrasse toit 40m², garage, cave.',                                                                                               'https://maps.google.com/?q=22+rue+des+Hallebardes+67000+Strasbourg',   'en vente', 18, 22, '2025-12-05', 6.00),
('STR-003', '15 route du Rhin, 67100 Strasbourg',        'Strasbourg',  'Maison',      140, 140,   520, 5, 2, 6, 385000, 1995, 'C', 'D', 'Gaz',          'Pavillon avec jardin et piscine, double garage, proche tram et centre.',                                                                                             'https://maps.google.com/?q=15+route+du+Rhin+67100+Strasbourg',         'en vente', 17, 23, '2026-01-10', 5.50),
('STR-004', '4 rue du Fossé des Tailleurs, 67000 Strasbourg','Strasbourg','Appartement', 58,  58,     0, 2, 1, 3, 228000, 2020, 'A', 'A', 'Pompe chaleur','Neuf BBC, cuisine intégrée, terrasse, parking, cave. Hyper-centre.',                                                                                                  'https://maps.google.com/?q=4+rue+du+Fossé+des+Tailleurs+67000+Strasbourg','en vente',19, 24, '2025-11-20', 5.00),
('STR-005', '31 avenue des Vosges, 67000 Strasbourg',    'Strasbourg',  'Appartement', 102, 102,     0, 3, 2, 4, 380000, 1880, 'D', 'E', 'Collectif gaz','Appartement de prestige Neustadt, parquets, caves, parking, gardien.',                                                                                                'https://maps.google.com/?q=31+avenue+des+Vosges+67000+Strasbourg',     'en vente', 17, 25, '2025-09-01', 5.50),
('STR-006', '18 rue de la Nuée Bleue, 67000 Strasbourg', 'Strasbourg',  'Appartement',  42,  42,     0, 1, 1, 2, 165000, 1990, 'D', 'D', 'Collectif gaz','Studio traversant, double vitrage, cave, digicode. Proche tram Homme de Fer.',                                                                                       'https://maps.google.com/?q=18+rue+de+la+Nuée+Bleue+67000+Strasbourg',  'en vente', 18, 26, '2026-02-05', 4.50),
('STR-007', '9 rue des Orfèvres, 67000 Strasbourg',      'Strasbourg',  'Maison',      175, 175,   400, 6, 3, 7, 680000, 2015, 'A', 'B', 'Géothermie',   'Maison de maître rénovée, caves voûtées, piscine, garage 2 voitures.',                                                                                               'https://maps.google.com/?q=9+rue+des+Orfèvres+67000+Strasbourg',       'en vente', 17, 27, '2025-08-20', 6.50),
('STR-008', '3 rue du 22 Novembre, 67000 Strasbourg',    'Strasbourg',  'Appartement',  65,  65,     0, 2, 1, 3, 252000, 2010, 'B', 'C', 'Pompe chaleur','F3 en étage élevé, vue cathédrale, ascenseur, parking, cave.',                                                                                                       'https://maps.google.com/?q=3+rue+du+22+Novembre+67000+Strasbourg',     'en vente', 19, 28, '2025-10-30', 5.50),
('STR-009', '45 route de la Wantzenau, 67000 Strasbourg','Strasbourg',  'Terrain',       0,   0,   900, 0, 0, 1,  98000,    0,  NULL, NULL,'Sans',       'Terrain constructible bord de l''Ill, CU positif, zone résidentielle.',                                                                                               'https://maps.google.com/?q=45+route+de+la+Wantzenau+67000+Strasbourg', 'en vente', 18, 29, '2025-11-05', 4.00),
('STR-010', '26 rue du Maréchal Foch, 67000 Strasbourg', 'Strasbourg',  'Maison',      160, 160,   600, 5, 3, 6, 590000, 2005, 'B', 'B', 'Pompe chaleur','Résidence principale haut de gamme, 3 niveaux, cave, garage double, jardin.',                                                                                        'https://maps.google.com/?q=26+rue+du+Maréchal+Foch+67000+Strasbourg',  'vendu',    17, 30, '2025-07-15', 6.00);

-- ============================================================
-- MANDATS (15)
-- ============================================================
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut) VALUES
(1,  1,  '2026-01-15', '2026-07-15', 6.00, 'actif'),
(2,  3,  '2025-11-10', '2026-05-10', 5.00, 'actif'),
(3,  5,  '2026-02-01', '2026-08-01', 5.00, 'actif'),
(4,  7,  '2026-01-08', '2026-07-08', 6.00, 'actif'),
(5,  2,  '2026-01-20', '2026-07-20', 5.50, 'actif'),
(6,  6,  '2025-12-15', '2026-06-15', 5.50, 'actif'),
(7,  4,  '2025-10-05', '2026-04-05', 6.00, 'expiré'),
(8,  8,  '2026-02-10', '2026-08-10', 5.00, 'actif'),
(9,  9,  '2025-09-20', '2026-03-20', 4.50, 'expiré'),
(11, 11, '2025-12-20', '2026-06-20', 5.50, 'actif'),
(13, 13, '2025-11-15', '2026-05-15', 6.00, 'actif'),
(15, 15, '2025-10-20', '2026-04-20', 5.50, 'actif'),
(17, 17, '2025-07-10', '2026-01-10', 6.50, 'actif'),
(21, 21, '2025-10-15', '2026-04-15', 5.50, 'actif'),
(23, 23, '2026-01-10', '2026-07-10', 5.50, 'actif');

-- ============================================================
-- PROSPECTS (10)
-- ============================================================
INSERT INTO prospects (nom, prenom, source, interet) VALUES
('KRASNIQI',  'Elton',       'site web',           'Recherche T3 Colmar, budget 250 000€'),
('SILVA',     'Tiago',       'téléphone entrant',  'Maison avec jardin Mulhouse, budget 300 000€ — chaud'),
('ALAMI',     'Zineb',       'SeLoger',            'Appartement T2 Colmar, budget 180 000€ — froid'),
('HOXHA',     'Ilir',        'portail immobilier', 'Villa Strasbourg 500 000€+, avec terrain — chaud'),
('ROSSI',     'Francesco',   'recommandation',     'Investissement locatif Mulhouse, budget 200 000€'),
('FERREIRA',  'Tânia',       'site web',           'Premier achat T2/T3 Strasbourg, budget 200 000€'),
('CHAKIR',    'Bilal',       'salon immobilier',   'Maison plain-pied Colmar, budget 350 000€'),
('BERBERI',   'Ardit',       'Instagram',          'Appartement prestige Strasbourg, budget 400 000€'),
('MARTIN',    'Baptiste',    'Google Ads',         'Investissement patrimonial, budget 600 000€'),
('OLIVEIRA',  'Sofia',       'bouche à oreille',   'Maison familiale Mulhouse, budget 280 000€');

-- ============================================================
-- VISITES (10)
-- ============================================================
INSERT INTO visites (bien_id, client_nom, date_visite, heure, agent_nom, statut, feedback) VALUES
(1,  'Giovanni & Laura FERRARI',  '2026-01-20', '14:00', 'Pedro FERREIRA',  'réalisée',  'Très intéressés, demandent contre-offre'),
(2,  'Leonit & Liris KRASNIQI',  '2026-01-25', '10:00', 'Pedro FERREIRA',  'réalisée',  'Superficie trop petite selon eux'),
(3,  'Ahmed CHAKIR',             '2026-02-03', '11:00', 'Fatima BENALI',   'réalisée',  'Dossier en cours de constitution'),
(4,  'Thomas MULLER',            '2026-02-10', '15:00', 'Pedro FERREIRA',  'réalisée',  'Coup de cœur, offre prévue'),
(11, 'Besnik & Drita LEKA',      '2026-02-15', '09:30', 'Gentian SHEHU',   'réalisée',  'Deuxième visite, très intéressés'),
(13, 'João & Maria SILVA',       '2026-02-20', '14:30', 'Gentian SHEHU',   'réalisée',  'Proposition sous réserve de prêt'),
(21, 'Erion & Anjeza HOXHA',     '2026-02-22', '11:00', 'David THOMAS',    'réalisée',  'Très intéressés par le bien'),
(22, 'Mohammed FASSI',           '2026-02-28', '10:00', 'Amina FASSI',     'planifiée', NULL),
(5,  'Ana RODRIGUES',            '2026-03-05', '16:00', 'Pedro FERREIRA',  'planifiée', NULL),
(24, 'Valentina ROSSI',          '2026-03-08', '14:00', 'David THOMAS',    'planifiée', NULL);

-- ============================================================
-- OFFRES (5)
-- ============================================================
INSERT INTO offres (bien_id, acheteur_nom, vendeur_nom, montant_offre, date_offre, statut) VALUES
(1,  'Giovanni & Laura FERRARI', 'Thomas MULLER',       368000, '2026-02-12', 'en cours'),
(2,  'Leonit & Liris KRASNIQI',  'Ahmed CHAKIR',        262000, '2026-02-25', 'contre-offre'),
(11, 'Besnik & Drita LEKA',      'João & Maria SILVA',  322000, '2026-02-18', 'acceptée'),
(21, 'Erion & Anjeza HOXHA',     'Valentina ROSSI',     498000, '2026-02-25', 'en cours'),
(4,  'Thomas MULLER',            'Karim & Leila IDRISSI',455000,'2026-03-01', 'en cours');

-- ============================================================
-- VENTES (3)
-- ============================================================
INSERT INTO ventes (bien_id, acheteur_nom, vendeur_nom, prix_vente, date_compromis, date_acte, notaire, commission_agence, statut) VALUES
(10, 'Youssef BENALI',           'Michele COSTA',        438000, '2025-11-15', '2026-02-15', 'Me DURAND Strasbourg', 24090, 'signée'),
(20, 'Michele COSTA',            'Teresa FERREIRA',      192000, '2025-12-10', '2026-03-10', 'Me MARTIN Mulhouse',    9600, 'en cours'),
(30, 'François MEYER',           'Nadia & Omar CHAKIR',  561000, '2025-10-20', '2026-01-20', 'Me WEBER Strasbourg',  33660, 'signée');

-- ============================================================
-- FACTURES FOURNISSEURS (10)
-- ============================================================
INSERT INTO factures_fournisseurs (numero_facture, fournisseur, montant_ht, tva, montant_ttc, date_facture, date_echeance, statut, anomalie) VALUES
('F-2026-001', 'PRINTEX COMMUNICATION',   500.00, 20.00,  600.00, '2026-01-15', '2026-02-14', 'litigieuse', 'Adresse de facturation absente sur la facture'),
('F-2026-002', 'EDF ALSACE',             1000.00, 20.00, 1200.00, '2026-01-20', '2026-02-19', 'payée',      NULL),
('F-2026-003', 'ORANGE BUSINESS',         450.00, 20.00,  540.00, '2026-01-25', '2026-02-24', 'payée',      NULL),
('F-2026-004', 'SELOGER / LOGIC-IMMO',    800.00, 20.00,  960.00, '2026-02-01', '2026-03-03', 'validée',    NULL),
('F-2026-005', 'RAPIDO NETTOYAGE',        350.00, 15.00,  402.50, '2026-02-05', '2026-03-07', 'litigieuse', 'TVA calculée à 15% au lieu de 20% — erreur de calcul'),
('F-2026-006', 'COGIP FOURNITURES',       280.00, 20.00,  336.00, '2026-02-10', '2026-03-12', 'reçue',      NULL),
('F-2026-007', 'ALLIANZ ASSURANCE PRO', 1800.00, 20.00, 2160.00, '2026-02-15', '2026-03-17', 'validée',    NULL),
('F-2026-008', 'TELECOM ALSACE',          390.00, 20.00,  468.00, '2026-02-20', '2026-03-22', 'reçue',      NULL),
('F-2026-009', 'GOOGLE ADS FRANCE',       650.00, 20.00,  780.00, '2026-02-28', '2026-03-30', 'reçue',      NULL),
('F-2026-010', 'MAIRIE COLMAR — TAXE',  1200.00,  0.00, 1200.00, '2026-03-01', '2026-03-31', 'litigieuse', 'Montant contesté — en attente de justificatif de la mairie');

-- ============================================================
-- CARTES PROFESSIONNELLES (9 commerciaux)
-- ============================================================
INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut) VALUES
('Fatima BENALI',   'CPI-68-2024-1234', '2027-03-01', 'CCI Alsace',      'valide'),
('Pedro FERREIRA',  'CPI-68-2023-5678', '2026-09-15', 'CCI Alsace',      'valide'),
('Léa KLEIN',       'CPI-68-2024-9012', '2027-06-01', 'CCI Alsace',      'valide'),
('Gentian SHEHU',   'CPI-68-2022-3456', '2025-11-30', 'CCI Alsace',      'expiré'),
('Sofia COSTA',     'CPI-68-2024-7890', '2027-08-16', 'CCI Alsace',      'valide'),
('Lucas WEBER',     'CPI-68-2023-2345', '2026-01-09', 'CCI Alsace',      'en renouvellement'),
('David THOMAS',    'CPI-67-2023-6789', '2026-03-01', 'CCI Bas-Rhin',    'en renouvellement'),
('Amina FASSI',     'CPI-67-2024-1011', '2027-10-01', 'CCI Bas-Rhin',    'valide'),
('Hugo OLIVEIRA',   'CPI-67-2024-1213', '2027-06-15', 'CCI Bas-Rhin',    'valide');

-- ============================================================
-- ASSURANCES RC (9 commerciaux)
-- ============================================================
INSERT INTO assurances_rc (salarie_nom, compagnie, numero_police, montant_garantie, date_debut, date_fin, statut) VALUES
('Fatima BENALI',   'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000, '2026-01-01', '2026-12-31', 'valide'),
('Pedro FERREIRA',  'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000, '2026-01-01', '2026-12-31', 'valide'),
('Léa KLEIN',       'ALLIANZ Professionnels', 'ALLZ-RC-COL-2026-001', 1500000, '2026-01-01', '2026-12-31', 'valide'),
('Gentian SHEHU',   'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000, '2025-09-01', '2026-08-31', 'valide'),
('Sofia COSTA',     'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000, '2025-09-01', '2026-08-31', 'valide'),
('Lucas WEBER',     'AXA Entreprises',        'AXA-RC-MLH-2025-088',   500000, '2025-09-01', '2026-08-31', 'valide'),
('David THOMAS',    'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000, '2026-01-01', '2026-12-31', 'valide'),
('Amina FASSI',     'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000, '2026-01-01', '2026-12-31', 'valide'),
('Hugo OLIVEIRA',   'MAIF Professionnels',    'MAIF-RC-STR-2026-332',  750000, '2026-01-01', '2026-12-31', 'valide');

-- ============================================================
-- FORMATIONS (14)
-- ============================================================
INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation, statut) VALUES
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
-- CONGÉS (20 — 1 par salarié)
-- ============================================================
INSERT INTO conges (salarie_nom, type, date_debut, date_fin, jours, statut) VALUES
('Christophe DIRINGER', 'CP',      '2026-07-14', '2026-08-01', 14, 'approuvé'),
('Elena ROSSI',          'CP',      '2026-08-03', '2026-08-21', 14, 'en attente'),
('Maria SILVA',          'CP',      '2026-07-06', '2026-07-18',  9, 'approuvé'),
('Laura MEYER',          'CP',      '2026-08-10', '2026-08-21',  8, 'en attente'),
('Youssef ALAMI',        'RTT',     '2026-06-02', '2026-06-06',  5, 'approuvé'),
('Julie BERNARD',        'CP',      '2026-07-06', '2026-07-18',  9, 'approuvé'),
('Arben HOXHA',          'CP',      '2026-08-17', '2026-08-28',  8, 'en attente'),
('Carla SANTOS',         'maladie', '2026-02-10', '2026-02-14',  5, 'approuvé'),
('Claire MARTIN',        'CP',      '2026-07-20', '2026-08-07', 13, 'approuvé'),
('Marco GRECO',          'RTT',     '2026-05-30', '2026-06-03',  5, 'approuvé'),
('Fatima BENALI',        'CP',      '2026-08-03', '2026-08-14',  8, 'approuvé'),
('Pedro FERREIRA',       'CP',      '2026-07-27', '2026-08-07',  8, 'en attente'),
('Léa KLEIN',            'CP',      '2026-08-24', '2026-09-04',  8, 'en attente'),
('Gentian SHEHU',        'CP',      '2026-07-20', '2026-08-07', 13, 'approuvé'),
('Sofia COSTA',          'CP',      '2026-08-03', '2026-08-14',  8, 'en attente'),
('Lucas WEBER',          'RTT',     '2026-04-14', '2026-04-18',  5, 'approuvé'),
('David THOMAS',         'CP',      '2026-07-27', '2026-08-14', 13, 'approuvé'),
('Amina FASSI',          'CP',      '2026-08-10', '2026-08-21',  8, 'en attente'),
('Hugo OLIVEIRA',        'CP',      '2026-07-13', '2026-07-31', 13, 'approuvé'),
('Valentina ROMANO',     'CP',      '2026-08-17', '2026-08-28',  8, 'en attente');

-- ============================================================
-- FIN DU SEED — LA BELLE AGENCE
-- Dernière mise à jour : mars 2026
-- ============================================================

-- ============================================================
-- SEED DATA — LA BELLE AGENCE
-- Données réalistes pour l'environnement pédagogique
-- À exécuter après services_tables.sql
-- ============================================================

-- ============================================================
-- CLIENTS (50 entrées)
-- ============================================================
INSERT INTO clients (nom, prenom, budget, type_recherche, telephone, email) VALUES
('Martin',      'Sophie',    320000, 'achat',          '06 12 34 56 78', 'sophie.martin@gmail.com'),
('Dubois',      'Pierre',    180000, 'achat',          '06 23 45 67 89', 'pierre.dubois@orange.fr'),
('Bernard',     'Marie',     750000, 'investissement',  '07 34 56 78 90', 'marie.bernard@yahoo.fr'),
('Thomas',      'Julien',    250000, 'achat',          '06 45 67 89 01', 'julien.thomas@gmail.com'),
('Petit',       'Isabelle',   900,   'location',       '07 56 78 90 12', 'isabelle.petit@hotmail.fr'),
('Robert',      'François',  450000, 'achat',          '06 67 89 01 23', 'francois.robert@sfr.fr'),
('Richard',     'Catherine', 1200000,'investissement',  '07 78 90 12 34', 'catherine.richard@gmail.com'),
('Leroy',       'Nicolas',   195000, 'achat',          '06 89 01 23 45', 'nicolas.leroy@orange.fr'),
('Moreau',      'Sylvie',    850,    'location',       '07 90 12 34 56', 'sylvie.moreau@gmail.com'),
('Simon',       'David',     380000, 'achat',          '06 01 23 45 67', 'david.simon@free.fr'),
('Laurent',     'Nathalie',  280000, 'achat',          '07 12 34 56 78', 'nathalie.laurent@yahoo.fr'),
('Lefebvre',    'Stéphane',  600000, 'investissement',  '06 23 45 67 89', 'stephane.lefebvre@sfr.fr'),
('Michel',      'Christine',  700,   'location',       '07 34 56 78 90', 'christine.michel@gmail.com'),
('Garcia',      'Patrick',   220000, 'achat',          '06 45 67 89 01', 'patrick.garcia@orange.fr'),
('Martinez',    'Véronique', 960000, 'investissement',  '07 56 78 90 12', 'veronique.martinez@gmail.com'),
('Roux',        'Philippe',  330000, 'achat',          '06 67 89 01 23', 'philippe.roux@hotmail.fr'),
('Vincent',     'Anne',      1100,   'location',       '07 78 90 12 34', 'anne.vincent@free.fr'),
('Dupont',      'Éric',      410000, 'achat',          '06 89 01 23 45', 'eric.dupont@gmail.com'),
('Fontaine',    'Laure',     175000, 'achat',          '07 90 12 34 56', 'laure.fontaine@orange.fr'),
('Girard',      'Michel',    520000, 'investissement',  '06 01 23 45 67', 'michel.girard@yahoo.fr'),
('Bonnet',      'Sandrine',  295000, 'achat',          '07 12 34 56 78', 'sandrine.bonnet@sfr.fr'),
('Dupuis',      'Thierry',    780,   'location',       '06 23 45 67 89', 'thierry.dupuis@gmail.com'),
('Lambert',     'Hélène',    650000, 'investissement',  '07 34 56 78 90', 'helene.lambert@orange.fr'),
('Chevalier',   'Bruno',     260000, 'achat',          '06 45 67 89 01', 'bruno.chevalier@gmail.com'),
('Rousseau',    'Céline',    350000, 'achat',          '07 56 78 90 12', 'celine.rousseau@hotmail.fr'),
('Muller',      'Klaus',     480000, 'investissement',  '06 67 89 01 23', 'klaus.muller@gmail.com'),
('Schmidt',     'Ingrid',    290000, 'achat',          '07 78 90 12 34', 'ingrid.schmidt@free.fr'),
('Weber',       'Hans',       950,   'location',       '06 89 01 23 45', 'hans.weber@sfr.fr'),
('Fischer',     'Monika',    185000, 'achat',          '07 90 12 34 56', 'monika.fischer@gmail.com'),
('Becker',      'Jürgen',    780000, 'investissement',  '06 01 23 45 67', 'jurgen.becker@yahoo.fr'),
('Maier',       'Ursula',    315000, 'achat',          '07 12 34 56 78', 'ursula.maier@orange.fr'),
('Schneider',   'Petra',     820,    'location',       '06 23 45 67 89', 'petra.schneider@gmail.com'),
('Hoffmann',    'Dieter',    420000, 'achat',          '07 34 56 78 90', 'dieter.hoffmann@sfr.fr'),
('Wagner',      'Karin',     540000, 'investissement',  '06 45 67 89 01', 'karin.wagner@gmail.com'),
('Braun',       'Wolfgang',  275000, 'achat',          '07 56 78 90 12', 'wolfgang.braun@free.fr'),
('Koch',        'Brigitte',   680,   'location',       '06 67 89 01 23', 'brigitte.koch@hotmail.fr'),
('Bauer',       'Heinrich',  360000, 'achat',          '07 78 90 12 34', 'heinrich.bauer@gmail.com'),
('Richter',     'Elisabeth', 1050000,'investissement',  '06 89 01 23 45', 'elisabeth.richter@orange.fr'),
('Klein',       'Thomas',    230000, 'achat',          '07 90 12 34 56', 'thomas.klein@yahoo.fr'),
('Wolf',        'Helga',      880,   'location',       '06 01 23 45 67', 'helga.wolf@sfr.fr'),
('Schäfer',     'Rainer',    490000, 'achat',          '07 12 34 56 78', 'rainer.schafer@gmail.com'),
('Zimmermann',  'Gisela',    155000, 'achat',          '06 23 45 67 89', 'gisela.zimmermann@free.fr'),
('Krüger',      'Manfred',   670000, 'investissement',  '07 34 56 78 90', 'manfred.kruger@orange.fr'),
('Lehmann',     'Renate',    310000, 'achat',          '06 45 67 89 01', 'renate.lehmann@gmail.com'),
('Köhler',      'Günter',     720,   'location',       '07 56 78 90 12', 'gunter.kohler@yahoo.fr'),
('Hartmann',    'Waltraud',  385000, 'achat',          '06 67 89 01 23', 'waltraud.hartmann@sfr.fr'),
('Lange',       'Eckhard',   580000, 'investissement',  '07 78 90 12 34', 'eckhard.lange@gmail.com'),
('Schwarz',     'Marlene',   245000, 'achat',          '06 89 01 23 45', 'marlene.schwarz@orange.fr'),
('Krause',      'Horst',      980,   'location',       '07 90 12 34 56', 'horst.krause@hotmail.fr'),
('Bauer',       'Gertrude',  460000, 'achat',          '06 01 23 45 67', 'gertrude.bauer2@gmail.com')
ON CONFLICT DO NOTHING;

-- ============================================================
-- BIENS IMMOBILIERS (30 entrées)
-- ============================================================
INSERT INTO biens (adresse, type, surface, prix, nb_pieces, description) VALUES
('12 rue des Fleurs, Colmar',           'appartement', 65,   195000,  3, 'Appartement lumineux en centre-ville, parquet chêne, balcon'),
('8 allée des Roses, Mulhouse',         'appartement', 48,   142000,  2, 'Studio rénové, cuisine équipée, vue dégagée'),
('45 avenue de Strasbourg, Colmar',     'maison',      120,  380000,  5, 'Maison individuelle avec jardin 400m², garage double'),
('3 rue du Marché, Strasbourg',         'appartement', 90,   320000,  4, 'Grand appartement centre historique, cave, parking'),
('27 boulevard de l''Europe, Mulhouse', 'bureau',      200,  450000,  0, 'Plateau de bureau open space, climatisation, fibre'),
('15 rue Principale, Colmar',           'appartement', 55,   168000,  2, 'F2 au 3ème étage, ascenseur, digicode'),
('89 route du Rhin, Strasbourg',        'maison',      180,  620000,  7, 'Villa contemporaine piscine, garage, alarme'),
('4 impasse des Lilas, Mulhouse',       'appartement', 72,   210000,  3, 'F3 avec terrasse 20m², parking souterrain'),
('33 avenue de la Paix, Colmar',        'terrain',     800,  95000,   0, 'Terrain constructible viabilisé, CU en cours'),
('67 rue de la Liberté, Strasbourg',    'appartement', 38,   135000,  1, 'Studio centre-ville, idéal investissement locatif'),
('21 chemin des Vignes, Colmar',        'maison',      95,   295000,  4, 'Maison de village alsacienne rénovée, cave à vins'),
('56 rue du Général de Gaulle, Mulhouse','appartement',110,  285000,  5, 'Grand F4 duplex, deux salles de bain, box'),
('11 avenue Kennedy, Strasbourg',       'bureau',      350,  780000,  0, 'Immeuble de bureaux, 3 niveaux, ascenseur, parking 20 pl'),
('2 rue des Tanneurs, Colmar',          'appartement', 62,   198000,  3, 'F3 au 1er étage, loggia, cave, digicode'),
('44 route de Mulhouse, Strasbourg',    'maison',      145,  495000,  6, 'Maison années 30 entièrement rénovée, jardin 600m²'),
('19 place du Marché, Mulhouse',        'appartement', 80,   235000,  4, 'F4 lumineux vue place, parking inclus'),
('77 rue de la Forêt, Colmar',          'terrain',     1200, 78000,   0, 'Terrain agricole, non constructible, beau potentiel'),
('36 boulevard de l''Ill, Strasbourg',  'appartement', 70,   265000,  3, 'F3 rez-de-chaussée avec jardin privatif 80m²'),
('8 rue Sainte-Croix, Colmar',          'appartement', 55,   175000,  2, 'F2 immeuble récent 2018, DPE A, sans travaux'),
('63 avenue des Vosges, Strasbourg',    'maison',      220,  895000,  8, 'Propriété exceptionnelle parc 2000m², piscine chauffée'),
('14 rue de Bâle, Mulhouse',            'appartement', 45,   138000,  2, 'F2 calme, cuisine américaine, cave'),
('52 route de Colmar, Strasbourg',      'bureau',      120,  268000,  0, 'Local commercial pied d''immeuble, vitrine 8m'),
('29 rue de l''Église, Colmar',         'maison',      85,   245000,  4, 'Maison mitoyenne, chauffage au sol, jardin 150m²'),
('7 avenue de Bâle, Mulhouse',          'appartement', 95,   278000,  4, 'F4 6ème étage vue panoramique, double garage'),
('41 rue du Logelbach, Colmar',         'appartement', 60,   188000,  3, 'F3 rez-de-jardin, terrasse 30m², cave, grenier'),
('18 place des Victoires, Strasbourg',  'appartement', 130,  420000,  5, 'Grand F5 haussmannien, parquet, cheminées'),
('5 rue de la Gare, Mulhouse',          'bureau',      80,   175000,  0, 'Bureau proche gare, idéal profession libérale'),
('33 rue des Acacias, Colmar',          'maison',      160,  520000,  6, 'Belle propriété avec dépendance, piscine hors-sol'),
('9 quai des Bateliers, Strasbourg',    'appartement', 75,   295000,  3, 'F3 bord de l''Ill, vue eau, balcon, cave'),
('71 avenue du Rhin, Mulhouse',         'terrain',     600,  65000,   0, 'Terrain en zone UC, constructible, raccordé')
ON CONFLICT DO NOTHING;

-- ============================================================
-- SALARIÉS (25 entrées)
-- ============================================================
INSERT INTO salaries (nom, prenom, poste, service, date_embauche) VALUES
('Moreau',    'Jean-Luc',    'Directeur Général',        'Direction',   '2015-01-15'),
('Dupont',    'Martine',     'Responsable RH',            'RH',          '2016-03-01'),
('Bernard',   'Olivier',     'Responsable Finance',       'Finance',     '2016-06-15'),
('Lambert',   'Émilie',      'Responsable Marketing',     'Marketing',   '2017-02-01'),
('Girard',    'Antoine',     'Responsable IT',            'IT',          '2017-09-01'),
('Fontaine',  'Lucie',       'Conseillère Patrimoine',    'Commercial',  '2018-01-10'),
('Petit',     'Marc',        'Agent Immobilier',          'Commercial',  '2018-04-15'),
('Rousseau',  'Clara',       'Assistante RH',             'RH',          '2019-01-07'),
('Vincent',   'Paul',        'Comptable',                 'Finance',     '2019-03-01'),
('Simon',     'Élodie',      'Chargée de Marketing',      'Marketing',   '2019-07-15'),
('Leroy',     'Christophe',  'Technicien IT',             'IT',          '2019-10-01'),
('Roux',      'Valérie',     'Conseillère Patrimoine',    'Commercial',  '2020-02-01'),
('Muller',    'Stefan',      'Agent Immobilier',          'Commercial',  '2020-05-01'),
('Martin',    'Sabine',      'Assistante Administrative', 'Direction',   '2020-09-01'),
('Thomas',    'Alexis',      'Chargé de Conformité',      'Conformité',  '2021-01-04'),
('Chevalier', 'Nadia',       'Conseillère Patrimoine',    'Commercial',  '2021-03-15'),
('Robert',    'Sébastien',   'Développeur Web',           'IT',          '2021-06-01'),
('Richard',   'Florence',    'Responsable Conformité',    'Conformité',  '2021-09-01'),
('Garcia',    'Pedro',       'Agent Immobilier',          'Commercial',  '2022-01-10'),
('Laurent',   'Anaïs',       'Chargée RH',               'RH',          '2022-03-01'),
('Lefebvre',  'Guillaume',   'Analyste Finance',          'Finance',     '2022-07-01'),
('Schmidt',   'Ingrid',      'Community Manager',         'Marketing',   '2022-10-03'),
('Bonnet',    'Camille',     'Agent Immobilier',          'Commercial',  '2023-01-16'),
('Dupuis',    'Théo',        'Support IT',                'IT',          '2023-04-01'),
('Fischer',   'Élise',       'Assistante Comptable',      'Finance',     '2023-09-01')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MANDATS (15 entrées — référencent biens et clients existants)
-- Les IDs supposent que les biens et clients ont été insérés dans l'ordre
-- ============================================================
INSERT INTO mandats (client_id, bien_id, date_debut, date_fin, commission, statut) VALUES
(1,  1,  '2024-01-15', '2025-01-15', 5.00, 'actif'),
(2,  2,  '2024-02-01', '2025-02-01', 5.00, 'actif'),
(3,  3,  '2024-01-10', '2024-07-10', 4.50, 'expiré'),
(4,  4,  '2024-03-01', '2025-03-01', 5.00, 'actif'),
(6,  7,  '2024-04-15', '2025-04-15', 4.00, 'actif'),
(8,  8,  '2024-05-01', '2025-05-01', 5.00, 'actif'),
(10, 10, '2024-02-20', '2025-02-20', 5.00, 'actif'),
(12, 11, '2024-06-01', '2025-06-01', 4.50, 'actif'),
(14, 14, '2024-07-01', '2024-12-31', 5.00, 'expiré'),
(16, 16, '2024-08-15', '2025-08-15', 5.00, 'actif'),
(18, 18, '2024-09-01', '2025-09-01', 4.00, 'actif'),
(20, 20, '2024-10-01', '2025-10-01', 4.50, 'actif'),
(22, 22, '2024-11-01', '2025-11-01', 5.00, 'actif'),
(24, 24, '2024-12-01', '2025-12-01', 5.00, 'actif'),
(26, 26, '2025-01-10', '2026-01-10', 4.50, 'actif')
ON CONFLICT DO NOTHING;

-- ============================================================
-- VISITES (10 entrées)
-- ============================================================
INSERT INTO visites (bien_id, client_nom, date_visite, heure, agent_nom, statut, feedback) VALUES
(1,  'Sophie Martin',   '2024-11-05', '10:00', 'Marc Petit',       'réalisée',  'Très intéressée, question sur travaux balcon'),
(3,  'Pierre Dubois',   '2024-11-08', '14:30', 'Pedro Garcia',     'réalisée',  'Budget insuffisant pour ce bien'),
(7,  'Marie Bernard',   '2024-11-12', '11:00', 'Valérie Roux',     'réalisée',  'Coup de cœur, offre en cours de préparation'),
(4,  'David Simon',     '2024-11-15', '09:00', 'Marc Petit',       'réalisée',  'Souhaite une 2ème visite avec son architecte'),
(10, 'Nicolas Leroy',   '2024-11-20', '15:00', 'Stefan Muller',    'réalisée',  'Trop petit, cherche au moins 50m²'),
(2,  'Sylvie Moreau',   '2024-11-25', '10:30', 'Camille Bonnet',   'annulée',   'Annulation client (maladie)'),
(11, 'François Robert', '2024-12-02', '14:00', 'Pedro Garcia',     'réalisée',  'Intéressé, négocie le prix'),
(14, 'Nathalie Laurent','2024-12-10', '11:30', 'Marc Petit',       'planifiée', NULL),
(18, 'Stéphane Lefebvre','2024-12-15','09:30', 'Stefan Muller',    'planifiée', NULL),
(20, 'Patrick Garcia',  '2024-12-20', '16:00', 'Camille Bonnet',   'planifiée', NULL)
ON CONFLICT DO NOTHING;

-- ============================================================
-- FACTURES FOURNISSEURS (20 entrées, dont F-2024-123 avec anomalie)
-- ============================================================
INSERT INTO factures_fournisseurs (numero_facture, fournisseur, montant_ht, tva, montant_ttc, date_facture, date_echeance, statut, anomalie) VALUES
('F-2024-001', 'BUREAU PLUS SARL',       1200.00,  20.00, 1440.00,  '2024-01-15', '2024-02-15', 'payée',      NULL),
('F-2024-002', 'NETTOYAGE PRO',           450.00,  20.00,  540.00,  '2024-01-20', '2024-02-20', 'payée',      NULL),
('F-2024-003', 'TELECOM ALSACE',          380.00,  20.00,  456.00,  '2024-02-01', '2024-03-01', 'payée',      NULL),
('F-2024-004', 'IMPRIMERIE COLORPRESS',   890.00,  20.00, 1068.00,  '2024-02-10', '2024-03-10', 'payée',      NULL),
('F-2024-005', 'EDF ENTREPRISES',        2100.00,  20.00, 2520.00,  '2024-03-01', '2024-04-01', 'payée',      NULL),
('F-2024-006', 'ASSUR IMMO PLUS',        5400.00,  20.00, 6480.00,  '2024-03-15', '2024-04-15', 'payée',      NULL),
('F-2024-007', 'MAIRIE DE COLMAR',        180.00,   0.00,  180.00,  '2024-04-01', '2024-05-01', 'payée',      NULL),
('F-2024-008', 'LOGICIELS RH EXPERT',    2400.00,  20.00, 2880.00,  '2024-04-10', '2024-05-10', 'payée',      NULL),
('F-2024-009', 'GARAGE AUTO MULHOUSE',    650.00,  20.00,  780.00,  '2024-05-01', '2024-06-01', 'payée',      NULL),
('F-2024-010', 'TRAITEUR SAVEURS D''ALS',1800.00,  10.00, 1980.00,  '2024-05-20', '2024-06-20', 'payée',      NULL),
('F-2024-011', 'SECURITE PROTECT PRO',   3200.00,  20.00, 3840.00,  '2024-06-01', '2024-07-01', 'payée',      NULL),
('F-2024-012', 'PHOTOGRAPHE MORAND',      750.00,  20.00,  900.00,  '2024-06-15', '2024-07-15', 'payée',      NULL),
('F-2024-013', 'AGENCE PUBLICITAIRE LBA', 4500.00, 20.00, 5400.00,  '2024-07-01', '2024-08-01', 'validée',    NULL),
('F-2024-014', 'FOURNITURES BUREAU ALS',   320.00, 20.00,  384.00,  '2024-07-15', '2024-08-15', 'payée',      NULL),
('F-2024-015', 'EXPERT COMPTABLE HUBER',  1200.00, 20.00, 1440.00,  '2024-08-01', '2024-09-01', 'validée',    NULL),
('F-2024-016', 'INTERNET FIBRE ALSACE',    480.00, 20.00,  576.00,  '2024-08-15', '2024-09-15', 'validée',    NULL),
('F-2024-017', 'FORMATIONS IMMO CONSEIL', 2800.00, 20.00, 3360.00,  '2024-09-01', '2024-10-01', 'validée',    NULL),
('F-2024-018', 'NOTAIRE GRUBER & ASSOC',  1650.00,  0.00, 1650.00,  '2024-09-15', '2024-10-15', 'reçue',      NULL),
('F-2024-019', 'TRANSPORT COLMAR EXP',     290.00, 20.00,  348.00,  '2024-10-01', '2024-11-01', 'reçue',      NULL),
('F-2024-123', 'PRINTEX COMMUNICATION',   3850.00, 20.00, 4620.00,  '2024-10-15', '2024-11-15', 'litigieuse', 'Adresse de facturation manquante — à régulariser avant paiement')
ON CONFLICT DO NOTHING;

-- ============================================================
-- TEMPLATES DE DOCUMENTS (20 entrées)
-- ============================================================
INSERT INTO templates_documents (type, service, nom, contenu_template, exemple_rempli) VALUES
('email', 'Commercial', 'Email de bienvenue client',
  'Objet : Bienvenue chez La Belle Agence

Madame, Monsieur [NOM],

Nous vous remercions de votre confiance et sommes ravis de vous accueillir parmi nos clients.

Notre conseiller [PRENOM_CONSEILLER] [NOM_CONSEILLER] sera votre interlocuteur privilégié pour tous vos projets immobiliers et patrimoniaux.

N''hésitez pas à le contacter au [TELEPHONE_CONSEILLER].

Cordialement,
L''équipe de La Belle Agence',

  'Objet : Bienvenue chez La Belle Agence

Madame MARTIN,

Nous vous remercions de votre confiance et sommes ravis de vous accueillir parmi nos clients.

Notre conseillère Lucie FONTAINE sera votre interlocutrice privilégiée pour tous vos projets immobiliers et patrimoniaux.

N''hésitez pas à la contacter au 06 12 34 56 78.

Cordialement,
L''équipe de La Belle Agence'),

('email', 'Commercial', 'Confirmation de visite',
  'Objet : Confirmation de votre visite — [ADRESSE_BIEN]

Madame, Monsieur [NOM],

Nous confirmons votre visite du bien situé [ADRESSE_BIEN] :
- Date : [DATE_VISITE]
- Heure : [HEURE_VISITE]
- Agent : [NOM_AGENT]

Merci de prévoir une pièce d''identité.

À bientôt,
La Belle Agence',

  'Objet : Confirmation de votre visite — 12 rue des Fleurs, Colmar

Madame MARTIN,

Nous confirmons votre visite du bien situé 12 rue des Fleurs, Colmar :
- Date : 5 novembre 2024
- Heure : 10h00
- Agent : Marc PETIT

Merci de prévoir une pièce d''identité.

À bientôt,
La Belle Agence'),

('contrat', 'Commercial', 'Mandat de vente exclusif',
  'MANDAT DE VENTE EXCLUSIF

Entre les soussignés :
- M./Mme [NOM_VENDEUR], [ADRESSE_VENDEUR], ci-après "le Mandant"
- La Belle Agence, SARL au capital de 50 000€, ci-après "le Mandataire"

Le Mandant confie exclusivement au Mandataire la mission de vendre :
Bien : [ADRESSE_BIEN]
Prix : [PRIX_VENTE] €
Durée : [DUREE] mois à compter du [DATE_DEBUT]
Honoraires : [TAUX_COMMISSION]% TTC du prix de vente

Fait à [VILLE], le [DATE]
Signature Mandant :                    Signature Mandataire :',
  NULL),

('courrier', 'RH', 'Lettre de convocation entretien',
  '[LIEU], le [DATE]

[NOM] [PRENOM]
[ADRESSE]

Objet : Convocation à un entretien professionnel

Madame, Monsieur,

Nous vous convoquons à un entretien professionnel qui se tiendra :
- Date : [DATE_ENTRETIEN]
- Heure : [HEURE_ENTRETIEN]
- Lieu : [LIEU_ENTRETIEN]
- Avec : [NOM_RRH]

Cet entretien portera sur [OBJET_ENTRETIEN].

Veuillez agréer, Madame, Monsieur, l''expression de nos salutations distinguées.

[NOM_RRH]
Responsable des Ressources Humaines',
  NULL),

('rh', 'RH', 'Attestation de travail',
  'ATTESTATION DE TRAVAIL

La Belle Agence, SARL au capital de 50 000€,
Siège social : 15 rue de la Paix, 68300 Saint-Louis
N° SIRET : 123 456 789 00012

Atteste que :

M./Mme [NOM] [PRENOM]
Né(e) le [DATE_NAISSANCE]

est employé(e) en qualité de [POSTE] au sein de notre entreprise depuis le [DATE_EMBAUCHE].

Type de contrat : [TYPE_CONTRAT]
Salaire brut mensuel : [SALAIRE] €

Cette attestation est délivrée à la demande de l''intéressé(e) pour servir et valoir ce que de droit.

Fait à Saint-Louis, le [DATE]

La Direction',
  NULL),

('email', 'RH', 'Email de confirmation de congés',
  'Objet : Confirmation de vos congés

Bonjour [PRENOM],

Nous vous confirmons l''acceptation de votre demande de congés :
- Type : [TYPE_CONGE]
- Du : [DATE_DEBUT]
- Au : [DATE_FIN]
- Durée : [NB_JOURS] jour(s)

Bon repos !

Le Service RH',
  NULL),

('facture', 'Finance', 'Facture d''honoraires agence',
  'FACTURE N° [NUMERO_FACTURE]

La Belle Agence
15 rue de la Paix, 68300 Saint-Louis
SIRET : 123 456 789 00012
TVA : FR12 123 456 789

FACTURÉ À :
[NOM_CLIENT]
[ADRESSE_CLIENT]

Désignation : Honoraires de négociation — [ADRESSE_BIEN]
Prix de vente : [PRIX_VENTE] €
Taux d''honoraires : [TAUX]% TTC
Montant HT : [MONTANT_HT] €
TVA 20% : [MONTANT_TVA] €
TOTAL TTC : [MONTANT_TTC] €

Date d''émission : [DATE]
Échéance : [ECHEANCE]

Règlement par virement sur IBAN : FR76 1234 5678 9012 3456 7890 123',
  NULL),

('email', 'Finance', 'Relance facture impayée',
  'Objet : Relance — Facture [NUMERO_FACTURE] en attente de règlement

Madame, Monsieur,

Sauf erreur de notre part, la facture ci-dessous demeure impayée à ce jour :
- N° facture : [NUMERO_FACTURE]
- Date d''émission : [DATE_FACTURE]
- Montant TTC : [MONTANT_TTC] €
- Échéance initiale : [DATE_ECHEANCE]

Nous vous remercions de bien vouloir régulariser cette situation dans les meilleurs délais.

En cas de difficulté, n''hésitez pas à nous contacter.

Le Service Comptabilité
La Belle Agence',
  NULL),

('email', 'Marketing', 'Email de prospection clients',
  'Objet : Découvrez nos biens exclusifs du mois

Madame, Monsieur [NOM],

La Belle Agence a le plaisir de vous présenter une sélection exclusive de biens immobiliers disponibles ce mois-ci dans votre secteur de recherche.

[LISTE_BIENS]

Ces biens correspondent à votre budget de [BUDGET] € et à vos critères : [CRITERES].

Contactez-nous dès aujourd''hui pour organiser une visite.

L''équipe commerciale de La Belle Agence
Tél : 03 89 XX XX XX',
  NULL),

('contrat', 'Marketing', 'Bon de commande prestataire',
  'BON DE COMMANDE N° [NUMERO_BC]

La Belle Agence, ci-après "le Client"
[NOM_PRESTATAIRE], ci-après "le Prestataire"

Désignation de la prestation : [DESCRIPTION]
Montant HT : [MONTANT_HT] €
TVA [TAUX_TVA]% : [MONTANT_TVA] €
TOTAL TTC : [MONTANT_TTC] €

Délai de réalisation : [DELAI]
Lieu de livraison : [ADRESSE_LIVRAISON]

Conditions de règlement : [CONDITIONS_PAIEMENT]

Fait en deux exemplaires à [VILLE], le [DATE]',
  NULL),

('courrier', 'Conformité', 'Demande de renouvellement carte professionnelle',
  '[LIEU], le [DATE]

CCI [DEPARTEMENT]
Service Cartes Professionnelles
[ADRESSE_CCI]

Objet : Renouvellement carte professionnelle — N° [NUMERO_CARTE]

Madame, Monsieur,

Je soussigné(e) [NOM_TITULAIRE], titulaire de la carte professionnelle N° [NUMERO_CARTE] arrivant à expiration le [DATE_EXPIRATION], sollicite le renouvellement de ladite carte.

Je joins à ce courrier les justificatifs requis :
☐ Attestation de formation continue DDA (minimum 14h/an)
☐ Attestation d''assurance RC professionnelle en cours de validité
☐ Justificatif de domicile
☐ Photo d''identité

Dans l''attente de votre réponse, je reste à votre disposition.

Cordialement,
[NOM_TITULAIRE]',
  NULL),

('rh', 'Conformité', 'Attestation formation DDA',
  'ATTESTATION DE FORMATION

L''organisme [NOM_ORGANISME], certifié Qualiopi, atteste que :

M./Mme [NOM_STAGIAIRE]
Salarié(e) de : La Belle Agence

a suivi avec assiduité la formation :
Intitulé : [INTITULE_FORMATION]
Durée : [DUREE] heures
Date(s) : [DATES_FORMATION]
Lieu : [LIEU_FORMATION]

Cette formation est reconnue au titre de la formation continue DDA (Directive sur la Distribution d''Assurances) / Loi ALUR selon les dispositions en vigueur.

Fait à [LIEU], le [DATE]

Le Responsable Pédagogique
[NOM_RESPONSABLE]',
  NULL),

('email', 'Conformité', 'Notification expiration carte pro',
  'Objet : ⚠️ Votre carte professionnelle expire dans [NB_JOURS] jours

Bonjour [PRENOM],

Nous vous informons que votre carte professionnelle N° [NUMERO_CARTE] expire le [DATE_EXPIRATION].

Pour la renouveler, vous devez fournir :
1. Attestation de 14h de formation continue DDA
2. Attestation d''assurance RC professionnelle valide
3. Dossier complet à déposer auprès de la CCI

Merci de prendre les dispositions nécessaires dès maintenant.

Le Service Conformité',
  NULL),

('courrier', 'RH', 'Lettre d''avertissement',
  '[LIEU], le [DATE]

Recommandé avec accusé de réception

[NOM] [PRENOM]
[ADRESSE]

Objet : Avertissement

Madame, Monsieur,

Nous avons été amenés à constater les faits suivants : [DESCRIPTION_FAITS]

Ces faits constituent un manquement à vos obligations professionnelles telles que définies par [REFERENCE_REGLEMENT].

En conséquence, nous vous notifions par la présente un avertissement.

Nous vous demandons de bien vouloir prendre note de cette décision et de veiller à ne plus vous rendre coupable de tels agissements à l''avenir.

La Direction',
  NULL),

('contrat', 'RH', 'Contrat de travail CDI',
  'CONTRAT DE TRAVAIL À DURÉE INDÉTERMINÉE

Entre :
La Belle Agence, SARL, SIRET 123 456 789 00012
Représentée par [NOM_DRH], en qualité de Directeur(rice) des Ressources Humaines
Ci-après "l''Employeur"

Et :
M./Mme [NOM] [PRENOM], né(e) le [DATE_NAISSANCE]
Demeurant [ADRESSE]
Ci-après "le Salarié"

Article 1 — Engagement
Le Salarié est engagé en qualité de [POSTE], Coefficient [COEF], à compter du [DATE_DEBUT].

Article 2 — Durée du travail
La durée hebdomadaire de travail est fixée à [DUREE_HEBDO] heures.

Article 3 — Rémunération
La rémunération brute mensuelle est fixée à [SALAIRE] €.

Article 4 — Période d''essai
La période d''essai est fixée à [DUREE_ESSAI] mois, renouvelable une fois.

Fait en deux exemplaires à [LIEU], le [DATE]',
  NULL),

('email', 'IT', 'Notification ouverture ticket support',
  'Objet : Ticket #[NUMERO_TICKET] ouvert — [TITRE_TICKET]

Bonjour [PRENOM_DEMANDEUR],

Votre demande de support a bien été enregistrée.

Ticket N° : [NUMERO_TICKET]
Titre : [TITRE_TICKET]
Priorité : [PRIORITE]
Agent assigné : [NOM_AGENT]

Nous reviendrons vers vous dans les délais suivants selon la priorité :
- Critique : 1h
- Haute : 4h
- Normale : 24h
- Basse : 48h

L''équipe IT',
  NULL),

('rh', 'RH', 'Fiche de poste',
  'FICHE DE POSTE

Intitulé du poste : [INTITULE_POSTE]
Service : [SERVICE]
Lieu de travail : [LIEU]
Supérieur hiérarchique : [NOM_SUPERIEUR]

MISSIONS PRINCIPALES :
[MISSIONS]

COMPÉTENCES REQUISES :
[COMPETENCES]

FORMATION :
[FORMATION_REQUISE]

EXPÉRIENCE :
[EXPERIENCE_REQUISE]

Statut : [STATUT_EMPLOI]
Salaire indicatif : [FOURCHETTE_SALAIRE]',
  NULL),

('email', 'Patrimoine', 'Compte-rendu bilan patrimonial',
  'Objet : Compte-rendu de votre bilan patrimonial

Madame, Monsieur [NOM],

Suite à notre entretien du [DATE_ENTRETIEN], nous vous adressons ci-après la synthèse de votre situation patrimoniale.

SITUATION ACTUELLE :
- Patrimoine brut : [PATRIMOINE_BRUT] €
- Revenus annuels : [REVENUS] €
- Profil d''investisseur : [PROFIL_RISQUE]

PRÉCONISATIONS :
[PRECONISATIONS]

Nous restons à votre disposition pour approfondir ces points.

Cordialement,
[NOM_CONSEILLER]
Conseiller en Gestion de Patrimoine',
  NULL),

('contrat', 'Patrimoine', 'Mandat de gestion patrimoniale',
  'MANDAT DE GESTION DE PATRIMOINE

Entre :
- M./Mme [NOM_CLIENT], ci-après "le Mandant"
- La Belle Agence — Pôle Patrimoine, ci-après "le Mandataire"

Le Mandant confie au Mandataire la gestion de son patrimoine dans le respect de son profil de risque : [PROFIL_RISQUE]

Objectifs validés : [OBJECTIFS]
Montant sous gestion : [MONTANT] €
Durée du mandat : [DUREE]
Frais de gestion : [FRAIS]% par an

Le Mandataire rendra compte de sa gestion tous les [FREQUENCE_REPORTING].

Fait à [VILLE], le [DATE]',
  NULL),

('email', 'Finance', 'Validation dépense budget',
  'Objet : ✅ Validation de votre demande de dépense

Bonjour [PRENOM_DEMANDEUR],

Votre demande de dépense a été validée par la Direction Financière.

Référence : [REF_DEMANDE]
Fournisseur : [NOM_FOURNISSEUR]
Montant approuvé : [MONTANT] € TTC
Budget imputé : [LIGNE_BUDGETAIRE]

Vous pouvez procéder à la commande. Merci de nous faire parvenir la facture originale dès réception.

Le Service Finance',
  NULL)
ON CONFLICT DO NOTHING;

-- ============================================================
-- CARTES PROFESSIONNELLES (3 entrées)
-- ============================================================
INSERT INTO cartes_professionnelles (salarie_nom, numero_carte, date_expiration, organisme_delivreur, statut) VALUES
('Jean-Luc Moreau',   'CPI-68-2021-001423', '2024-12-31', 'CCI Alsace', 'en renouvellement'),
('Lucie Fontaine',    'CPI-68-2022-003187', '2025-06-30', 'CCI Alsace', 'valide'),
('Marc Petit',        'CPI-67-2020-007654', '2024-09-30', 'CCI Bas-Rhin', 'expiré')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ASSURANCES RC PROFESSIONNELLES (2 entrées)
-- ============================================================
INSERT INTO assurances_rc (compagnie, numero_police, montant_garantie, date_debut, date_fin) VALUES
('AXA Entreprises',       'AXA-PRO-2024-00145', 1500000.00, '2024-01-01', '2024-12-31'),
('Allianz Professionnels', 'ALLZ-RC-2024-08872',  500000.00, '2024-03-01', '2025-02-28')
ON CONFLICT DO NOTHING;

-- ============================================================
-- FORMATIONS DDA (5 entrées)
-- ============================================================
INSERT INTO formations (salarie_nom, intitule, organisme, date_formation, duree_heures, type_formation) VALUES
('Lucie Fontaine',    'Réglementation DDA et distribution d''assurances', 'IFPASS',          '2024-03-15', 7.0,  'DDA'),
('Marc Petit',        'Droit immobilier et pratique de la transaction',    'FNAIM Formation', '2024-04-20', 7.0,  'DDA'),
('Valérie Roux',      'Éthique et déontologie dans le conseil patrimonial','AF2I',            '2024-05-10', 3.5,  'DDA'),
('Stefan Muller',     'Lutte anti-blanchiment et conformité',              'AUREP',           '2024-06-18', 7.0,  'DDA'),
('Camille Bonnet',    'Fiscalité de l''immobilier 2024',                   'FNAIM Formation', '2024-09-25', 7.0,  'DDA')
ON CONFLICT DO NOTHING;

-- ============================================================
-- CAMPAGNES MARKETING (3 entrées)
-- ============================================================
INSERT INTO campagnes_marketing (nom, canal, budget, date_debut, date_fin, statut, objectif) VALUES
('Printemps Immobilier 2024', 'print',          8500.00,  '2024-03-01', '2024-05-31', 'terminée',      'Générer 50 nouveaux mandats dans les 3 agences'),
('LinkedIn Patrimoine Q4',    'réseaux sociaux', 3200.00,  '2024-10-01', '2024-12-31', 'active',        'Attirer des clients patrimoniaux avec actifs >500k€'),
('Portes Ouvertes Colmar',    'événement',       5000.00,  '2024-11-15', '2024-11-16', 'terminée',      'Présenter 15 biens exclusifs, objectif 30 visites en 2 jours')
ON CONFLICT DO NOTHING;

-- ============================================================
-- TICKETS IT (3 entrées)
-- ============================================================
INSERT INTO tickets_support (demandeur_nom, titre, description, priorite, statut, agent_it) VALUES
('Marc Petit',     'Accès CRM bloqué',           'Impossible de se connecter au CRM depuis ce matin, message "accès refusé"', 'haute',    'résolu',   'Théo Dupuis'),
('Sabine Martin',  'Imprimante bureaux 2ème étage hors service', 'L''imprimante HP LaserJet affiche erreur 79 et ne répond plus', 'normale', 'en cours', 'Théo Dupuis'),
('Émilie Lambert', 'Demande accès outil Canva Pro','Besoin d''un compte Canva Pro pour création visuels campagnes réseaux', 'basse',    'ouvert',   NULL)
ON CONFLICT DO NOTHING;

-- ============================================================
-- MATÉRIEL INFORMATIQUE (3 entrées)
-- ============================================================
INSERT INTO materiel_informatique (designation, marque, numero_serie, utilisateur_nom, date_achat, garantie_fin, statut) VALUES
('Laptop 15" Professionnel',  'Dell',    'DL-XPS15-2023-44721', 'Lucie Fontaine',  '2023-02-15', '2026-02-15', 'opérationnel'),
('Imprimante Laser A4/A3',    'HP',      'HP-LASER-2021-83654', 'Service commun',  '2021-06-01', '2024-06-01', 'panne'),
('Tablette tactile 12.9"',    'Apple',   'APL-IPAD-2022-99001', 'Marc Petit',      '2022-09-01', '2024-09-01', 'opérationnel')
ON CONFLICT DO NOTHING;

-- ============================================================
-- LICENCES LOGICIELS (3 entrées)
-- ============================================================
INSERT INTO licences_logiciels (logiciel, editeur, nombre_postes, date_expiration, cout_annuel, statut) VALUES
('Microsoft 365 Business',  'Microsoft',  25, '2025-01-31', 3750.00, 'active'),
('Logiciel CRM Immobilier', 'APIMO',      10, '2025-06-30', 4800.00, 'active'),
('Adobe Creative Cloud',    'Adobe',       2, '2024-11-30',  960.00, 'renouvellement')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ÉCRITURES COMPTABLES (5 entrées)
-- ============================================================
INSERT INTO ecritures_comptables (date_ecriture, libelle, compte_debit, compte_credit, montant, piece_justificative) VALUES
('2024-10-31', 'Paiement loyer siège octobre 2024',      '613100', '512000', 4200.00,  'BAIL-2024-10'),
('2024-10-31', 'Salaires octobre 2024',                   '641100', '421000', 52800.00, 'BP-OCT-2024'),
('2024-11-05', 'Encaissement honoraires vente COL-003',   '512000', '706000', 15200.00, 'FAC-CLI-2024-031'),
('2024-11-15', 'Règlement facture PRINTEX F-2024-119',    '401000', '512000', 3840.00,  'F-2024-119'),
('2024-11-30', 'Abonnement logiciels novembre 2024',      '626300', '512000', 1150.00,  'LICENCES-NOV-2024')
ON CONFLICT DO NOTHING;

-- ============================================================
-- DOSSIERS PATRIMONIAUX (3 entrées)
-- ============================================================
INSERT INTO dossiers_patrimoniaux (conseiller_nom, date_entree, objectif_patrimoine, montant_patrimoine_brut, revenus_annuels, profil_risque, statut) VALUES
('Lucie Fontaine',  '2024-01-20', 'Préparer la retraite et transmettre un patrimoine de 1M€ à ses enfants', 650000.00, 95000.00, 'équilibré',  'actif'),
('Valérie Roux',    '2024-03-15', 'Diversifier l''épargne et réduire la pression fiscale',                  280000.00, 68000.00, 'dynamique',  'actif'),
('Lucie Fontaine',  '2024-07-01', 'Constitution d''un patrimoine immobilier locatif en vue de la retraite',  120000.00, 52000.00, 'prudent',    'actif')
ON CONFLICT DO NOTHING;

-- ============================================================
-- UPDATE missions existantes avec donnees_exercice concrets
-- Note : ces UPDATE n'échoueront pas si les missions n'existent pas
--        (la colonne est nullable par défaut)
-- ============================================================

-- Mission type "Analyse de factures fournisseurs" (Finance)
UPDATE missions SET
  donnees_exercice = '{
    "contexte": "Vous êtes stagiaire au service comptabilité de La Belle Agence.",
    "factures_a_traiter": [
      {"numero": "F-2024-119", "fournisseur": "BUREAU PLUS SARL", "montant_ttc": 1440.00, "statut": "reçue", "anomalie": null},
      {"numero": "F-2024-120", "fournisseur": "NETTOYAGE PRO", "montant_ttc": 540.00, "statut": "reçue", "anomalie": null},
      {"numero": "F-2024-123", "fournisseur": "PRINTEX COMMUNICATION", "montant_ttc": 4620.00, "statut": "litigieuse", "anomalie": "Adresse de facturation manquante"},
      {"numero": "F-2024-124", "fournisseur": "TELECOM ALSACE", "montant_ttc": 456.00, "statut": "reçue", "anomalie": null}
    ],
    "consigne": "Identifiez la facture litigieuse et rédigez un email au fournisseur pour demander la régularisation."
  }'::jsonb,
  fichiers_annexes = '{}'
WHERE profil_code IN ('FINANCE_MANAGER', 'ELEVE_FINANCE')
  AND titre ILIKE '%facture%'
LIMIT 1;

-- Mission type "Rédaction contrat de travail" (RH)
UPDATE missions SET
  donnees_exercice = '{
    "nouveau_salarie": {
      "nom": "MULLER",
      "prenom": "Stefan",
      "poste": "Agent Immobilier",
      "date_embauche": "2025-01-06",
      "salaire_brut": 2400,
      "type_contrat": "CDI",
      "periode_essai": "3 mois"
    },
    "baremes": {
      "smic_mensuel_brut": 1767.93,
      "coefficient_agent_immo": 220,
      "convention_collective": "Immobilier — IDCC 1527"
    },
    "documents_a_produire": ["Contrat de travail CDI", "Fiche de poste", "Attestation prise de poste"]
  }'::jsonb
WHERE profil_code IN ('RH_MANAGER', 'ELEVE_RH')
  AND titre ILIKE '%contrat%'
LIMIT 1;

-- Mission type "Planification de visites" (Commercial)
UPDATE missions SET
  donnees_exercice = '{
    "clients_a_planifier": [
      {"nom": "MARTIN Sophie", "budget": 320000, "type_recherche": "achat", "criteres": "F3 min, Colmar, avec balcon"},
      {"nom": "DUBOIS Pierre", "budget": 180000, "type_recherche": "achat", "criteres": "F2, Mulhouse, calme"},
      {"nom": "SIMON David",   "budget": 380000, "type_recherche": "achat", "criteres": "F4 min, Strasbourg, parking"}
    ],
    "biens_disponibles": [
      {"ref": "COL-001", "adresse": "12 rue des Fleurs, Colmar",   "type": "appartement", "surface": 65, "prix": 195000, "pieces": 3},
      {"ref": "MLH-002", "adresse": "8 allée des Roses, Mulhouse",  "type": "appartement", "surface": 48, "prix": 142000, "pieces": 2},
      {"ref": "STR-004", "adresse": "3 rue du Marché, Strasbourg",  "type": "appartement", "surface": 90, "prix": 320000, "pieces": 4}
    ],
    "consigne": "Proposez un planning de visites pour la semaine du 6 au 10 janvier 2025 en associant chaque client au bien correspondant à ses critères."
  }'::jsonb
WHERE profil_code IN ('AGENT_IMMOBILIER', 'DIRECTEUR_AGENCE')
  AND titre ILIKE '%visite%'
LIMIT 1;

-- Mission type "Campagne marketing réseaux sociaux" (Marketing)
UPDATE missions SET
  donnees_exercice = '{
    "brief_campagne": {
      "objectif": "Générer 20 leads qualifiés patrimoniaux en décembre",
      "budget": 1500,
      "plateforme_cible": "LinkedIn",
      "duree": "4 semaines",
      "cible": "Cadres 40-55 ans, revenus >80k€/an, Alsace"
    },
    "performances_precedentes": [
      {"mois": "Octobre", "plateforme": "LinkedIn", "impressions": 12500, "clics": 340, "leads": 8,  "cout_lead": 187.50},
      {"mois": "Novembre", "plateforme": "LinkedIn", "impressions": 15200, "clics": 412, "leads": 11, "cout_lead": 136.36}
    ],
    "consigne": "Rédigez 3 posts LinkedIn et planifiez leur publication sur 4 semaines avec un objectif de 20 leads."
  }'::jsonb
WHERE profil_code IN ('MKT_MANAGER', 'ELEVE_MARKETING')
LIMIT 1;

-- Mission type "Renouvellement cartes professionnelles" (Conformité)
UPDATE missions SET
  donnees_exercice = '{
    "cartes_a_renouveler": [
      {"titulaire": "Jean-Luc Moreau",  "numero": "CPI-68-2021-001423", "expiration": "2024-12-31", "heures_dda_validees": 14, "rc_valide": true},
      {"titulaire": "Marc Petit",        "numero": "CPI-67-2020-007654", "expiration": "2024-09-30", "heures_dda_validees": 7,  "rc_valide": true}
    ],
    "exigences_renouvellement": {
      "heures_dda_minimum": 14,
      "organismes_agrees": ["IFPASS", "FNAIM Formation", "AUREP", "AF2I"],
      "delai_depot_avant_expiration": "3 mois",
      "organisme_depot": "CCI Alsace"
    },
    "consigne": "Identifiez les dossiers incomplets et rédigez le courrier de demande de renouvellement pour chaque titulaire."
  }'::jsonb
WHERE profil_code IN ('CONFORMITE', 'RH_MANAGER')
LIMIT 1;

-- ============================================================
-- MISSION RH_001 — Préparer l'accueil d'une nouvelle collaboratrice
-- Premier exercice réel de La Belle Agence, sur le modèle CM Expert
-- Compétence AGORA : 3.1.1 — Appliquer des procédures d'entrée et
-- de sortie du personnel (Bloc 3 — Pôle 3.1)
--
-- À coller APRÈS fix_missions_profils.sql (nécessite la colonne
-- profil_code sur missions et le rôle 'RH' dans profils_metier)
-- ============================================================

INSERT INTO missions (
  titre, profil_code, contexte, instructions, donnees_exercice,
  indice, correction_detaillee, difficulte, duree_minutes
)
SELECT
  'RH_001 — Préparer l''accueil d''une nouvelle collaboratrice',
  'RH',
  'Vous êtes affecté(e) auprès de Maria SILVA, Responsable RH au siège de La Belle Agence (Mulhouse), en tant qu''Assistante RH. La Belle Agence recrute Camille WEISS comme Conseillère en Gestion de Patrimoine à l''agence de Colmar. Vous devez préparer son accueil et son intégration.

Nous sommes le lundi 21 septembre 2026.',

  '1. Analysez le compte rendu de réunion (donnees_exercice → compte_rendu) et répondez : à quelle date Camille WEISS est-elle recrutée ? Quel est son bureau ? Qui sera son mentor ?
2. Préparez le programme de la journée d''accueil (tableau 3 colonnes : horaires / activités / personnes et lieu concernés).
3. Rédigez le mail de confirmation à Camille WEISS (signataire : Maria SILVA), avec la liste des documents à apporter le jour J.
4. Rédigez le mail au service IT du siège pour l''activation de ses accès (messagerie, CRM patrimoine, VPN agence).
5. Rédigez le mail à l''ensemble du personnel de l''agence Colmar annonçant son arrivée, organigramme mis à jour joint.
6. Complétez le contrat de travail (CDI) à partir de la fiche d''informations.
7. Préparez la DPAE — rappel : elle peut être transmise au plus tôt 8 jours avant la prise de poste, toujours avant le premier jour de travail effectif.
8. Rédigez un mémo à l''attention du mentor (Hugo OLIVEIRA, Conseiller Patrimoine, agence Strasbourg) présentant sa mission d''accompagnement, puis un mail lui rappelant sa présence le jour de l''accueil.',

  '{
  "compte_rendu": {
    "date_reunion": "2026-09-17",
    "objet": "Recrutement Camille WEISS",
    "presents": ["Maria SILVA (Responsable RH)", "Fatima BENALI (Responsable Agence Colmar)", "Elena ROSSI (Directrice Adjointe)"],
    "decisions": "Camille WEISS est recrutée à compter du lundi 28 septembre 2026 en qualité de Conseillère en Gestion de Patrimoine à l''agence de Colmar, sous l''autorité de Fatima BENALI. Hugo OLIVEIRA (Conseiller Patrimoine, agence Strasbourg) sera son mentor — c''est sa première expérience de mentorat, à confirmer par écrit. Le contrat (CDI) est en cours d''élaboration. Rappel : la DPAE doit être transmise au plus tôt 8 jours avant la prise de poste, toujours avant le premier jour de travail.",
    "programme_prevu": "9h00 accueil par Fatima BENALI (bureau agence Colmar) — 10h30 visite de l''agence — 11h00 rencontre avec Maria SILVA par visioconférence pour les formalités RH — 14h00-16h00 prise en main du CRM patrimoine avec l''équipe — 16h30 point avec Hugo OLIVEIRA (visio depuis Strasbourg)."
  },
  "nouvelle_collaboratrice": {
    "nom": "WEISS", "prenom": "Camille",
    "date_naissance": "1993-04-12", "lieu_naissance": "Colmar", "nationalite": "Française",
    "adresse": "9 rue des Clefs, 68000 Colmar",
    "telephone": "06 45 12 34 56", "email_personnel": "camille.weiss93@gmail.com",
    "situation_familiale": "Célibataire",
    "contrat": "CDI — période d''essai 3 mois, préavis 1 mois",
    "fonction": "Conseillère en Gestion de Patrimoine",
    "agence": "Colmar",
    "responsable_hierarchique": "Fatima BENALI",
    "duree_hebdomadaire": "35h/semaine — base 1607h",
    "remuneration_brute_annuelle": 34000,
    "date_debut": "2026-09-28"
  },
  "mentor": {
    "nom": "Hugo OLIVEIRA", "poste": "Conseiller Patrimoine", "agence": "Strasbourg",
    "premiere_experience_mentorat": true
  },
  "regle_dpae": "Transmissible au plus tôt 8 jours avant la date de début de contrat ; toujours avant le premier jour de travail effectif du salarié."
}'::jsonb,

  '💡 INDICE : Reprenez la même logique que le cas CM Expert vu en classe (accueil d''un nouveau collaborateur) mais avec les données de La Belle Agence. Attention à la règle DPAE : ce n''est PAS "au minimum 8 jours avant" mais "au plus tôt 8 jours avant, et toujours avant le premier jour de travail" — c''est une erreur fréquente. Le mentor n''étant pas dans la même agence que la nouvelle collaboratrice, pensez à prévoir des points en visioconférence dans votre programme.',

  '✅ CORRECTION — Accueil de Camille WEISS

RÉCAPITULATIF DES INFORMATIONS CLÉS :
• Recrutement : lundi 28 septembre 2026, CDI, Conseillère en Gestion de Patrimoine, agence Colmar
• Responsable hiérarchique : Fatima BENALI
• Mentor : Hugo OLIVEIRA (agence Strasbourg — première expérience de mentorat, à confirmer par écrit)
• DPAE : transmissible au plus tôt le 20/09/2026 (J-8), impérativement avant le 28/09/2026

POINTS DE VIGILANCE ATTENDUS DANS LES PRODUCTIONS DES ÉLÈVES :
✅ Programme d''accueil tenant compte du mentor à distance (créneaux visio prévus)
✅ Mail à Camille WEISS : accroche cordiale, liste des documents à apporter (pièce d''identité, RIB, carte Vitale, mutuelle), signé Maria SILVA
✅ Mail IT : demande d''activation messagerie + CRM patrimoine + VPN, avec date d''embauche et fonction précisées
✅ Mail à l''équipe Colmar : nom, poste, service, date d''arrivée, organigramme joint, mention du manager et du mentor
✅ Contrat de travail complété avec les bonnes données (rémunération, durée, période d''essai 3 mois)
✅ DPAE avec la bonne règle de délai (au plus tôt 8 jours avant, jamais après le début du contrat)
✅ Mémo mentorat expliquant le rôle du mentor (accompagnement, pas de lien hiérarchique, base volontariat) + mail de rappel à Hugo OLIVEIRA',

  'Intermédiaire',
  90
WHERE NOT EXISTS (SELECT 1 FROM missions WHERE titre ILIKE '%RH_001%' OR titre ILIKE '%Camille WEISS%');

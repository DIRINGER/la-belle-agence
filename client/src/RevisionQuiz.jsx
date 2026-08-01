import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const TAILLE_SESSION = 16;
const RATIO_RATEES = 0.8;

function melanger(liste) {
  return [...liste].sort(() => Math.random() - 0.5);
}

export default function RevisionQuiz({ utilisateur, estProf, onRetour }) {
  const [vue, setVue] = useState(estProf ? 'prof' : 'themes');
  const [chargement, setChargement] = useState(false);

  const [themes, setThemes] = useState([]);
  const [paliers, setPaliers] = useState({});
  const [progression, setProgression] = useState({});

  const [themeChoisi, setThemeChoisi] = useState(null);
  const [file, setFile] = useState([]);
  const [indexCourant, setIndexCourant] = useState(0);
  const [reponseSelectionnee, setReponseSelectionnee] = useState(null);
  const [aRepondu, setARepondu] = useState(false);
  const [streak, setStreak] = useState(0);
  const [meilleurStreak, setMeilleurStreak] = useState(0);
  const [nbBonnes, setNbBonnes] = useState(0);
  const [nbVues, setNbVues] = useState(0);
  const [palierDebloque, setPalierDebloque] = useState(null);
  const [jokerDebloque, setJokerDebloque] = useState(false);
  const [texteJoker, setTexteJoker] = useState('');
  const [jokerEnvoye, setJokerEnvoye] = useState(false);

  const [statsProf, setStatsProf] = useState(null);
  const [elevesRoster, setElevesRoster] = useState([]);
  const [pinRegenere, setPinRegenere] = useState({});

  useEffect(() => {
    if (estProf) {
      chargerStatsProf();
    } else {
      chargerThemes();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function chargerThemes() {
    setChargement(true);
    const { data: comp } = await supabase.from('competences').select('*');
    const { data: pal } = await supabase.from('revision_narratif_paliers').select('*');
    const { data: prog } = await supabase.from('revision_theme_progress').select('*').eq('student_id', utilisateur);

    const palMap = {};
    (pal || []).forEach(p => { palMap[p.theme_id] = p; });
    const progMap = {};
    (prog || []).forEach(p => { progMap[p.theme_id] = p; });

    const themesTries = [...(comp || [])].sort((a, b) => {
      const oa = palMap[a.id]?.ordre ?? 999;
      const ob = palMap[b.id]?.ordre ?? 999;
      return oa - ob;
    });

    setThemes(themesTries);
    setPaliers(palMap);
    setProgression(progMap);
    setChargement(false);
  }

  async function demarrerQuiz(theme) {
    setChargement(true);
    setThemeChoisi(theme);

    const { data: questions } = await supabase
      .from('revision_questions')
      .select('*')
      .eq('competence_id', theme.id);

    if (!questions || questions.length === 0) {
      setChargement(false);
      alert("Aucune question n'est encore disponible pour ce thème.");
      return;
    }

    const ids = questions.map(q => q.id);
    const { data: stats } = await supabase
      .from('student_question_stats')
      .select('*')
      .eq('student_id', utilisateur)
      .in('question_id', ids);

    const statsMap = {};
    (stats || []).forEach(s => { statsMap[s.question_id] = s; });

    const ratees = questions.filter(q => statsMap[q.id]?.last_outcome === 'rate');
    const jamaisVues = questions.filter(q => !statsMap[q.id]);
    const maitrisees = questions.filter(q => statsMap[q.id]?.last_outcome === 'reussi');

    const tailleSession = Math.min(TAILLE_SESSION, questions.length);
    const nbRatees = Math.round(tailleSession * RATIO_RATEES);
    const nbAutres = tailleSession - nbRatees;

    let selectionRatees = melanger(ratees).slice(0, nbRatees);
    const idsPris = new Set(selectionRatees.map(q => q.id));

    if (selectionRatees.length < nbRatees) {
      const manque = nbRatees - selectionRatees.length;
      const complement = melanger(jamaisVues.filter(q => !idsPris.has(q.id))).slice(0, manque);
      complement.forEach(q => idsPris.add(q.id));
      selectionRatees = [...selectionRatees, ...complement];
    }

    const poolAutres = [...jamaisVues, ...maitrisees].filter(q => !idsPris.has(q.id));
    let selectionAutres = melanger(poolAutres).slice(0, nbAutres);
    selectionAutres.forEach(q => idsPris.add(q.id));

    let session = [...selectionRatees, ...selectionAutres];

    if (session.length < tailleSession) {
      const reste = questions.filter(q => !idsPris.has(q.id));
      session = [...session, ...melanger(reste).slice(0, tailleSession - session.length)];
    }

    session = melanger(session);

    setFile(session);
    setIndexCourant(0);
    setReponseSelectionnee(null);
    setARepondu(false);
    setStreak(0);
    setMeilleurStreak(0);
    setNbBonnes(0);
    setNbVues(0);
    setPalierDebloque(null);
    setJokerDebloque(false);
    setJokerEnvoye(false);
    setTexteJoker('');
    setChargement(false);
    setVue('quiz');
  }

  async function validerReponse(indexChoix) {
    if (aRepondu) return;
    const question = file[indexCourant];
    const correct = indexChoix === question.bonne_reponse_index;

    setReponseSelectionnee(indexChoix);
    setARepondu(true);
    setNbVues(n => n + 1);

    const { data: existant } = await supabase
      .from('student_question_stats')
      .select('*')
      .eq('student_id', utilisateur)
      .eq('question_id', question.id)
      .maybeSingle();

    await supabase.from('student_question_stats').upsert({
      student_id: utilisateur,
      question_id: question.id,
      theme_id: themeChoisi.id,
      last_outcome: correct ? 'reussi' : 'rate',
      nb_tentatives: (existant?.nb_tentatives || 0) + 1,
      last_seen_at: new Date().toISOString(),
    }, { onConflict: 'student_id,question_id' });

    if (correct) {
      setNbBonnes(n => n + 1);
      setStreak(s => {
        const nouveau = s + 1;
        setMeilleurStreak(m => Math.max(m, nouveau));
        return nouveau;
      });
    } else {
      setStreak(0);
      setFile(f => [...f, question]);
    }
  }

  function questionSuivante() {
    setReponseSelectionnee(null);
    setARepondu(false);
    if (indexCourant + 1 >= file.length) {
      terminerSession();
    } else {
      setIndexCourant(i => i + 1);
    }
  }

  async function terminerSession() {
    setChargement(true);
    const { data: questionsTheme } = await supabase
      .from('revision_questions')
      .select('id')
      .eq('competence_id', themeChoisi.id);
    const idsTheme = (questionsTheme || []).map(q => q.id);

    const { data: statsTheme } = await supabase
      .from('student_question_stats')
      .select('question_id,last_outcome')
      .eq('student_id', utilisateur)
      .in('question_id', idsTheme);

    const reussies = new Set((statsTheme || []).filter(s => s.last_outcome === 'reussi').map(s => s.question_id));
    const maitrise = idsTheme.length > 0 && idsTheme.every(id => reussies.has(id));

    if (maitrise) {
      const dejaMaitrise = progression[themeChoisi.id]?.statut === 'maitrise';
      if (!dejaMaitrise) {
        await supabase.from('revision_theme_progress').upsert({
          student_id: utilisateur,
          theme_id: themeChoisi.id,
          statut: 'maitrise',
          date_maitrise: new Date().toISOString(),
          joker_disponible: true,
        }, { onConflict: 'student_id,theme_id' });

        await supabase.from('revision_maitrises_log').insert({
          student_id: utilisateur,
          theme_id: themeChoisi.id,
        });

        const { data: palier } = await supabase
          .from('revision_narratif_paliers')
          .select('*')
          .eq('theme_id', themeChoisi.id)
          .maybeSingle();

        setPalierDebloque(palier || null);
        setJokerDebloque(true);
      }
    }
    setChargement(false);
    setVue('bilan');
  }

  async function utiliserJoker() {
    if (!texteJoker.trim()) return;
    await supabase.from('revision_theme_progress').update({
      joker_utilise: true,
      joker_evaluation_choisie: texteJoker.trim(),
    }).eq('student_id', utilisateur).eq('theme_id', themeChoisi.id);
    setJokerEnvoye(true);
  }

  async function retourThemes() {
    await chargerThemes();
    setVue('themes');
  }

  async function chargerStatsProf() {
    setChargement(true);
    const { data: comp } = await supabase.from('competences').select('*');
    const { data: questions } = await supabase.from('revision_questions').select('id,enonce,competence_id');
    const { data: stats } = await supabase.from('student_question_stats').select('question_id,last_outcome,student_id');
    const { data: progressionAll } = await supabase.from('revision_theme_progress').select('*');
    const { data: param } = await supabase.from('revision_parametres').select('*').eq('cle', 'nb_eleves_classe').maybeSingle();
    const { data: paliersRecompense } = await supabase.from('revision_recompense_paliers').select('*').order('seuil_pourcent', { ascending: false });
    const { data: roster } = await supabase.from('eleves_roster').select('*').order('nom');

    const debutSemaine = new Date();
    const jour = debutSemaine.getDay() || 7;
    debutSemaine.setDate(debutSemaine.getDate() - jour + 1);
    debutSemaine.setHours(0, 0, 0, 0);
    const { data: maitrisesSemaine } = await supabase
      .from('revision_maitrises_log')
      .select('student_id,theme_id,date_maitrise')
      .gte('date_maitrise', debutSemaine.toISOString());

    const nbEleves = parseInt(param?.valeur || '24', 10);

    const questionsParTheme = {};
    (questions || []).forEach(q => {
      if (!questionsParTheme[q.competence_id]) questionsParTheme[q.competence_id] = [];
      questionsParTheme[q.competence_id].push(q);
    });

    const ratesParQuestion = {};
    (stats || []).forEach(s => {
      if (s.last_outcome === 'rate') {
        ratesParQuestion[s.question_id] = (ratesParQuestion[s.question_id] || 0) + 1;
      }
    });

    const themesAvecStats = (comp || []).map(t => {
      const qs = questionsParTheme[t.id] || [];
      const questionsRatees = qs
        .map(q => ({ ...q, nbRates: ratesParQuestion[q.id] || 0 }))
        .filter(q => q.nbRates > 0)
        .sort((a, b) => b.nbRates - a.nbRates)
        .slice(0, 3);
      const nbMaitrise = (progressionAll || []).filter(p => p.theme_id === t.id && p.statut === 'maitrise').length;
      return { ...t, questionsRatees, nbMaitrise };
    });

    const maitrisesParTheme = {};
    (maitrisesSemaine || []).forEach(m => {
      if (!maitrisesParTheme[m.theme_id]) maitrisesParTheme[m.theme_id] = new Set();
      maitrisesParTheme[m.theme_id].add(m.student_id);
    });
    let meilleurPourcentage = 0;
    Object.values(maitrisesParTheme).forEach(set => {
      const pct = (set.size / nbEleves) * 100;
      if (pct > meilleurPourcentage) meilleurPourcentage = pct;
    });
    const palierAtteint = (paliersRecompense || []).find(p => meilleurPourcentage >= p.seuil_pourcent) || null;

    setElevesRoster(roster || []);
    setStatsProf({
      themesAvecStats,
      nbElevesAyantMaitriseCetteSemaine: [...new Set((maitrisesSemaine || []).map(m => m.student_id))].length,
      nbMaitrisesSemaine: (maitrisesSemaine || []).length,
      nbEleves,
      meilleurPourcentage: Math.round(meilleurPourcentage),
      palierAtteint,
      paliersRecompense: paliersRecompense || [],
    });
    setChargement(false);
  }

  async function regenererPin(eleve) {
    const nouveau = String(Math.floor(1000 + Math.random() * 9000));
    const { error } = await supabase.from('eleves_roster').update({ pin: nouveau }).eq('id', eleve.id);
    if (!error) {
      setElevesRoster(prev => prev.map(e => e.id === eleve.id ? { ...e, pin: nouveau } : e));
      setPinRegenere(prev => ({ ...prev, [eleve.id]: nouveau }));
    }
  }

  const conteneur = { padding: '32px', maxWidth: '900px', margin: '0 auto' };
  const boutonRetour = (
    <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}>
      ← Retour
    </button>
  );

  if (chargement) {
    return (
      <div style={conteneur}>
        {boutonRetour}
        <p>Chargement…</p>
      </div>
    );
  }

  if (vue === 'prof') {
    if (!statsProf) return <div style={conteneur}>{boutonRetour}<p>Chargement…</p></div>;
    return (
      <div style={conteneur}>
        {boutonRetour}
        <h1 style={{ color: '#1E3A8A' }}>📊 Tableau de bord — Révisions</h1>

        <div style={{ background: '#F0FDF4', border: '2px solid #059669', borderRadius: '12px', padding: '20px', marginBottom: '28px' }}>
          <h3 style={{ marginTop: 0 }}>🎁 Récompense collective de la semaine</h3>
          <p>{statsProf.nbMaitrisesSemaine} thème(s) maîtrisé(s) cette semaine, par {statsProf.nbElevesAyantMaitriseCetteSemaine} élève(s) différent(s) sur {statsProf.nbEleves}.</p>
          <p>Meilleur taux de réussite collective sur un même thème cette semaine : <strong>{statsProf.meilleurPourcentage}%</strong></p>
          {statsProf.palierAtteint ? (
            <p style={{ color: '#059669', fontWeight: 'bold' }}>
              ✅ Palier atteint : {statsProf.palierAtteint.minutes_bonus} min de pause bonus sur {statsProf.palierAtteint.jours_bonus} jour(s) la semaine prochaine !
            </p>
          ) : (
            <p style={{ color: '#9CA3AF' }}>Aucun palier atteint pour l'instant (seuil le plus bas : 60%).</p>
          )}
          <details style={{ marginTop: '10px' }}>
            <summary style={{ cursor: 'pointer', fontSize: '13px' }}>Voir le barème complet</summary>
            <ul style={{ fontSize: '13px' }}>
              {statsProf.paliersRecompense.map(p => (
                <li key={p.seuil_pourcent}>{p.seuil_pourcent}% → {p.minutes_bonus} min sur {p.jours_bonus} jour(s)</li>
              ))}
            </ul>
          </details>
        </div>

        <div style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: '12px', padding: '20px', marginBottom: '28px' }}>
          <h3 style={{ marginTop: 0 }}>🔑 Gestion des codes PIN</h3>
          <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '14px' }}>
            <thead>
              <tr>
                <th style={{ textAlign: 'left', padding: '6px', borderBottom: '1px solid #E5E7EB' }}>Élève</th>
                <th style={{ textAlign: 'left', padding: '6px', borderBottom: '1px solid #E5E7EB' }}>Code actuel</th>
                <th style={{ padding: '6px', borderBottom: '1px solid #E5E7EB' }}></th>
              </tr>
            </thead>
            <tbody>
              {elevesRoster.map(eleve => (
                <tr key={eleve.id}>
                  <td style={{ padding: '6px' }}>{eleve.nom}</td>
                  <td style={{ padding: '6px', fontFamily: 'monospace', fontWeight: pinRegenere[eleve.id] ? 'bold' : 'normal', color: pinRegenere[eleve.id] ? '#059669' : '#374151' }}>
                    {pinRegenere[eleve.id] || eleve.pin}
                  </td>
                  <td style={{ padding: '6px', textAlign: 'right' }}>
                    <button
                      onClick={() => regenererPin(eleve)}
                      style={{ padding: '6px 14px', fontSize: '13px', cursor: 'pointer', background: '#1E3A8A', color: 'white', border: 'none', borderRadius: '6px' }}
                    >
                      Régénérer
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <p style={{ fontSize: '12px', color: '#9CA3AF', marginTop: '10px' }}>
            Un code régénéré s'affiche ici en vert — communique-le à l'élève, il pourra ensuite le changer lui-même depuis son écran.
          </p>
        </div>

        <h3>📚 Détail par thème</h3>
        {statsProf.themesAvecStats.map(t => (
          <div key={t.id} style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: '8px', padding: '16px', marginBottom: '14px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <strong>{t.code} — {t.intitule}</strong>
              <span style={{ fontSize: '13px', color: '#059669' }}>{t.nbMaitrise} élève(s) au niveau maîtrise</span>
            </div>
            {t.questionsRatees.length > 0 ? (
              <div style={{ marginTop: '10px' }}>
                <p style={{ fontSize: '13px', color: '#6B7280', margin: '0 0 6px' }}>Questions les plus ratées :</p>
                <ul style={{ fontSize: '13px', margin: 0 }}>
                  {t.questionsRatees.map(q => (
                    <li key={q.id}>{q.enonce} <span style={{ color: '#DC2626' }}>({q.nbRates} échec(s))</span></li>
                  ))}
                </ul>
              </div>
            ) : (
              <p style={{ fontSize: '13px', color: '#9CA3AF', marginTop: '8px' }}>Aucune question ratée pour l'instant.</p>
            )}
          </div>
        ))}
      </div>
    );
  }

  if (vue === 'themes') {
    return (
      <div style={conteneur}>
        {boutonRetour}
        <h1 style={{ color: '#1E3A8A' }}>📚 Révisions — {utilisateur}</h1>
        <p style={{ color: '#6B7280' }}>Choisissez un thème. Chaque quiz dure 10 à 15 minutes.</p>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '16px', marginTop: '20px' }}>
          {themes.map(t => {
            const prog = progression[t.id];
            const maitrise = prog?.statut === 'maitrise';
            const palier = paliers[t.id];
            return (
              <button
                key={t.id}
                onClick={() => demarrerQuiz(t)}
                style={{
                  textAlign: 'left', padding: '18px', borderRadius: '12px', cursor: 'pointer',
                  border: maitrise ? '2px solid #059669' : '2px solid #E5E7EB',
                  background: maitrise ? '#F0FDF4' : 'white',
                }}
              >
                <div style={{ fontSize: '14px', color: '#6B7280' }}>{t.code}</div>
                <div style={{ fontWeight: 'bold', marginBottom: '6px' }}>{t.intitule}</div>
                {maitrise ? (
                  <span style={{ color: '#059669', fontSize: '13px' }}>🏅 Thème maîtrisé{prog?.joker_disponible && !prog?.joker_utilise ? ' • 🃏 Joker disponible' : ''}</span>
                ) : (
                  <span style={{ color: '#9CA3AF', fontSize: '13px' }}>En cours…</span>
                )}
                {palier && <div style={{ fontSize: '12px', color: '#1E3A8A', marginTop: '6px' }}>🏢 {palier.titre}</div>}
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  if (vue === 'quiz') {
    const question = file[indexCourant];
    const progressionPct = Math.round((nbVues / Math.max(file.length, 1)) * 100);
    return (
      <div style={conteneur}>
        {boutonRetour}
        <div style={{ marginBottom: '16px' }}>
          <div style={{ background: '#E5E7EB', borderRadius: '20px', height: '10px', overflow: 'hidden' }}>
            <div style={{ background: '#059669', height: '100%', width: `${progressionPct}%`, transition: 'width 0.3s' }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '6px', fontSize: '13px', color: '#6B7280' }}>
            <span>{themeChoisi?.code} — {themeChoisi?.intitule}</span>
            <span>🔥 Série : {streak}</span>
          </div>
        </div>

        <div style={{ background: '#F3F4F6', padding: '26px', borderRadius: '12px' }}>
          <h3 style={{ marginTop: 0 }}>{question.enonce}</h3>
          <div style={{ display: 'grid', gap: '10px', marginTop: '16px' }}>
            {question.choix.map((choix, i) => {
              let style = {
                padding: '14px 16px', borderRadius: '8px', cursor: aRepondu ? 'default' : 'pointer',
                border: '2px solid #CBD5E1', background: 'white', textAlign: 'left',
              };
              if (aRepondu) {
                if (i === question.bonne_reponse_index) {
                  style = { ...style, border: '2px solid #059669', background: '#D1FAE5' };
                } else if (i === reponseSelectionnee) {
                  style = { ...style, border: '2px solid #DC2626', background: '#FEE2E2' };
                }
              }
              return (
                <button key={i} onClick={() => validerReponse(i)} disabled={aRepondu} style={style}>
                  {choix}
                </button>
              );
            })}
          </div>

          {aRepondu && (
            <div style={{ marginTop: '18px', padding: '16px', borderRadius: '8px', background: reponseSelectionnee === question.bonne_reponse_index ? '#D1FAE5' : '#FEF3C7' }}>
              <p style={{ margin: 0 }}>
                {reponseSelectionnee === question.bonne_reponse_index ? '✅ Bonne réponse ! ' : "↩️ Pas tout à fait — cette question reviendra un peu plus tard. "}
                {question.feedback_pedagogique}
              </p>
              <button onClick={questionSuivante} style={{ marginTop: '12px', padding: '10px 20px', background: '#1E3A8A', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer' }}>
                Continuer →
              </button>
            </div>
          )}
        </div>
      </div>
    );
  }

  if (vue === 'bilan') {
    return (
      <div style={conteneur}>
        {boutonRetour}
        <h1 style={{ color: '#1E3A8A' }}>🎉 Session terminée !</h1>
        <div style={{ background: '#F3F4F6', padding: '24px', borderRadius: '12px', marginBottom: '20px' }}>
          <p>Bonnes réponses : <strong>{nbBonnes}</strong></p>
          <p>Meilleure série de la session : <strong>🔥 {meilleurStreak}</strong></p>
          <p style={{ color: '#059669', fontWeight: 'bold' }}>
            {nbBonnes === nbVues ? 'Sans faute, bravo !' : 'Bon travail, continuez comme ça !'}
          </p>
        </div>

        {palierDebloque && (
          <div style={{ background: '#EFF6FF', border: '2px solid #1E3A8A', borderRadius: '12px', padding: '20px', marginBottom: '20px' }}>
            <h3 style={{ marginTop: 0, color: '#1E3A8A' }}>🏅 Thème maîtrisé !</h3>
            <p><strong>{palierDebloque.titre}</strong></p>
            <p style={{ margin: 0 }}>{palierDebloque.description}</p>
          </div>
        )}

        {jokerDebloque && (
          <div style={{ background: '#FEF3C7', border: '2px solid #F59E0B', borderRadius: '12px', padding: '20px', marginBottom: '20px' }}>
            <h3 style={{ marginTop: 0 }}>🃏 Joker "dispense d'interro" débloqué !</h3>
            {!jokerEnvoye ? (
              <>
                <p>Sur quelle évaluation mineure souhaitez-vous l'utiliser ? (vous pourrez le garder pour plus tard si vous préférez)</p>
                <input
                  type="text"
                  value={texteJoker}
                  onChange={e => setTexteJoker(e.target.value)}
                  placeholder="Ex : interrogation écrite du 12/10"
                  style={{ width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #CBD5E1', marginBottom: '10px', boxSizing: 'border-box' }}
                />
                <button onClick={utiliserJoker} style={{ padding: '10px 20px', background: '#F59E0B', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer' }}>
                  Utiliser mon joker
                </button>
              </>
            ) : (
              <p style={{ color: '#059669' }}>✅ Joker enregistré — montrez cet écran à votre professeur.</p>
            )}
          </div>
        )}

        <button onClick={retourThemes} style={{ padding: '12px 24px', background: '#1E3A8A', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer' }}>
          ← Retour aux thèmes
        </button>
      </div>
    );
  }

  return null;
}

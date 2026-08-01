import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const ICONES_SERVICE = {
  RH: '📇',
  CONF: '🛡️',
  MARKETING: '📣',
};

export default function MonAgence({ utilisateur, onRetour }) {
  const [chargement, setChargement] = useState(true);
  const [paliers, setPaliers] = useState([]);
  const [badgesServices, setBadgesServices] = useState([]);
  const [encouragement, setEncouragement] = useState('');
  const [historique, setHistorique] = useState([]);

  useEffect(() => {
    chargerTout();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function chargerTout() {
    setChargement(true);
    const [
      { data: comp },
      { data: pal },
      { data: prog },
      { data: missionsAll },
      { data: reponses },
      { data: profils },
      { data: maitrisesLog },
    ] = await Promise.all([
      supabase.from('competences').select('*'),
      supabase.from('revision_narratif_paliers').select('*'),
      supabase.from('revision_theme_progress').select('*').eq('student_id', utilisateur),
      supabase.from('missions').select('id,titre,profil_code'),
      supabase.from('reponses_eleves').select('mission_id,reponse_texte,lien_url,fichier_url,updated_at').eq('eleve_nom', utilisateur),
      supabase.from('profils_metier').select('code,nom'),
      supabase.from('revision_maitrises_log').select('theme_id,date_maitrise').eq('student_id', utilisateur).order('date_maitrise', { ascending: false }).limit(5),
    ]);

    const palMap = {};
    (pal || []).forEach(p => { palMap[p.theme_id] = p; });
    const progMap = {};
    (prog || []).forEach(p => { progMap[p.theme_id] = p; });
    const themeIntituleMap = {};
    (comp || []).forEach(c => { themeIntituleMap[c.id] = `${c.code} — ${c.intitule}`; });

    const paliersTries = (comp || [])
      .filter(c => palMap[c.id])
      .map(c => ({
        ...c,
        palier: palMap[c.id],
        maitrise: progMap[c.id]?.statut === 'maitrise',
      }))
      .sort((a, b) => a.palier.ordre - b.palier.ordre);
    setPaliers(paliersTries);

    const missionTitreMap = {};
    (missionsAll || []).forEach(m => { missionTitreMap[m.id] = m.titre; });

    const idsReponduValide = new Set(
      (reponses || [])
        .filter(r => (r.reponse_texte && r.reponse_texte.trim()) || r.lien_url || r.fichier_url)
        .map(r => r.mission_id)
    );

    const missionsParService = {};
    (missionsAll || []).forEach(m => {
      if (!missionsParService[m.profil_code]) missionsParService[m.profil_code] = [];
      missionsParService[m.profil_code].push(m);
    });

    const badges = Object.entries(missionsParService)
      .filter(([, liste]) => liste.length > 0)
      .map(([code, liste]) => {
        const obtenus = liste.filter(m => idsReponduValide.has(m.id)).length;
        const total = liste.length;
        const nom = (profils || []).find(p => p.code === code)?.nom || code;
        return { code, nom, obtenus, total, complete: obtenus === total };
      });
    setBadgesServices(badges);

    const incomplets = badges.filter(b => !b.complete).sort((a, b) => (a.total - a.obtenus) - (b.total - b.obtenus));
    if (badges.length === 0) {
      setEncouragement("Commence une mission pour débloquer ton premier badge métier !");
    } else if (incomplets.length === 0) {
      setEncouragement('🏆 Tous tes badges métiers sont débloqués, bravo !');
    } else {
      const cible = incomplets[0];
      const manque = cible.total - cible.obtenus;
      setEncouragement(`Plus que ${manque} mission${manque > 1 ? 's' : ''} pour débloquer ton badge « ${cible.nom} » !`);
    }

    const activitesMissions = (reponses || [])
      .filter(r => r.updated_at)
      .map(r => ({ date: r.updated_at, label: `📝 Mission rendue — ${missionTitreMap[r.mission_id] || 'mission'}` }));
    const activitesTheme = (maitrisesLog || [])
      .map(m => ({ date: m.date_maitrise, label: `🏅 Thème maîtrisé — ${themeIntituleMap[m.theme_id] || ''}` }));
    const historiqueTrie = [...activitesMissions, ...activitesTheme]
      .sort((a, b) => new Date(b.date) - new Date(a.date))
      .slice(0, 5);
    setHistorique(historiqueTrie);

    setChargement(false);
  }

  if (chargement) {
    return (
      <div style={{ padding: '32px', maxWidth: '820px', margin: '0 auto' }}>
        <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}>← Retour</button>
        <p>Chargement…</p>
      </div>
    );
  }

  return (
    <div style={{ padding: '32px', maxWidth: '820px', margin: '0 auto' }}>
      <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}>← Retour</button>
      <h1 style={{ color: '#1E3A8A' }}>🏢 Mon agence — {utilisateur}</h1>

      <div style={{ background: '#EFF6FF', border: '2px solid #1E3A8A', borderRadius: '12px', padding: '18px', marginBottom: '28px' }}>
        <p style={{ margin: 0, fontWeight: '600', color: '#1E3A8A' }}>{encouragement}</p>
      </div>

      <h3>🎖️ Mes badges métiers</h3>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '14px', marginBottom: '30px' }}>
        {badgesServices.map(b => (
          <div key={b.code} style={{
            padding: '16px', borderRadius: '12px', textAlign: 'center',
            border: b.complete ? '2px solid #059669' : '2px solid #E5E7EB',
            background: b.complete ? '#F0FDF4' : '#F9FAFB',
          }}>
            <div style={{ fontSize: '30px' }}>{b.complete ? (ICONES_SERVICE[b.code] || '🏢') : '🔒'}</div>
            <div style={{ fontWeight: '700', marginTop: '6px' }}>{b.nom}</div>
            <div style={{ fontSize: '13px', color: b.complete ? '#059669' : '#9CA3AF', marginTop: '4px' }}>
              {b.obtenus} / {b.total} missions
            </div>
          </div>
        ))}
      </div>

      <h3>🗺️ Développement de mon agence</h3>
      <p style={{ color: '#6B7280', fontSize: '14px' }}>Chaque thème de révision maîtrisé fait grandir ton agence virtuelle.</p>
      <div style={{ display: 'grid', gap: '10px', marginBottom: '30px' }}>
        {paliers.map(p => (
          <div key={p.id} style={{
            display: 'flex', alignItems: 'center', gap: '14px', padding: '14px 16px', borderRadius: '10px',
            background: p.maitrise ? '#F0FDF4' : '#F9FAFB',
            border: p.maitrise ? '2px solid #059669' : '2px dashed #D1D5DB',
          }}>
            <div style={{ fontSize: '22px' }}>{p.maitrise ? '🏢' : '🔒'}</div>
            <div>
              <div style={{ fontWeight: '700', color: p.maitrise ? '#059669' : '#9CA3AF' }}>
                {p.palier.titre}
              </div>
              <div style={{ fontSize: '13px', color: '#6B7280' }}>
                {p.maitrise ? p.palier.description : `À débloquer — thème ${p.code}`}
              </div>
            </div>
          </div>
        ))}
      </div>

      <h3>🕘 Dernières activités</h3>
      {historique.length === 0 ? (
        <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Pas encore d'activité — lance-toi sur une mission ou un quiz de révision !</p>
      ) : (
        <ul style={{ fontSize: '14px', paddingLeft: '20px' }}>
          {historique.map((h, i) => (
            <li key={i}>
              {h.label} <span style={{ color: '#9CA3AF' }}>
                — {new Date(h.date).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric' })}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const STATUT_LABEL = {
  cours: null,
  vacances: { texte: '🏖️ Vacances scolaires', couleur: '#6B7280', bg: '#F3F4F6' },
  stage: { texte: '🏢 Stage (PFMP)', couleur: '#7C3AED', bg: '#F3E8FF' },
};

function typeSemaine(intitule) {
  if (intitule.startsWith('Vacances')) return 'vacances';
  if (intitule.startsWith('Stage')) return 'stage';
  return 'cours';
}

export default function Progression({ onRetour }) {
  const [chargement, setChargement] = useState(true);
  const [semaines, setSemaines] = useState([]);

  useEffect(() => {
    chargerProgression();
  }, []);

  async function chargerProgression() {
    setChargement(true);
    const { data } = await supabase
      .from('progression')
      .select('*')
      .eq('annee_scolaire', '2026-2027')
      .order('semaine');

    const parSemaine = {};
    (data || []).forEach(row => {
      if (!parSemaine[row.semaine]) {
        parSemaine[row.semaine] = {
          semaine: row.semaine,
          date_debut: row.date_debut,
          date_fin: row.date_fin,
          type: typeSemaine(row.intitule),
          parFiliere: {},
        };
      }
      parSemaine[row.semaine].parFiliere[row.filiere] = row.intitule;
    });
    setSemaines(Object.values(parSemaine).sort((a, b) => a.semaine - b.semaine));
    setChargement(false);
  }

  function estSemaineActuelle(deb, fin) {
    const aujourdhui = new Date();
    return aujourdhui >= new Date(deb) && aujourdhui <= new Date(fin + 'T23:59:59');
  }

  if (chargement) {
    return (
      <div style={{ padding: '32px', maxWidth: '900px', margin: '0 auto' }}>
        <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}>← Retour</button>
        <p>Chargement…</p>
      </div>
    );
  }

  return (
    <div style={{ padding: '32px', maxWidth: '900px', margin: '0 auto' }}>
      <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}>← Retour</button>
      <h1 style={{ color: '#1E3A8A' }}>📅 Progression de l'année — 1PGA2 (2026-2027)</h1>
      <p style={{ color: '#6B7280', fontSize: '14px' }}>TP 7h · Gestion-Administration 3,5h · Économie-Droit 1,5h</p>

      <div style={{ display: 'grid', gap: '10px', marginTop: '20px' }}>
        {semaines.map(s => {
          const actuelle = estSemaineActuelle(s.date_debut, s.date_fin);
          const infoSpeciale = STATUT_LABEL[s.type];
          return (
            <div
              key={s.semaine}
              style={{
                border: actuelle ? '2px solid #1E3A8A' : '1px solid #E5E7EB',
                borderRadius: '10px', padding: '14px 18px',
                background: infoSpeciale ? infoSpeciale.bg : (actuelle ? '#EFF6FF' : 'white'),
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '8px' }}>
                <strong style={{ color: '#1E3A8A' }}>
                  Semaine {s.semaine} — {new Date(s.date_debut).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })} au {new Date(s.date_fin).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })}
                </strong>
                {actuelle && <span style={{ fontSize: '12px', background: '#1E3A8A', color: 'white', padding: '2px 10px', borderRadius: '10px' }}>Semaine actuelle</span>}
                {infoSpeciale && <span style={{ fontSize: '13px', fontWeight: '700', color: infoSpeciale.couleur }}>{infoSpeciale.texte}</span>}
              </div>

              {s.type === 'cours' && (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '10px', marginTop: '10px', fontSize: '13px' }}>
                  <div>
                    <div style={{ fontWeight: '700', color: '#6B7280' }}>TP 7h</div>
                    <div>{s.parFiliere['TP']}</div>
                  </div>
                  <div>
                    <div style={{ fontWeight: '700', color: '#6B7280' }}>Gestion-Administration 3,5h</div>
                    <div>{s.parFiliere['Gestion-Administration']}</div>
                  </div>
                  <div>
                    <div style={{ fontWeight: '700', color: '#6B7280' }}>Économie-Droit 1,5h</div>
                    <div>{s.parFiliere['Eco-Droit']}</div>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

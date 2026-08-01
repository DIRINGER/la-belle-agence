import { useState, useEffect, useRef } from 'react';
import { supabase } from './supabaseClient';
import { lancerConfettis } from './confetti';

const COULEURS = ['#1E3A8A', '#059669', '#F59E0B', '#DC2626', '#7C3AED', '#0EA5E9', '#DB2777', '#65A30D', '#D97706', '#0D9488'];

export default function RoueOrale({ onRetour }) {
  const [elevesRoster, setElevesRoster] = useState([]);
  const [tirages, setTirages] = useState([]);
  const [segments, setSegments] = useState([]);
  const [exclureRecents, setExclureRecents] = useState(true);
  const [joursExclusion, setJoursExclusion] = useState(5);
  const [enRotation, setEnRotation] = useState(false);
  const [gagnant, setGagnant] = useState(null);
  const wheelRef = useRef(null);

  useEffect(() => {
    chargerRoster();
    chargerHistorique();
  }, []);

  async function chargerRoster() {
    const { data } = await supabase.from('eleves_roster').select('*').order('nom');
    setElevesRoster(data || []);
    setSegments(data || []);
  }

  async function chargerHistorique() {
    const { data } = await supabase
      .from('roue_tirages')
      .select('*')
      .order('date_tirage', { ascending: false })
      .limit(15);
    setTirages(data || []);
  }

  function calculerCandidats() {
    if (!exclureRecents) return elevesRoster;
    const seuil = new Date();
    seuil.setDate(seuil.getDate() - joursExclusion);
    const nomsRecents = new Set(
      tirages.filter(t => new Date(t.date_tirage) >= seuil).map(t => t.eleve_nom)
    );
    const filtres = elevesRoster.filter(e => !nomsRecents.has(e.nom));
    return filtres.length > 0 ? filtres : elevesRoster;
  }

  function construireDegrade(liste) {
    const n = liste.length;
    if (n === 0) return 'none';
    const stops = liste.map((_, i) => {
      const couleur = COULEURS[i % COULEURS.length];
      const debut = (i / n) * 100;
      const fin = ((i + 1) / n) * 100;
      return `${couleur} ${debut}% ${fin}%`;
    });
    return `conic-gradient(${stops.join(', ')})`;
  }

  function girerLaRoue() {
    if (enRotation) return;
    const candidats = calculerCandidats();
    const n = candidats.length;
    if (n === 0) return;

    const segmentAngle = 360 / n;
    const indexGagnant = Math.floor(Math.random() * n);
    const angleCentre = indexGagnant * segmentAngle + segmentAngle / 2;
    const extraTours = 6;
    const delta = (360 - angleCentre + 360) % 360;
    const rotationFinale = extraTours * 360 + delta;

    setSegments(candidats);
    setGagnant(null);
    setEnRotation(true);

    const el = wheelRef.current;
    if (el) {
      el.style.backgroundImage = construireDegrade(candidats);
      el.style.transition = 'none';
      el.style.transform = 'rotate(0deg)';
      // eslint-disable-next-line no-unused-expressions
      el.offsetHeight;
      el.style.transition = 'transform 4.2s cubic-bezier(0.12, 0.72, 0.24, 1)';
      el.style.transform = `rotate(${rotationFinale}deg)`;
    }

    setTimeout(async () => {
      const nomGagnant = candidats[indexGagnant].nom;
      setGagnant(nomGagnant);
      setEnRotation(false);
      await supabase.from('roue_tirages').insert({ eleve_nom: nomGagnant });
      chargerHistorique();
      lancerConfettis();
    }, 4300);
  }

  const rayon = 130;
  const centre = 160;

  return (
    <div style={{ padding: '32px', maxWidth: '760px', margin: '0 auto', textAlign: 'center' }}>
      <button onClick={onRetour} style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px', float: 'left' }}>
        ← Retour
      </button>
      <h1 style={{ color: '#1E3A8A', clear: 'both' }}>🎡 Roue à l'oral</h1>
      <p style={{ color: '#6B7280' }}>Fais tourner la roue pour désigner un élève qui passe à l'oral.</p>

      <div style={{ margin: '16px 0', display: 'flex', gap: '16px', justifyContent: 'center', alignItems: 'center', flexWrap: 'wrap', fontSize: '14px' }}>
        <label style={{ display: 'flex', gap: '6px', alignItems: 'center', cursor: 'pointer' }}>
          <input type="checkbox" checked={exclureRecents} onChange={e => setExclureRecents(e.target.checked)} />
          Exclure les élèves déjà tirés dans les derniers
        </label>
        <input
          type="number"
          min={1}
          max={30}
          value={joursExclusion}
          onChange={e => setJoursExclusion(Math.max(1, parseInt(e.target.value, 10) || 1))}
          style={{ width: '60px', padding: '6px', border: '1px solid #CBD5E1', borderRadius: '6px' }}
        />
        <span>jour(s)</span>
      </div>

      <div style={{ position: 'relative', width: `${centre * 2}px`, margin: '30px auto' }}>
        <div style={{
          position: 'absolute', top: '-14px', left: '50%', transform: 'translateX(-50%)',
          width: 0, height: 0, borderLeft: '14px solid transparent', borderRight: '14px solid transparent',
          borderTop: '22px solid #DC2626', zIndex: 5,
        }} />
        <div
          ref={wheelRef}
          style={{
            width: `${centre * 2}px`, height: `${centre * 2}px`, borderRadius: '50%',
            backgroundImage: construireDegrade(segments),
            border: '6px solid #1E3A8A', position: 'relative', margin: '0 auto',
            boxShadow: '0 4px 18px rgba(0,0,0,0.18)',
          }}
        >
          {segments.map((eleve, i) => {
            const n = segments.length;
            const angleDeg = (i * (360 / n)) + (360 / n) / 2;
            const angleRad = (angleDeg * Math.PI) / 180;
            const x = centre + (rayon - 30) * Math.sin(angleRad);
            const y = centre - (rayon - 30) * Math.cos(angleRad);
            return (
              <span
                key={eleve.id}
                style={{
                  position: 'absolute', left: `${x}px`, top: `${y}px`,
                  transform: 'translate(-50%, -50%)', fontSize: '10px', fontWeight: '700',
                  color: 'white', textShadow: '0 1px 2px rgba(0,0,0,0.5)', width: '70px',
                  textAlign: 'center', pointerEvents: 'none',
                }}
              >
                {eleve.nom.split(' ')[0]}
              </span>
            );
          })}
          <div style={{
            position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
            width: '30px', height: '30px', borderRadius: '50%', background: 'white',
            border: '4px solid #1E3A8A',
          }} />
        </div>
      </div>

      <button
        onClick={girerLaRoue}
        disabled={enRotation || elevesRoster.length === 0}
        style={{
          padding: '16px 36px', fontSize: '17px', fontWeight: '700', cursor: enRotation ? 'not-allowed' : 'pointer',
          background: enRotation ? '#9CA3AF' : '#059669', color: 'white', border: 'none', borderRadius: '50px',
        }}
      >
        {enRotation ? 'Ça tourne…' : '🎯 Faire tourner la roue'}
      </button>

      {gagnant && (
        <div style={{ marginTop: '26px', background: '#F0FDF4', border: '2px solid #059669', borderRadius: '12px', padding: '20px' }}>
          <p style={{ margin: 0, fontSize: '14px', color: '#6B7280' }}>Élève désigné :</p>
          <p style={{ margin: '6px 0 0', fontSize: '26px', fontWeight: '700', color: '#059669' }}>🎉 {gagnant}</p>
        </div>
      )}

      <div style={{ marginTop: '36px', textAlign: 'left' }}>
        <h3>🕘 Historique des tirages</h3>
        {tirages.length === 0 ? (
          <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Aucun tirage pour l'instant.</p>
        ) : (
          <ul style={{ fontSize: '14px', paddingLeft: '20px' }}>
            {tirages.map(t => (
              <li key={t.id}>
                {t.eleve_nom} — {new Date(t.date_tirage).toLocaleString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

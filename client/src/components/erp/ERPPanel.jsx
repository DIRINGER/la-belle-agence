import { useState } from 'react';
import ClientForm   from './ClientForm';
import BienForm     from './BienForm';
import SalarieForm  from './SalarieForm';
import ProspectForm from './ProspectForm';
import MandatForm   from './MandatForm';

const ONGLETS = [
  { id: 'clients',   label: '👤 Clients',   couleur: '#1E3A8A' },
  { id: 'biens',     label: '🏠 Biens',     couleur: '#059669' },
  { id: 'salaries',  label: '🧑‍💼 Salariés', couleur: '#D97706' },
  { id: 'prospects', label: '🎯 Prospects', couleur: '#7C3AED' },
  { id: 'mandats',   label: '📋 Mandats',   couleur: '#DC2626' },
];

export default function ERPPanel({ onRetour }) {
  const [ongletActif, setOngletActif] = useState('clients');

  const onglet = ONGLETS.find(o => o.id === ongletActif);

  return (
    <div style={{ minHeight: '100vh', background: '#F8FAFC' }}>
      {/* En-tête */}
      <div style={{ background: '#1E3A8A', color: 'white', padding: '20px 32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <h1 style={{ margin: 0, fontSize: '22px' }}>🗂️ ERP — La Belle Agence</h1>
          <p style={{ margin: '4px 0 0', opacity: 0.8, fontSize: '14px' }}>Saisie des données — Jour 1</p>
        </div>
        {onRetour && (
          <button onClick={onRetour} style={{ padding: '10px 20px', background: 'rgba(255,255,255,0.15)', color: 'white', border: '1px solid rgba(255,255,255,0.4)', borderRadius: '8px', cursor: 'pointer', fontSize: '14px' }}>
            ← Retour à l'app
          </button>
        )}
      </div>

      {/* Onglets */}
      <div style={{ display: 'flex', borderBottom: '2px solid #E5E7EB', background: 'white', paddingLeft: '24px' }}>
        {ONGLETS.map(o => (
          <button
            key={o.id}
            onClick={() => setOngletActif(o.id)}
            style={{
              padding: '14px 24px',
              border: 'none',
              borderBottom: ongletActif === o.id ? `3px solid ${o.couleur}` : '3px solid transparent',
              background: 'none',
              cursor: 'pointer',
              fontSize: '15px',
              fontWeight: ongletActif === o.id ? '700' : '400',
              color: ongletActif === o.id ? o.couleur : '#6B7280',
              transition: 'all 0.15s',
              marginBottom: '-2px',
            }}
          >
            {o.label}
          </button>
        ))}
      </div>

      {/* Contenu */}
      <div style={{ maxWidth: '1100px', margin: '0 auto', padding: '32px 24px' }}>
        <div style={{ borderLeft: `4px solid ${onglet.couleur}`, paddingLeft: '16px', marginBottom: '28px' }}>
          <h2 style={{ margin: 0, color: onglet.couleur }}>
            {onglet.label}
          </h2>
          <p style={{ margin: '4px 0 0', color: '#6B7280', fontSize: '14px' }}>
            Remplis le formulaire et clique sur "Ajouter" pour enregistrer dans Supabase.
          </p>
        </div>

        {ongletActif === 'clients'   && <ClientForm />}
        {ongletActif === 'biens'     && <BienForm />}
        {ongletActif === 'salaries'  && <SalarieForm />}
        {ongletActif === 'prospects' && <ProspectForm />}
        {ongletActif === 'mandats'   && <MandatForm />}
      </div>
    </div>
  );
}

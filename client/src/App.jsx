import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';
 import ERPPanel from './components/erp/ERPPanel';

function App() {
  const [utilisateur, setUtilisateur] = useState(null);
  const [roleChoisi, setRoleChoisi] = useState(null);
  const [roles, setRoles] = useState([]);
  const [missions, setMissions] = useState([]);
  const [missionEnCours, setMissionEnCours] = useState(null);
  const [afficherIndice, setAfficherIndice] = useState(false);
  const [afficherCorrection, setAfficherCorrection] = useState(false);
  const [afficherERP, setAfficherERP] = useState(false);

  const eleves = [
    'Christophe DIRINGER (Prof)',
    'Anisa ADEMAJ', 'Tiago AFONSO', 'Sofia ARRADI', 'Melisa ARSLANFER',
    'Imene BAHROUME', 'Meline BRETINIER', 'Alessandra CARDIA',
    'Leonor CARVALHO MARQUES', 'Ana Beatriz DA SILVA COSTA',
    'Eve DI GRAZIA-DIEDA', 'Farah EL AZIZ', 'Leonardo FERREIRIA',
    'Maxim GUILLOT', 'Mirsada GUSANII', 'Jon HALILI',
    'Aya HAMMENA', 'Rawda KOCAASLAN', 'Belen KUL',
    'Romane LAUFFENBURGER', 'Caroline RODRIGUES EIRAO',
    'Léonit RUKOVCI', 'Emma SCHULL', 'Lorik SYLEJMANI', 'Darine ZELLAGUI'
  ];

  // Charger les rôles au démarrage
  useEffect(() => {
    async function chargerRoles() {
      const { data, error } = await supabase
        .from('profils_metier')
        .select('*')
        .order('nom');
      
      if (error) {
        console.error('Erreur chargement rôles:', error);
      } else {
        setRoles(data || []);
      }
    }
    chargerRoles();
  }, []);

  // Charger les missions quand un rôle est choisi
  useEffect(() => {
    if (roleChoisi) {
      async function chargerMissions() {
        const { data, error } = await supabase
          .from('missions')
          .select('*')
          .eq('profil_code', roleChoisi.code)
          .limit(5);
        
        if (error) {
          console.error('Erreur chargement missions:', error);
        } else {
          setMissions(data || []);
        }
      }
      chargerMissions();
    }
  }, [roleChoisi]);

// ERP pour le professeur
  if (utilisateur === 'Christophe DIRINGER (Prof)') {
    return <ERPPanel onRetour={() => setUtilisateur(null)} />;
  }  

  if (afficherERP) return <ERPPanel onRetour={() => setAfficherERP(false)} />;

  const btnERP = (
    <button
      onClick={() => setAfficherERP(true)}
      style={{
        position: 'fixed',
        bottom: '24px',
        right: '24px',
        padding: '14px 22px',
        background: '#1E3A8A',
        color: 'white',
        border: 'none',
        borderRadius: '50px',
        cursor: 'pointer',
        fontSize: '15px',
        fontWeight: '700',
        boxShadow: '0 4px 15px rgba(30,58,138,0.4)',
        zIndex: 1000,
      }}
    >
      🗂️ ERP
    </button>
  );

  // Page 1 : Sélection utilisateur
  if (!utilisateur) {
    return (
      <div style={{ padding: '40px', textAlign: 'center' }}>
        <h1 style={{ color: '#1E3A8A' }}>🏢 LA BELLE AGENCE</h1>
        <h2>Qui êtes-vous ?</h2>
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: '15px', 
          maxWidth: '1200px', 
          margin: '40px auto' 
        }}>
          {eleves.map((nom, index) => (
            <button 
              key={index}
              onClick={() => setUtilisateur(nom)}
              style={{
                padding: '20px',
                fontSize: '16px',
                cursor: 'pointer',
                border: '2px solid #1E3A8A',
                borderRadius: '8px',
                background: 'white',
                transition: 'all 0.3s'
              }}
              onMouseOver={(e) => e.target.style.background = '#E0E7FF'}
              onMouseOut={(e) => e.target.style.background = 'white'}
            >
              {nom}
            </button>
          ))}
        </div>
        {btnERP}
      </div>
    );
  }

  // Page 2 : Choix du rôle
  if (!roleChoisi) {
    return (
      <div style={{ padding: '40px' }}>
        <div style={{ textAlign: 'center', marginBottom: '40px' }}>
          <h1 style={{ color: '#1E3A8A' }}>Bonjour {utilisateur} ! 👋</h1>
          <h2>Quel rôle voulez-vous jouer aujourd'hui ?</h2>
          <button 
            onClick={() => setUtilisateur(null)}
            style={{ padding: '10px 20px', marginTop: '20px', cursor: 'pointer' }}
          >
            ← Changer d'utilisateur
          </button>
        </div>
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
          gap: '20px', 
          maxWidth: '1200px', 
          margin: '0 auto' 
        }}>
          {roles.map((role) => (
            <button
              key={role.code}
              onClick={() => setRoleChoisi(role)}
              style={{
                padding: '30px',
                textAlign: 'left',
                cursor: 'pointer',
                border: '2px solid #059669',
                borderRadius: '12px',
                background: 'white',
                transition: 'all 0.3s'
              }}
              onMouseOver={(e) => e.target.style.background = '#D1FAE5'}
              onMouseOut={(e) => e.target.style.background = 'white'}
            >
              <div style={{ fontSize: '18px', fontWeight: 'bold' }}>
                {role.nom}
              </div>
            </button>
          ))}
        </div>
        {btnERP}
      </div>
    );
  }

  // Page 4 : Détail d'une mission
  if (missionEnCours) {
    return (
      <div style={{ padding: '40px', maxWidth: '900px', margin: '0 auto' }}>
        <button 
          onClick={() => {
            setMissionEnCours(null);
            setAfficherIndice(false);
            setAfficherCorrection(false);
          }}
          style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}
        >
          ← Retour aux missions
        </button>

        <div style={{ background: '#F3F4F6', padding: '30px', borderRadius: '12px' }}>
          <h1>{missionEnCours.titre}</h1>
          <p><strong>Difficulté :</strong> {missionEnCours.difficulte} • <strong>Durée :</strong> {missionEnCours.duree_minutes} min</p>
          
          <div style={{ marginTop: '30px' }}>
            <h3>📋 Contexte</h3>
            <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.contexte}</p>
          </div>

          <div style={{ marginTop: '30px' }}>
            <h3>✅ Instructions</h3>
            <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.instructions}</p>
          </div>

          <div style={{ marginTop: '30px', display: 'flex', gap: '15px' }}>
            <button 
              onClick={() => setAfficherIndice(!afficherIndice)}
              style={{ 
                padding: '15px 30px', 
                background: '#F59E0B', 
                color: 'white', 
                border: 'none', 
                borderRadius: '8px', 
                cursor: 'pointer',
                fontSize: '16px'
              }}
            >
              💡 {afficherIndice ? 'Masquer' : 'Voir'} l'indice
            </button>

            <button 
              onClick={() => setAfficherCorrection(!afficherCorrection)}
              style={{ 
                padding: '15px 30px', 
                background: '#059669', 
                color: 'white', 
                border: 'none', 
                borderRadius: '8px', 
                cursor: 'pointer',
                fontSize: '16px'
              }}
            >
              📖 {afficherCorrection ? 'Masquer' : 'Voir'} la correction
            </button>
          </div>

          {afficherIndice && missionEnCours.indice && (
            <div style={{ marginTop: '20px', background: '#FEF3C7', padding: '20px', borderRadius: '8px', border: '2px solid #F59E0B' }}>
              <h3>💡 Indice</h3>
              <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.indice}</p>
            </div>
          )}

          {afficherCorrection && missionEnCours.correction_detaillee && (
            <div style={{ marginTop: '20px', background: '#D1FAE5', padding: '20px', borderRadius: '8px', border: '2px solid #059669' }}>
              <h3>📖 Correction détaillée</h3>
              <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.correction_detaillee}</p>
            </div>
          )}
        </div>
        {btnERP}
      </div>
    );
  }

  // Page 3 : Liste des missions
  return (
    <div style={{ padding: '40px' }}>
      <div style={{ background: '#1E3A8A', color: 'white', padding: '20px', borderRadius: '8px', marginBottom: '30px' }}>
        <h1>🏢 LA BELLE AGENCE</h1>
        <p style={{ fontSize: '18px' }}>
          {utilisateur} - {roleChoisi.nom}
        </p>
        <button 
          onClick={() => {
            setRoleChoisi(null);
            setMissions([]);
          }}
          style={{ padding: '10px 20px', cursor: 'pointer', marginTop: '10px' }}
        >
          ← Changer de rôle
        </button>
      </div>

      <h2>📋 Vos missions</h2>
      {missions.length === 0 ? (
        <p>Chargement des missions...</p>
      ) : (
        <div style={{ display: 'grid', gap: '20px', maxWidth: '800px' }}>
          {missions.map((mission) => (
            <div key={mission.code} style={{ border: '2px solid #ddd', padding: '20px', borderRadius: '8px' }}>
              <h3>{mission.titre}</h3>
              <p>Difficulté : {mission.difficulte} • Durée : {mission.duree_minutes} min</p>
              <button 
                onClick={() => setMissionEnCours(mission)}
                style={{ 
                  padding: '10px 20px', 
                  background: '#059669', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '4px', 
                  cursor: 'pointer' 
                }}
              >
                Commencer
              </button>
            </div>
          ))}
        </div>
      )}
      {btnERP}
    </div>
  );
}

export default App;
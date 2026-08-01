import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';
import ERPServices from './components/erp/ERPServices';
import RevisionQuiz from './RevisionQuiz';
import RoueOrale from './RoueOrale';
import MonAgence from './MonAgence';
import { lancerConfettis } from './confetti';

const PIN_PROF = '2026'; // code simple pour protéger l'accès Prof et les corrections — change-le si tu veux

function App() {
  const [utilisateur, setUtilisateur]         = useState(null);
  const [roleChoisi, setRoleChoisi]           = useState(null);
  const [roles, setRoles]                     = useState([]);
  const [missions, setMissions]               = useState([]);
  const [missionEnCours, setMissionEnCours]   = useState(null);
  const [afficherERP, setAfficherERP]         = useState(false);
  const [afficherRevision, setAfficherRevision] = useState(false);
  const [afficherRoue, setAfficherRoue]       = useState(false);
  const [afficherAgence, setAfficherAgence]   = useState(false);

  const [ongletMission, setOngletMission]     = useState('donnees');
  const [afficherIndice, setAfficherIndice]   = useState(false);
  const [afficherCorrection, setAfficherCorrection] = useState(false);
  const [reponseTexte, setReponseTexte]       = useState('');
  const [reponseLien, setReponseLien]         = useState('');
  const [reponseFichierUrl, setReponseFichierUrl] = useState('');
  const [uploadingReponse, setUploadingReponse] = useState(false);
  const [sauvegarde, setSauvegarde]           = useState(null);
  const [templatesMission, setTemplatesMission] = useState([]);

  const [elevesRoster, setElevesRoster]       = useState([]);
  const [afficherChangementPin, setAfficherChangementPin] = useState(false);
  const [nouveauPin, setNouveauPin]           = useState('');
  const [messagePin, setMessagePin]           = useState(null);

  function choisirUtilisateur(nom) {
    if (nom === 'Christophe DIRINGER (Prof)') {
      const code = window.prompt('Code PIN professeur :');
      if (code !== PIN_PROF) { window.alert('Code incorrect.'); return; }
      setUtilisateur(nom);
      return;
    }
    const eleve = elevesRoster.find(e => e.nom === nom);
    if (!eleve) { window.alert("Élève introuvable — réessaie dans un instant."); return; }
    const code = window.prompt(`Code PIN de ${nom} :`);
    if (code !== eleve.pin) { window.alert('Code incorrect.'); return; }
    setUtilisateur(nom);
  }

  async function changerMonCode() {
    if (!/^\d{4}$/.test(nouveauPin)) {
      setMessagePin('❌ Le code doit contenir exactement 4 chiffres.');
      return;
    }
    const eleve = elevesRoster.find(e => e.nom === utilisateur);
    if (!eleve) { setMessagePin('❌ Élève introuvable.'); return; }
    const { error } = await supabase.from('eleves_roster').update({ pin: nouveauPin }).eq('id', eleve.id);
    if (error) {
      setMessagePin('❌ Erreur : ' + error.message);
    } else {
      setMessagePin('✅ Code PIN mis à jour !');
      setElevesRoster(prev => prev.map(e => e.id === eleve.id ? { ...e, pin: nouveauPin } : e));
      setNouveauPin('');
      setAfficherChangementPin(false);
    }
  }

  useEffect(() => {
    async function chargerRoles() {
      const { data, error } = await supabase
        .from('profils_metier')
        .select('*')
        .order('nom');
      if (error) { console.error('Erreur chargement rôles:', error); }
      else { setRoles(data || []); }
    }
    chargerRoles();
  }, []);

  useEffect(() => {
    async function chargerElevesRoster() {
      const { data, error } = await supabase
        .from('eleves_roster')
        .select('*')
        .order('nom');
      if (error) { console.error('Erreur chargement élèves:', error); }
      else { setElevesRoster(data || []); }
    }
    chargerElevesRoster();
  }, []);

  useEffect(() => {
    if (roleChoisi) {
      async function chargerMissions() {
        const { data, error } = await supabase
          .from('missions')
          .select('*')
          .eq('profil_code', roleChoisi.code)
          .order('titre')
          .limit(50);
        if (error) { console.error('Erreur chargement missions:', error); }
        else { setMissions(data || []); }
      }
      chargerMissions();
    }
  }, [roleChoisi]);

  useEffect(() => {
    if (missionEnCours?.service) {
      async function chargerTemplates() {
        const { data } = await supabase
          .from('templates_documents')
          .select('*')
          .eq('service', missionEnCours.service);
        setTemplatesMission(data || []);
      }
      chargerTemplates();
    } else {
      setTemplatesMission([]);
    }
  }, [missionEnCours]);

  useEffect(() => {
    if (!missionEnCours || !utilisateur) return;
    async function chargerReponse() {
      const { data } = await supabase
        .from('reponses_eleves')
        .select('*')
        .eq('mission_id', missionEnCours.id)
        .eq('eleve_nom', utilisateur)
        .maybeSingle();
      setReponseTexte(data?.reponse_texte || '');
      setReponseLien(data?.lien_url || '');
      setReponseFichierUrl(data?.fichier_url || '');
    }
    chargerReponse();
  }, [missionEnCours]);

  // ERP / Révisions / Roue pour le professeur
  if (utilisateur === 'Christophe DIRINGER (Prof)') {
    if (afficherRevision) return <RevisionQuiz utilisateur={utilisateur} estProf={true} onRetour={() => setAfficherRevision(false)} />;
    if (afficherRoue) return <RoueOrale onRetour={() => setAfficherRoue(false)} />;
    if (afficherERP) return <ERPServices onRetour={() => setAfficherERP(false)} />;
    return (
      <div style={{ padding: '40px', textAlign: 'center' }}>
        <h1 style={{ color: '#1E3A8A' }}>Bonjour Christophe 👋</h1>
        <div style={{ display: 'flex', gap: '20px', justifyContent: 'center', marginTop: '30px', flexWrap: 'wrap' }}>
          <button onClick={() => setAfficherERP(true)} style={{ padding: '20px 30px', fontSize: '16px', cursor: 'pointer', background: '#1E3A8A', color: 'white', border: 'none', borderRadius: '8px' }}>🗂️ Accéder à l'ERP</button>
          <button onClick={() => setAfficherRevision(true)} style={{ padding: '20px 30px', fontSize: '16px', cursor: 'pointer', background: '#059669', color: 'white', border: 'none', borderRadius: '8px' }}>📚 Tableau de bord Révisions</button>
          <button onClick={() => setAfficherRoue(true)} style={{ padding: '20px 30px', fontSize: '16px', cursor: 'pointer', background: '#DC2626', color: 'white', border: 'none', borderRadius: '8px' }}>🎡 Roue à l'oral</button>
        </div>
        <button onClick={() => setUtilisateur(null)} style={{ padding: '10px 20px', marginTop: '20px', cursor: 'pointer' }}>← Changer d'utilisateur</button>
      </div>
    );
  }

  if (afficherERP) return <ERPServices onRetour={() => setAfficherERP(false)} />;
  if (afficherRevision) return <RevisionQuiz utilisateur={utilisateur} estProf={false} onRetour={() => setAfficherRevision(false)} />;
  if (afficherAgence) return <MonAgence utilisateur={utilisateur} onRetour={() => setAfficherAgence(false)} />;

  const btnERP = (
    <button
      onClick={() => setAfficherERP(true)}
      style={{
        position: 'fixed', bottom: '24px', right: '24px',
        padding: '14px 22px', background: '#1E3A8A', color: 'white',
        border: 'none', borderRadius: '50px', cursor: 'pointer',
        fontSize: '15px', fontWeight: '700',
        boxShadow: '0 4px 15px rgba(30,58,138,0.4)', zIndex: 1000,
      }}
    >
      🗂️ ERP
    </button>
  );

  const btnRevision = (
    <button
      onClick={() => setAfficherRevision(true)}
      style={{
        position: 'fixed', bottom: '24px', right: '110px',
        padding: '14px 22px', background: '#059669', color: 'white',
        border: 'none', borderRadius: '50px', cursor: 'pointer',
        fontSize: '15px', fontWeight: '700',
        boxShadow: '0 4px 15px rgba(5,150,105,0.4)', zIndex: 1000,
      }}
    >
      📚 Réviser
    </button>
  );

  const btnAgence = (
    <button
      onClick={() => setAfficherAgence(true)}
      style={{
        position: 'fixed', bottom: '24px', right: '196px',
        padding: '14px 22px', background: '#7C3AED', color: 'white',
        border: 'none', borderRadius: '50px', cursor: 'pointer',
        fontSize: '15px', fontWeight: '700',
        boxShadow: '0 4px 15px rgba(124,58,237,0.4)', zIndex: 1000,
      }}
    >
      🏢 Mon agence
    </button>
  );

  if (!utilisateur) {
    return (
      <div style={{ padding: '40px', textAlign: 'center' }}>
        <h1 style={{ color: '#1E3A8A' }}>🏢 LA BELLE AGENCE</h1>
        <h2>Qui êtes-vous ?</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '15px', maxWidth: '1200px', margin: '40px auto' }}>
          {elevesRoster.map((eleve) => (
            <button
              key={eleve.id}
              onClick={() => choisirUtilisateur(eleve.nom)}
              style={{ padding: '20px', fontSize: '16px', cursor: 'pointer', border: '2px solid #1E3A8A', borderRadius: '8px', background: 'white', transition: 'all 0.3s' }}
              onMouseOver={(e) => e.target.style.background = '#E0E7FF'}
              onMouseOut={(e) => e.target.style.background = 'white'}
            >
              {eleve.nom}
            </button>
          ))}
          <button
            onClick={() => choisirUtilisateur('Christophe DIRINGER (Prof)')}
            style={{ padding: '20px', fontSize: '16px', fontWeight: '600', cursor: 'pointer', border: '2px solid #F59E0B', borderRadius: '8px', background: '#FEF3C7', transition: 'all 0.3s' }}
          >
            Christophe DIRINGER (Prof)
          </button>
        </div>
        {btnERP}
      </div>
    );
  }

  if (!roleChoisi) {
    return (
      <div style={{ padding: '40px' }}>
        <div style={{ textAlign: 'center', marginBottom: '40px' }}>
          <h1 style={{ color: '#1E3A8A' }}>Bonjour {utilisateur} ! 👋</h1>
          <h2>Quel rôle voulez-vous jouer aujourd'hui ?</h2>
          <button onClick={() => setUtilisateur(null)} style={{ padding: '10px 20px', marginTop: '20px', cursor: 'pointer' }}>
            ← Changer d'utilisateur
          </button>

          <div style={{ marginTop: '16px' }}>
            {!afficherChangementPin ? (
              <button
                onClick={() => { setAfficherChangementPin(true); setMessagePin(null); }}
                style={{ padding: '8px 16px', fontSize: '13px', cursor: 'pointer', background: 'none', border: '1px solid #CBD5E1', borderRadius: '6px' }}
              >
                🔑 Changer mon code PIN
              </button>
            ) : (
              <div style={{ display: 'inline-flex', gap: '8px', alignItems: 'center', flexWrap: 'wrap', justifyContent: 'center' }}>
                <input
                  type="text"
                  maxLength={4}
                  value={nouveauPin}
                  onChange={(e) => setNouveauPin(e.target.value.replace(/\D/g, ''))}
                  placeholder="Nouveau code (4 chiffres)"
                  style={{ padding: '8px', width: '180px', border: '1px solid #CBD5E1', borderRadius: '6px' }}
                />
                <button onClick={changerMonCode} style={{ padding: '8px 16px', cursor: 'pointer', background: '#059669', color: 'white', border: 'none', borderRadius: '6px' }}>
                  Valider
                </button>
                <button
                  onClick={() => { setAfficherChangementPin(false); setNouveauPin(''); setMessagePin(null); }}
                  style={{ padding: '8px 16px', cursor: 'pointer', background: 'none', border: '1px solid #CBD5E1', borderRadius: '6px' }}
                >
                  Annuler
                </button>
              </div>
            )}
            {messagePin && (
              <p style={{ fontSize: '13px', marginTop: '8px', color: messagePin.startsWith('✅') ? '#059669' : '#DC2626' }}>
                {messagePin}
              </p>
            )}
          </div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '20px', maxWidth: '1200px', margin: '0 auto' }}>
          {roles.map((role) => (
            <button
              key={role.code}
              onClick={() => setRoleChoisi(role)}
              style={{ padding: '30px', textAlign: 'left', cursor: 'pointer', border: '2px solid #059669', borderRadius: '12px', background: 'white', transition: 'all 0.3s' }}
              onMouseOver={(e) => e.target.style.background = '#D1FAE5'}
              onMouseOut={(e) => e.target.style.background = 'white'}
            >
              <div style={{ fontSize: '18px', fontWeight: 'bold' }}>{role.nom}</div>
            </button>
          ))}
        </div>
        {btnERP}
        {btnRevision}
        {btnAgence}
      </div>
    );
  }

  if (missionEnCours) {
    const onglets = [
      { id: 'donnees',    label: '📊 Données' },
      { id: 'documents',  label: '📎 Documents' },
      { id: 'templates',  label: '📝 Templates' },
      { id: 'reponse',    label: '✍️ Réponse' },
      { id: 'indice',     label: '💡 Indice' },
      { id: 'correction', label: '📖 Correction' },
    ];

    async function sauvegarderReponse() {
      const { error } = await supabase
        .from('reponses_eleves')
        .upsert({
          mission_id:    missionEnCours.id,
          eleve_nom:     utilisateur,
          reponse_texte: reponseTexte || null,
          lien_url:      reponseLien || null,
          fichier_url:   reponseFichierUrl || null,
          updated_at:    new Date().toISOString(),
        }, { onConflict: 'mission_id,eleve_nom' });
      setSauvegarde(error ? 'erreur' : 'ok');
      if (!error) lancerConfettis();
      setTimeout(() => setSauvegarde(null), 3000);
    }

    async function uploaderFichier(e) {
      const fichier = e.target.files?.[0];
      if (!fichier) return;
      setUploadingReponse(true);
      const nom = `${utilisateur}_m${missionEnCours.id}_${Date.now()}_${fichier.name}`;
      const { error } = await supabase.storage
        .from('reponses-eleves')
        .upload(nom, fichier, { upsert: true });
      if (!error) {
        const { data: urlData } = supabase.storage
          .from('reponses-eleves')
          .getPublicUrl(nom);
        setReponseFichierUrl(urlData.publicUrl);
      }
      setUploadingReponse(false);
    }

    function reveleCorrection() {
      if (!afficherCorrection) {
        const code = window.prompt('Code PIN professeur pour révéler la correction :');
        if (code !== PIN_PROF) { window.alert('Code incorrect.'); return; }
      }
      setAfficherCorrection(!afficherCorrection);
    }

    function renderDonnees(data, niveau = 0) {
      if (!data || typeof data !== 'object') {
        return <span>{String(data)}</span>;
      }
      if (Array.isArray(data)) {
        if (data.length === 0) return <span style={{ color: '#9CA3AF' }}>—</span>;
        return (
          <ul style={{ margin: '4px 0', paddingLeft: '20px' }}>
            {data.map((item, i) => (
              <li key={i}>{renderDonnees(item, niveau + 1)}</li>
            ))}
          </ul>
        );
      }
      const entries = Object.entries(data);
      if (entries.length === 0) return <span style={{ color: '#9CA3AF' }}>—</span>;
      if (niveau === 0) {
        return (
          <div style={{ overflowX: 'auto' }}>
            {entries.map(([cle, val]) => {
              if (Array.isArray(val) && val.length > 0 && typeof val[0] === 'object') {
                const cols = Object.keys(val[0]);
                return (
                  <div key={cle} style={{ marginBottom: '24px' }}>
                    <h4 style={{ color: '#1E3A8A', borderBottom: '1px solid #E5E7EB', paddingBottom: '6px' }}>{cle}</h4>
                    <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                      <thead>
                        <tr>{cols.map(c => <th key={c} style={{ background: '#1E3A8A', color: 'white', padding: '7px 10px', textAlign: 'left' }}>{c}</th>)}</tr>
                      </thead>
                      <tbody>
                        {val.map((row, i) => (
                          <tr key={i} style={{ background: i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                            {cols.map(c => <td key={c} style={{ padding: '7px 10px', borderBottom: '1px solid #E5E7EB' }}>{row[c] ?? '—'}</td>)}
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                );
              }
              return (
                <div key={cle} style={{ marginBottom: '12px' }}>
                  <strong style={{ color: '#374151' }}>{cle} :</strong>{' '}
                  <span>{renderDonnees(val, niveau + 1)}</span>
                </div>
              );
            })}
          </div>
        );
      }
      return (
        <span>
          {entries.map(([k, v]) => (
            <span key={k}><strong>{k}:</strong> {renderDonnees(v, niveau + 1)}{'  '}</span>
          ))}
        </span>
      );
    }

    return (
      <div style={{ padding: '32px', maxWidth: '960px', margin: '0 auto' }}>
        <button
          onClick={() => {
            setMissionEnCours(null);
            setOngletMission('donnees');
            setAfficherIndice(false);
            setAfficherCorrection(false);
            setReponseTexte('');
            setReponseLien('');
            setReponseFichierUrl('');
          }}
          style={{ padding: '10px 20px', cursor: 'pointer', marginBottom: '20px' }}
        >
          ← Retour aux missions
        </button>

        <div style={{ background: '#F3F4F6', padding: '28px', borderRadius: '12px' }}>
          <h1 style={{ marginTop: 0 }}>{missionEnCours.titre}</h1>
          <p><strong>Difficulté :</strong> {missionEnCours.difficulte} • <strong>Durée :</strong> {missionEnCours.duree_minutes} min</p>

          <div style={{ marginBottom: '20px' }}>
            <h3>📋 Contexte</h3>
            <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.contexte}</p>
          </div>
          <div style={{ marginBottom: '24px' }}>
            <h3>✅ Instructions</h3>
            <p style={{ whiteSpace: 'pre-wrap' }}>{missionEnCours.instructions}</p>
          </div>

          <div style={{ display: 'flex', flexWrap: 'wrap', borderBottom: '2px solid #D1D5DB', marginBottom: '20px' }}>
            {onglets.map(o => (
              <button
                key={o.id}
                onClick={() => setOngletMission(o.id)}
                style={{
                  padding: '10px 18px', border: 'none', background: 'none', cursor: 'pointer',
                  fontSize: '14px', fontWeight: ongletMission === o.id ? '700' : '400',
                  color: ongletMission === o.id ? '#1E3A8A' : '#6B7280',
                  borderBottom: ongletMission === o.id ? '2px solid #1E3A8A' : '2px solid transparent',
                  marginBottom: '-2px',
                }}
              >
                {o.label}
              </button>
            ))}
          </div>

          {ongletMission === 'donnees' && (
            <div>
              {missionEnCours.donnees_exercice && Object.keys(missionEnCours.donnees_exercice).length > 0
                ? renderDonnees(missionEnCours.donnees_exercice)
                : <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Aucune donnée d'exercice disponible pour cette mission.</p>
              }
            </div>
          )}

          {ongletMission === 'documents' && (
            <div>
              {missionEnCours.fichiers_annexes && missionEnCours.fichiers_annexes.length > 0 ? (
                <ul style={{ paddingLeft: '20px' }}>
                  {missionEnCours.fichiers_annexes.map((url, i) => (
                    <li key={i} style={{ marginBottom: '8px' }}>
                      <a href={url} target="_blank" rel="noopener noreferrer" style={{ color: '#1E3A8A' }}>
                        📄 Document {i + 1}
                      </a>
                    </li>
                  ))}
                </ul>
              ) : (
                <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Aucun fichier annexe pour cette mission.</p>
              )}
            </div>
          )}

          {ongletMission === 'templates' && (
            <div>
              {templatesMission.length === 0 ? (
                <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Aucun template disponible pour ce service.</p>
              ) : (
                templatesMission.map(t => (
                  <div key={t.id} style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: '8px', padding: '16px', marginBottom: '14px' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
                      <strong style={{ color: '#1E3A8A' }}>{t.nom}</strong>
                      <span style={{ fontSize: '12px', background: '#E0E7FF', color: '#1E3A8A', padding: '2px 8px', borderRadius: '4px' }}>{t.type}</span>
                    </div>
                    {t.contenu_template && (
                      <pre style={{ background: '#F8FAFC', padding: '12px', borderRadius: '6px', fontSize: '13px', whiteSpace: 'pre-wrap', margin: '0 0 8px' }}>
                        {t.contenu_template}
                      </pre>
                    )}
                    {t.exemple_rempli && (
                      <details>
                        <summary style={{ cursor: 'pointer', fontSize: '13px', color: '#059669' }}>Voir exemple rempli</summary>
                        <pre style={{ background: '#F0FDF4', padding: '12px', borderRadius: '6px', fontSize: '13px', whiteSpace: 'pre-wrap', marginTop: '8px' }}>
                          {t.exemple_rempli}
                        </pre>
                      </details>
                    )}
                  </div>
                ))
              )}
            </div>
          )}

          {ongletMission === 'reponse' && (
            <div>
              <div style={{ marginBottom: '22px' }}>
                <h4 style={{ margin: '0 0 8px', color: '#374151' }}>✍️ Votre réponse rédigée</h4>
                <textarea
                  value={reponseTexte}
                  onChange={(e) => setReponseTexte(e.target.value)}
                  placeholder="Écrivez votre réponse ici…"
                  style={{ width: '100%', minHeight: '200px', padding: '14px', border: '1px solid #CBD5E1', borderRadius: '8px', fontSize: '15px', fontFamily: 'inherit', boxSizing: 'border-box', resize: 'vertical' }}
                />
              </div>

              <div style={{ marginBottom: '22px' }}>
                <h4 style={{ margin: '0 0 8px', color: '#374151' }}>🔗 Lien (Google Doc, site, Drive…)</h4>
                <input
                  type="url"
                  value={reponseLien}
                  onChange={(e) => setReponseLien(e.target.value)}
                  placeholder="https://docs.google.com/…"
                  style={{ width: '100%', padding: '10px 14px', border: '1px solid #CBD5E1', borderRadius: '8px', fontSize: '14px', boxSizing: 'border-box' }}
                />
              </div>

              <div style={{ marginBottom: '22px' }}>
                <h4 style={{ margin: '0 0 8px', color: '#374151' }}>📎 Pièce jointe (PDF, Word, image)</h4>
                <input
                  type="file"
                  accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                  onChange={uploaderFichier}
                  disabled={uploadingReponse}
                  style={{ fontSize: '14px' }}
                />
                {uploadingReponse && (
                  <span style={{ marginLeft: '10px', color: '#6B7280', fontSize: '13px' }}>Envoi en cours…</span>
                )}
                {reponseFichierUrl && !uploadingReponse && (
                  <div style={{ marginTop: '8px' }}>
                    <a href={reponseFichierUrl} target="_blank" rel="noopener noreferrer"
                      style={{ color: '#1E3A8A', fontSize: '13px', textDecoration: 'underline' }}>
                      📄 Fichier joint — voir
                    </a>
                    <button
                      onClick={() => setReponseFichierUrl('')}
                      style={{ marginLeft: '12px', background: 'none', border: 'none', color: '#DC2626', cursor: 'pointer', fontSize: '13px' }}
                    >
                      ✕ Retirer
                    </button>
                  </div>
                )}
              </div>

              <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
                <button
                  onClick={sauvegarderReponse}
                  disabled={uploadingReponse}
                  style={{ padding: '12px 24px', background: '#059669', color: 'white', border: 'none', borderRadius: '8px', cursor: uploadingReponse ? 'not-allowed' : 'pointer', fontSize: '15px', fontWeight: '600', opacity: uploadingReponse ? 0.6 : 1 }}
                >
                  💾 Sauvegarder
                </button>
                {sauvegarde === 'ok'     && <span style={{ color: '#059669', fontWeight: '600' }}>✅ Réponse sauvegardée !</span>}
                {sauvegarde === 'erreur' && <span style={{ color: '#DC2626', fontWeight: '600' }}>❌ Erreur lors de la sauvegarde.</span>}
              </div>
            </div>
          )}

          {ongletMission === 'indice' && (
            <div>
              <button
                onClick={() => setAfficherIndice(!afficherIndice)}
                style={{ padding: '13px 26px', background: '#F59E0B', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' }}
              >
                💡 {afficherIndice ? 'Masquer' : 'Révéler'} l'indice
              </button>
              {afficherIndice && missionEnCours.indice && (
                <div style={{ marginTop: '16px', background: '#FEF3C7', padding: '18px', borderRadius: '8px', border: '2px solid #F59E0B' }}>
                  <p style={{ whiteSpace: 'pre-wrap', margin: 0 }}>{missionEnCours.indice}</p>
                </div>
              )}
              {afficherIndice && !missionEnCours.indice && (
                <p style={{ color: '#9CA3AF', fontStyle: 'italic', marginTop: '12px' }}>Aucun indice disponible.</p>
              )}
            </div>
          )}

          {ongletMission === 'correction' && (
            <div>
              <button
                onClick={reveleCorrection}
                style={{ padding: '13px 26px', background: '#059669', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' }}
              >
                📖 {afficherCorrection ? 'Masquer' : 'Révéler'} la correction (code Prof requis)
              </button>
              {afficherCorrection && missionEnCours.correction_detaillee && (
                <div style={{ marginTop: '16px', background: '#D1FAE5', padding: '18px', borderRadius: '8px', border: '2px solid #059669' }}>
                  <p style={{ whiteSpace: 'pre-wrap', margin: 0 }}>{missionEnCours.correction_detaillee}</p>
                </div>
              )}
              {afficherCorrection && !missionEnCours.correction_detaillee && (
                <p style={{ color: '#9CA3AF', fontStyle: 'italic', marginTop: '12px' }}>Aucune correction disponible.</p>
              )}
            </div>
          )}
        </div>
        {btnERP}
        {btnRevision}
        {btnAgence}
      </div>
    );
  }

  return (
    <div style={{ padding: '40px' }}>
      <div style={{ background: '#1E3A8A', color: 'white', padding: '20px', borderRadius: '8px', marginBottom: '30px' }}>
        <h1>🏢 LA BELLE AGENCE</h1>
        <p style={{ fontSize: '18px' }}>{utilisateur} - {roleChoisi.nom}</p>
        <button
          onClick={() => { setRoleChoisi(null); setMissions([]); }}
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
                onClick={() => {
                  setMissionEnCours(mission);
                  setOngletMission('donnees');
                  setAfficherIndice(false);
                  setAfficherCorrection(false);
                  setReponseTexte('');
                  setReponseLien('');
                  setReponseFichierUrl('');
                }}
                style={{ padding: '10px 20px', background: '#059669', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
              >
                Commencer
              </button>
            </div>
          ))}
        </div>
      )}
      {btnERP}
      {btnRevision}
      {btnAgence}
    </div>
  );
}

export default App;

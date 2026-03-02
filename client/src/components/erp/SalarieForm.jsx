import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

const SERVICES = ['RH', 'Finance', 'Juridique', 'IT', 'Marketing', 'Achats', 'Qualité', 'Agence Mulhouse', 'Agence Colmar', 'Agence Strasbourg'];
const POSTES   = ['Directeur d\'agence', 'Conseiller en patrimoine', 'Agent immobilier', 'Responsable RH', 'Responsable Finance', 'Responsable IT', 'Responsable Marketing', 'Responsable Achats', 'Responsable Juridique', 'Responsable Qualité', 'Assistant(e)'];

const vide = { nom: '', prenom: '', poste: '', service: '', date_embauche: '' };

async function uploadFichier(file, bucket) {
  const path = `${Date.now()}_${file.name.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
  const { error } = await supabase.storage.from(bucket).upload(path, file, { upsert: true });
  if (error) return null;
  return supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl;
}

export default function SalarieForm() {
  const [form, setForm]           = useState(vide);
  const [editId, setEditId]       = useState(null);
  const [liste, setListe]         = useState([]);
  const [statut, setStatut]       = useState(null);
  const [chargement, setChargement] = useState(false);
  const [cvUrl, setCvUrl]         = useState('');
  const [uploading, setUploading] = useState(false);

  useEffect(() => { charger(); }, []);

  async function charger() {
    const { data } = await supabase.from('salaries').select('*').order('nom');
    setListe(data || []);
  }

  function champ(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  async function onCV(e) {
    const file = e.target.files[0];
    if (!file) return;
    setUploading(true);
    const url = await uploadFichier(file, 'cv-salaries');
    if (url) setCvUrl(url);
    setUploading(false);
    e.target.value = '';
  }

  function modifier(s) {
    setForm({
      nom:           s.nom,
      prenom:        s.prenom,
      poste:         s.poste || '',
      service:       s.service || '',
      date_embauche: s.date_embauche || '',
    });
    setCvUrl(s.cv_url || '');
    setEditId(s.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() {
    setForm(vide);
    setEditId(null);
    setStatut(null);
    setCvUrl('');
  }

  async function supprimer(id, nom) {
    if (!window.confirm(`Supprimer le salarié "${nom}" ?`)) return;
    await supabase.from('salaries').delete().eq('id', id);
    charger();
  }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.nom || !form.prenom) { setStatut('erreur'); return; }
    setChargement(true);
    const payload = {
      ...form,
      date_embauche: form.date_embauche || null,
      cv_url:        cvUrl || null,
    };

    const { error } = editId
      ? await supabase.from('salaries').update(payload).eq('id', editId)
      : await supabase.from('salaries').insert([payload]);

    setChargement(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    setForm(vide);
    setEditId(null);
    setCvUrl('');
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...styles.form, borderLeft: editId ? '4px solid #F59E0B' : 'none' }}>
        <h3 style={styles.titreForm}>{editId ? '✏️ Modifier le salarié' : 'Nouveau salarié'}</h3>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Nom *</label>
            <input name="nom" value={form.nom} onChange={champ} style={styles.input} placeholder="Martin" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Prénom *</label>
            <input name="prenom" value={form.prenom} onChange={champ} style={styles.input} placeholder="Sophie" />
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Poste</label>
            <select name="poste" value={form.poste} onChange={champ} style={styles.input}>
              <option value="">— Choisir —</option>
              {POSTES.map(p => <option key={p} value={p}>{p}</option>)}
            </select>
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Service / Agence</label>
            <select name="service" value={form.service} onChange={champ} style={styles.input}>
              <option value="">— Choisir —</option>
              {SERVICES.map(s => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>
        </div>

        <div style={styles.champ}>
          <label style={styles.label}>Date d'embauche</label>
          <input name="date_embauche" type="date" value={form.date_embauche} onChange={champ} style={{ ...styles.input, maxWidth: '220px' }} />
        </div>

        {/* Upload CV */}
        <div style={styles.champ}>
          <label style={styles.label}>CV (PDF, JPG, PNG)</label>
          <input type="file" accept=".pdf,.jpg,.jpeg,.png" onChange={onCV} style={styles.input} />
          {uploading && <p style={{ color: '#D97706', fontSize: '13px', margin: '4px 0 0' }}>Téléchargement...</p>}
          {cvUrl && !uploading && (
            <a href={cvUrl} target="_blank" rel="noopener noreferrer" style={{ marginTop: '6px', fontSize: '13px', color: '#92400E' }}>📄 Voir le CV</a>
          )}
        </div>

        {statut === 'erreur' && <p style={styles.erreur}>Nom et prénom obligatoires.</p>}
        {statut === 'ok'    && <p style={styles.succes}>Salarié ajouté !</p>}
        {statut === 'maj'   && <p style={styles.succes}>Salarié mis à jour !</p>}

        <div style={{ display: 'flex', gap: '12px', marginTop: '4px' }}>
          <button type="submit" disabled={chargement || uploading} style={editId ? styles.boutonMaj : styles.bouton}>
            {chargement ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Ajouter le salarié'}
          </button>
          {editId && (
            <button type="button" onClick={annuler} style={styles.boutonAnnuler}>
              Annuler
            </button>
          )}
        </div>
      </form>

      <h3 style={styles.titreListe}>Salariés enregistrés ({liste.length})</h3>
      {liste.length === 0 ? (
        <p style={styles.vide}>Aucun salarié pour l'instant.</p>
      ) : (
        <table style={styles.table}>
          <thead>
            <tr>
              {['Nom', 'Prénom', 'Poste', 'Service', 'Date embauche', 'CV', 'Actions'].map(h => (
                <th key={h} style={styles.th}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {liste.map((s, i) => (
              <tr key={s.id} style={{ background: editId === s.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                <td style={styles.td}>{s.nom}</td>
                <td style={styles.td}>{s.prenom}</td>
                <td style={styles.td}>{s.poste || '—'}</td>
                <td style={styles.td}>{s.service || '—'}</td>
                <td style={styles.td}>{s.date_embauche ? new Date(s.date_embauche).toLocaleDateString('fr-FR') : '—'}</td>
                <td style={styles.td}>
                  {s.cv_url
                    ? <a href={s.cv_url} target="_blank" rel="noopener noreferrer" style={{ color: '#92400E', fontSize: '13px' }}>📄 Voir</a>
                    : '—'}
                </td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  <button onClick={() => modifier(s)} style={styles.btnEdit} title="Modifier">✏️</button>
                  <button onClick={() => supprimer(s.id, `${s.nom} ${s.prenom}`)} style={styles.btnDel} title="Supprimer">🗑️</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

const styles = {
  form:          { background: '#FFF7ED', padding: '24px', borderRadius: '12px', marginBottom: '32px' },
  titreForm:     { marginTop: 0, color: '#92400E' },
  titreListe:    { color: '#92400E' },
  rangee:        { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' },
  champ:         { display: 'flex', flexDirection: 'column', marginBottom: '16px' },
  label:         { fontWeight: '600', marginBottom: '4px', fontSize: '14px' },
  input:         { padding: '10px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '15px' },
  bouton:        { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonMaj:     { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600', outline: '3px solid #92400E' },
  boutonAnnuler: { padding: '12px 20px', background: 'white', color: '#374151', border: '1px solid #D1D5DB', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' },
  erreur:        { color: '#DC2626', fontWeight: '600' },
  succes:        { color: '#059669', fontWeight: '600' },
  table:         { width: '100%', borderCollapse: 'collapse', fontSize: '14px' },
  th:            { background: '#D97706', color: 'white', padding: '10px 14px', textAlign: 'left' },
  td:            { padding: '9px 14px', borderBottom: '1px solid #E5E7EB' },
  vide:          { color: '#6B7280', fontStyle: 'italic' },
  btnEdit:       { marginRight: '6px', padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnDel:        { padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
};

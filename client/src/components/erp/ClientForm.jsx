import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

const TYPES_RECHERCHE = ['achat', 'location', 'investissement'];

const vide = { nom: '', prenom: '', budget: '', type_recherche: '', telephone: '', email: '' };

async function uploadFichier(file, bucket) {
  const path = `${Date.now()}_${file.name.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
  const { error } = await supabase.storage.from(bucket).upload(path, file, { upsert: true });
  if (error) return null;
  return supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl;
}

export default function ClientForm() {
  const [form, setForm]           = useState(vide);
  const [editId, setEditId]       = useState(null);
  const [liste, setListe]         = useState([]);
  const [statut, setStatut]       = useState(null);
  const [chargement, setChargement] = useState(false);
  const [docUrl, setDocUrl]       = useState('');
  const [uploading, setUploading] = useState(false);

  useEffect(() => { charger(); }, []);

  async function charger() {
    const { data } = await supabase.from('clients').select('*').order('created_at', { ascending: false });
    setListe(data || []);
  }

  function champ(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  async function onDocument(e) {
    const file = e.target.files[0];
    if (!file) return;
    setUploading(true);
    const url = await uploadFichier(file, 'documents-clients');
    if (url) setDocUrl(url);
    setUploading(false);
    e.target.value = '';
  }

  function modifier(c) {
    setForm({
      nom:           c.nom,
      prenom:        c.prenom,
      budget:        c.budget?.toString() || '',
      type_recherche: c.type_recherche || '',
      telephone:     c.telephone || '',
      email:         c.email || '',
    });
    setDocUrl(c.document_url || '');
    setEditId(c.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() {
    setForm(vide);
    setEditId(null);
    setStatut(null);
    setDocUrl('');
  }

  async function supprimer(id, nom) {
    if (!window.confirm(`Supprimer le client "${nom}" ?`)) return;
    await supabase.from('clients').delete().eq('id', id);
    charger();
  }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.nom || !form.prenom) { setStatut('erreur'); return; }
    setChargement(true);
    const payload = {
      ...form,
      budget:       form.budget ? parseFloat(form.budget) : null,
      document_url: docUrl || null,
    };

    const { error } = editId
      ? await supabase.from('clients').update(payload).eq('id', editId)
      : await supabase.from('clients').insert([payload]);

    setChargement(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    setForm(vide);
    setEditId(null);
    setDocUrl('');
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...styles.form, borderLeft: editId ? '4px solid #F59E0B' : 'none' }}>
        <h3 style={styles.titreForm}>{editId ? '✏️ Modifier le client' : 'Nouveau client'}</h3>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Nom *</label>
            <input name="nom" value={form.nom} onChange={champ} style={styles.input} placeholder="Dupont" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Prénom *</label>
            <input name="prenom" value={form.prenom} onChange={champ} style={styles.input} placeholder="Marie" />
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Budget (€)</label>
            <input name="budget" type="number" value={form.budget} onChange={champ} style={styles.input} placeholder="250000" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Type de recherche</label>
            <select name="type_recherche" value={form.type_recherche} onChange={champ} style={styles.input}>
              <option value="">— Choisir —</option>
              {TYPES_RECHERCHE.map(t => <option key={t} value={t}>{t}</option>)}
            </select>
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Téléphone</label>
            <input name="telephone" value={form.telephone} onChange={champ} style={styles.input} placeholder="06 12 34 56 78" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Email</label>
            <input name="email" type="email" value={form.email} onChange={champ} style={styles.input} placeholder="marie@email.fr" />
          </div>
        </div>

        {/* Upload pièce d'identité */}
        <div style={styles.champ}>
          <label style={styles.label}>Pièce d'identité (PDF, JPG, PNG)</label>
          <input type="file" accept=".pdf,.jpg,.jpeg,.png" onChange={onDocument} style={styles.input} />
          {uploading && <p style={{ color: '#D97706', fontSize: '13px', margin: '4px 0 0' }}>Téléchargement...</p>}
          {docUrl && !uploading && (
            <a href={docUrl} target="_blank" rel="noopener noreferrer" style={{ marginTop: '6px', fontSize: '13px', color: '#1E3A8A' }}>📄 Voir le document</a>
          )}
        </div>

        {statut === 'erreur' && <p style={styles.erreur}>Nom et prénom obligatoires.</p>}
        {statut === 'ok'    && <p style={styles.succes}>Client ajouté !</p>}
        {statut === 'maj'   && <p style={styles.succes}>Client mis à jour !</p>}

        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <button type="submit" disabled={chargement || uploading} style={editId ? styles.boutonMaj : styles.bouton}>
            {chargement ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Ajouter le client'}
          </button>
          {editId && (
            <button type="button" onClick={annuler} style={styles.boutonAnnuler}>
              Annuler
            </button>
          )}
        </div>
      </form>

      <h3 style={styles.titreListe}>Clients enregistrés ({liste.length})</h3>
      {liste.length === 0 ? (
        <p style={styles.vide}>Aucun client pour l'instant.</p>
      ) : (
        <table style={styles.table}>
          <thead>
            <tr>
              {['Nom', 'Prénom', 'Budget', 'Type', 'Téléphone', 'Email', 'Document', 'Actions'].map(h => (
                <th key={h} style={styles.th}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {liste.map((c, i) => (
              <tr key={c.id} style={{ background: editId === c.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                <td style={styles.td}>{c.nom}</td>
                <td style={styles.td}>{c.prenom}</td>
                <td style={styles.td}>{c.budget ? `${Number(c.budget).toLocaleString('fr-FR')} €` : '—'}</td>
                <td style={styles.td}>{c.type_recherche || '—'}</td>
                <td style={styles.td}>{c.telephone || '—'}</td>
                <td style={styles.td}>{c.email || '—'}</td>
                <td style={styles.td}>
                  {c.document_url
                    ? <a href={c.document_url} target="_blank" rel="noopener noreferrer" style={{ color: '#1E3A8A', fontSize: '13px' }}>📄 Voir</a>
                    : '—'}
                </td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  <button onClick={() => modifier(c)} style={styles.btnEdit} title="Modifier">✏️</button>
                  <button onClick={() => supprimer(c.id, `${c.nom} ${c.prenom}`)} style={styles.btnDel} title="Supprimer">🗑️</button>
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
  form:          { background: '#F0F4FF', padding: '24px', borderRadius: '12px', marginBottom: '32px' },
  titreForm:     { marginTop: 0, color: '#1E3A8A' },
  titreListe:    { color: '#1E3A8A' },
  rangee:        { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' },
  champ:         { display: 'flex', flexDirection: 'column', marginBottom: '16px' },
  label:         { fontWeight: '600', marginBottom: '4px', fontSize: '14px' },
  input:         { padding: '10px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '15px' },
  bouton:        { padding: '12px 28px', background: '#1E3A8A', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonMaj:     { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonAnnuler: { padding: '12px 20px', background: 'white', color: '#374151', border: '1px solid #D1D5DB', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' },
  erreur:        { color: '#DC2626', fontWeight: '600' },
  succes:        { color: '#059669', fontWeight: '600' },
  table:         { width: '100%', borderCollapse: 'collapse', fontSize: '14px' },
  th:            { background: '#1E3A8A', color: 'white', padding: '10px 14px', textAlign: 'left' },
  td:            { padding: '9px 14px', borderBottom: '1px solid #E5E7EB' },
  vide:          { color: '#6B7280', fontStyle: 'italic' },
  btnEdit:       { marginRight: '6px', padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnDel:        { padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
};

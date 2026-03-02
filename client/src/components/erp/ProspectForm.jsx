import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

const SOURCES = ['site web', 'bouche à oreille', 'publicité', 'réseaux sociaux', 'événement', 'vitrine agence', 'autre'];

const vide = { nom: '', prenom: '', source: '', interet: '' };

export default function ProspectForm() {
  const [form, setForm]       = useState(vide);
  const [editId, setEditId]   = useState(null);
  const [liste, setListe]     = useState([]);
  const [statut, setStatut]   = useState(null);
  const [chargement, setChargement] = useState(false);

  useEffect(() => { charger(); }, []);

  async function charger() {
    const { data } = await supabase.from('prospects').select('*').order('created_at', { ascending: false });
    setListe(data || []);
  }

  function champ(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  function modifier(p) {
    setForm({
      nom:     p.nom,
      prenom:  p.prenom,
      source:  p.source || '',
      interet: p.interet || '',
    });
    setEditId(p.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() {
    setForm(vide);
    setEditId(null);
    setStatut(null);
  }

  async function supprimer(id, nom) {
    if (!window.confirm(`Supprimer le prospect "${nom}" ?`)) return;
    await supabase.from('prospects').delete().eq('id', id);
    charger();
  }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.nom || !form.prenom) { setStatut('erreur'); return; }
    setChargement(true);

    const { error } = editId
      ? await supabase.from('prospects').update(form).eq('id', editId)
      : await supabase.from('prospects').insert([form]);

    setChargement(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    setForm(vide);
    setEditId(null);
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...styles.form, borderLeft: editId ? '4px solid #F59E0B' : 'none' }}>
        <h3 style={styles.titreForm}>{editId ? '✏️ Modifier le prospect' : 'Nouveau prospect'}</h3>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Nom *</label>
            <input name="nom" value={form.nom} onChange={champ} style={styles.input} placeholder="Bernard" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Prénom *</label>
            <input name="prenom" value={form.prenom} onChange={champ} style={styles.input} placeholder="Paul" />
          </div>
        </div>

        <div style={styles.champ}>
          <label style={styles.label}>Source (comment nous a-t-il trouvés ?)</label>
          <select name="source" value={form.source} onChange={champ} style={styles.input}>
            <option value="">— Choisir —</option>
            {SOURCES.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>

        <div style={styles.champ}>
          <label style={styles.label}>Intérêt / Besoin exprimé</label>
          <textarea name="interet" value={form.interet} onChange={champ} style={{ ...styles.input, minHeight: '80px', resize: 'vertical' }} placeholder="Recherche un appartement 3 pièces à Mulhouse pour début 2025..." />
        </div>

        {statut === 'erreur' && <p style={styles.erreur}>Nom et prénom obligatoires.</p>}
        {statut === 'ok'    && <p style={styles.succes}>Prospect ajouté !</p>}
        {statut === 'maj'   && <p style={styles.succes}>Prospect mis à jour !</p>}

        <div style={{ display: 'flex', gap: '12px', marginTop: '4px' }}>
          <button type="submit" disabled={chargement} style={editId ? styles.boutonMaj : styles.bouton}>
            {chargement ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Ajouter le prospect'}
          </button>
          {editId && (
            <button type="button" onClick={annuler} style={styles.boutonAnnuler}>
              Annuler
            </button>
          )}
        </div>
      </form>

      <h3 style={styles.titreListe}>Prospects enregistrés ({liste.length})</h3>
      {liste.length === 0 ? (
        <p style={styles.vide}>Aucun prospect pour l'instant.</p>
      ) : (
        <table style={styles.table}>
          <thead>
            <tr>
              {['Nom', 'Prénom', 'Source', 'Intérêt', 'Actions'].map(h => (
                <th key={h} style={styles.th}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {liste.map((p, i) => (
              <tr key={p.id} style={{ background: editId === p.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                <td style={styles.td}>{p.nom}</td>
                <td style={styles.td}>{p.prenom}</td>
                <td style={styles.td}>{p.source || '—'}</td>
                <td style={{ ...styles.td, maxWidth: '300px' }}>{p.interet || '—'}</td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  <button onClick={() => modifier(p)} style={styles.btnEdit} title="Modifier">✏️</button>
                  <button onClick={() => supprimer(p.id, `${p.nom} ${p.prenom}`)} style={styles.btnDel} title="Supprimer">🗑️</button>
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
  form:        { background: '#FDF4FF', padding: '24px', borderRadius: '12px', marginBottom: '32px' },
  titreForm:   { marginTop: 0, color: '#6B21A8' },
  titreListe:  { color: '#6B21A8' },
  rangee:      { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' },
  champ:       { display: 'flex', flexDirection: 'column', marginBottom: '16px' },
  label:       { fontWeight: '600', marginBottom: '4px', fontSize: '14px' },
  input:       { padding: '10px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '15px' },
  bouton:      { padding: '12px 28px', background: '#7C3AED', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonMaj:   { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonAnnuler:{ padding: '12px 20px', background: 'white', color: '#374151', border: '1px solid #D1D5DB', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' },
  erreur:      { color: '#DC2626', fontWeight: '600' },
  succes:      { color: '#059669', fontWeight: '600' },
  table:       { width: '100%', borderCollapse: 'collapse', fontSize: '14px' },
  th:          { background: '#7C3AED', color: 'white', padding: '10px 14px', textAlign: 'left' },
  td:          { padding: '9px 14px', borderBottom: '1px solid #E5E7EB' },
  vide:        { color: '#6B7280', fontStyle: 'italic' },
  btnEdit:     { marginRight: '6px', padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnDel:      { padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
};

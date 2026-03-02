import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

const TYPES_BIEN = ['appartement', 'maison', 'bureau', 'local commercial', 'terrain'];

const vide = { adresse: '', type: '', surface: '', prix: '', nb_pieces: '', description: '' };

async function uploadFichier(file, bucket) {
  const path = `${Date.now()}_${file.name.replace(/[^a-zA-Z0-9._-]/g, '_')}`;
  const { error } = await supabase.storage.from(bucket).upload(path, file, { upsert: true });
  if (error) return null;
  return supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl;
}

function mapsUrl(adresse) {
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(adresse)}`;
}

export default function BienForm() {
  const [form, setForm]           = useState(vide);
  const [editId, setEditId]       = useState(null);
  const [liste, setListe]         = useState([]);
  const [statut, setStatut]       = useState(null);
  const [chargement, setChargement] = useState(false);
  const [photos, setPhotos]       = useState([]);        // URLs déjà uploadées
  const [uploading, setUploading] = useState(false);

  useEffect(() => { charger(); }, []);

  async function charger() {
    const { data } = await supabase.from('biens').select('*').order('created_at', { ascending: false });
    setListe(data || []);
  }

  function champ(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  async function onPhotos(e) {
    const files = Array.from(e.target.files);
    if (!files.length) return;
    setUploading(true);
    const urls = [];
    for (const file of files) {
      const url = await uploadFichier(file, 'photos-biens');
      if (url) urls.push(url);
    }
    setPhotos(prev => [...prev, ...urls]);
    setUploading(false);
    e.target.value = '';
  }

  function supprimerPhoto(url) {
    setPhotos(prev => prev.filter(u => u !== url));
  }

  function modifier(b) {
    setForm({
      adresse:     b.adresse,
      type:        b.type || '',
      surface:     b.surface?.toString() || '',
      prix:        b.prix?.toString() || '',
      nb_pieces:   b.nb_pieces?.toString() || '',
      description: b.description || '',
    });
    setPhotos(Array.isArray(b.photos_urls) ? b.photos_urls : []);
    setEditId(b.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() {
    setForm(vide);
    setEditId(null);
    setStatut(null);
    setPhotos([]);
  }

  async function supprimer(id, adresse) {
    if (!window.confirm(`Supprimer le bien "${adresse}" ?`)) return;
    await supabase.from('biens').delete().eq('id', id);
    charger();
  }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.adresse) { setStatut('erreur'); return; }
    setChargement(true);
    const payload = {
      ...form,
      surface:    form.surface   ? parseFloat(form.surface)  : null,
      prix:       form.prix      ? parseFloat(form.prix)     : null,
      nb_pieces:  form.nb_pieces ? parseInt(form.nb_pieces)  : null,
      photos_urls: photos,
    };

    const { error } = editId
      ? await supabase.from('biens').update(payload).eq('id', editId)
      : await supabase.from('biens').insert([payload]);

    setChargement(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    setForm(vide);
    setEditId(null);
    setPhotos([]);
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...styles.form, borderLeft: editId ? '4px solid #F59E0B' : 'none' }}>
        <h3 style={styles.titreForm}>{editId ? '✏️ Modifier le bien' : 'Nouveau bien immobilier'}</h3>

        <div style={styles.champ}>
          <label style={styles.label}>Adresse *</label>
          <input name="adresse" value={form.adresse} onChange={champ} style={styles.input} placeholder="12 rue des Fleurs, 68100 Mulhouse" />
        </div>

        <div style={{ ...styles.rangee, marginTop: '16px' }}>
          <div style={styles.champ}>
            <label style={styles.label}>Type de bien</label>
            <select name="type" value={form.type} onChange={champ} style={styles.input}>
              <option value="">— Choisir —</option>
              {TYPES_BIEN.map(t => <option key={t} value={t}>{t}</option>)}
            </select>
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Surface (m²)</label>
            <input name="surface" type="number" value={form.surface} onChange={champ} style={styles.input} placeholder="75" />
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Prix (€)</label>
            <input name="prix" type="number" value={form.prix} onChange={champ} style={styles.input} placeholder="185000" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Nombre de pièces</label>
            <input name="nb_pieces" type="number" value={form.nb_pieces} onChange={champ} style={styles.input} placeholder="3" />
          </div>
        </div>

        <div style={{ ...styles.champ, marginTop: '0' }}>
          <label style={styles.label}>Description</label>
          <textarea name="description" value={form.description} onChange={champ} style={{ ...styles.input, minHeight: '80px', resize: 'vertical' }} placeholder="Beau T3 rénové, proche commodités..." />
        </div>

        {/* Upload photos */}
        <div style={{ ...styles.champ, marginTop: '0' }}>
          <label style={styles.label}>Photos du bien</label>
          <input type="file" accept="image/*" multiple onChange={onPhotos} style={styles.input} />
          {uploading && <p style={{ color: '#D97706', fontSize: '13px', margin: '4px 0 0' }}>Téléchargement...</p>}
          {photos.length > 0 && (
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', marginTop: '10px' }}>
              {photos.map((url, i) => (
                <div key={i} style={{ position: 'relative' }}>
                  <a href={url} target="_blank" rel="noopener noreferrer">
                    <img src={url} alt={`photo ${i + 1}`} style={{ width: '50px', height: '50px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #CBD5E1' }} />
                  </a>
                  <button type="button" onClick={() => supprimerPhoto(url)} style={{ position: 'absolute', top: '-6px', right: '-6px', background: '#DC2626', color: 'white', border: 'none', borderRadius: '50%', width: '16px', height: '16px', fontSize: '10px', cursor: 'pointer', lineHeight: '16px', padding: 0 }}>×</button>
                </div>
              ))}
            </div>
          )}
        </div>

        {statut === 'erreur' && <p style={styles.erreur}>L'adresse est obligatoire.</p>}
        {statut === 'ok'    && <p style={styles.succes}>Bien ajouté !</p>}
        {statut === 'maj'   && <p style={styles.succes}>Bien mis à jour !</p>}

        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <button type="submit" disabled={chargement || uploading} style={editId ? styles.boutonMaj : styles.bouton}>
            {chargement ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Ajouter le bien'}
          </button>
          {editId && (
            <button type="button" onClick={annuler} style={styles.boutonAnnuler}>
              Annuler
            </button>
          )}
        </div>
      </form>

      <h3 style={styles.titreListe}>Biens enregistrés ({liste.length})</h3>
      {liste.length === 0 ? (
        <p style={styles.vide}>Aucun bien pour l'instant.</p>
      ) : (
        <table style={styles.table}>
          <thead>
            <tr>
              {['Adresse', 'Type', 'Surface', 'Prix', 'Pièces', 'Photos', 'Maps', 'Actions'].map(h => (
                <th key={h} style={styles.th}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {liste.map((b, i) => (
              <tr key={b.id} style={{ background: editId === b.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                <td style={styles.td}>{b.adresse}</td>
                <td style={styles.td}>{b.type || '—'}</td>
                <td style={styles.td}>{b.surface ? `${b.surface} m²` : '—'}</td>
                <td style={styles.td}>{b.prix ? `${Number(b.prix).toLocaleString('fr-FR')} €` : '—'}</td>
                <td style={styles.td}>{b.nb_pieces || '—'}</td>
                <td style={styles.td}>
                  {Array.isArray(b.photos_urls) && b.photos_urls.length > 0 ? (
                    <div style={{ display: 'flex', gap: '4px' }}>
                      {b.photos_urls.map((url, j) => (
                        <a key={j} href={url} target="_blank" rel="noopener noreferrer">
                          <img src={url} alt="" style={{ width: '50px', height: '50px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #CBD5E1' }} />
                        </a>
                      ))}
                    </div>
                  ) : '—'}
                </td>
                <td style={styles.td}>
                  {b.adresse ? (
                    <a href={mapsUrl(b.adresse)} target="_blank" rel="noopener noreferrer" title="Voir sur Google Maps" style={{ fontSize: '18px', textDecoration: 'none' }}>🗺️</a>
                  ) : '—'}
                </td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  <button onClick={() => modifier(b)} style={styles.btnEdit} title="Modifier">✏️</button>
                  <button onClick={() => supprimer(b.id, b.adresse)} style={styles.btnDel} title="Supprimer">🗑️</button>
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
  form:          { background: '#F0FFF4', padding: '24px', borderRadius: '12px', marginBottom: '32px' },
  titreForm:     { marginTop: 0, color: '#065F46' },
  titreListe:    { color: '#065F46' },
  rangee:        { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' },
  champ:         { display: 'flex', flexDirection: 'column', marginBottom: '16px' },
  label:         { fontWeight: '600', marginBottom: '4px', fontSize: '14px' },
  input:         { padding: '10px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '15px' },
  bouton:        { padding: '12px 28px', background: '#059669', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonMaj:     { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonAnnuler: { padding: '12px 20px', background: 'white', color: '#374151', border: '1px solid #D1D5DB', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' },
  erreur:        { color: '#DC2626', fontWeight: '600' },
  succes:        { color: '#059669', fontWeight: '600' },
  table:         { width: '100%', borderCollapse: 'collapse', fontSize: '14px' },
  th:            { background: '#059669', color: 'white', padding: '10px 14px', textAlign: 'left' },
  td:            { padding: '9px 14px', borderBottom: '1px solid #E5E7EB' },
  vide:          { color: '#6B7280', fontStyle: 'italic' },
  btnEdit:       { marginRight: '6px', padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnDel:        { padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
};

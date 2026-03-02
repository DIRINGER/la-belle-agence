import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';

const STATUTS = ['actif', 'suspendu', 'terminé', 'annulé'];

const vide = { client_id: '', bien_id: '', date_debut: '', date_fin: '', commission: '5', statut: 'actif' };

function genererPDF(mandat) {
  const client = mandat.clients;
  const bien   = mandat.biens;
  const num    = String(mandat.id).padStart(4, '0');

  const html = `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Mandat N°${num}</title>
  <style>
    body { font-family: 'Georgia', serif; margin: 40px; color: #1a1a1a; font-size: 14px; }
    h1 { text-align: center; font-size: 22px; letter-spacing: 2px; border-bottom: 3px solid #1E3A8A; padding-bottom: 12px; color: #1E3A8A; }
    .sous-titre { text-align: center; color: #6B7280; margin-bottom: 32px; font-style: italic; }
    .section { margin-bottom: 28px; }
    .section h2 { font-size: 14px; text-transform: uppercase; letter-spacing: 1px; color: #1E3A8A; border-bottom: 1px solid #CBD5E1; padding-bottom: 4px; margin-bottom: 12px; }
    .ligne { display: flex; margin-bottom: 6px; }
    .cle { width: 200px; font-weight: bold; color: #374151; flex-shrink: 0; }
    .val { color: #111827; }
    .signatures { display: flex; gap: 80px; margin-top: 60px; }
    .sig-bloc { flex: 1; }
    .sig-bloc p { font-weight: bold; margin-bottom: 8px; }
    .sig-ligne { border-bottom: 1px solid #374151; height: 60px; margin-bottom: 8px; }
    .sig-label { font-size: 12px; color: #6B7280; text-align: center; }
    .pied { text-align: center; margin-top: 60px; font-size: 11px; color: #9CA3AF; border-top: 1px solid #E5E7EB; padding-top: 12px; }
  </style>
</head>
<body>
  <h1>LA BELLE AGENCE — MANDAT N°${num}</h1>
  <p class="sous-titre">Mandat de ${bien ? (bien.type || 'vente') : 'vente'}</p>

  <div class="section">
    <h2>Mandant (Client)</h2>
    <div class="ligne"><span class="cle">Nom :</span><span class="val">${client ? `${client.prenom} ${client.nom}` : '—'}</span></div>
    <div class="ligne"><span class="cle">Email :</span><span class="val">${client?.email || '—'}</span></div>
    <div class="ligne"><span class="cle">Téléphone :</span><span class="val">${client?.telephone || '—'}</span></div>
  </div>

  <div class="section">
    <h2>Bien concerné</h2>
    <div class="ligne"><span class="cle">Adresse :</span><span class="val">${bien?.adresse || '—'}</span></div>
    <div class="ligne"><span class="cle">Type :</span><span class="val">${bien?.type || '—'}</span></div>
    <div class="ligne"><span class="cle">Surface :</span><span class="val">${bien?.surface ? `${bien.surface} m²` : '—'}</span></div>
    <div class="ligne"><span class="cle">Prix :</span><span class="val">${bien?.prix ? `${Number(bien.prix).toLocaleString('fr-FR')} €` : '—'}</span></div>
  </div>

  <div class="section">
    <h2>Conditions du mandat</h2>
    <div class="ligne"><span class="cle">Date de début :</span><span class="val">${mandat.date_debut ? new Date(mandat.date_debut).toLocaleDateString('fr-FR') : '—'}</span></div>
    <div class="ligne"><span class="cle">Date de fin :</span><span class="val">${mandat.date_fin ? new Date(mandat.date_fin).toLocaleDateString('fr-FR') : '—'}</span></div>
    <div class="ligne"><span class="cle">Commission agence :</span><span class="val">${mandat.commission} %</span></div>
    <div class="ligne"><span class="cle">Statut :</span><span class="val">${mandat.statut}</span></div>
  </div>

  <div class="signatures">
    <div class="sig-bloc">
      <p>Le Mandant</p>
      <div class="sig-ligne"></div>
      <p class="sig-label">${client ? `${client.prenom} ${client.nom}` : 'Mandant'}</p>
    </div>
    <div class="sig-bloc">
      <p>L'Agence</p>
      <div class="sig-ligne"></div>
      <p class="sig-label">La Belle Agence</p>
    </div>
  </div>

  <div class="pied">
    Document généré le ${new Date().toLocaleDateString('fr-FR')} — La Belle Agence — Confidentiel
  </div>
</body>
</html>`;

  const win = window.open('', '_blank');
  if (!win) return;
  win.document.write(html);
  win.document.close();
  setTimeout(() => win.print(), 500);
}

export default function MandatForm() {
  const [form, setForm]           = useState(vide);
  const [editId, setEditId]       = useState(null);
  const [clients, setClients]     = useState([]);
  const [biens, setBiens]         = useState([]);
  const [liste, setListe]         = useState([]);
  const [statut, setStatut]       = useState(null);
  const [chargement, setChargement] = useState(false);

  useEffect(() => { chargerTout(); }, []);

  async function chargerTout() {
    const [{ data: c }, { data: b }] = await Promise.all([
      supabase.from('clients').select('id, nom, prenom').order('nom'),
      supabase.from('biens').select('id, adresse, type, surface, prix').order('adresse'),
    ]);
    setClients(c || []);
    setBiens(b || []);
    await charger();
  }

  async function charger() {
    const { data } = await supabase
      .from('mandats')
      .select('*, clients(nom, prenom, email, telephone), biens(adresse, type, surface, prix)')
      .order('created_at', { ascending: false });
    setListe(data || []);
  }

  function champ(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  function modifier(m) {
    setForm({
      client_id:  m.client_id?.toString() || '',
      bien_id:    m.bien_id?.toString() || '',
      date_debut: m.date_debut || '',
      date_fin:   m.date_fin || '',
      commission: m.commission?.toString() || '5',
      statut:     m.statut || 'actif',
    });
    setEditId(m.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() {
    setForm(vide);
    setEditId(null);
    setStatut(null);
  }

  async function supprimer(id) {
    if (!window.confirm('Supprimer ce mandat ?')) return;
    await supabase.from('mandats').delete().eq('id', id);
    charger();
  }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.date_debut || !form.date_fin) { setStatut('erreur'); return; }
    setChargement(true);
    const payload = {
      client_id:  form.client_id  ? parseInt(form.client_id)   : null,
      bien_id:    form.bien_id    ? parseInt(form.bien_id)      : null,
      date_debut: form.date_debut,
      date_fin:   form.date_fin,
      commission: parseFloat(form.commission) || 5,
      statut:     form.statut,
    };

    const { error } = editId
      ? await supabase.from('mandats').update(payload).eq('id', editId)
      : await supabase.from('mandats').insert([payload]);

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
        <h3 style={styles.titreForm}>{editId ? '✏️ Modifier le mandat' : 'Nouveau mandat'}</h3>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Client</label>
            <select name="client_id" value={form.client_id} onChange={champ} style={styles.input}>
              <option value="">— Sélectionner un client —</option>
              {clients.map(c => (
                <option key={c.id} value={c.id}>{c.prenom} {c.nom}</option>
              ))}
            </select>
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Bien immobilier</label>
            <select name="bien_id" value={form.bien_id} onChange={champ} style={styles.input}>
              <option value="">— Sélectionner un bien —</option>
              {biens.map(b => (
                <option key={b.id} value={b.id}>{b.adresse}{b.type ? ` (${b.type})` : ''}</option>
              ))}
            </select>
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Date de début *</label>
            <input name="date_debut" type="date" value={form.date_debut} onChange={champ} style={styles.input} />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Date de fin *</label>
            <input name="date_fin" type="date" value={form.date_fin} onChange={champ} style={styles.input} />
          </div>
        </div>

        <div style={styles.rangee}>
          <div style={styles.champ}>
            <label style={styles.label}>Commission agence (%)</label>
            <input name="commission" type="number" step="0.01" min="0" max="100" value={form.commission} onChange={champ} style={styles.input} placeholder="5" />
          </div>
          <div style={styles.champ}>
            <label style={styles.label}>Statut</label>
            <select name="statut" value={form.statut} onChange={champ} style={styles.input}>
              {STATUTS.map(s => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>
        </div>

        {statut === 'erreur' && <p style={styles.erreur}>Les dates de début et de fin sont obligatoires.</p>}
        {statut === 'ok'    && <p style={styles.succes}>Mandat créé !</p>}
        {statut === 'maj'   && <p style={styles.succes}>Mandat mis à jour !</p>}

        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <button type="submit" disabled={chargement} style={editId ? styles.boutonMaj : styles.bouton}>
            {chargement ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Créer le mandat'}
          </button>
          {editId && (
            <button type="button" onClick={annuler} style={styles.boutonAnnuler}>
              Annuler
            </button>
          )}
        </div>
      </form>

      <h3 style={styles.titreListe}>Mandats enregistrés ({liste.length})</h3>
      {liste.length === 0 ? (
        <p style={styles.vide}>Aucun mandat pour l'instant.</p>
      ) : (
        <table style={styles.table}>
          <thead>
            <tr>
              {['N°', 'Client', 'Bien', 'Période', 'Commission', 'Statut', 'Actions'].map(h => (
                <th key={h} style={styles.th}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {liste.map((m, i) => (
              <tr key={m.id} style={{ background: editId === m.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                <td style={styles.td}>#{String(m.id).padStart(4, '0')}</td>
                <td style={styles.td}>
                  {m.clients ? `${m.clients.prenom} ${m.clients.nom}` : '—'}
                </td>
                <td style={{ ...styles.td, maxWidth: '180px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {m.biens?.adresse || '—'}
                </td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  {m.date_debut ? new Date(m.date_debut).toLocaleDateString('fr-FR') : '—'}
                  {' → '}
                  {m.date_fin ? new Date(m.date_fin).toLocaleDateString('fr-FR') : '—'}
                </td>
                <td style={styles.td}>{m.commission} %</td>
                <td style={styles.td}>
                  <span style={{
                    padding: '2px 10px',
                    borderRadius: '12px',
                    fontSize: '12px',
                    fontWeight: '600',
                    background: m.statut === 'actif' ? '#D1FAE5' : m.statut === 'terminé' ? '#E5E7EB' : '#FEE2E2',
                    color: m.statut === 'actif' ? '#065F46' : m.statut === 'terminé' ? '#374151' : '#991B1B',
                  }}>
                    {m.statut}
                  </span>
                </td>
                <td style={{ ...styles.td, whiteSpace: 'nowrap' }}>
                  <button onClick={() => modifier(m)} style={styles.btnEdit} title="Modifier">✏️</button>
                  <button onClick={() => supprimer(m.id)} style={styles.btnDel} title="Supprimer">🗑️</button>
                  <button onClick={() => genererPDF(m)} style={styles.btnPdf} title="Générer PDF">📄</button>
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
  form:          { background: '#FFF1F2', padding: '24px', borderRadius: '12px', marginBottom: '32px' },
  titreForm:     { marginTop: 0, color: '#9F1239' },
  titreListe:    { color: '#9F1239' },
  rangee:        { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '16px' },
  champ:         { display: 'flex', flexDirection: 'column', marginBottom: '16px' },
  label:         { fontWeight: '600', marginBottom: '4px', fontSize: '14px' },
  input:         { padding: '10px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '15px' },
  bouton:        { padding: '12px 28px', background: '#DC2626', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonMaj:     { padding: '12px 28px', background: '#D97706', color: 'white', border: 'none', borderRadius: '8px', cursor: 'pointer', fontSize: '15px', fontWeight: '600' },
  boutonAnnuler: { padding: '12px 20px', background: 'white', color: '#374151', border: '1px solid #D1D5DB', borderRadius: '8px', cursor: 'pointer', fontSize: '15px' },
  erreur:        { color: '#DC2626', fontWeight: '600' },
  succes:        { color: '#059669', fontWeight: '600' },
  table:         { width: '100%', borderCollapse: 'collapse', fontSize: '14px' },
  th:            { background: '#DC2626', color: 'white', padding: '10px 14px', textAlign: 'left' },
  td:            { padding: '9px 14px', borderBottom: '1px solid #E5E7EB' },
  vide:          { color: '#6B7280', fontStyle: 'italic' },
  btnEdit:       { marginRight: '6px', padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnDel:        { marginRight: '6px', padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
  btnPdf:        { padding: '4px 8px', background: '#EFF6FF', border: '1px solid #93C5FD', borderRadius: '4px', cursor: 'pointer', fontSize: '14px' },
};

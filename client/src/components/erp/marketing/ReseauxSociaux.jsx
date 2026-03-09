import { useState, useEffect } from 'react';
import { supabase } from '../../../supabaseClient';

const PLATEFORMES = {
  instagram: { label: 'Instagram', icon: '📸', couleur: '#E1306C' },
  facebook:  { label: 'Facebook',  icon: '👥', couleur: '#1877F2' },
  linkedin:  { label: 'LinkedIn',  icon: '💼', couleur: '#0A66C2' },
  tiktok:    { label: 'TikTok',    icon: '🎵', couleur: '#111111' },
  youtube:   { label: 'YouTube',   icon: '▶️', couleur: '#FF0000' },
  twitter:   { label: 'Twitter/X', icon: '🐦', couleur: '#1DA1F2' },
};

const STATUTS = {
  brouillon: { label: 'Brouillon', bg: '#F3F4F6', color: '#6B7280' },
  planifie:  { label: 'Planifié',  bg: '#FEF3C7', color: '#D97706' },
  publie:    { label: 'Publié',    bg: '#D1FAE5', color: '#059669' },
  archive:   { label: 'Archivé',  bg: '#E5E7EB', color: '#374151' },
};

const VUES = [
  { id: 'posts',      label: '📋 Posts' },
  { id: 'calendrier', label: '📅 Calendrier' },
  { id: 'stats',      label: '📊 Stats' },
];

const S = {
  form:   { background: '#F8FAFC', padding: '20px', borderRadius: '10px', marginBottom: '24px' },
  champ:  { display: 'flex', flexDirection: 'column', marginBottom: '14px' },
  label:  { fontWeight: '600', marginBottom: '4px', fontSize: '13px', color: '#374151' },
  input:  { padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '14px', width: '100%', boxSizing: 'border-box' },
  textarea: { padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '14px', width: '100%', boxSizing: 'border-box', minHeight: '80px', resize: 'vertical', fontFamily: 'inherit' },
  btn:    (bg, color = 'white') => ({ padding: '9px 18px', background: bg, color, border: 'none', borderRadius: '7px', cursor: 'pointer', fontSize: '14px', fontWeight: '600' }),
  badge:  (statut) => ({ ...STATUTS[statut] ?? { bg: '#F3F4F6', color: '#6B7280' }, padding: '2px 8px', borderRadius: '12px', fontSize: '12px', fontWeight: '600', display: 'inline-block' }),
  card:   { background: 'white', border: '1px solid #E5E7EB', borderRadius: '10px', padding: '16px', marginBottom: '12px' },
};

function PlatformeBadge({ plateforme }) {
  const p = PLATEFORMES[plateforme?.toLowerCase()] ?? { icon: '🌐', label: plateforme, couleur: '#6B7280' };
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: '5px', background: p.couleur, color: 'white', padding: '3px 10px', borderRadius: '12px', fontSize: '12px', fontWeight: '600' }}>
      {p.icon} {p.label}
    </span>
  );
}

function StatutBadge({ statut }) {
  const s = STATUTS[statut] ?? { label: statut, bg: '#F3F4F6', color: '#6B7280' };
  return <span style={{ background: s.bg, color: s.color, padding: '2px 8px', borderRadius: '12px', fontSize: '12px', fontWeight: '600' }}>{s.label}</span>;
}

// ─── Vue Posts ────────────────────────────────────────────────────────────────
function VuePosts({ couleur }) {
  const [posts, setPosts]           = useState([]);
  const [chargement, setChargement] = useState(true);
  const [filtre, setFiltre]         = useState('');
  const [form, setForm]             = useState({ plateforme: '', contenu: '', hashtags: '', date_publication: '', statut: 'brouillon', auteur: '' });
  const [editId, setEditId]         = useState(null);
  const [saving, setSaving]         = useState(false);
  const [statut, setStatut]         = useState(null);

  useEffect(() => { charger(); }, []);

  async function charger() {
    setChargement(true);
    const { data } = await supabase.from('reseaux_sociaux_posts').select('*').order('date_publication', { ascending: false });
    setPosts(data || []);
    setChargement(false);
  }

  function ch(e) { setForm({ ...form, [e.target.name]: e.target.value }); }

  function modifier(row) {
    setForm({
      plateforme:       row.plateforme ?? '',
      contenu:          row.contenu ?? '',
      hashtags:         row.hashtags ?? '',
      date_publication: row.date_publication ? row.date_publication.slice(0, 16) : '',
      statut:           row.statut ?? 'brouillon',
      auteur:           row.auteur ?? '',
    });
    setEditId(row.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() { setForm({ plateforme: '', contenu: '', hashtags: '', date_publication: '', statut: 'brouillon', auteur: '' }); setEditId(null); setStatut(null); }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.contenu.trim()) { setStatut('erreur'); return; }
    setSaving(true);
    const payload = {
      plateforme:       form.plateforme || null,
      contenu:          form.contenu,
      hashtags:         form.hashtags || null,
      date_publication: form.date_publication || null,
      statut:           form.statut,
      auteur:           form.auteur || null,
    };
    const { error } = editId
      ? await supabase.from('reseaux_sociaux_posts').update(payload).eq('id', editId)
      : await supabase.from('reseaux_sociaux_posts').insert([payload]);
    setSaving(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    annuler();
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  async function supprimer(id) {
    if (!window.confirm('Supprimer ce post ?')) return;
    await supabase.from('reseaux_sociaux_posts').delete().eq('id', id);
    charger();
  }

  const postsFiltres = filtre
    ? posts.filter(p => p.plateforme?.toLowerCase() === filtre)
    : posts;

  return (
    <div>
      {/* Formulaire */}
      <form onSubmit={envoyer} style={{ ...S.form, borderLeft: editId ? `4px solid ${couleur}` : 'none' }}>
        <h3 style={{ marginTop: 0, color: couleur }}>{editId ? '✏️ Modifier le post' : '+ Nouveau post'}</h3>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '14px' }}>
          <div style={S.champ}>
            <label style={S.label}>Plateforme</label>
            <select name="plateforme" value={form.plateforme} onChange={ch} style={S.input}>
              <option value="">— Choisir —</option>
              {Object.entries(PLATEFORMES).map(([k, v]) => (
                <option key={k} value={k}>{v.icon} {v.label}</option>
              ))}
            </select>
          </div>
          <div style={S.champ}>
            <label style={S.label}>Statut</label>
            <select name="statut" value={form.statut} onChange={ch} style={S.input}>
              {Object.entries(STATUTS).map(([k, v]) => <option key={k} value={k}>{v.label}</option>)}
            </select>
          </div>
          <div style={S.champ}>
            <label style={S.label}>Date de publication</label>
            <input name="date_publication" type="datetime-local" value={form.date_publication} onChange={ch} style={S.input} />
          </div>
          <div style={S.champ}>
            <label style={S.label}>Auteur</label>
            <input name="auteur" value={form.auteur} onChange={ch} placeholder="Prénom Nom" style={S.input} />
          </div>
        </div>
        <div style={S.champ}>
          <label style={S.label}>Contenu *</label>
          <textarea name="contenu" value={form.contenu} onChange={ch} placeholder="Rédigez votre post…" style={S.textarea} />
        </div>
        <div style={S.champ}>
          <label style={S.label}>Hashtags</label>
          <input name="hashtags" value={form.hashtags} onChange={ch} placeholder="#immobilier #alsace…" style={S.input} />
        </div>
        {statut === 'erreur' && <p style={{ color: '#DC2626', fontWeight: '600', marginBottom: '8px' }}>Le contenu est obligatoire.</p>}
        {statut === 'ok'    && <p style={{ color: '#059669', fontWeight: '600', marginBottom: '8px' }}>Post ajouté !</p>}
        {statut === 'maj'   && <p style={{ color: '#059669', fontWeight: '600', marginBottom: '8px' }}>Post mis à jour !</p>}
        <div style={{ display: 'flex', gap: '10px' }}>
          <button type="submit" disabled={saving} style={S.btn(couleur)}>{saving ? 'Enregistrement…' : editId ? '✏️ Mettre à jour' : '+ Publier'}</button>
          {editId && <button type="button" onClick={annuler} style={S.btn('#6B7280')}>Annuler</button>}
        </div>
      </form>

      {/* Filtres */}
      <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginBottom: '16px' }}>
        <button onClick={() => setFiltre('')} style={{ ...S.btn(filtre === '' ? couleur : '#E5E7EB', filtre === '' ? 'white' : '#374151'), fontSize: '13px', padding: '5px 12px' }}>
          Tous ({posts.length})
        </button>
        {Object.entries(PLATEFORMES).map(([k, v]) => {
          const n = posts.filter(p => p.plateforme === k).length;
          if (!n) return null;
          return (
            <button key={k} onClick={() => setFiltre(k)} style={{ ...S.btn(filtre === k ? v.couleur : '#E5E7EB', filtre === k ? 'white' : '#374151'), fontSize: '13px', padding: '5px 12px' }}>
              {v.icon} {v.label} ({n})
            </button>
          );
        })}
      </div>

      {/* Liste des posts */}
      {chargement ? <p style={{ color: '#9CA3AF' }}>Chargement…</p> : (
        <>
          <p style={{ color: '#6B7280', fontSize: '13px', marginBottom: '12px' }}>{postsFiltres.length} post(s)</p>
          {postsFiltres.map(post => {
            const p = PLATEFORMES[post.plateforme] ?? {};
            return (
              <div key={post.id} style={{ ...S.card, borderLeft: `4px solid ${p.couleur ?? '#E5E7EB'}` }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '12px' }}>
                  <div style={{ flex: 1 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px', flexWrap: 'wrap' }}>
                      <PlatformeBadge plateforme={post.plateforme} />
                      <StatutBadge statut={post.statut} />
                      {post.date_publication && (
                        <span style={{ color: '#6B7280', fontSize: '12px' }}>
                          📅 {new Date(post.date_publication).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })}
                        </span>
                      )}
                    </div>
                    <p style={{ margin: '0 0 8px', fontSize: '14px', lineHeight: 1.5 }}>{post.contenu}</p>
                    {post.hashtags && <p style={{ margin: '0 0 8px', fontSize: '12px', color: '#0A66C2' }}>{post.hashtags}</p>}
                    {post.statut === 'publie' && (
                      <div style={{ display: 'flex', gap: '16px', fontSize: '12px', color: '#6B7280' }}>
                        <span>❤️ {post.engagement_likes ?? 0}</span>
                        <span>💬 {post.engagement_commentaires ?? 0}</span>
                        <span>↗️ {post.engagement_partages ?? 0}</span>
                      </div>
                    )}
                    {post.auteur && <p style={{ margin: '6px 0 0', fontSize: '12px', color: '#9CA3AF' }}>Par {post.auteur}</p>}
                  </div>
                  <div style={{ display: 'flex', gap: '6px', flexShrink: 0 }}>
                    <button onClick={() => modifier(post)} style={{ padding: '4px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '13px' }} title="Modifier">✏️</button>
                    <button onClick={() => supprimer(post.id)} style={{ padding: '4px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '13px' }} title="Supprimer">🗑️</button>
                  </div>
                </div>
              </div>
            );
          })}
          {postsFiltres.length === 0 && <p style={{ color: '#9CA3AF', fontStyle: 'italic' }}>Aucun post pour cette plateforme.</p>}
        </>
      )}
    </div>
  );
}

// ─── Vue Calendrier ───────────────────────────────────────────────────────────
function VueCalendrier({ couleur }) {
  const [entrees, setEntrees]       = useState([]);
  const [chargement, setChargement] = useState(true);
  const [form, setForm]             = useState({ titre: '', plateforme: '', type_contenu: '', date_prevue: '', statut: 'a_planifier', responsable: '', notes: '' });
  const [editId, setEditId]         = useState(null);
  const [saving, setSaving]         = useState(false);
  const [msgStatut, setMsgStatut]   = useState(null);

  useEffect(() => { charger(); }, []);

  async function charger() {
    setChargement(true);
    const { data } = await supabase.from('calendrier_editorial').select('*').order('date_prevue');
    setEntrees(data || []);
    setChargement(false);
  }

  function ch(e) { setForm({ ...form, [e.target.name]: e.target.value }); }

  function modifier(row) {
    setForm({ titre: row.titre ?? '', plateforme: row.plateforme ?? '', type_contenu: row.type_contenu ?? '', date_prevue: row.date_prevue ?? '', statut: row.statut ?? 'a_planifier', responsable: row.responsable ?? '', notes: row.notes ?? '' });
    setEditId(row.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() { setForm({ titre: '', plateforme: '', type_contenu: '', date_prevue: '', statut: 'a_planifier', responsable: '', notes: '' }); setEditId(null); }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.titre.trim()) { setMsgStatut('erreur'); return; }
    setSaving(true);
    const payload = { titre: form.titre, plateforme: form.plateforme || null, type_contenu: form.type_contenu || null, date_prevue: form.date_prevue || null, statut: form.statut, responsable: form.responsable || null, notes: form.notes || null };
    const { error } = editId
      ? await supabase.from('calendrier_editorial').update(payload).eq('id', editId)
      : await supabase.from('calendrier_editorial').insert([payload]);
    setSaving(false);
    if (error) { setMsgStatut('erreur'); return; }
    setMsgStatut(editId ? 'maj' : 'ok');
    annuler();
    charger();
    setTimeout(() => setMsgStatut(null), 3000);
  }

  async function supprimer(id) {
    if (!window.confirm('Supprimer cette entrée ?')) return;
    await supabase.from('calendrier_editorial').delete().eq('id', id);
    charger();
  }

  const STATUTS_CAL = {
    a_planifier: { label: 'À planifier', bg: '#F3F4F6', color: '#6B7280' },
    en_creation:  { label: 'En création', bg: '#DBEAFE', color: '#2563EB' },
    valide:       { label: 'Validé',      bg: '#D1FAE5', color: '#059669' },
    publie:       { label: 'Publié',      bg: '#E5E7EB', color: '#374151' },
  };

  // Grouper par semaine (lundi → dimanche)
  const parSemaine = {};
  entrees.forEach(e => {
    if (!e.date_prevue) { (parSemaine['Sans date'] ??= []).push(e); return; }
    const d = new Date(e.date_prevue);
    const lundi = new Date(d);
    lundi.setDate(d.getDate() - ((d.getDay() + 6) % 7));
    const key = lundi.toISOString().slice(0, 10);
    (parSemaine[key] ??= []).push(e);
  });

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...S.form, borderLeft: editId ? `4px solid ${couleur}` : 'none' }}>
        <h3 style={{ marginTop: 0, color: couleur }}>{editId ? '✏️ Modifier' : '+ Nouvelle entrée'}</h3>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px' }}>
          <div style={{ ...S.champ, gridColumn: '1 / -1' }}>
            <label style={S.label}>Titre *</label>
            <input name="titre" value={form.titre} onChange={ch} placeholder="Ex : Exclusivité Strasbourg — Penthouse" style={S.input} />
          </div>
          <div style={S.champ}>
            <label style={S.label}>Plateforme</label>
            <select name="plateforme" value={form.plateforme} onChange={ch} style={S.input}>
              <option value="">— Choisir —</option>
              {Object.entries(PLATEFORMES).map(([k, v]) => <option key={k} value={k}>{v.icon} {v.label}</option>)}
            </select>
          </div>
          <div style={S.champ}>
            <label style={S.label}>Type de contenu</label>
            <select name="type_contenu" value={form.type_contenu} onChange={ch} style={S.input}>
              <option value="">— Choisir —</option>
              {['photo', 'video', 'carousel', 'story', 'reels', 'texte'].map(t => <option key={t} value={t}>{t}</option>)}
            </select>
          </div>
          <div style={S.champ}>
            <label style={S.label}>Date prévue</label>
            <input name="date_prevue" type="date" value={form.date_prevue} onChange={ch} style={S.input} />
          </div>
          <div style={S.champ}>
            <label style={S.label}>Statut</label>
            <select name="statut" value={form.statut} onChange={ch} style={S.input}>
              {Object.entries(STATUTS_CAL).map(([k, v]) => <option key={k} value={k}>{v.label}</option>)}
            </select>
          </div>
          <div style={S.champ}>
            <label style={S.label}>Responsable</label>
            <input name="responsable" value={form.responsable} onChange={ch} placeholder="Prénom Nom" style={S.input} />
          </div>
          <div style={{ ...S.champ, gridColumn: '1 / -1' }}>
            <label style={S.label}>Notes</label>
            <input name="notes" value={form.notes} onChange={ch} placeholder="Informations complémentaires…" style={S.input} />
          </div>
        </div>
        {msgStatut === 'erreur' && <p style={{ color: '#DC2626', fontWeight: '600', margin: '8px 0' }}>Le titre est obligatoire.</p>}
        {msgStatut === 'ok'    && <p style={{ color: '#059669', fontWeight: '600', margin: '8px 0' }}>Ajouté !</p>}
        {msgStatut === 'maj'   && <p style={{ color: '#059669', fontWeight: '600', margin: '8px 0' }}>Mis à jour !</p>}
        <div style={{ display: 'flex', gap: '10px', marginTop: '4px' }}>
          <button type="submit" disabled={saving} style={S.btn(couleur)}>{saving ? '…' : editId ? '✏️ Mettre à jour' : '+ Ajouter'}</button>
          {editId && <button type="button" onClick={annuler} style={S.btn('#6B7280')}>Annuler</button>}
        </div>
      </form>

      {chargement ? <p style={{ color: '#9CA3AF' }}>Chargement…</p> : (
        Object.keys(parSemaine).sort().map(semaineKey => {
          const labelSem = semaineKey === 'Sans date' ? 'Sans date' : (() => {
            const lundi = new Date(semaineKey);
            const dim = new Date(lundi);
            dim.setDate(lundi.getDate() + 6);
            return `Semaine du ${lundi.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })} au ${dim.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })}`;
          })();
          return (
            <div key={semaineKey} style={{ marginBottom: '24px' }}>
              <h4 style={{ color: couleur, borderBottom: `2px solid ${couleur}`, paddingBottom: '6px', marginBottom: '12px' }}>{labelSem}</h4>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(240px, 1fr))', gap: '10px' }}>
                {parSemaine[semaineKey].map(entry => {
                  const p = PLATEFORMES[entry.plateforme] ?? {};
                  const s = STATUTS_CAL[entry.statut] ?? STATUTS_CAL.a_planifier;
                  return (
                    <div key={entry.id} style={{ background: 'white', border: `1px solid ${p.couleur ?? '#E5E7EB'}`, borderRadius: '8px', padding: '12px' }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                        {entry.plateforme ? <PlatformeBadge plateforme={entry.plateforme} /> : <span style={{ fontSize: '12px', color: '#9CA3AF' }}>— Toutes —</span>}
                        <span style={{ background: s.bg, color: s.color, padding: '2px 7px', borderRadius: '10px', fontSize: '11px', fontWeight: '600' }}>{s.label}</span>
                      </div>
                      <p style={{ margin: '0 0 6px', fontSize: '13px', fontWeight: '600' }}>{entry.titre}</p>
                      {entry.type_contenu && <p style={{ margin: '0 0 4px', fontSize: '12px', color: '#6B7280' }}>📎 {entry.type_contenu}</p>}
                      {entry.date_prevue && <p style={{ margin: '0 0 4px', fontSize: '12px', color: '#6B7280' }}>📅 {new Date(entry.date_prevue).toLocaleDateString('fr-FR')}</p>}
                      {entry.responsable && <p style={{ margin: '0 0 4px', fontSize: '12px', color: '#6B7280' }}>👤 {entry.responsable}</p>}
                      {entry.notes && <p style={{ margin: '4px 0 0', fontSize: '11px', color: '#9CA3AF', fontStyle: 'italic' }}>{entry.notes}</p>}
                      <div style={{ display: 'flex', gap: '6px', marginTop: '8px' }}>
                        <button onClick={() => modifier(entry)} style={{ padding: '2px 6px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '12px' }}>✏️</button>
                        <button onClick={() => supprimer(entry.id)} style={{ padding: '2px 6px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '12px' }}>🗑️</button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          );
        })
      )}
    </div>
  );
}

// ─── Vue Stats ────────────────────────────────────────────────────────────────
function VueStats() {
  const [posts, setPosts]           = useState([]);
  const [comptes, setComptes]       = useState([]);
  const [chargement, setChargement] = useState(true);

  useEffect(() => {
    async function charger() {
      const [{ data: p }, { data: c }] = await Promise.all([
        supabase.from('reseaux_sociaux_posts').select('*'),
        supabase.from('reseaux_sociaux_comptes').select('*'),
      ]);
      setPosts(p || []);
      setComptes(c || []);
      setChargement(false);
    }
    charger();
  }, []);

  if (chargement) return <p style={{ color: '#9CA3AF' }}>Chargement…</p>;

  const postsPub = posts.filter(p => p.statut === 'publie');

  // Stats par plateforme
  const statsPar = {};
  postsPub.forEach(p => {
    const k = p.plateforme ?? 'autre';
    if (!statsPar[k]) statsPar[k] = { likes: 0, comm: 0, partages: 0, nb: 0 };
    statsPar[k].likes    += p.engagement_likes ?? 0;
    statsPar[k].comm     += p.engagement_commentaires ?? 0;
    statsPar[k].partages += p.engagement_partages ?? 0;
    statsPar[k].nb++;
  });

  const totalLikes = postsPub.reduce((s, p) => s + (p.engagement_likes ?? 0), 0);
  const maxLikes   = Math.max(...Object.values(statsPar).map(s => s.likes), 1);

  return (
    <div>
      {/* KPI globaux */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(160px, 1fr))', gap: '14px', marginBottom: '28px' }}>
        {[
          { label: 'Posts publiés',  val: postsPub.length,    icon: '📋', bg: '#EFF6FF', color: '#2563EB' },
          { label: 'Total Likes',    val: totalLikes.toLocaleString('fr-FR'), icon: '❤️', bg: '#FFF0F0', color: '#DC2626' },
          { label: 'Commentaires',   val: postsPub.reduce((s, p) => s + (p.engagement_commentaires ?? 0), 0).toLocaleString('fr-FR'), icon: '💬', bg: '#F0FDF4', color: '#059669' },
          { label: 'Partages',       val: postsPub.reduce((s, p) => s + (p.engagement_partages ?? 0), 0).toLocaleString('fr-FR'), icon: '↗️', bg: '#FFF7ED', color: '#D97706' },
          { label: 'Abonnés total',  val: comptes.reduce((s, c) => s + (c.abonnes ?? 0), 0).toLocaleString('fr-FR'), icon: '👥', bg: '#F5F3FF', color: '#7C3AED' },
          { label: 'Comptes actifs', val: comptes.filter(c => c.statut === 'actif').length, icon: '✅', bg: '#F0FDF4', color: '#059669' },
        ].map(k => (
          <div key={k.label} style={{ background: k.bg, border: `1px solid ${k.color}22`, borderRadius: '10px', padding: '14px', textAlign: 'center' }}>
            <p style={{ margin: 0, fontSize: '24px' }}>{k.icon}</p>
            <p style={{ margin: '4px 0 0', fontSize: '22px', fontWeight: '700', color: k.color }}>{k.val}</p>
            <p style={{ margin: '2px 0 0', fontSize: '12px', color: '#6B7280' }}>{k.label}</p>
          </div>
        ))}
      </div>

      {/* Engagement par plateforme */}
      <h3 style={{ color: '#374151', marginBottom: '14px' }}>Engagement par plateforme</h3>
      {Object.entries(statsPar).sort((a, b) => b[1].likes - a[1].likes).map(([plat, stats]) => {
        const p = PLATEFORMES[plat] ?? { icon: '🌐', label: plat, couleur: '#6B7280' };
        const pct = Math.round((stats.likes / maxLikes) * 100);
        return (
          <div key={plat} style={{ background: 'white', border: '1px solid #E5E7EB', borderRadius: '10px', padding: '16px', marginBottom: '10px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
              <PlatformeBadge plateforme={plat} />
              <span style={{ fontSize: '12px', color: '#6B7280' }}>{stats.nb} post(s) publié(s)</span>
            </div>
            <div style={{ display: 'flex', gap: '20px', fontSize: '13px', marginBottom: '8px' }}>
              <span>❤️ {stats.likes.toLocaleString('fr-FR')} likes</span>
              <span>💬 {stats.comm.toLocaleString('fr-FR')} commentaires</span>
              <span>↗️ {stats.partages.toLocaleString('fr-FR')} partages</span>
            </div>
            <div style={{ background: '#F3F4F6', borderRadius: '4px', height: '8px', overflow: 'hidden' }}>
              <div style={{ width: `${pct}%`, height: '100%', background: p.couleur, borderRadius: '4px', transition: 'width 0.3s' }} />
            </div>
          </div>
        );
      })}

      {/* Comptes */}
      <h3 style={{ color: '#374151', margin: '28px 0 14px' }}>Comptes réseaux sociaux</h3>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '12px' }}>
        {comptes.map(c => {
          const p = PLATEFORMES[c.plateforme] ?? { icon: '🌐', label: c.plateforme, couleur: '#6B7280' };
          return (
            <a key={c.id} href={c.url_profil ?? '#'} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
              <div style={{ background: 'white', border: `2px solid ${p.couleur}33`, borderRadius: '10px', padding: '14px', textAlign: 'center', cursor: 'pointer', transition: 'box-shadow 0.15s' }}>
                <p style={{ margin: 0, fontSize: '28px' }}>{p.icon}</p>
                <p style={{ margin: '4px 0 2px', fontWeight: '700', color: p.couleur, fontSize: '14px' }}>{c.nom_compte}</p>
                <p style={{ margin: 0, fontSize: '13px', color: '#6B7280' }}>{p.label}</p>
                <p style={{ margin: '6px 0 0', fontSize: '20px', fontWeight: '700', color: '#1E3A8A' }}>{c.abonnes?.toLocaleString('fr-FR')}</p>
                <p style={{ margin: '0', fontSize: '11px', color: '#9CA3AF' }}>abonnés</p>
              </div>
            </a>
          );
        })}
      </div>
    </div>
  );
}

// ─── Composant principal ──────────────────────────────────────────────────────
export default function ReseauxSociaux({ couleur = '#7C3AED' }) {
  const [vue, setVue] = useState('posts');

  return (
    <div>
      {/* Sous-navigation */}
      <div style={{ display: 'flex', gap: '6px', marginBottom: '20px', flexWrap: 'wrap' }}>
        {VUES.map(v => (
          <button
            key={v.id}
            onClick={() => setVue(v.id)}
            style={{
              ...S.btn(vue === v.id ? couleur : '#F1F5F9', vue === v.id ? 'white' : '#374151'),
              fontSize: '13px', padding: '7px 14px',
            }}
          >
            {v.label}
          </button>
        ))}
      </div>

      {vue === 'posts'      && <VuePosts couleur={couleur} />}
      {vue === 'calendrier' && <VueCalendrier couleur={couleur} />}
      {vue === 'stats'      && <VueStats />}
    </div>
  );
}

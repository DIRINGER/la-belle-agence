import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';
import ClientForm       from './ClientForm';
import BienForm         from './BienForm';
import SalarieForm      from './SalarieForm';
import ProspectForm     from './ProspectForm';
import MandatForm       from './MandatForm';
import ReseauxSociaux   from './marketing/ReseauxSociaux';
import SimulateurCredit from './commercial/SimulateurCredit';

// ─── Couleurs par service ───────────────────────────────────────────────────
const COULEURS = {
  RH:           '#D97706',
  Marketing:    '#7C3AED',
  Conformité:   '#DC2626',
  Finance:      '#059669',
  Patrimoine:   '#0891B2',
  Commercial:   '#1E3A8A',
  IT:           '#374151',
  Fournisseurs: '#92400E',
};

// ─── Définition des 7 services + leurs sous-onglets ────────────────────────
const SERVICES = [
  {
    id: 'RH', label: '📋 RH', couleur: COULEURS.RH,
    sousOnglets: [
      { id: 'salaries',    label: '🧑‍💼 Salariés',   table: 'salaries',    composant: 'SalarieForm' },
      { id: 'conges',      label: '🌴 Congés',        table: 'conges',      composant: 'CongesTable' },
      { id: 'formations',  label: '🎓 Formations',    table: 'formations',  composant: 'FormationsTable' },
      { id: 'docs_rh',     label: '📄 Documents',     table: 'documents_rh',composant: 'DocsRHTable' },
    ],
  },
  {
    id: 'Marketing', label: '📊 Marketing', couleur: COULEURS.Marketing,
    sousOnglets: [
      { id: 'campagnes',  label: '📣 Campagnes',       table: 'campagnes_marketing',  composant: 'CampagnesTable' },
      { id: 'reseaux',    label: '📱 Réseaux Sociaux',  table: 'reseaux_sociaux_posts',composant: 'ReseauxSociaux' },
      { id: 'posts_blog', label: '✍️ Posts Blog',       table: 'posts_sociaux',        composant: 'PostsTable' },
      { id: 'templates',  label: '📝 Templates',        table: 'templates_documents',  composant: 'TemplatesTable' },
    ],
  },
  {
    id: 'Conformité', label: '⚖️ Conformité', couleur: COULEURS.Conformité,
    sousOnglets: [
      { id: 'orias',       label: '🗂️ Dossiers ORIAS', table: 'documents_orias',         composant: 'DocumentsOriasTable' },
      { id: 'cartes',      label: '🪪 Cartes pro',      table: 'cartes_professionnelles', composant: 'CartesTable' },
      { id: 'assurances',  label: '🛡️ Assurances RC',   table: 'assurances_rc',           composant: 'AssurancesTable' },
      { id: 'forma_dda',   label: '📚 Formations DDA',  table: 'formations',              composant: 'FormationsDDA' },
    ],
  },
  {
    id: 'Finance', label: '💰 Finance', couleur: COULEURS.Finance,
    sousOnglets: [
      { id: 'fact_fourn',  label: '🧾 Factures fourn.', table: 'factures_fournisseurs', composant: 'FactFournTable' },
      { id: 'fact_cli',    label: '📋 Factures clients', table: 'factures_clients',      composant: 'FactCliTable' },
      { id: 'ecritures',   label: '📒 Écritures',        table: 'ecritures_comptables',  composant: 'EcrituresTable' },
    ],
  },
  {
    id: 'Patrimoine', label: '🏢 Patrimoine', couleur: COULEURS.Patrimoine,
    sousOnglets: [
      { id: 'clients_pat', label: '👤 Clients',         table: 'clients',               composant: 'ClientForm' },
      { id: 'dossiers',    label: '📁 Dossiers',         table: 'dossiers_patrimoniaux', composant: 'DossiersTable' },
      { id: 'tmpl_pat',    label: '📝 Templates',        table: 'templates_documents',   composant: 'TemplatesTable' },
    ],
  },
  {
    id: 'Commercial', label: '🏠 Commercial', couleur: COULEURS.Commercial,
    sousOnglets: [
      { id: 'biens',      label: '🏠 Biens',             table: 'biens',    composant: 'BienForm' },
      { id: 'mandats',    label: '📋 Mandats',            table: 'mandats',  composant: 'MandatForm' },
      { id: 'visites',    label: '👁️ Visites',            table: 'visites',  composant: 'VisitesTable' },
      { id: 'offres',     label: '💬 Offres',             table: 'offres',   composant: 'OffresTable' },
      { id: 'ventes',     label: '✅ Ventes',              table: 'ventes',   composant: 'VentesTable' },
      { id: 'simulateur', label: '🧮 Simulateur crédit',  table: '',         composant: 'SimulateurCredit' },
    ],
  },
  {
    id: 'IT', label: '🛠️ IT', couleur: COULEURS.IT,
    sousOnglets: [
      { id: 'tickets',   label: '🎫 Tickets',  table: 'tickets_support',       composant: 'TicketsTable' },
      { id: 'materiel',  label: '💻 Matériel', table: 'materiel_informatique', composant: 'MaterielTable' },
      { id: 'licences',  label: '🔑 Licences', table: 'licences_logiciels',    composant: 'LicencesTable' },
    ],
  },
  {
    id: 'Fournisseurs', label: '🤝 Fournisseurs', couleur: COULEURS.Fournisseurs,
    sousOnglets: [
      { id: 'partenaires',  label: '🏢 Partenaires',  table: 'fournisseurs_partenaires', composant: 'FournisseursTable' },
      { id: 'evaluations',  label: '⭐ Évaluations',  table: 'evaluations_fournisseurs', composant: 'EvaluationsTable' },
      { id: 'historique',   label: '📈 Historique',   table: 'historique_fournisseurs',  composant: 'HistoriqueFournTable' },
    ],
  },
  {
    id: 'Pédagogie', label: '📚 Pédagogie', couleur: '#6D28D9',
    sousOnglets: [
      { id: 'progression',  label: '📊 Progression élèves', table: 'progression_eleves', composant: 'ProgressionElevesTable' },
    ],
  },
];

// ─── Styles partagés ───────────────────────────────────────────────────────
const S = {
  form:   { background: '#F8FAFC', padding: '20px', borderRadius: '10px', marginBottom: '24px' },
  rangee: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '14px' },
  champ:  { display: 'flex', flexDirection: 'column', marginBottom: '14px' },
  label:  { fontWeight: '600', marginBottom: '4px', fontSize: '13px', color: '#374151' },
  input:  { padding: '9px 12px', border: '1px solid #CBD5E1', borderRadius: '6px', fontSize: '14px' },
  btn:    (couleur) => ({ padding: '10px 22px', background: couleur, color: 'white', border: 'none', borderRadius: '7px', cursor: 'pointer', fontSize: '14px', fontWeight: '600' }),
  table:  { width: '100%', borderCollapse: 'collapse', fontSize: '13px' },
  th:     (couleur) => ({ background: couleur, color: 'white', padding: '9px 12px', textAlign: 'left', whiteSpace: 'nowrap' }),
  td:     { padding: '8px 12px', borderBottom: '1px solid #E5E7EB' },
  succes: { color: '#059669', fontWeight: '600', marginTop: '8px' },
  erreur: { color: '#DC2626', fontWeight: '600', marginTop: '8px' },
  vide:   { color: '#9CA3AF', fontStyle: 'italic', padding: '16px 0' },
  btnEdit: { marginRight: '6px', padding: '3px 8px', background: '#FEF3C7', border: '1px solid #F59E0B', borderRadius: '4px', cursor: 'pointer', fontSize: '13px' },
  btnDel:  { padding: '3px 8px', background: '#FEE2E2', border: '1px solid #FCA5A5', borderRadius: '4px', cursor: 'pointer', fontSize: '13px' },
};

// ─── Combobox salarié avec datalist (autocomplete) ────────────────────────
function SalarieCombobox({ name, value, onChange, style }) {
  const [options, setOptions] = useState([]);
  const listId = `datalist-salaries-${name}`;

  useEffect(() => {
    supabase
      .from('salaries')
      .select('nom, prenom')
      .order('nom')
      .then(({ data }) => setOptions(data || []));
  }, []);

  return (
    <>
      <input
        name={name}
        value={value ?? ''}
        onChange={onChange}
        list={listId}
        placeholder="Tapez un nom…"
        style={style}
        autoComplete="off"
      />
      <datalist id={listId}>
        {options.map((s, i) => (
          <option key={i} value={`${s.prenom} ${s.nom}`} />
        ))}
      </datalist>
    </>
  );
}

// ─── Hook générique de CRUD Supabase ──────────────────────────────────────
function useListe(table, filtres = {}) {
  const [liste, setListe] = useState([]);
  const [chargement, setChargement] = useState(true);

  useEffect(() => {
    charger();
  }, [table]);

  async function charger() {
    setChargement(true);
    let q = supabase.from(table).select('*').order('created_at', { ascending: false });
    Object.entries(filtres).forEach(([col, val]) => { q = q.eq(col, val); });
    const { data } = await q;
    setListe(data || []);
    setChargement(false);
  }

  async function supprimer(id) {
    if (!window.confirm('Supprimer cette entrée ?')) return;
    await supabase.from(table).delete().eq('id', id);
    charger();
  }

  return { liste, chargement, charger, supprimer };
}

// ─── Formulaire + tableau générique ────────────────────────────────────────
function TableGeneric({ table, couleur, champs, colonnes, filtres = {} }) {
  const { liste, chargement, charger, supprimer } = useListe(table, filtres);
  const [form, setForm] = useState({});
  const [editId, setEditId] = useState(null);
  const [statut, setStatut] = useState(null);
  const [saving, setSaving] = useState(false);

  function ch(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  function annuler() { setForm({}); setEditId(null); setStatut(null); }

  function modifier(row) {
    const f = {};
    champs.forEach(c => { f[c.name] = row[c.name] ?? ''; });
    setForm(f);
    setEditId(row.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  async function envoyer(e) {
    e.preventDefault();
    const chOblig = champs.find(c => c.required && !form[c.name]);
    if (chOblig) { setStatut('erreur'); return; }
    setSaving(true);
    const payload = { ...filtres };
    champs.forEach(c => {
      const v = form[c.name];
      if (c.type === 'number') payload[c.name] = v ? parseFloat(v) : null;
      else payload[c.name] = v || null;
    });
    const { error } = editId
      ? await supabase.from(table).update(payload).eq('id', editId)
      : await supabase.from(table).insert([payload]);
    setSaving(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    setForm({});
    setEditId(null);
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...S.form, borderLeft: editId ? `4px solid ${couleur}` : 'none' }}>
        <h3 style={{ marginTop: 0, color: couleur }}>{editId ? '✏️ Modifier' : '+ Nouvelle entrée'}</h3>
        <div style={S.rangee}>
          {champs.map(c => (
            <div key={c.name} style={S.champ}>
              <label style={S.label}>{c.label}{c.required ? ' *' : ''}</label>
              {c.type === 'salarie' ? (
                <SalarieCombobox name={c.name} value={form[c.name]} onChange={ch} style={S.input} />
              ) : c.options ? (
                <select name={c.name} value={form[c.name] ?? ''} onChange={ch} style={S.input}>
                  <option value="">— Choisir —</option>
                  {c.options.map(o => <option key={o} value={o}>{o}</option>)}
                </select>
              ) : (
                <input
                  name={c.name}
                  type={c.type || 'text'}
                  value={form[c.name] ?? ''}
                  onChange={ch}
                  placeholder={c.placeholder || ''}
                  style={S.input}
                />
              )}
            </div>
          ))}
        </div>
        {statut === 'erreur' && <p style={S.erreur}>Champ(s) obligatoire(s) manquant(s).</p>}
        {statut === 'ok'    && <p style={S.succes}>Ajouté avec succès !</p>}
        {statut === 'maj'   && <p style={S.succes}>Mis à jour !</p>}
        <div style={{ display: 'flex', gap: '10px', marginTop: '4px' }}>
          <button type="submit" disabled={saving} style={S.btn(couleur)}>
            {saving ? 'Enregistrement...' : editId ? '✏️ Mettre à jour' : '+ Ajouter'}
          </button>
          {editId && <button type="button" onClick={annuler} style={{ ...S.btn('#6B7280') }}>Annuler</button>}
        </div>
      </form>

      <p style={{ color: '#6B7280', fontSize: '13px' }}>{chargement ? 'Chargement…' : `${liste.length} entrée(s)`}</p>
      {liste.length > 0 && (
        <div style={{ overflowX: 'auto' }}>
          <table style={S.table}>
            <thead>
              <tr>
                {colonnes.map(col => <th key={col.key} style={S.th(couleur)}>{col.label}</th>)}
                <th style={S.th(couleur)}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {liste.map((row, i) => (
                <tr key={row.id} style={{ background: editId === row.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                  {colonnes.map(col => (
                    <td key={col.key} style={S.td}>
                      {col.render ? col.render(row[col.key], row) : (row[col.key] ?? '—')}
                    </td>
                  ))}
                  <td style={{ ...S.td, whiteSpace: 'nowrap' }}>
                    <button onClick={() => modifier(row)} style={S.btnEdit} title="Modifier">✏️</button>
                    <button onClick={() => supprimer(row.id)} style={S.btnDel} title="Supprimer">🗑️</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      {!chargement && liste.length === 0 && <p style={S.vide}>Aucune entrée pour l'instant.</p>}
    </div>
  );
}

// ─── Sous-onglets spécialisés ──────────────────────────────────────────────

function CongesTable({ couleur }) {
  return <TableGeneric
    table="conges" couleur={couleur}
    champs={[
      { name: 'salarie_nom', label: 'Salarié', required: true, type: 'salarie' },
      { name: 'type', label: 'Type', options: ['CP', 'RTT', 'maladie', 'autre'] },
      { name: 'date_debut', label: 'Date début', type: 'date' },
      { name: 'date_fin',   label: 'Date fin',   type: 'date' },
      { name: 'jours',  label: 'Jours', type: 'number', placeholder: '5' },
      { name: 'statut', label: 'Statut', options: ['en attente', 'approuvé', 'refusé'] },
    ]}
    colonnes={[
      { key: 'salarie_nom', label: 'Salarié' },
      { key: 'type',        label: 'Type' },
      { key: 'date_debut',  label: 'Début' },
      { key: 'date_fin',    label: 'Fin' },
      { key: 'jours',       label: 'Jours' },
      { key: 'statut',      label: 'Statut' },
    ]}
  />;
}

function FormationsTable({ couleur, filtreDDA = false }) {
  return <TableGeneric
    table="formations" couleur={couleur}
    filtres={filtreDDA ? { type_formation: 'DDA' } : {}}
    champs={[
      { name: 'salarie_nom',    label: 'Salarié', required: true, type: 'salarie' },
      { name: 'intitule',       label: 'Intitulé', required: true },
      { name: 'organisme',      label: 'Organisme' },
      { name: 'date_formation', label: 'Date', type: 'date' },
      { name: 'duree_heures',   label: 'Durée (h)', type: 'number' },
      { name: 'type_formation', label: 'Type', options: ['DDA', 'obligatoire', 'facultatif'] },
    ]}
    colonnes={[
      { key: 'salarie_nom',    label: 'Salarié' },
      { key: 'intitule',       label: 'Intitulé' },
      { key: 'organisme',      label: 'Organisme' },
      { key: 'date_formation', label: 'Date' },
      { key: 'duree_heures',   label: 'Heures' },
      { key: 'type_formation', label: 'Type' },
      {
        key: 'prochaine_dda',
        label: 'Prochaine DDA',
        render: (_, row) => {
          const v = row.date_formation;
          if (row.type_formation !== 'DDA' || !v) return '—';
          const next = new Date(v);
          next.setFullYear(next.getFullYear() + 1);
          const diff = Math.round((next - new Date()) / 86400000);
          const c = diff < 30 ? '#DC2626' : diff < 90 ? '#D97706' : '#059669';
          return (
            <span style={{ color: c, fontWeight: 600 }}>
              {next.toLocaleDateString('fr-FR')} (J{diff >= 0 ? '-' : '+'}{Math.abs(diff)})
            </span>
          );
        },
      },
    ]}
  />;
}

function DocsRHTable({ couleur }) {
  return <TableGeneric
    table="documents_rh" couleur={couleur}
    champs={[
      { name: 'salarie_nom',    label: 'Salarié', required: true, type: 'salarie' },
      { name: 'type_document',  label: 'Type de document' },
      { name: 'date_expiration',label: 'Expiration', type: 'date' },
      { name: 'url',            label: 'URL document' },
    ]}
    colonnes={[
      { key: 'salarie_nom',    label: 'Salarié' },
      { key: 'type_document',  label: 'Type' },
      { key: 'date_expiration',label: 'Expiration' },
      { key: 'alerte_active',  label: 'Alerte', render: v => v ? '🔔 Oui' : 'Non' },
    ]}
  />;
}

function CartesTable({ couleur }) {
  return <TableGeneric
    table="cartes_professionnelles" couleur={couleur}
    champs={[
      { name: 'salarie_nom',         label: 'Salarié', required: true, type: 'salarie' },
      { name: 'numero_carte',        label: 'N° carte' },
      { name: 'date_expiration',     label: 'Expiration', type: 'date' },
      { name: 'organisme_delivreur', label: 'Organisme' },
      { name: 'statut',              label: 'Statut', options: ['valide', 'expiré', 'en renouvellement'] },
    ]}
    colonnes={[
      { key: 'salarie_nom',         label: 'Salarié' },
      { key: 'numero_carte',        label: 'N° carte' },
      { key: 'date_expiration',     label: 'Expiration' },
      { key: 'organisme_delivreur', label: 'Organisme' },
      { key: 'statut',              label: 'Statut' },
    ]}
  />;
}

function AssurancesTable({ couleur }) {
  return <TableGeneric
    table="assurances_rc" couleur={couleur}
    champs={[
      { name: 'salarie_nom',      label: 'Salarié', required: true, type: 'salarie' },
      { name: 'compagnie',        label: 'Compagnie', required: true },
      { name: 'numero_police',    label: 'N° police' },
      { name: 'montant_garantie', label: 'Garantie (€)', type: 'number' },
      { name: 'date_debut',       label: 'Début', type: 'date' },
      { name: 'date_fin',         label: 'Fin',   type: 'date' },
    ]}
    colonnes={[
      { key: 'compagnie',        label: 'Compagnie' },
      { key: 'numero_police',    label: 'N° police' },
      { key: 'montant_garantie', label: 'Garantie', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'date_debut',       label: 'Début' },
      { key: 'date_fin',         label: 'Fin' },
    ]}
  />;
}

function CampagnesTable({ couleur }) {
  return <TableGeneric
    table="campagnes_marketing" couleur={couleur}
    champs={[
      { name: 'nom',        label: 'Nom campagne', required: true },
      { name: 'canal',      label: 'Canal', options: ['réseaux sociaux', 'email', 'print', 'événement'] },
      { name: 'budget',     label: 'Budget (€)', type: 'number' },
      { name: 'date_debut', label: 'Début', type: 'date' },
      { name: 'date_fin',   label: 'Fin',   type: 'date' },
      { name: 'statut',     label: 'Statut', options: ['en préparation', 'active', 'terminée', 'suspendue'] },
      { name: 'objectif',   label: 'Objectif' },
    ]}
    colonnes={[
      { key: 'nom',    label: 'Campagne' },
      { key: 'canal',  label: 'Canal' },
      { key: 'budget', label: 'Budget', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'statut', label: 'Statut' },
    ]}
  />;
}

function PostsTable({ couleur }) {
  return <TableGeneric
    table="posts_sociaux" couleur={couleur}
    champs={[
      { name: 'plateforme',       label: 'Plateforme', options: ['LinkedIn', 'Instagram', 'Facebook', 'Twitter/X', 'TikTok'] },
      { name: 'contenu',          label: 'Contenu', required: true },
      { name: 'date_publication', label: 'Date publication', type: 'date' },
      { name: 'statut',           label: 'Statut', options: ['brouillon', 'planifié', 'publié'] },
    ]}
    colonnes={[
      { key: 'plateforme',       label: 'Plateforme' },
      { key: 'contenu',          label: 'Contenu', render: v => v ? (v.length > 60 ? v.slice(0, 60) + '…' : v) : '—' },
      { key: 'date_publication', label: 'Date' },
      { key: 'statut',           label: 'Statut' },
      { key: 'engagement_likes', label: '❤️ Likes' },
    ]}
  />;
}

function TemplatesTable({ couleur }) {
  return <TableGeneric
    table="templates_documents" couleur={couleur}
    champs={[
      { name: 'nom',     label: 'Nom du template', required: true },
      { name: 'type',    label: 'Type', options: ['email', 'contrat', 'facture', 'courrier', 'rh'] },
      { name: 'service', label: 'Service', options: ['RH', 'Marketing', 'Finance', 'Commercial', 'Conformité'] },
      { name: 'contenu_template', label: 'Contenu modèle' },
      { name: 'exemple_rempli',   label: 'Exemple rempli' },
    ]}
    colonnes={[
      { key: 'nom',     label: 'Nom' },
      { key: 'type',    label: 'Type' },
      { key: 'service', label: 'Service' },
      { key: 'contenu_template', label: 'Aperçu', render: v => v ? (v.length > 50 ? v.slice(0, 50) + '…' : v) : '—' },
    ]}
  />;
}

function FactFournTable({ couleur }) {
  return <TableGeneric
    table="factures_fournisseurs" couleur={couleur}
    champs={[
      { name: 'numero_facture', label: 'N° facture', required: true },
      { name: 'fournisseur',    label: 'Fournisseur', required: true },
      { name: 'montant_ht',     label: 'Montant HT (€)', type: 'number' },
      { name: 'tva',            label: 'TVA (%)', type: 'number' },
      { name: 'montant_ttc',    label: 'Montant TTC (€)', type: 'number' },
      { name: 'date_facture',   label: 'Date facture', type: 'date' },
      { name: 'date_echeance',  label: 'Échéance', type: 'date' },
      { name: 'statut',         label: 'Statut', options: ['reçue', 'validée', 'payée', 'litigieuse'] },
      { name: 'anomalie',       label: 'Anomalie détectée' },
    ]}
    colonnes={[
      { key: 'numero_facture', label: 'N°' },
      { key: 'fournisseur',    label: 'Fournisseur' },
      { key: 'montant_ttc',    label: 'TTC', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'date_echeance',  label: 'Échéance' },
      { key: 'statut',         label: 'Statut' },
      { key: 'anomalie',       label: '⚠️ Anomalie', render: v => v ? <span style={{ color: '#DC2626', fontWeight: 600 }}>{v}</span> : '—' },
    ]}
  />;
}

function FactCliTable({ couleur }) {
  return <TableGeneric
    table="factures_clients" couleur={couleur}
    champs={[
      { name: 'numero_facture', label: 'N° facture', required: true },
      { name: 'client_nom',     label: 'Client', required: true },
      { name: 'bien_ref',       label: 'Réf. bien' },
      { name: 'montant_ht',     label: 'Montant HT (€)', type: 'number' },
      { name: 'tva',            label: 'TVA (%)', type: 'number' },
      { name: 'montant_ttc',    label: 'Montant TTC (€)', type: 'number' },
      { name: 'date_facture',   label: 'Date', type: 'date' },
      { name: 'statut',         label: 'Statut', options: ['émise', 'payée', 'en retard', 'annulée'] },
    ]}
    colonnes={[
      { key: 'numero_facture', label: 'N°' },
      { key: 'client_nom',     label: 'Client' },
      { key: 'bien_ref',       label: 'Bien' },
      { key: 'montant_ttc',    label: 'TTC', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'statut',         label: 'Statut' },
    ]}
  />;
}

function EcrituresTable({ couleur }) {
  return <TableGeneric
    table="ecritures_comptables" couleur={couleur}
    champs={[
      { name: 'date_ecriture',      label: 'Date', type: 'date', required: true },
      { name: 'libelle',            label: 'Libellé', required: true },
      { name: 'compte_debit',       label: 'Compte débit' },
      { name: 'compte_credit',      label: 'Compte crédit' },
      { name: 'montant',            label: 'Montant (€)', type: 'number' },
      { name: 'piece_justificative',label: 'Pièce justificative' },
    ]}
    colonnes={[
      { key: 'date_ecriture',  label: 'Date' },
      { key: 'libelle',        label: 'Libellé' },
      { key: 'compte_debit',   label: 'Débit' },
      { key: 'compte_credit',  label: 'Crédit' },
      { key: 'montant',        label: 'Montant', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
    ]}
  />;
}

function DossiersTable({ couleur }) {
  return <TableGeneric
    table="dossiers_patrimoniaux" couleur={couleur}
    champs={[
      { name: 'conseiller_nom',          label: 'Conseiller', required: true },
      { name: 'date_entree',             label: 'Date entrée', type: 'date' },
      { name: 'objectif_patrimoine',     label: 'Objectif patrimoine' },
      { name: 'montant_patrimoine_brut', label: 'Patrimoine brut (€)', type: 'number' },
      { name: 'revenus_annuels',         label: 'Revenus annuels (€)', type: 'number' },
      { name: 'profil_risque',           label: 'Profil risque', options: ['prudent', 'équilibré', 'dynamique'] },
      { name: 'statut',                  label: 'Statut', options: ['actif', 'clôturé'] },
    ]}
    colonnes={[
      { key: 'conseiller_nom',          label: 'Conseiller' },
      { key: 'objectif_patrimoine',     label: 'Objectif', render: v => v ? (v.length > 40 ? v.slice(0, 40) + '…' : v) : '—' },
      { key: 'montant_patrimoine_brut', label: 'Patrimoine', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'profil_risque',           label: 'Profil' },
      { key: 'statut',                  label: 'Statut' },
    ]}
  />;
}

function VisitesTable({ couleur }) {
  return <TableGeneric
    table="visites" couleur={couleur}
    champs={[
      { name: 'client_nom',  label: 'Client', required: true },
      { name: 'date_visite', label: 'Date', type: 'date', required: true },
      { name: 'heure',       label: 'Heure', type: 'time' },
      { name: 'agent_nom',   label: 'Agent' },
      { name: 'statut',      label: 'Statut', options: ['planifiée', 'réalisée', 'annulée'] },
      { name: 'feedback',    label: 'Feedback' },
    ]}
    colonnes={[
      { key: 'client_nom',  label: 'Client' },
      { key: 'date_visite', label: 'Date' },
      { key: 'heure',       label: 'Heure' },
      { key: 'agent_nom',   label: 'Agent' },
      { key: 'statut',      label: 'Statut' },
    ]}
  />;
}

function OffresTable({ couleur }) {
  return <TableGeneric
    table="offres" couleur={couleur}
    champs={[
      { name: 'acheteur_nom',  label: 'Acheteur', required: true },
      { name: 'vendeur_nom',   label: 'Vendeur' },
      { name: 'montant_offre', label: 'Montant offre (€)', type: 'number', required: true },
      { name: 'date_offre',    label: 'Date offre', type: 'date' },
      { name: 'statut',        label: 'Statut', options: ['en cours', 'acceptée', 'refusée', 'contre-offre'] },
    ]}
    colonnes={[
      { key: 'acheteur_nom',  label: 'Acheteur' },
      { key: 'vendeur_nom',   label: 'Vendeur' },
      { key: 'montant_offre', label: 'Offre', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'date_offre',    label: 'Date' },
      { key: 'statut',        label: 'Statut' },
    ]}
  />;
}

function VentesTable({ couleur }) {
  return <TableGeneric
    table="ventes" couleur={couleur}
    champs={[
      { name: 'acheteur_nom',      label: 'Acheteur', required: true },
      { name: 'vendeur_nom',       label: 'Vendeur' },
      { name: 'prix_vente',        label: 'Prix vente (€)', type: 'number', required: true },
      { name: 'date_compromis',    label: 'Date compromis', type: 'date' },
      { name: 'date_acte',         label: 'Date acte', type: 'date' },
      { name: 'notaire',           label: 'Notaire' },
      { name: 'commission_agence', label: 'Commission (€)', type: 'number' },
      { name: 'statut',            label: 'Statut', options: ['en cours', 'signée', 'annulée'] },
    ]}
    colonnes={[
      { key: 'acheteur_nom',      label: 'Acheteur' },
      { key: 'prix_vente',        label: 'Prix', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'date_compromis',    label: 'Compromis' },
      { key: 'commission_agence', label: 'Commission', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'statut',            label: 'Statut' },
    ]}
  />;
}

function TicketsTable({ couleur }) {
  return <TableGeneric
    table="tickets_support" couleur={couleur}
    champs={[
      { name: 'demandeur_nom', label: 'Demandeur', required: true },
      { name: 'titre',         label: 'Titre', required: true },
      { name: 'description',   label: 'Description' },
      { name: 'priorite',      label: 'Priorité', options: ['basse', 'normale', 'haute', 'critique'] },
      { name: 'statut',        label: 'Statut', options: ['ouvert', 'en cours', 'résolu', 'fermé'] },
      { name: 'agent_it',      label: 'Agent IT' },
    ]}
    colonnes={[
      { key: 'demandeur_nom', label: 'Demandeur' },
      { key: 'titre',         label: 'Titre' },
      { key: 'priorite',      label: 'Priorité' },
      { key: 'statut',        label: 'Statut' },
      { key: 'agent_it',      label: 'Agent IT' },
    ]}
  />;
}

function MaterielTable({ couleur }) {
  return <TableGeneric
    table="materiel_informatique" couleur={couleur}
    champs={[
      { name: 'designation',    label: 'Désignation', required: true },
      { name: 'marque',         label: 'Marque' },
      { name: 'numero_serie',   label: 'N° série' },
      { name: 'utilisateur_nom',label: 'Utilisateur' },
      { name: 'date_achat',     label: 'Date achat', type: 'date' },
      { name: 'garantie_fin',   label: 'Fin garantie', type: 'date' },
      { name: 'statut',         label: 'Statut', options: ['opérationnel', 'panne', 'réforme'] },
    ]}
    colonnes={[
      { key: 'designation',    label: 'Matériel' },
      { key: 'marque',         label: 'Marque' },
      { key: 'utilisateur_nom',label: 'Utilisateur' },
      { key: 'garantie_fin',   label: 'Fin garantie' },
      { key: 'statut',         label: 'Statut' },
    ]}
  />;
}

function LicencesTable({ couleur }) {
  return <TableGeneric
    table="licences_logiciels" couleur={couleur}
    champs={[
      { name: 'logiciel',        label: 'Logiciel', required: true },
      { name: 'editeur',         label: 'Éditeur' },
      { name: 'nombre_postes',   label: 'Nb postes', type: 'number' },
      { name: 'date_expiration', label: 'Expiration', type: 'date' },
      { name: 'cout_annuel',     label: 'Coût annuel (€)', type: 'number' },
      { name: 'statut',          label: 'Statut', options: ['active', 'expiree', 'renouvellement'] },
    ]}
    colonnes={[
      { key: 'logiciel',        label: 'Logiciel' },
      { key: 'editeur',         label: 'Éditeur' },
      { key: 'nombre_postes',   label: 'Postes' },
      { key: 'date_expiration', label: 'Expiration' },
      { key: 'cout_annuel',     label: 'Coût/an', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'statut',          label: 'Statut' },
    ]}
  />;
}

// ─── Dossiers ORIAS — Tableau de bord conformité ──────────────────────────

const STATUT_ORIAS = {
  valide:           { icon: '🟢', label: 'Valide',          bg: '#D1FAE5', color: '#059669' },
  expire_bientot:   { icon: '🟠', label: 'Expire bientôt',  bg: '#FEF3C7', color: '#D97706' },
  'expiré':         { icon: '🔴', label: 'Expiré',          bg: '#FEE2E2', color: '#DC2626' },
  manquant:         { icon: '🔴', label: 'Manquant',        bg: '#FEE2E2', color: '#DC2626' },
  en_renouvellement:{ icon: '🔵', label: 'En renouvellement',bg: '#DBEAFE', color: '#2563EB' },
};

function statutGlobalOrias(row) {
  const statuts = [row.carte_pro_statut, row.rc_pro_statut];
  if (statuts.some(s => s === 'expiré' || s === 'manquant')) return { label: 'BLOQUANT', bg: '#DC2626', color: 'white' };
  if (statuts.some(s => s === 'expire_bientot') || row.formation_dda_statut === 'expire_bientot') return { label: 'URGENT', bg: '#D97706', color: 'white' };
  if (statuts.some(s => s === 'en_renouvellement')) return { label: 'EN COURS', bg: '#2563EB', color: 'white' };
  return { label: 'CONFORME', bg: '#059669', color: 'white' };
}

function IndicateurStatut({ statut }) {
  const s = STATUT_ORIAS[statut] ?? { icon: '⚪', label: statut ?? '—', bg: '#F3F4F6', color: '#6B7280' };
  return (
    <span style={{ background: s.bg, color: s.color, padding: '2px 8px', borderRadius: '10px', fontSize: '11px', fontWeight: '600', whiteSpace: 'nowrap' }}>
      {s.icon} {s.label}
    </span>
  );
}

function DocumentsOriasTable({ couleur }) {
  const [liste, setListe]           = useState([]);
  const [chargement, setChargement] = useState(true);
  const [selection, setSelection]   = useState(null);
  const [filtre, setFiltre]         = useState('tous');
  const [form, setForm]             = useState({});
  const [editId, setEditId]         = useState(null);
  const [saving, setSaving]         = useState(false);
  const [statut, setStatut]         = useState(null);
  const [modeForm, setModeForm]     = useState(false);
  const [vue, setVue]               = useState('actifs');

  useEffect(() => { charger(); }, []);

  async function charger() {
    setChargement(true);
    const { data } = await supabase.from('documents_orias').select('*').order('salarie_nom');
    setListe(data || []);
    setChargement(false);
  }

  const ch = e => setForm({ ...form, [e.target.name]: e.target.value });

  function ouvrirEdition(row) {
    setForm({ salarie_nom: row.salarie_nom ?? '', salarie_prenom: row.salarie_prenom ?? '', poste: row.poste ?? '', agence: row.agence ?? '',
      carte_pro_numero: row.carte_pro_numero ?? '', carte_pro_date_expiration: row.carte_pro_date_expiration ?? '',
      carte_pro_organisme: row.carte_pro_organisme ?? '', carte_pro_statut: row.carte_pro_statut ?? 'manquant',
      rc_pro_assureur: row.rc_pro_assureur ?? '', rc_pro_numero_contrat: row.rc_pro_numero_contrat ?? '',
      rc_pro_montant_garantie: row.rc_pro_montant_garantie ?? '', rc_pro_date_expiration: row.rc_pro_date_expiration ?? '',
      rc_pro_statut: row.rc_pro_statut ?? 'manquant',
      formation_dda_derniere_date: row.formation_dda_derniere_date ?? '',
      formation_dda_heures: row.formation_dda_heures ?? '', formation_dda_organisme: row.formation_dda_organisme ?? '',
      formation_dda_prochaine_echeance: row.formation_dda_prochaine_echeance ?? '',
      formation_dda_statut: row.formation_dda_statut ?? 'manquant',
      commentaires: row.commentaires ?? '',
    });
    setEditId(row.id);
    setModeForm(true);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() { setForm({}); setEditId(null); setModeForm(false); setStatut(null); }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.salarie_nom?.trim()) { setStatut('erreur'); return; }
    setSaving(true);
    const payload = {
      salarie_nom: form.salarie_nom, salarie_prenom: form.salarie_prenom || null,
      poste: form.poste || null, agence: form.agence || null,
      carte_pro_numero: form.carte_pro_numero || null,
      carte_pro_date_expiration: form.carte_pro_date_expiration || null,
      carte_pro_organisme: form.carte_pro_organisme || null,
      carte_pro_statut: form.carte_pro_statut || 'manquant',
      rc_pro_assureur: form.rc_pro_assureur || null,
      rc_pro_numero_contrat: form.rc_pro_numero_contrat || null,
      rc_pro_montant_garantie: form.rc_pro_montant_garantie ? parseFloat(form.rc_pro_montant_garantie) : null,
      rc_pro_date_expiration: form.rc_pro_date_expiration || null,
      rc_pro_statut: form.rc_pro_statut || 'manquant',
      formation_dda_derniere_date: form.formation_dda_derniere_date || null,
      formation_dda_heures: form.formation_dda_heures ? parseInt(form.formation_dda_heures) : null,
      formation_dda_organisme: form.formation_dda_organisme || null,
      formation_dda_prochaine_echeance: form.formation_dda_prochaine_echeance || null,
      formation_dda_statut: form.formation_dda_statut || 'manquant',
      commentaires: form.commentaires || null,
      derniere_verification: new Date().toISOString().slice(0, 10),
      updated_at: new Date().toISOString(),
    };
    const { error } = editId
      ? await supabase.from('documents_orias').update(payload).eq('id', editId)
      : await supabase.from('documents_orias').insert([payload]);
    setSaving(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    annuler();
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  async function supprimer(id) {
    if (!window.confirm('Supprimer ce dossier ORIAS ?')) return;
    await supabase.from('documents_orias').delete().eq('id', id);
    charger();
  }

  async function archiver(id) {
    if (!window.confirm('Archiver ce dossier ORIAS ? Il sera retiré de la liste active mais conservé pour audit.')) return;
    await supabase.from('documents_orias').update({ statut_dossier: 'archivé', updated_at: new Date().toISOString() }).eq('id', id);
    charger();
  }

  const STATUTS_OPTIONS = ['valide', 'expire_bientot', 'expiré', 'manquant', 'en_renouvellement'];

  const listeVue = liste.filter(row =>
    vue === 'archives' ? row.statut_dossier === 'archivé' : row.statut_dossier !== 'archivé'
  );

  const listeFiltree = listeVue.filter(row => {
    if (filtre === 'tous') return true;
    if (filtre === 'alerte') return row.alerte_carte_pro || row.alerte_rc_pro || row.alerte_formation_dda;
    if (filtre === 'bloquant') { const sg = statutGlobalOrias(row); return sg.label === 'BLOQUANT'; }
    if (filtre === 'urgent') { const sg = statutGlobalOrias(row); return sg.label === 'URGENT'; }
    return true;
  });

  const nbAlertes   = listeVue.filter(r => r.alerte_carte_pro || r.alerte_rc_pro || r.alerte_formation_dda).length;
  const nbBloquants = listeVue.filter(r => statutGlobalOrias(r).label === 'BLOQUANT').length;
  const nbUrgents   = listeVue.filter(r => statutGlobalOrias(r).label === 'URGENT').length;

  return (
    <div>
      {/* Onglets Actifs / Archivés */}
      <div style={{ display: 'flex', gap: '8px', marginBottom: '16px' }}>
        {[{ v: 'actifs', label: '✅ Dossiers actifs' }, { v: 'archives', label: '📦 Archivés' }].map(({ v, label }) => (
          <button key={v} onClick={() => { setVue(v); setFiltre('tous'); }}
            style={{ padding: '8px 18px', border: `2px solid ${couleur}`, borderRadius: '8px',
              background: vue === v ? couleur : 'white', color: vue === v ? 'white' : couleur,
              fontWeight: '700', cursor: 'pointer', fontSize: '13px' }}>
            {label}
          </button>
        ))}
      </div>

      {/* KPI rapides */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '12px', marginBottom: '20px' }}>
        {[
          { label: 'Dossiers total',  val: listeVue.length, bg: '#EFF6FF', color: '#2563EB', filtre: 'tous' },
          { label: 'Alertes actives', val: nbAlertes,     bg: '#FFF7ED', color: '#D97706', filtre: 'alerte' },
          { label: 'Bloquants',       val: nbBloquants,   bg: '#FEF2F2', color: '#DC2626', filtre: 'bloquant' },
          { label: 'Urgents',         val: nbUrgents,     bg: '#FFFBEB', color: '#B45309', filtre: 'urgent' },
        ].map(k => (
          <button key={k.filtre} onClick={() => setFiltre(k.filtre)}
            style={{ background: filtre === k.filtre ? k.color : k.bg, border: `2px solid ${k.color}44`, borderRadius: '10px', padding: '12px', cursor: 'pointer', textAlign: 'center', transition: 'all 0.15s' }}>
            <p style={{ margin: 0, fontSize: '22px', fontWeight: '800', color: filtre === k.filtre ? 'white' : k.color }}>{k.val}</p>
            <p style={{ margin: '2px 0 0', fontSize: '11px', color: filtre === k.filtre ? 'white' : '#6B7280', fontWeight: '600' }}>{k.label}</p>
          </button>
        ))}
      </div>

      {/* Bouton nouveau + formulaire */}
      {!modeForm && (
        <div style={{ marginBottom: '16px' }}>
          <button onClick={() => setModeForm(true)} style={S.btn(couleur)}>+ Nouveau dossier ORIAS</button>
          {statut === 'ok'  && <span style={{ ...S.succes, marginLeft: '12px' }}>Ajouté !</span>}
          {statut === 'maj' && <span style={{ ...S.succes, marginLeft: '12px' }}>Mis à jour !</span>}
        </div>
      )}

      {modeForm && (
        <form onSubmit={envoyer} style={{ ...S.form, borderLeft: `4px solid ${couleur}` }}>
          <h3 style={{ marginTop: 0, color: couleur }}>{editId ? '✏️ Modifier le dossier ORIAS' : '+ Nouveau dossier ORIAS'}</h3>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
            <div style={S.champ}><label style={S.label}>Nom *</label><input name="salarie_nom" value={form.salarie_nom ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Prénom</label><input name="salarie_prenom" value={form.salarie_prenom ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Poste</label><input name="poste" value={form.poste ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Agence</label><input name="agence" value={form.agence ?? ''} onChange={ch} style={S.input} /></div>
            {/* Carte pro */}
            <div style={{ gridColumn: '1/-1' }}><p style={{ margin: '8px 0 4px', fontWeight: '700', color: '#DC2626', fontSize: '13px' }}>🪪 Carte professionnelle CPI</p></div>
            <div style={S.champ}><label style={S.label}>N° carte</label><input name="carte_pro_numero" value={form.carte_pro_numero ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Date expiration</label><input name="carte_pro_date_expiration" type="date" value={form.carte_pro_date_expiration ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Organisme</label><input name="carte_pro_organisme" value={form.carte_pro_organisme ?? ''} onChange={ch} placeholder="CCI Alsace" style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Statut</label><select name="carte_pro_statut" value={form.carte_pro_statut ?? 'manquant'} onChange={ch} style={S.input}>{STATUTS_OPTIONS.map(o => <option key={o} value={o}>{o}</option>)}</select></div>
            {/* RC Pro */}
            <div style={{ gridColumn: '1/-1' }}><p style={{ margin: '8px 0 4px', fontWeight: '700', color: '#DC2626', fontSize: '13px' }}>🛡️ RC Professionnelle</p></div>
            <div style={S.champ}><label style={S.label}>Assureur</label><input name="rc_pro_assureur" value={form.rc_pro_assureur ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>N° contrat</label><input name="rc_pro_numero_contrat" value={form.rc_pro_numero_contrat ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Date expiration</label><input name="rc_pro_date_expiration" type="date" value={form.rc_pro_date_expiration ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Statut</label><select name="rc_pro_statut" value={form.rc_pro_statut ?? 'manquant'} onChange={ch} style={S.input}>{STATUTS_OPTIONS.map(o => <option key={o} value={o}>{o}</option>)}</select></div>
            {/* Formation DDA */}
            <div style={{ gridColumn: '1/-1' }}><p style={{ margin: '8px 0 4px', fontWeight: '700', color: '#DC2626', fontSize: '13px' }}>📚 Formation DDA</p></div>
            <div style={S.champ}><label style={S.label}>Dernière formation</label><input name="formation_dda_derniere_date" type="date" value={form.formation_dda_derniere_date ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Heures validées</label><input name="formation_dda_heures" type="number" value={form.formation_dda_heures ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Organisme</label><input name="formation_dda_organisme" value={form.formation_dda_organisme ?? ''} onChange={ch} style={S.input} /></div>
            <div style={S.champ}><label style={S.label}>Prochaine échéance</label><input name="formation_dda_prochaine_echeance" type="date" value={form.formation_dda_prochaine_echeance ?? ''} onChange={ch} style={S.input} /></div>
            <div style={{ ...S.champ, gridColumn: '1/-1' }}><label style={S.label}>Commentaires</label><input name="commentaires" value={form.commentaires ?? ''} onChange={ch} style={S.input} /></div>
          </div>
          {statut === 'erreur' && <p style={S.erreur}>Le nom est obligatoire.</p>}
          <div style={{ display: 'flex', gap: '10px', marginTop: '8px' }}>
            <button type="submit" disabled={saving} style={S.btn(couleur)}>{saving ? '…' : editId ? '✏️ Mettre à jour' : '+ Ajouter'}</button>
            <button type="button" onClick={annuler} style={S.btn('#6B7280')}>Annuler</button>
          </div>
        </form>
      )}

      {/* Tableau principal */}
      {chargement ? <p style={{ color: '#9CA3AF' }}>Chargement…</p> : (
        <>
          <p style={{ color: '#6B7280', fontSize: '13px', marginBottom: '10px' }}>{listeFiltree.length} dossier(s)</p>
          {listeFiltree.length > 0 && (
            <div style={{ overflowX: 'auto' }}>
              <table style={S.table}>
                <thead>
                  <tr>
                    {['Salarié', 'Poste / Agence', 'Carte pro CPI', 'RC Professionnelle', 'Formation DDA', 'Statut global', 'Actions'].map(h => (
                      <th key={h} style={S.th(couleur)}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {listeFiltree.map((row, i) => {
                    const sg = statutGlobalOrias(row);
                    const isSelected = selection?.id === row.id;
                    return (
                      <>
                        <tr key={row.id}
                          style={{ background: isSelected ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white', cursor: 'pointer' }}
                          onClick={() => setSelection(isSelected ? null : row)}
                        >
                          <td style={S.td}><strong>{row.salarie_prenom} {row.salarie_nom}</strong></td>
                          <td style={S.td}><span style={{ fontSize: '12px' }}>{row.poste ?? '—'}<br /><span style={{ color: '#6B7280' }}>{row.agence ?? ''}</span></span></td>
                          <td style={S.td}>
                            <IndicateurStatut statut={row.carte_pro_statut} />
                            {row.carte_pro_date_expiration && <><br /><span style={{ fontSize: '11px', color: '#6B7280' }}>{row.carte_pro_date_expiration}</span></>}
                          </td>
                          <td style={S.td}>
                            <IndicateurStatut statut={row.rc_pro_statut} />
                            {row.rc_pro_date_expiration && <><br /><span style={{ fontSize: '11px', color: '#6B7280' }}>{row.rc_pro_date_expiration}</span></>}
                          </td>
                          <td style={S.td}>
                            <IndicateurStatut statut={row.formation_dda_statut} />
                            {row.formation_dda_prochaine_echeance && <><br /><span style={{ fontSize: '11px', color: '#6B7280' }}>Prochaine : {row.formation_dda_prochaine_echeance}</span></>}
                          </td>
                          <td style={S.td}>
                            <span style={{ background: sg.bg, color: sg.color, padding: '3px 10px', borderRadius: '10px', fontSize: '12px', fontWeight: '700' }}>{sg.label}</span>
                          </td>
                          <td style={{ ...S.td, whiteSpace: 'nowrap' }}>
                            <button onClick={ev => { ev.stopPropagation(); ouvrirEdition(row); }} style={S.btnEdit} title="Modifier">✏️</button>
                            {vue !== 'archives' && <button onClick={ev => { ev.stopPropagation(); archiver(row.id); }} style={{ ...S.btnEdit, background: '#FEF9C3', color: '#92400E' }} title="Archiver">📦</button>}
                            <button onClick={ev => { ev.stopPropagation(); supprimer(row.id); }} style={S.btnDel} title="Supprimer">🗑️</button>
                          </td>
                        </tr>
                        {isSelected && (
                          <tr key={`${row.id}-detail`}>
                            <td colSpan={7} style={{ background: '#F0F9FF', padding: '16px 20px', borderBottom: `2px solid ${couleur}` }}>
                              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '16px', fontSize: '13px' }}>
                                <div>
                                  <p style={{ margin: '0 0 8px', fontWeight: '700', color: '#DC2626' }}>🪪 Carte pro CPI</p>
                                  <p style={{ margin: '2px 0' }}>N° : {row.carte_pro_numero ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Organisme : {row.carte_pro_organisme ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Expiration : {row.carte_pro_date_expiration ?? '—'}</p>
                                </div>
                                <div>
                                  <p style={{ margin: '0 0 8px', fontWeight: '700', color: '#DC2626' }}>🛡️ RC Professionnelle</p>
                                  <p style={{ margin: '2px 0' }}>Assureur : {row.rc_pro_assureur ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>N° : {row.rc_pro_numero_contrat ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Garantie : {row.rc_pro_montant_garantie ? `${Number(row.rc_pro_montant_garantie).toLocaleString('fr-FR')} €` : '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Expiration : {row.rc_pro_date_expiration ?? '—'}</p>
                                </div>
                                <div>
                                  <p style={{ margin: '0 0 8px', fontWeight: '700', color: '#DC2626' }}>📚 Formation DDA</p>
                                  <p style={{ margin: '2px 0' }}>Dernière : {row.formation_dda_derniere_date ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Heures : {row.formation_dda_heures ?? '—'}h</p>
                                  <p style={{ margin: '2px 0' }}>Organisme : {row.formation_dda_organisme ?? '—'}</p>
                                  <p style={{ margin: '2px 0' }}>Prochaine : <strong>{row.formation_dda_prochaine_echeance ?? '—'}</strong></p>
                                </div>
                              </div>
                              {row.commentaires && (
                                <p style={{ margin: '12px 0 0', padding: '10px', background: '#FEF3C7', borderRadius: '6px', fontSize: '13px', color: '#92400E' }}>
                                  💬 {row.commentaires}
                                </p>
                              )}
                            </td>
                          </tr>
                        )}
                      </>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
          {listeFiltree.length === 0 && <p style={S.vide}>Aucun dossier pour ce filtre.</p>}
        </>
      )}
    </div>
  );
}

// ─── Progression élèves (vue professeur) ──────────────────────────────────

function ProgressionElevesTable({ couleur }) {
  const [liste, setListe]           = useState([]);
  const [chargement, setChargement] = useState(true);
  const [filtreEleve, setFiltreEleve] = useState('');
  const [saving, setSaving]         = useState(false);

  useEffect(() => { charger(); }, []);

  async function charger() {
    setChargement(true);
    const { data } = await supabase
      .from('progression_eleves')
      .select('*, missions(titre, profil_code)')
      .order('eleve_nom');
    setListe(data || []);
    setChargement(false);
  }

  async function mettreAJourNote(id, note) {
    await supabase.from('progression_eleves').update({ note_prof: note ? parseInt(note) : null, updated_at: new Date().toISOString() }).eq('id', id);
    charger();
  }

  async function mettreAJourCommentaire(id, commentaire) {
    await supabase.from('progression_eleves').update({ commentaire_prof: commentaire, updated_at: new Date().toISOString() }).eq('id', id);
    charger();
  }

  const eleves = [...new Set(liste.map(r => r.eleve_nom))].sort();
  const listeFiltree = filtreEleve ? liste.filter(r => r.eleve_nom === filtreEleve) : liste;

  const STATUT_PROG = {
    non_commence: { label: 'Non commencé', bg: '#F3F4F6', color: '#6B7280' },
    en_cours:     { label: 'En cours',      bg: '#DBEAFE', color: '#2563EB' },
    termine:      { label: 'Terminé',       bg: '#D1FAE5', color: '#059669' },
    valide:       { label: 'Validé ✅',     bg: '#A7F3D0', color: '#065F46' },
  };

  return (
    <div>
      <div style={{ display: 'flex', gap: '10px', alignItems: 'center', marginBottom: '16px', flexWrap: 'wrap' }}>
        <select value={filtreEleve} onChange={e => setFiltreEleve(e.target.value)} style={{ ...S.input, maxWidth: '300px' }}>
          <option value="">— Tous les élèves ({eleves.length}) —</option>
          {eleves.map(e => <option key={e} value={e}>{e}</option>)}
        </select>
        <span style={{ color: '#6B7280', fontSize: '13px' }}>{listeFiltree.length} entrée(s)</span>
      </div>

      {chargement ? <p style={{ color: '#9CA3AF' }}>Chargement…</p> : (
        <div style={{ overflowX: 'auto' }}>
          <table style={S.table}>
            <thead>
              <tr>
                {['Élève', 'Mission', 'Statut', 'Indice consulté', 'Correction consultée', 'Temps (min)', 'Note /20', 'Commentaire prof'].map(h => (
                  <th key={h} style={S.th(couleur)}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {listeFiltree.map((row, i) => {
                const sp = STATUT_PROG[row.statut] ?? STATUT_PROG.non_commence;
                return (
                  <tr key={row.id} style={{ background: i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                    <td style={S.td}><strong>{row.eleve_nom}</strong></td>
                    <td style={S.td}><span style={{ fontSize: '12px' }}>{row.missions?.titre ?? `Mission #${row.mission_id}`}</span></td>
                    <td style={S.td}><span style={{ background: sp.bg, color: sp.color, padding: '2px 8px', borderRadius: '10px', fontSize: '11px', fontWeight: '600' }}>{sp.label}</span></td>
                    <td style={{ ...S.td, textAlign: 'center' }}>{row.a_consulte_indice ? '💡 Oui' : '—'}</td>
                    <td style={{ ...S.td, textAlign: 'center' }}>{row.a_consulte_correction ? '📖 Oui' : '—'}</td>
                    <td style={{ ...S.td, textAlign: 'center' }}>{row.temps_passe_minutes ?? '—'}</td>
                    <td style={S.td}>
                      <input type="number" min="0" max="20" defaultValue={row.note_prof ?? ''}
                        onBlur={e => mettreAJourNote(row.id, e.target.value)}
                        style={{ width: '60px', padding: '3px 6px', border: '1px solid #CBD5E1', borderRadius: '4px', fontSize: '13px' }}
                      />
                    </td>
                    <td style={S.td}>
                      <input type="text" defaultValue={row.commentaire_prof ?? ''}
                        onBlur={e => mettreAJourCommentaire(row.id, e.target.value)}
                        placeholder="Ajouter un commentaire…"
                        style={{ width: '180px', padding: '3px 6px', border: '1px solid #CBD5E1', borderRadius: '4px', fontSize: '12px' }}
                      />
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
          {listeFiltree.length === 0 && <p style={S.vide}>Aucune progression enregistrée.</p>}
        </div>
      )}
    </div>
  );
}

// ─── Fournisseurs & Partenaires ────────────────────────────────────────────

const TYPES_FOURN = ['portail_annonces', 'courtier_credit', 'assurance', 'promoteur', 'diagnostiqueur', 'apporteur_affaires'];
const ICONES_TYPE = { portail_annonces: '🌐', courtier_credit: '🏦', assurance: '🛡️', promoteur: '🏗️', diagnostiqueur: '🔬', apporteur_affaires: '🤝' };

function FournisseursTable({ couleur }) {
  const { liste, chargement, charger, supprimer } = useListe('fournisseurs_partenaires');
  const [form, setForm] = useState({ code_fournisseur: '', nom: '', type: '', contact_nom: '', contact_email: '', contact_telephone: '', site_web: '', commission_taux: '', contrat_debut: '', contrat_fin: '', statut: 'actif' });
  const [editId, setEditId] = useState(null);
  const [saving, setSaving] = useState(false);
  const [statut, setStatut] = useState(null);
  const [filtre, setFiltre] = useState('');

  function ch(e) { setForm({ ...form, [e.target.name]: e.target.value }); }

  function modifier(row) {
    setForm({ code_fournisseur: row.code_fournisseur ?? '', nom: row.nom ?? '', type: row.type ?? '', contact_nom: row.contact_nom ?? '', contact_email: row.contact_email ?? '', contact_telephone: row.contact_telephone ?? '', site_web: row.site_web ?? '', commission_taux: row.commission_taux ?? '', contrat_debut: row.contrat_debut ?? '', contrat_fin: row.contrat_fin ?? '', statut: row.statut ?? 'actif' });
    setEditId(row.id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function annuler() { setForm({ code_fournisseur: '', nom: '', type: '', contact_nom: '', contact_email: '', contact_telephone: '', site_web: '', commission_taux: '', contrat_debut: '', contrat_fin: '', statut: 'actif' }); setEditId(null); setStatut(null); }

  async function envoyer(e) {
    e.preventDefault();
    if (!form.nom.trim()) { setStatut('erreur'); return; }
    setSaving(true);
    const payload = { code_fournisseur: form.code_fournisseur || null, nom: form.nom, type: form.type || null, contact_nom: form.contact_nom || null, contact_email: form.contact_email || null, contact_telephone: form.contact_telephone || null, site_web: form.site_web || null, commission_taux: form.commission_taux ? parseFloat(form.commission_taux) : null, contrat_debut: form.contrat_debut || null, contrat_fin: form.contrat_fin || null, statut: form.statut };
    const { error } = editId ? await supabase.from('fournisseurs_partenaires').update(payload).eq('id', editId) : await supabase.from('fournisseurs_partenaires').insert([payload]);
    setSaving(false);
    if (error) { setStatut('erreur'); return; }
    setStatut(editId ? 'maj' : 'ok');
    annuler();
    charger();
    setTimeout(() => setStatut(null), 3000);
  }

  const listeFiltree = filtre ? liste.filter(f => f.type === filtre) : liste;

  return (
    <div>
      <form onSubmit={envoyer} style={{ ...S.form, borderLeft: editId ? `4px solid ${couleur}` : 'none' }}>
        <h3 style={{ marginTop: 0, color: couleur }}>{editId ? '✏️ Modifier' : '+ Nouveau partenaire'}</h3>
        <div style={S.rangee}>
          <div style={S.champ}><label style={S.label}>Nom *</label><input name="nom" value={form.nom} onChange={ch} style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Code</label><input name="code_fournisseur" value={form.code_fournisseur} onChange={ch} placeholder="PORTAIL-001" style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Type</label><select name="type" value={form.type} onChange={ch} style={S.input}><option value="">— Choisir —</option>{TYPES_FOURN.map(t => <option key={t} value={t}>{ICONES_TYPE[t]} {t.replace(/_/g, ' ')}</option>)}</select></div>
          <div style={S.champ}><label style={S.label}>Statut</label><select name="statut" value={form.statut} onChange={ch} style={S.input}><option value="actif">actif</option><option value="suspendu">suspendu</option><option value="inactif">inactif</option></select></div>
          <div style={S.champ}><label style={S.label}>Contact</label><input name="contact_nom" value={form.contact_nom} onChange={ch} placeholder="Prénom Nom" style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Email</label><input name="contact_email" type="email" value={form.contact_email} onChange={ch} style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Téléphone</label><input name="contact_telephone" value={form.contact_telephone} onChange={ch} style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Commission (%)</label><input name="commission_taux" type="number" step="0.01" value={form.commission_taux} onChange={ch} style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Contrat début</label><input name="contrat_debut" type="date" value={form.contrat_debut} onChange={ch} style={S.input} /></div>
          <div style={S.champ}><label style={S.label}>Contrat fin</label><input name="contrat_fin" type="date" value={form.contrat_fin} onChange={ch} style={S.input} /></div>
        </div>
        {statut === 'erreur' && <p style={S.erreur}>Le nom est obligatoire.</p>}
        {statut === 'ok'    && <p style={S.succes}>Partenaire ajouté !</p>}
        {statut === 'maj'   && <p style={S.succes}>Mis à jour !</p>}
        <div style={{ display: 'flex', gap: '10px', marginTop: '4px' }}>
          <button type="submit" disabled={saving} style={S.btn(couleur)}>{saving ? '…' : editId ? '✏️ Mettre à jour' : '+ Ajouter'}</button>
          {editId && <button type="button" onClick={annuler} style={S.btn('#6B7280')}>Annuler</button>}
        </div>
      </form>

      {/* Filtres par type */}
      <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap', marginBottom: '14px' }}>
        <button onClick={() => setFiltre('')} style={{ ...S.btn(filtre === '' ? couleur : '#E5E7EB', filtre === '' ? 'white' : '#374151'), fontSize: '12px', padding: '4px 10px' }}>Tous ({liste.length})</button>
        {TYPES_FOURN.map(t => { const n = liste.filter(f => f.type === t).length; if (!n) return null; return <button key={t} onClick={() => setFiltre(t)} style={{ ...S.btn(filtre === t ? couleur : '#E5E7EB', filtre === t ? 'white' : '#374151'), fontSize: '12px', padding: '4px 10px' }}>{ICONES_TYPE[t]} {t.replace(/_/g, ' ')} ({n})</button>; })}
      </div>

      <p style={{ color: '#6B7280', fontSize: '13px' }}>{chargement ? 'Chargement…' : `${listeFiltree.length} partenaire(s)`}</p>
      {listeFiltree.length > 0 && (
        <div style={{ overflowX: 'auto' }}>
          <table style={S.table}>
            <thead><tr>
              {['Type', 'Nom', 'Contact', 'Commission', 'Contrat fin', 'Statut', 'Actions'].map(h => <th key={h} style={S.th(couleur)}>{h}</th>)}
            </tr></thead>
            <tbody>
              {listeFiltree.map((row, i) => (
                <tr key={row.id} style={{ background: editId === row.id ? '#FEF3C7' : i % 2 === 0 ? '#F9FAFB' : 'white' }}>
                  <td style={S.td}>{ICONES_TYPE[row.type] ?? ''} <span style={{ fontSize: '11px', color: '#6B7280' }}>{row.type?.replace(/_/g, ' ') ?? '—'}</span></td>
                  <td style={S.td}><strong>{row.nom}</strong>{row.site_web && <><br /><a href={row.site_web} target="_blank" rel="noreferrer" style={{ fontSize: '11px', color: '#0A66C2' }}>🔗 Site web</a></>}</td>
                  <td style={S.td}>{row.contact_nom ?? '—'}{row.contact_email && <><br /><span style={{ fontSize: '11px', color: '#6B7280' }}>{row.contact_email}</span></>}</td>
                  <td style={S.td}>{row.commission_taux != null ? `${row.commission_taux} %` : '—'}</td>
                  <td style={S.td}>{row.contrat_fin ?? '—'}</td>
                  <td style={S.td}><span style={{ background: row.statut === 'actif' ? '#D1FAE5' : '#FEE2E2', color: row.statut === 'actif' ? '#059669' : '#DC2626', padding: '2px 8px', borderRadius: '10px', fontSize: '12px', fontWeight: '600' }}>{row.statut}</span></td>
                  <td style={{ ...S.td, whiteSpace: 'nowrap' }}>
                    <button onClick={() => modifier(row)} style={S.btnEdit} title="Modifier">✏️</button>
                    <button onClick={() => supprimer(row.id)} style={S.btnDel} title="Supprimer">🗑️</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      {!chargement && liste.length === 0 && <p style={S.vide}>Aucun partenaire pour l'instant.</p>}
    </div>
  );
}

function EvaluationsTable({ couleur }) {
  return <TableGeneric
    table="evaluations_fournisseurs" couleur={couleur}
    champs={[
      { name: 'fournisseur_nom', label: 'Partenaire', required: true },
      { name: 'date_evaluation', label: 'Date évaluation', type: 'date' },
      { name: 'note_qualite',    label: 'Note qualité (1-5)', type: 'number' },
      { name: 'note_delais',     label: 'Note délais (1-5)',  type: 'number' },
      { name: 'note_prix',       label: 'Note prix (1-5)',    type: 'number' },
      { name: 'commentaire',     label: 'Commentaire' },
      { name: 'evaluateur',      label: 'Évaluateur' },
    ]}
    colonnes={[
      { key: 'fournisseur_nom', label: 'Partenaire' },
      { key: 'date_evaluation', label: 'Date' },
      { key: 'note_qualite', label: 'Qualité', render: v => v ? '⭐'.repeat(Math.min(v, 5)) : '—' },
      { key: 'note_delais',  label: 'Délais',  render: v => v ? '⭐'.repeat(Math.min(v, 5)) : '—' },
      { key: 'note_prix',    label: 'Prix',    render: v => v ? '⭐'.repeat(Math.min(v, 5)) : '—' },
      { key: 'commentaire',  label: 'Commentaire', render: v => v ? (v.length > 60 ? v.slice(0, 60) + '…' : v) : '—' },
      { key: 'evaluateur',   label: 'Évaluateur' },
    ]}
  />;
}

function HistoriqueFournTable({ couleur }) {
  return <TableGeneric
    table="historique_fournisseurs" couleur={couleur}
    champs={[
      { name: 'fournisseur_nom', label: 'Partenaire', required: true },
      { name: 'type_operation',  label: 'Type opération', options: ['abonnement', 'commission', 'mise_en_relation', 'diagnostics', 'renouvellement', 'autre'] },
      { name: 'montant',         label: 'Montant (€)', type: 'number' },
      { name: 'date_operation',  label: 'Date', type: 'date' },
      { name: 'description',     label: 'Description' },
      { name: 'statut',          label: 'Statut', options: ['réalisé', 'en cours', 'annulé'] },
    ]}
    colonnes={[
      { key: 'fournisseur_nom', label: 'Partenaire' },
      { key: 'type_operation',  label: 'Type' },
      { key: 'montant',         label: 'Montant', render: v => v ? `${Number(v).toLocaleString('fr-FR')} €` : '—' },
      { key: 'date_operation',  label: 'Date' },
      { key: 'description',     label: 'Description', render: v => v ? (v.length > 50 ? v.slice(0, 50) + '…' : v) : '—' },
      { key: 'statut',          label: 'Statut' },
    ]}
  />;
}

// ─── Mapping composant → rendu ─────────────────────────────────────────────
function renderSousOnglet(composant, couleur) {
  switch (composant) {
    case 'ClientForm':      return <ClientForm />;
    case 'BienForm':        return <BienForm />;
    case 'SalarieForm':     return <SalarieForm />;
    case 'ProspectForm':    return <ProspectForm />;
    case 'MandatForm':      return <MandatForm />;
    case 'CongesTable':     return <CongesTable couleur={couleur} />;
    case 'FormationsTable': return <FormationsTable couleur={couleur} />;
    case 'FormationsDDA':   return <FormationsTable couleur={couleur} filtreDDA={true} />;
    case 'DocsRHTable':     return <DocsRHTable couleur={couleur} />;
    case 'CartesTable':     return <CartesTable couleur={couleur} />;
    case 'AssurancesTable': return <AssurancesTable couleur={couleur} />;
    case 'CampagnesTable':  return <CampagnesTable couleur={couleur} />;
    case 'PostsTable':      return <PostsTable couleur={couleur} />;
    case 'TemplatesTable':  return <TemplatesTable couleur={couleur} />;
    case 'FactFournTable':  return <FactFournTable couleur={couleur} />;
    case 'FactCliTable':    return <FactCliTable couleur={couleur} />;
    case 'EcrituresTable':  return <EcrituresTable couleur={couleur} />;
    case 'DossiersTable':   return <DossiersTable couleur={couleur} />;
    case 'VisitesTable':    return <VisitesTable couleur={couleur} />;
    case 'OffresTable':     return <OffresTable couleur={couleur} />;
    case 'VentesTable':     return <VentesTable couleur={couleur} />;
    case 'TicketsTable':    return <TicketsTable couleur={couleur} />;
    case 'MaterielTable':        return <MaterielTable couleur={couleur} />;
    case 'LicencesTable':        return <LicencesTable couleur={couleur} />;
    case 'ReseauxSociaux':       return <ReseauxSociaux couleur={couleur} />;
    case 'SimulateurCredit':     return <SimulateurCredit couleur={couleur} />;
    case 'FournisseursTable':    return <FournisseursTable couleur={couleur} />;
    case 'EvaluationsTable':     return <EvaluationsTable couleur={couleur} />;
    case 'HistoriqueFournTable':    return <HistoriqueFournTable couleur={couleur} />;
    case 'DocumentsOriasTable':    return <DocumentsOriasTable couleur={couleur} />;
    case 'ProgressionElevesTable': return <ProgressionElevesTable couleur={couleur} />;
    default: return <p style={{ color: '#9CA3AF' }}>Composant "{composant}" non trouvé.</p>;
  }
}

// ─── Composant principal ERPServices ──────────────────────────────────────
export default function ERPServices({ onRetour }) {
  const [serviceActif, setServiceActif]     = useState(SERVICES[0].id);
  const [sousOngletActif, setSousOngletActif] = useState(SERVICES[0].sousOnglets[0].id);

  const service     = SERVICES.find(s => s.id === serviceActif);
  const sousOnglet  = service.sousOnglets.find(o => o.id === sousOngletActif)
                   ?? service.sousOnglets[0];

  function changerService(id) {
    const svc = SERVICES.find(s => s.id === id);
    setServiceActif(id);
    setSousOngletActif(svc.sousOnglets[0].id);
  }

  return (
    <div style={{ minHeight: '100vh', background: '#F8FAFC' }}>
      {/* En-tête */}
      <div style={{ background: '#1E3A8A', color: 'white', padding: '18px 28px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <h1 style={{ margin: 0, fontSize: '20px' }}>🗂️ ERP — La Belle Agence</h1>
          <p style={{ margin: '3px 0 0', opacity: 0.75, fontSize: '13px' }}>Gestion par services professionnels</p>
        </div>
        {onRetour && (
          <button onClick={onRetour} style={{ padding: '9px 18px', background: 'rgba(255,255,255,0.15)', color: 'white', border: '1px solid rgba(255,255,255,0.4)', borderRadius: '8px', cursor: 'pointer', fontSize: '14px' }}>
            ← Retour à l'app
          </button>
        )}
      </div>

      {/* Onglets niveau 1 — Services */}
      <div style={{ display: 'flex', flexWrap: 'wrap', borderBottom: '2px solid #E5E7EB', background: 'white', paddingLeft: '16px' }}>
        {SERVICES.map(svc => (
          <button
            key={svc.id}
            onClick={() => changerService(svc.id)}
            style={{
              padding: '13px 18px',
              border: 'none',
              borderBottom: serviceActif === svc.id ? `3px solid ${svc.couleur}` : '3px solid transparent',
              background: 'none',
              cursor: 'pointer',
              fontSize: '14px',
              fontWeight: serviceActif === svc.id ? '700' : '400',
              color: serviceActif === svc.id ? svc.couleur : '#6B7280',
              transition: 'all 0.12s',
              marginBottom: '-2px',
              whiteSpace: 'nowrap',
            }}
          >
            {svc.label}
          </button>
        ))}
      </div>

      {/* Onglets niveau 2 — Sous-onglets du service actif */}
      <div style={{ display: 'flex', flexWrap: 'wrap', borderBottom: '1px solid #E5E7EB', background: '#F1F5F9', paddingLeft: '24px' }}>
        {service.sousOnglets.map(so => (
          <button
            key={so.id}
            onClick={() => setSousOngletActif(so.id)}
            style={{
              padding: '9px 16px',
              border: 'none',
              borderBottom: sousOngletActif === so.id ? `2px solid ${service.couleur}` : '2px solid transparent',
              background: 'none',
              cursor: 'pointer',
              fontSize: '13px',
              fontWeight: sousOngletActif === so.id ? '700' : '400',
              color: sousOngletActif === so.id ? service.couleur : '#6B7280',
              marginBottom: '-1px',
              whiteSpace: 'nowrap',
            }}
          >
            {so.label}
          </button>
        ))}
      </div>

      {/* Contenu du sous-onglet */}
      <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '28px 24px' }}>
        <div style={{ borderLeft: `4px solid ${service.couleur}`, paddingLeft: '14px', marginBottom: '24px' }}>
          <h2 style={{ margin: 0, color: service.couleur }}>{sousOnglet.label}</h2>
          <p style={{ margin: '3px 0 0', color: '#6B7280', fontSize: '13px' }}>
            Service {service.id} — Table : <code>{sousOnglet.table}</code>
          </p>
        </div>
        {renderSousOnglet(sousOnglet.composant, service.couleur)}
      </div>
    </div>
  );
}

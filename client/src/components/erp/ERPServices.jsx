import { useState, useEffect } from 'react';
import { supabase } from '../../supabaseClient';
import ClientForm   from './ClientForm';
import BienForm     from './BienForm';
import SalarieForm  from './SalarieForm';
import ProspectForm from './ProspectForm';
import MandatForm   from './MandatForm';

// ─── Couleurs par service ───────────────────────────────────────────────────
const COULEURS = {
  RH:         '#D97706',
  Marketing:  '#7C3AED',
  Conformité: '#DC2626',
  Finance:    '#059669',
  Patrimoine: '#0891B2',
  Commercial: '#1E3A8A',
  IT:         '#374151',
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
      { id: 'campagnes',   label: '📣 Campagnes',     table: 'campagnes_marketing', composant: 'CampagnesTable' },
      { id: 'posts',       label: '📱 Posts',          table: 'posts_sociaux',       composant: 'PostsTable' },
      { id: 'templates',   label: '📝 Templates',      table: 'templates_documents', composant: 'TemplatesTable' },
    ],
  },
  {
    id: 'Conformité', label: '⚖️ Conformité', couleur: COULEURS.Conformité,
    sousOnglets: [
      { id: 'cartes',      label: '🪪 Cartes pro',     table: 'cartes_professionnelles', composant: 'CartesTable' },
      { id: 'assurances',  label: '🛡️ Assurances RC',  table: 'assurances_rc',           composant: 'AssurancesTable' },
      { id: 'forma_dda',   label: '📚 Formations DDA', table: 'formations',              composant: 'FormationsDDA' },
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
      { id: 'biens',       label: '🏠 Biens',            table: 'biens',    composant: 'BienForm' },
      { id: 'mandats',     label: '📋 Mandats',           table: 'mandats',  composant: 'MandatForm' },
      { id: 'visites',     label: '👁️ Visites',           table: 'visites',  composant: 'VisitesTable' },
      { id: 'offres',      label: '💬 Offres',            table: 'offres',   composant: 'OffresTable' },
      { id: 'ventes',      label: '✅ Ventes',             table: 'ventes',   composant: 'VentesTable' },
    ],
  },
  {
    id: 'IT', label: '🛠️ IT', couleur: COULEURS.IT,
    sousOnglets: [
      { id: 'tickets',     label: '🎫 Tickets',           table: 'tickets_support',       composant: 'TicketsTable' },
      { id: 'materiel',    label: '💻 Matériel',           table: 'materiel_informatique', composant: 'MaterielTable' },
      { id: 'licences',    label: '🔑 Licences',           table: 'licences_logiciels',    composant: 'LicencesTable' },
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
              {c.options ? (
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
      { name: 'salarie_nom', label: 'Salarié', required: true, placeholder: 'Dupont Marie' },
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
      { name: 'salarie_nom',    label: 'Salarié', required: true },
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
    ]}
  />;
}

function DocsRHTable({ couleur }) {
  return <TableGeneric
    table="documents_rh" couleur={couleur}
    champs={[
      { name: 'salarie_nom',    label: 'Salarié', required: true },
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
      { name: 'salarie_nom',         label: 'Salarié', required: true },
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
    case 'MaterielTable':   return <MaterielTable couleur={couleur} />;
    case 'LicencesTable':   return <LicencesTable couleur={couleur} />;
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

import { useAuth } from '../../context/AuthContext.jsx'
import { useWorkflow } from '../../hooks/useWorkflow.js'
import { getRoleLabel } from '../../utils/permissions.js'
import { getStatusLabel, getStatusColor, getTypeLabel, formatDate } from '../../utils/formatters.js'
import Badge from '../../components/ui/Badge.jsx'

function StatCard({ label, value, color = 'var(--color-primary)' }) {
  return (
    <div style={{
      background: 'var(--color-surface)',
      border: '1px solid var(--color-border)',
      borderRadius: '8px',
      padding: '20px',
      boxShadow: 'var(--shadow)',
    }}>
      <div style={{ fontSize: '2rem', fontWeight: 700, color }}>{value}</div>
      <div style={{ fontSize: '0.875rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>{label}</div>
    </div>
  )
}

export default function DashboardPage() {
  const { profile } = useAuth()
  const { data: requests, loading } = useWorkflow('BUDGET', { limit: 5 })

  const pending = requests.filter((r) => r.status === 'PENDING_APPROVAL').length
  const approved = requests.filter((r) => r.status === 'APPROVED').length

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '4px' }}>
        Bonjour, {profile?.first_name}
      </h1>
      <p style={{ color: 'var(--color-text-muted)', marginBottom: '32px', fontSize: '0.875rem' }}>
        {getRoleLabel(profile?.roles?.code)} · {profile?.agencies?.name}
      </p>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(160px, 1fr))', gap: '16px', marginBottom: '32px' }}>
        <StatCard label="En attente" value={pending} color="var(--color-warning)" />
        <StatCard label="Approuvées" value={approved} color="var(--color-success)" />
        <StatCard label="Total" value={requests.length} />
      </div>

      <div style={{ background: 'var(--color-surface)', border: '1px solid var(--color-border)', borderRadius: '8px', boxShadow: 'var(--shadow)' }}>
        <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--color-border)', fontWeight: 600 }}>
          Dernières demandes
        </div>
        {loading ? (
          <div style={{ padding: '32px', textAlign: 'center', color: 'var(--color-text-muted)' }}>Chargement...</div>
        ) : requests.length === 0 ? (
          <div style={{ padding: '32px', textAlign: 'center', color: 'var(--color-text-muted)' }}>Aucune demande</div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', borderBottom: '1px solid var(--color-border)' }}>
                <th style={{ padding: '10px 20px', textAlign: 'left' }}>Type</th>
                <th style={{ padding: '10px 20px', textAlign: 'left' }}>Titre</th>
                <th style={{ padding: '10px 20px', textAlign: 'left' }}>Statut</th>
                <th style={{ padding: '10px 20px', textAlign: 'left' }}>Date</th>
              </tr>
            </thead>
            <tbody>
              {requests.map((r) => (
                <tr key={r.id} style={{ borderBottom: '1px solid var(--color-border)', fontSize: '0.875rem' }}>
                  <td style={{ padding: '12px 20px' }}>{getTypeLabel(r.type)}</td>
                  <td style={{ padding: '12px 20px' }}>{r.title}</td>
                  <td style={{ padding: '12px 20px' }}>
                    <Badge label={getStatusLabel(r.status)} color={getStatusColor(r.status)} />
                  </td>
                  <td style={{ padding: '12px 20px', color: 'var(--color-text-muted)' }}>{formatDate(r.created_at)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}

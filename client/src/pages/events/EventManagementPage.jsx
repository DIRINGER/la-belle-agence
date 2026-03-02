import { useWorkflow } from '../../hooks/useWorkflow.js'
import { formatDate, formatCurrency, getStatusLabel, getStatusColor } from '../../utils/formatters.js'
import Badge from '../../components/ui/Badge.jsx'
import WorkflowStatus from '../../components/workflows/WorkflowStatus.jsx'

export default function EventManagementPage() {
  const { data: events, loading } = useWorkflow('EVENT')

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Événements</h1>

      {loading ? (
        <p>Chargement...</p>
      ) : events.length === 0 ? (
        <p style={{ color: 'var(--color-text-muted)' }}>Aucun événement.</p>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: '16px' }}>
          {events.map((e) => (
            <div key={e.id} style={{
              background: 'var(--color-surface)',
              border: '1px solid var(--color-border)',
              borderRadius: '8px',
              padding: '16px',
              boxShadow: 'var(--shadow)',
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                <div style={{ fontWeight: 600 }}>{e.data?.event_name}</div>
                <Badge label={getStatusLabel(e.status)} color={getStatusColor(e.status)} />
              </div>
              <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '12px' }}>
                <div>Date : {e.data?.event_date ? formatDate(e.data.event_date) : '-'}</div>
                <div>Lieu : {e.data?.location}</div>
                <div>Budget : {e.data?.estimated_budget ? formatCurrency(e.data.estimated_budget) : '-'}</div>
                <div>Participants : {e.data?.expected_attendees || '-'}</div>
              </div>
              <WorkflowStatus status={e.status} approvals={e.workflow_approvals} />
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

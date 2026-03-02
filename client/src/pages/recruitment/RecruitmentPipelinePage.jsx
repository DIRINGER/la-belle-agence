import { useWorkflow } from '../../hooks/useWorkflow.js'
import { getStatusLabel, getStatusColor, formatDate } from '../../utils/formatters.js'
import Badge from '../../components/ui/Badge.jsx'
import WorkflowStatus from '../../components/workflows/WorkflowStatus.jsx'

export default function RecruitmentPipelinePage() {
  const { data: requests, loading } = useWorkflow('RECRUITMENT')

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Pipeline de recrutement</h1>

      {loading ? (
        <p>Chargement...</p>
      ) : requests.length === 0 ? (
        <p style={{ color: 'var(--color-text-muted)' }}>Aucune demande de recrutement.</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {requests.map((r) => (
            <div key={r.id} style={{
              background: 'var(--color-surface)',
              border: '1px solid var(--color-border)',
              borderRadius: '8px',
              padding: '16px 20px',
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <div>
                  <div style={{ fontWeight: 600, marginBottom: '4px' }}>{r.data?.position_title}</div>
                  <div style={{ fontSize: '0.875rem', color: 'var(--color-text-muted)', marginBottom: '8px' }}>
                    {r.data?.contract_type} · {r.agencies?.name} · Soumis le {formatDate(r.created_at)}
                  </div>
                  <WorkflowStatus status={r.status} approvals={r.workflow_approvals} />
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

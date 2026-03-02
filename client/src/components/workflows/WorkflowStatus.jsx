import Badge from '../ui/Badge.jsx'
import { getStatusLabel, getStatusColor } from '../../utils/formatters.js'

export default function WorkflowStatus({ status, approvals = [] }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      <Badge label={getStatusLabel(status)} color={getStatusColor(status)} />
      {approvals.length > 0 && (
        <ol style={{ paddingLeft: '16px', fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
          {approvals
            .sort((a, b) => a.step_order - b.step_order)
            .map((step) => (
              <li key={step.id} style={{ marginBottom: '4px' }}>
                <span>{step.step_name}</span>
                {' — '}
                <Badge
                  label={step.status === 'PENDING' ? 'En attente' : step.status === 'APPROVED' ? 'Validé' : 'Rejeté'}
                  color={step.status === 'APPROVED' ? 'green' : step.status === 'REJECTED' ? 'red' : 'gray'}
                />
              </li>
            ))}
        </ol>
      )}
    </div>
  )
}

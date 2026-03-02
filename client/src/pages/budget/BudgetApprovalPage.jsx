import { useState } from 'react'
import { useAuth } from '../../context/AuthContext.jsx'
import { useWorkflow } from '../../hooks/useWorkflow.js'
import { budgetService } from '../../services/budget.service.js'
import { can } from '../../utils/permissions.js'
import { formatCurrency, formatDate, getStatusLabel, getStatusColor } from '../../utils/formatters.js'
import Badge from '../../components/ui/Badge.jsx'
import WorkflowStatus from '../../components/workflows/WorkflowStatus.jsx'
import Button from '../../components/ui/Button.jsx'

function DecisionModal({ request, onClose, onDecide }) {
  const [decision, setDecision] = useState('APPROVED')
  const [comment, setComment] = useState('')
  const [loading, setLoading] = useState(false)

  const submit = async () => {
    setLoading(true)
    try {
      await onDecide(request.id, decision, comment)
      onClose()
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 200 }}>
      <div style={{ background: 'var(--color-surface)', borderRadius: '8px', padding: '24px', width: '440px' }}>
        <h3 style={{ marginBottom: '16px' }}>Décision sur : {request.title}</h3>
        <p style={{ fontSize: '0.875rem', marginBottom: '16px', color: 'var(--color-text-muted)' }}>
          Montant : <strong>{formatCurrency(request.data?.amount)}</strong>
        </p>
        <div style={{ display: 'flex', gap: '12px', marginBottom: '16px' }}>
          {['APPROVED', 'REJECTED'].map((d) => (
            <label key={d} style={{ display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer' }}>
              <input type="radio" value={d} checked={decision === d} onChange={() => setDecision(d)} />
              {d === 'APPROVED' ? 'Approuver' : 'Rejeter'}
            </label>
          ))}
        </div>
        <textarea
          placeholder="Commentaire (optionnel)"
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          rows={3}
          style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem', marginBottom: '16px' }}
        />
        <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={onClose}>Annuler</Button>
          <Button variant={decision === 'REJECTED' ? 'danger' : 'primary'} loading={loading} onClick={submit}>
            Confirmer
          </Button>
        </div>
      </div>
    </div>
  )
}

export default function BudgetApprovalPage() {
  const { profile } = useAuth()
  const { data: requests, loading, refresh } = useWorkflow('BUDGET')
  const [selected, setSelected] = useState(null)
  const roleCode = profile?.roles?.code

  const handleDecide = async (id, decision, comment) => {
    await budgetService.decide(id, { decision, comment })
    refresh()
  }

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Demandes de budget</h1>

      {loading ? (
        <p>Chargement...</p>
      ) : requests.length === 0 ? (
        <p style={{ color: 'var(--color-text-muted)' }}>Aucune demande de budget.</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {requests.map((r) => (
            <div key={r.id} style={{
              background: 'var(--color-surface)',
              border: '1px solid var(--color-border)',
              borderRadius: '8px',
              padding: '16px 20px',
              display: 'flex',
              alignItems: 'flex-start',
              gap: '16px',
            }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 600, marginBottom: '4px' }}>{r.title}</div>
                <div style={{ fontSize: '0.875rem', color: 'var(--color-text-muted)', marginBottom: '8px' }}>
                  {formatCurrency(r.data?.amount)} · {r.data?.category} · {formatDate(r.created_at)}
                </div>
                <WorkflowStatus status={r.status} approvals={r.workflow_approvals} />
              </div>
              {can.approve(roleCode) && r.status !== 'APPROVED' && r.status !== 'REJECTED' && (
                <Button variant="secondary" onClick={() => setSelected(r)}>Décider</Button>
              )}
            </div>
          ))}
        </div>
      )}

      {selected && (
        <DecisionModal
          request={selected}
          onClose={() => setSelected(null)}
          onDecide={handleDecide}
        />
      )}
    </div>
  )
}

import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext.jsx'
import { budgetService } from '../../services/budget.service.js'
import Button from '../../components/ui/Button.jsx'

export default function BudgetRequestPage() {
  const { profile } = useAuth()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [form, setForm] = useState({
    title: '',
    description: '',
    amount: '',
    category: 'FONCTIONNEMENT',
    fiscal_year: new Date().getFullYear(),
    supplier: '',
    urgency: 'NORMAL',
  })

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await budgetService.create({
        title: form.title,
        description: form.description,
        agency_id: profile.agency_id,
        data: {
          amount: parseFloat(form.amount),
          category: form.category,
          fiscal_year: parseInt(form.fiscal_year),
          supplier: form.supplier,
          urgency: form.urgency,
        },
      })
      navigate('/budget/approvals')
    } catch (err) {
      setError(err.response?.data?.error?.message || 'Erreur lors de la création')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ maxWidth: '640px' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Nouvelle demande de budget</h1>

      <form onSubmit={handleSubmit} style={{
        background: 'var(--color-surface)',
        border: '1px solid var(--color-border)',
        borderRadius: '8px',
        padding: '24px',
        display: 'flex',
        flexDirection: 'column',
        gap: '16px',
      }}>
        {[
          { label: 'Titre *', key: 'title', type: 'text', required: true },
          { label: 'Fournisseur (optionnel)', key: 'supplier', type: 'text' },
          { label: 'Montant (€) *', key: 'amount', type: 'number', required: true, min: '0.01', step: '0.01' },
          { label: 'Exercice fiscal *', key: 'fiscal_year', type: 'number', required: true },
        ].map(({ label, key, ...rest }) => (
          <div key={key}>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>{label}</label>
            <input
              value={form[key]}
              onChange={set(key)}
              {...rest}
              style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }}
            />
          </div>
        ))}

        <div>
          <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>Catégorie *</label>
          <select value={form.category} onChange={set('category')} style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }}>
            <option value="FONCTIONNEMENT">Fonctionnement</option>
            <option value="INVESTISSEMENT">Investissement</option>
            <option value="RH">Ressources Humaines</option>
          </select>
        </div>

        <div>
          <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>Urgence</label>
          <select value={form.urgency} onChange={set('urgency')} style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }}>
            <option value="NORMAL">Normal</option>
            <option value="URGENT">Urgent</option>
          </select>
        </div>

        <div>
          <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>Description / justification</label>
          <textarea
            value={form.description}
            onChange={set('description')}
            rows={4}
            style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem', resize: 'vertical' }}
          />
        </div>

        {error && <p style={{ color: 'var(--color-error)', fontSize: '0.875rem' }}>{error}</p>}

        <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={() => navigate(-1)}>Annuler</Button>
          <Button type="submit" loading={loading}>Soumettre la demande</Button>
        </div>
      </form>
    </div>
  )
}

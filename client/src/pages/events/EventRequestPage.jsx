import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext.jsx'
import { eventsService } from '../../services/events.service.js'
import Button from '../../components/ui/Button.jsx'

const DEPARTMENTS = ['MKT', 'IT', 'ACH', 'RH', 'QUA', 'JUR', 'FIN']

export default function EventRequestPage() {
  const { profile } = useAuth()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [form, setForm] = useState({
    event_name: '',
    event_date: '',
    location: '',
    target_audience: '',
    estimated_budget: '',
    expected_attendees: '',
    involved_departments: [],
    catering_required: false,
  })

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }))

  const toggleDept = (code) => {
    setForm((f) => ({
      ...f,
      involved_departments: f.involved_departments.includes(code)
        ? f.involved_departments.filter((d) => d !== code)
        : [...f.involved_departments, code],
    }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await eventsService.create({
        title: form.event_name,
        agency_id: profile.agency_id,
        data: {
          ...form,
          estimated_budget: parseFloat(form.estimated_budget),
          expected_attendees: parseInt(form.expected_attendees) || 0,
        },
      })
      navigate('/events')
    } catch (err) {
      setError(err.response?.data?.error?.message || 'Erreur lors de la création')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ maxWidth: '640px' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Nouvelle demande d'événement</h1>

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
          { label: 'Nom de l\'événement *', key: 'event_name', type: 'text', required: true },
          { label: 'Date *', key: 'event_date', type: 'date', required: true },
          { label: 'Lieu *', key: 'location', type: 'text', required: true },
          { label: 'Public cible', key: 'target_audience', type: 'text' },
          { label: 'Budget estimé (€) *', key: 'estimated_budget', type: 'number', required: true, min: '0' },
          { label: 'Nombre de participants attendus', key: 'expected_attendees', type: 'number', min: '0' },
        ].map(({ label, key, ...rest }) => (
          <div key={key}>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>{label}</label>
            <input value={form[key]} onChange={set(key)} {...rest}
              style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }} />
          </div>
        ))}

        <div>
          <label style={{ display: 'block', marginBottom: '8px', fontSize: '0.875rem', fontWeight: 500 }}>Services impliqués</label>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
            {DEPARTMENTS.map((d) => (
              <button key={d} type="button" onClick={() => toggleDept(d)} style={{
                padding: '4px 12px',
                borderRadius: '999px',
                border: '1px solid var(--color-border)',
                background: form.involved_departments.includes(d) ? 'var(--color-primary)' : 'transparent',
                color: form.involved_departments.includes(d) ? '#fff' : 'var(--color-text)',
                fontSize: '0.8rem',
                cursor: 'pointer',
              }}>{d}</button>
            ))}
          </div>
        </div>

        <label style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '0.875rem', cursor: 'pointer' }}>
          <input type="checkbox" checked={form.catering_required} onChange={(e) => setForm((f) => ({ ...f, catering_required: e.target.checked }))} />
          Restauration requise
        </label>

        {error && <p style={{ color: 'var(--color-error)', fontSize: '0.875rem' }}>{error}</p>}
        <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={() => navigate(-1)}>Annuler</Button>
          <Button type="submit" loading={loading}>Soumettre</Button>
        </div>
      </form>
    </div>
  )
}

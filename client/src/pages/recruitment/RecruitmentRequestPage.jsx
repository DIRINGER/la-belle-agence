import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext.jsx'
import { recruitmentService } from '../../services/recruitment.service.js'
import Button from '../../components/ui/Button.jsx'

export default function RecruitmentRequestPage() {
  const { profile } = useAuth()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [form, setForm] = useState({
    title: '',
    position_title: '',
    contract_type: 'CDI',
    profile_description: '',
    desired_start_date: '',
    salary_range_min: '',
    salary_range_max: '',
    headcount_justification: '',
  })

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await recruitmentService.create({
        title: form.title || `Recrutement : ${form.position_title}`,
        agency_id: profile.agency_id,
        data: {
          position_title: form.position_title,
          contract_type: form.contract_type,
          target_agency_id: profile.agency_id,
          profile_description: form.profile_description,
          desired_start_date: form.desired_start_date,
          salary_range_min: form.salary_range_min ? parseInt(form.salary_range_min) : null,
          salary_range_max: form.salary_range_max ? parseInt(form.salary_range_max) : null,
          headcount_justification: form.headcount_justification,
        },
      })
      navigate('/recruitment/pipeline')
    } catch (err) {
      setError(err.response?.data?.error?.message || 'Erreur lors de la création')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ maxWidth: '640px' }}>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Nouvelle demande de recrutement</h1>

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
          { label: 'Intitulé du poste *', key: 'position_title', type: 'text', required: true },
          { label: 'Date de prise de poste souhaitée', key: 'desired_start_date', type: 'date' },
          { label: 'Fourchette salariale min (€)', key: 'salary_range_min', type: 'number' },
          { label: 'Fourchette salariale max (€)', key: 'salary_range_max', type: 'number' },
        ].map(({ label, key, ...rest }) => (
          <div key={key}>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>{label}</label>
            <input value={form[key]} onChange={set(key)} {...rest}
              style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }} />
          </div>
        ))}

        <div>
          <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>Type de contrat *</label>
          <select value={form.contract_type} onChange={set('contract_type')} style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem' }}>
            {['CDI', 'CDD', 'STAGE', 'ALTERNANCE'].map((c) => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>

        {[
          { label: 'Profil recherché', key: 'profile_description' },
          { label: 'Justification du poste *', key: 'headcount_justification' },
        ].map(({ label, key }) => (
          <div key={key}>
            <label style={{ display: 'block', marginBottom: '6px', fontSize: '0.875rem', fontWeight: 500 }}>{label}</label>
            <textarea value={form[key]} onChange={set(key)} rows={3}
              style={{ width: '100%', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem', resize: 'vertical' }} />
          </div>
        ))}

        {error && <p style={{ color: 'var(--color-error)', fontSize: '0.875rem' }}>{error}</p>}
        <div style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end' }}>
          <Button variant="secondary" onClick={() => navigate(-1)}>Annuler</Button>
          <Button type="submit" loading={loading}>Soumettre</Button>
        </div>
      </form>
    </div>
  )
}

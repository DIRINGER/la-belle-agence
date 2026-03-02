import { useAuth } from '../../context/AuthContext.jsx'
import { Navigate } from 'react-router-dom'
import { can } from '../../utils/permissions.js'

export default function AdminPage() {
  const { profile } = useAuth()

  if (!can.accessAdmin(profile?.roles?.code)) {
    return <Navigate to="/dashboard" replace />
  }

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '8px' }}>Administration</h1>
      <p style={{ color: 'var(--color-text-muted)', marginBottom: '32px', fontSize: '0.875rem' }}>
        Espace réservé à la Direction Générale
      </p>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '16px' }}>
        {[
          { title: 'Gestion des utilisateurs', desc: 'Créer, modifier et désactiver des comptes', href: '/employees' },
          { title: 'Vue globale des demandes', desc: 'Toutes les demandes de toutes les agences', href: '/budget/approvals' },
          { title: 'Reporting', desc: 'Suivi des enveloppes budgétaires', href: '#' },
        ].map((card) => (
          <a key={card.title} href={card.href} style={{
            background: 'var(--color-surface)',
            border: '1px solid var(--color-border)',
            borderRadius: '8px',
            padding: '20px',
            boxShadow: 'var(--shadow)',
            transition: 'box-shadow .15s',
          }}>
            <div style={{ fontWeight: 600, marginBottom: '6px' }}>{card.title}</div>
            <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>{card.desc}</div>
          </a>
        ))}
      </div>
    </div>
  )
}

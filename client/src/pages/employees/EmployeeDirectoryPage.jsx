import { useState, useEffect } from 'react'
import api from '../../services/api.js'
import { getRoleLabel } from '../../utils/permissions.js'

export default function EmployeeDirectoryPage() {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    api.get('/users').then((res) => {
      setUsers(res.data.data || [])
    }).catch(() => {}).finally(() => setLoading(false))
  }, [])

  const filtered = users.filter((u) =>
    `${u.first_name} ${u.last_name} ${u.email}`.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div>
      <h1 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '24px' }}>Annuaire</h1>

      <input
        placeholder="Rechercher un collaborateur..."
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        style={{ width: '100%', maxWidth: '360px', padding: '10px 12px', border: '1px solid var(--color-border)', borderRadius: 'var(--radius)', fontSize: '0.875rem', marginBottom: '20px' }}
      />

      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div style={{ background: 'var(--color-surface)', border: '1px solid var(--color-border)', borderRadius: '8px', overflow: 'hidden' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ background: 'var(--color-bg)', fontSize: '0.75rem', color: 'var(--color-text-muted)', fontWeight: 600 }}>
                {['Nom', 'Email', 'Rôle', 'Agence / Service', 'Statut'].map((h) => (
                  <th key={h} style={{ padding: '10px 16px', textAlign: 'left', borderBottom: '1px solid var(--color-border)' }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filtered.map((u) => (
                <tr key={u.id} style={{ borderBottom: '1px solid var(--color-border)', fontSize: '0.875rem' }}>
                  <td style={{ padding: '12px 16px', fontWeight: 500 }}>{u.first_name} {u.last_name}</td>
                  <td style={{ padding: '12px 16px', color: 'var(--color-text-muted)' }}>{u.email}</td>
                  <td style={{ padding: '12px 16px' }}>{getRoleLabel(u.roles?.code)}</td>
                  <td style={{ padding: '12px 16px' }}>{u.agencies?.name || '-'}</td>
                  <td style={{ padding: '12px 16px' }}>
                    <span style={{
                      padding: '2px 8px', borderRadius: '999px', fontSize: '0.75rem',
                      background: u.is_active ? '#dcfce7' : '#fee2e2',
                      color: u.is_active ? '#166534' : '#991b1b',
                    }}>
                      {u.is_active ? 'Actif' : 'Inactif'}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <div style={{ padding: '32px', textAlign: 'center', color: 'var(--color-text-muted)' }}>Aucun résultat</div>
          )}
        </div>
      )}
    </div>
  )
}

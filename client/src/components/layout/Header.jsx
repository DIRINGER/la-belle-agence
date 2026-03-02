import { useAuth } from '../../context/AuthContext.jsx'
import { getRoleLabel } from '../../utils/permissions.js'

export default function Header() {
  const { profile, signOut } = useAuth()

  return (
    <header style={{
      height: '60px',
      background: 'var(--color-primary)',
      color: '#fff',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 24px',
      boxShadow: '0 1px 3px rgba(0,0,0,.2)',
      position: 'sticky',
      top: 0,
      zIndex: 100,
    }}>
      <div style={{ fontWeight: 700, fontSize: '1.1rem', letterSpacing: '.5px' }}>
        La Belle Agence
      </div>
      {profile && (
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px', fontSize: '0.875rem' }}>
          <span>{profile.first_name} {profile.last_name}</span>
          <span style={{ opacity: 0.7 }}>{getRoleLabel(profile.roles?.code)}</span>
          <button
            onClick={signOut}
            style={{
              background: 'rgba(255,255,255,.15)',
              border: 'none',
              color: '#fff',
              padding: '4px 12px',
              borderRadius: 'var(--radius)',
              cursor: 'pointer',
              fontSize: '0.875rem',
            }}
          >
            Déconnexion
          </button>
        </div>
      )}
    </header>
  )
}

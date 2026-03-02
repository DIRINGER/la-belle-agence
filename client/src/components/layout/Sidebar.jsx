import { NavLink } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext.jsx'
import { can } from '../../utils/permissions.js'

const linkStyle = (isActive) => ({
  display: 'block',
  padding: '10px 16px',
  borderRadius: 'var(--radius)',
  color: isActive ? 'var(--color-primary)' : 'var(--color-text-muted)',
  background: isActive ? '#eff6ff' : 'transparent',
  fontWeight: isActive ? 600 : 400,
  fontSize: '0.875rem',
  transition: 'all .15s',
})

export default function Sidebar() {
  const { profile } = useAuth()
  const roleCode = profile?.roles?.code

  return (
    <nav style={{
      width: '220px',
      minHeight: '100%',
      background: 'var(--color-surface)',
      borderRight: '1px solid var(--color-border)',
      padding: '16px 8px',
      display: 'flex',
      flexDirection: 'column',
      gap: '4px',
    }}>
      <NavLink to="/dashboard" style={({ isActive }) => linkStyle(isActive)}>Tableau de bord</NavLink>

      <div style={{ padding: '8px 16px 4px', fontSize: '0.7rem', fontWeight: 700, color: 'var(--color-text-muted)', textTransform: 'uppercase', letterSpacing: '.05em' }}>
        Demandes
      </div>
      {can.createRequest(roleCode) && (
        <>
          <NavLink to="/budget/new" style={({ isActive }) => linkStyle(isActive)}>Nouvelle demande budget</NavLink>
          <NavLink to="/recruitment/new" style={({ isActive }) => linkStyle(isActive)}>Nouvelle demande RH</NavLink>
          <NavLink to="/events/new" style={({ isActive }) => linkStyle(isActive)}>Nouvel événement</NavLink>
        </>
      )}
      <NavLink to="/budget/approvals" style={({ isActive }) => linkStyle(isActive)}>Mes demandes</NavLink>
      <NavLink to="/events" style={({ isActive }) => linkStyle(isActive)}>Événements</NavLink>
      <NavLink to="/recruitment/pipeline" style={({ isActive }) => linkStyle(isActive)}>Recrutements</NavLink>

      <div style={{ padding: '8px 16px 4px', fontSize: '0.7rem', fontWeight: 700, color: 'var(--color-text-muted)', textTransform: 'uppercase', letterSpacing: '.05em' }}>
        Organisation
      </div>
      <NavLink to="/employees" style={({ isActive }) => linkStyle(isActive)}>Annuaire</NavLink>
      {can.accessAdmin(roleCode) && (
        <NavLink to="/admin" style={({ isActive }) => linkStyle(isActive)}>Administration</NavLink>
      )}
    </nav>
  )
}

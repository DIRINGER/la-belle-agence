const variants = {
  primary: { background: 'var(--color-primary)', color: '#fff', border: 'none' },
  secondary: { background: 'transparent', color: 'var(--color-primary)', border: '1px solid var(--color-primary)' },
  danger: { background: 'var(--color-error)', color: '#fff', border: 'none' },
  ghost: { background: 'transparent', color: 'var(--color-text)', border: 'none' },
}

export default function Button({ children, variant = 'primary', disabled, loading, onClick, type = 'button', style }) {
  return (
    <button
      type={type}
      disabled={disabled || loading}
      onClick={onClick}
      style={{
        ...variants[variant],
        padding: '8px 16px',
        borderRadius: 'var(--radius)',
        fontWeight: 500,
        fontSize: '0.875rem',
        opacity: disabled || loading ? 0.6 : 1,
        cursor: disabled || loading ? 'not-allowed' : 'pointer',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '6px',
        ...style,
      }}
    >
      {loading ? 'Chargement...' : children}
    </button>
  )
}

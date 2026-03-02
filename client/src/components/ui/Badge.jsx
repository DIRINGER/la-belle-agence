const colors = {
  green: { bg: '#dcfce7', text: '#166534' },
  red: { bg: '#fee2e2', text: '#991b1b' },
  orange: { bg: '#ffedd5', text: '#9a3412' },
  blue: { bg: '#dbeafe', text: '#1e40af' },
  gray: { bg: '#f1f5f9', text: '#475569' },
}

export default function Badge({ label, color = 'gray' }) {
  const c = colors[color] || colors.gray
  return (
    <span style={{
      background: c.bg,
      color: c.text,
      padding: '2px 8px',
      borderRadius: '999px',
      fontSize: '0.75rem',
      fontWeight: 500,
      whiteSpace: 'nowrap',
    }}>
      {label}
    </span>
  )
}

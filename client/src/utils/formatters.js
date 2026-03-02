export const formatCurrency = (amount) =>
  new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount)

export const formatDate = (dateStr) =>
  new Intl.DateTimeFormat('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric' }).format(new Date(dateStr))

export const formatDateTime = (dateStr) =>
  new Intl.DateTimeFormat('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' }).format(new Date(dateStr))

export const getStatusLabel = (status) => ({
  DRAFT: 'Brouillon',
  SUBMITTED: 'Soumis',
  PENDING_APPROVAL: 'En cours de validation',
  APPROVED: 'Approuvé',
  REJECTED: 'Rejeté',
  CANCELLED: 'Annulé',
  CLOSED_FILLED: 'Pourvu',
}[status] || status)

export const getStatusColor = (status) => ({
  DRAFT: 'gray',
  SUBMITTED: 'blue',
  PENDING_APPROVAL: 'orange',
  APPROVED: 'green',
  REJECTED: 'red',
  CANCELLED: 'gray',
  CLOSED_FILLED: 'green',
}[status] || 'gray')

export const getTypeLabel = (type) => ({
  BUDGET: 'Budget',
  RECRUITMENT: 'Recrutement',
  EVENT: 'Événement',
}[type] || type)

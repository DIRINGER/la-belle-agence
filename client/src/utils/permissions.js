const MANAGER_ROLES = [
  'DIRECTION_GENERALE',
  'DIRECTEUR_AGENCE',
  'RH_MANAGER',
  'FINANCE_MANAGER',
  'MKT_MANAGER',
  'ACH_MANAGER',
  'IT_MANAGER',
  'QUA_MANAGER',
  'JUR_MANAGER',
]

export const can = {
  createRequest: (roleCode) => MANAGER_ROLES.includes(roleCode),
  viewAllRequests: (roleCode) => roleCode === 'DIRECTION_GENERALE',
  viewAgencyRequests: (roleCode) => ['DIRECTION_GENERALE', 'DIRECTEUR_AGENCE', ...MANAGER_ROLES].includes(roleCode),
  manageUsers: (roleCode) => ['RH_MANAGER', 'DIRECTION_GENERALE'].includes(roleCode),
  accessAdmin: (roleCode) => roleCode === 'DIRECTION_GENERALE',
  approve: (roleCode) => MANAGER_ROLES.includes(roleCode),
}

export const getRoleLabel = (code) => ({
  DIRECTION_GENERALE: 'Direction Générale',
  DIRECTEUR_AGENCE: 'Directeur d\'Agence',
  RH_MANAGER: 'Responsable RH',
  FINANCE_MANAGER: 'Responsable Finance',
  MKT_MANAGER: 'Responsable Marketing',
  ACH_MANAGER: 'Responsable Achats',
  IT_MANAGER: 'Responsable IT',
  QUA_MANAGER: 'Responsable Qualité',
  JUR_MANAGER: 'Responsable Juridique',
  CONSEILLER_PATRIMOINE: 'Conseiller en Patrimoine',
  AGENT_IMMOBILIER: 'Agent Immobilier',
}[code] || code)

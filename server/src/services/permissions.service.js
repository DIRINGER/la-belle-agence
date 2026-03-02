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

const APPROVER_ROLES = [...MANAGER_ROLES]

export const permissionsService = {
  canCreateRequest: (roleCode) => MANAGER_ROLES.includes(roleCode),
  canApprove: (roleCode) => APPROVER_ROLES.includes(roleCode),
  canViewAllRequests: (roleCode) => roleCode === 'DIRECTION_GENERALE',
  canManageUsers: (roleCode) => ['RH_MANAGER', 'DIRECTION_GENERALE'].includes(roleCode),
  isAgencyScoped: (roleCode) => roleCode === 'DIRECTEUR_AGENCE',
  isSiegeManager: (roleCode) => MANAGER_ROLES.includes(roleCode) && roleCode !== 'DIRECTEUR_AGENCE',
}

// Vérifie que l'utilisateur possède l'un des rôles requis
export const requireRole = (...roleCodes) => {
  return (req, res, next) => {
    const roleCode = req.user?.roles?.code
    if (!roleCode || !roleCodes.includes(roleCode)) {
      return res.status(403).json({
        success: false,
        error: { code: 'FORBIDDEN', message: 'Accès non autorisé pour ce rôle' },
      })
    }
    next()
  }
}

// Vérifie que l'utilisateur appartient à l'agence ciblée
// La Direction Générale a accès à toutes les agences
export const requireSameAgency = (req, res, next) => {
  const roleCode = req.user?.roles?.code
  if (roleCode === 'DIRECTION_GENERALE') return next()

  const targetAgencyId = parseInt(req.params.agencyId || req.body.agency_id)
  if (!targetAgencyId || req.user.agency_id !== targetAgencyId) {
    return res.status(403).json({
      success: false,
      error: { code: 'FORBIDDEN', message: 'Accès limité à votre agence' },
    })
  }
  next()
}

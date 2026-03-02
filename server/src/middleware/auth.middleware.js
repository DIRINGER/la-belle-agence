import { supabase } from '../config/db.js'

export const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Token manquant' },
    })
  }

  const token = authHeader.split(' ')[1]

  try {
    // Vérifie le JWT Supabase
    const { data: { user }, error } = await supabase.auth.getUser(token)
    if (error || !user) {
      return res.status(401).json({
        success: false,
        error: { code: 'INVALID_TOKEN', message: 'Token invalide ou expiré' },
      })
    }

    // Charge le profil avec rôle, agence et service
    const { data: profile, error: profileError } = await supabase
      .from('users')
      .select(`
        id, first_name, last_name, email, is_active,
        agency_id, department_id,
        roles ( id, name, code, scope ),
        agencies ( id, name, type, city ),
        departments ( id, name, code )
      `)
      .eq('id', user.id)
      .single()

    if (profileError || !profile) {
      return res.status(401).json({
        success: false,
        error: { code: 'PROFILE_NOT_FOUND', message: 'Profil utilisateur introuvable' },
      })
    }

    if (!profile.is_active) {
      return res.status(403).json({
        success: false,
        error: { code: 'ACCOUNT_INACTIVE', message: 'Ce compte est désactivé' },
      })
    }

    req.user = profile
    next()
  } catch (err) {
    next(err)
  }
}

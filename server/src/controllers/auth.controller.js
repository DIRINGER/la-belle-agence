import { supabase } from '../config/db.js'

export const getMe = async (req, res) => {
  res.json({ success: true, data: req.user })
}

export const updateProfile = async (req, res, next) => {
  try {
    const { first_name, last_name } = req.body
    const { data, error } = await supabase
      .from('users')
      .update({ first_name, last_name, updated_at: new Date().toISOString() })
      .eq('id', req.user.id)
      .select()
      .single()

    if (error) throw error
    res.json({ success: true, data, message: 'Profil mis à jour' })
  } catch (err) {
    next(err)
  }
}

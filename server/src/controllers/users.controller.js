import { supabase } from '../config/db.js'

export const getUsers = async (req, res, next) => {
  try {
    const { agency_id, role_id, page = 1, limit = 20 } = req.query
    let query = supabase
      .from('users')
      .select('id, first_name, last_name, email, is_active, agency_id, department_id, roles ( name, code ), agencies ( name, city )', { count: 'exact' })
      .order('last_name')
      .range((page - 1) * limit, page * limit - 1)

    if (agency_id) query = query.eq('agency_id', agency_id)
    if (role_id) query = query.eq('role_id', role_id)

    const { data, count, error } = await query
    if (error) throw error
    res.json({ success: true, data, total: count, page: parseInt(page), limit: parseInt(limit) })
  } catch (err) {
    next(err)
  }
}

export const createUser = async (req, res, next) => {
  try {
    const { email, first_name, last_name, role_id, agency_id, department_id } = req.body

    // Crée le compte auth Supabase
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email,
      password: `Welcome_${Math.random().toString(36).slice(2, 10)}!`,
      email_confirm: true,
    })
    if (authError) throw authError

    // Crée le profil dans notre table users
    const { data, error } = await supabase
      .from('users')
      .insert({
        id: authData.user.id,
        email,
        first_name,
        last_name,
        role_id,
        agency_id,
        department_id: department_id || null,
      })
      .select()
      .single()

    if (error) throw error
    res.status(201).json({ success: true, data, message: 'Utilisateur créé avec succès' })
  } catch (err) {
    next(err)
  }
}

export const updateUser = async (req, res, next) => {
  try {
    const { id } = req.params
    const { first_name, last_name, role_id, agency_id, department_id } = req.body
    const updates = {}
    if (first_name !== undefined) updates.first_name = first_name
    if (last_name !== undefined) updates.last_name = last_name
    if (role_id !== undefined) updates.role_id = role_id
    if (agency_id !== undefined) updates.agency_id = agency_id
    if (department_id !== undefined) updates.department_id = department_id
    updates.updated_at = new Date().toISOString()

    const { data, error } = await supabase
      .from('users')
      .update(updates)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    res.json({ success: true, data, message: 'Utilisateur mis à jour' })
  } catch (err) {
    next(err)
  }
}

export const deactivateUser = async (req, res, next) => {
  try {
    const { id } = req.params
    const { error } = await supabase
      .from('users')
      .update({ is_active: false, updated_at: new Date().toISOString() })
      .eq('id', id)

    if (error) throw error
    res.json({ success: true, message: 'Compte désactivé' })
  } catch (err) {
    next(err)
  }
}

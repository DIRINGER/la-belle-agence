import { Router } from 'express'
import { authenticate } from '../middleware/auth.middleware.js'
import { supabase } from '../config/db.js'

const router = Router()

router.use(authenticate)

router.get('/', async (_req, res, next) => {
  try {
    const { data, error } = await supabase
      .from('agencies')
      .select('*')
      .order('type', { ascending: false })
    if (error) throw error
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
})

router.get('/:id', async (req, res, next) => {
  try {
    const { data, error } = await supabase
      .from('agencies')
      .select('*, users ( id, first_name, last_name, roles ( name, code ) )')
      .eq('id', req.params.id)
      .single()
    if (error) throw error
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
})

export default router

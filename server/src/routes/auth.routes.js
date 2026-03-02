import { Router } from 'express'
import { authenticate } from '../middleware/auth.middleware.js'
import { getMe, updateProfile } from '../controllers/auth.controller.js'

const router = Router()

router.get('/me', authenticate, getMe)
router.patch('/me', authenticate, updateProfile)

export default router

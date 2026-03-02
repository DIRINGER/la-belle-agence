import { Router } from 'express'
import { body } from 'express-validator'
import { authenticate } from '../middleware/auth.middleware.js'
import { requireRole } from '../middleware/rbac.middleware.js'
import { validate } from '../utils/validators.js'
import { getUsers, createUser, updateUser, deactivateUser } from '../controllers/users.controller.js'

const router = Router()

router.use(authenticate)
router.use(requireRole('DIRECTION_GENERALE', 'RH_MANAGER'))

router.get('/', getUsers)

router.post('/',
  body('email').isEmail().normalizeEmail(),
  body('first_name').notEmpty().trim(),
  body('last_name').notEmpty().trim(),
  body('role_id').isInt(),
  body('agency_id').isInt(),
  validate,
  createUser
)

router.patch('/:id',
  body('first_name').optional().trim(),
  body('last_name').optional().trim(),
  body('role_id').optional().isInt(),
  body('agency_id').optional().isInt(),
  validate,
  updateUser
)

router.delete('/:id', requireRole('DIRECTION_GENERALE'), deactivateUser)

export default router

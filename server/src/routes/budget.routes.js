import { Router } from 'express'
import { body } from 'express-validator'
import { authenticate } from '../middleware/auth.middleware.js'
import { validate } from '../utils/validators.js'
import {
  getBudgetRequests,
  getBudgetRequestById,
  createBudgetRequest,
  decideBudgetRequest,
  getBudgetEnvelopes,
} from '../controllers/budget.controller.js'

const router = Router()

router.use(authenticate)

router.get('/', getBudgetRequests)
router.get('/envelopes', getBudgetEnvelopes)
router.get('/:id', getBudgetRequestById)

router.post('/',
  body('title').notEmpty().trim(),
  body('description').optional().trim(),
  body('agency_id').isInt(),
  body('data.amount').isFloat({ min: 0.01 }),
  body('data.category').isIn(['FONCTIONNEMENT', 'INVESTISSEMENT', 'RH']),
  body('data.fiscal_year').isInt({ min: 2020, max: 2100 }),
  validate,
  createBudgetRequest
)

router.post('/:id/decide',
  body('decision').isIn(['APPROVED', 'REJECTED']),
  body('comment').optional().trim(),
  validate,
  decideBudgetRequest
)

export default router

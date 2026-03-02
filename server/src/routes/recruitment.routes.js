import { Router } from 'express'
import { body } from 'express-validator'
import { authenticate } from '../middleware/auth.middleware.js'
import { validate } from '../utils/validators.js'
import {
  getRecruitmentRequests,
  getRecruitmentRequestById,
  createRecruitmentRequest,
  decideRecruitmentRequest,
  closeRecruitment,
} from '../controllers/recruitment.controller.js'

const router = Router()

router.use(authenticate)

router.get('/', getRecruitmentRequests)
router.get('/:id', getRecruitmentRequestById)

router.post('/',
  body('title').notEmpty().trim(),
  body('agency_id').isInt(),
  body('data.position_title').notEmpty().trim(),
  body('data.contract_type').isIn(['CDI', 'CDD', 'STAGE', 'ALTERNANCE']),
  body('data.target_agency_id').isInt(),
  validate,
  createRecruitmentRequest
)

router.post('/:id/decide',
  body('decision').isIn(['APPROVED', 'REJECTED']),
  body('comment').optional().trim(),
  validate,
  decideRecruitmentRequest
)

router.post('/:id/close',
  body('outcome').isIn(['FILLED', 'CANCELLED']),
  body('comment').optional().trim(),
  validate,
  closeRecruitment
)

export default router

import { Router } from 'express'
import { body } from 'express-validator'
import { authenticate } from '../middleware/auth.middleware.js'
import { validate } from '../utils/validators.js'
import {
  getEvents,
  getEventById,
  createEvent,
  decideEvent,
  submitEventReport,
} from '../controllers/events.controller.js'

const router = Router()

router.use(authenticate)

router.get('/', getEvents)
router.get('/:id', getEventById)

router.post('/',
  body('title').notEmpty().trim(),
  body('agency_id').isInt(),
  body('data.event_name').notEmpty().trim(),
  body('data.event_date').isISO8601(),
  body('data.location').notEmpty().trim(),
  body('data.estimated_budget').isFloat({ min: 0 }),
  validate,
  createEvent
)

router.post('/:id/decide',
  body('decision').isIn(['APPROVED', 'REJECTED']),
  body('comment').optional().trim(),
  validate,
  decideEvent
)

router.post('/:id/report',
  body('report').notEmpty().trim(),
  validate,
  submitEventReport
)

export default router

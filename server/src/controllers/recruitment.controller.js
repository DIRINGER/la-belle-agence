import { supabase } from '../config/db.js'
import { workflowService } from '../services/workflow.service.js'

export const getRecruitmentRequests = async (req, res, next) => {
  try {
    const { status, page, limit } = req.query
    const result = await workflowService.getRequestsForUser(
      req.user.id, req.user.roles.code, req.user.agency_id,
      { type: 'RECRUITMENT', status, page: parseInt(page) || 1, limit: parseInt(limit) || 20 }
    )
    res.json({ success: true, ...result })
  } catch (err) {
    next(err)
  }
}

export const getRecruitmentRequestById = async (req, res, next) => {
  try {
    const data = await workflowService.getRequestById(parseInt(req.params.id))
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
}

export const createRecruitmentRequest = async (req, res, next) => {
  try {
    const { title, description, agency_id, data } = req.body
    const request = await workflowService.createRequest({
      type: 'RECRUITMENT',
      title,
      description,
      data,
      requesterId: req.user.id,
      agencyId: parseInt(agency_id),
      departmentId: req.user.department_id,
    })
    res.status(201).json({ success: true, data: request, message: 'Demande de recrutement créée' })
  } catch (err) {
    next(err)
  }
}

export const decideRecruitmentRequest = async (req, res, next) => {
  try {
    const { decision, comment } = req.body
    const result = await workflowService.processDecision({
      requestId: parseInt(req.params.id),
      approverId: req.user.id,
      approverRoleCode: req.user.roles.code,
      decision,
      comment,
    })
    res.json({ success: true, data: result, message: `Décision : ${result.status}` })
  } catch (err) {
    next(err)
  }
}

export const closeRecruitment = async (req, res, next) => {
  try {
    const { outcome, comment } = req.body
    const { error } = await supabase
      .from('workflow_requests')
      .update({
        status: outcome === 'FILLED' ? 'CLOSED_FILLED' : 'CANCELLED',
        data: supabase.rpc('jsonb_set_key', { key: 'closure_comment', value: comment }),
        updated_at: new Date().toISOString(),
      })
      .eq('id', req.params.id)

    if (error) throw error
    res.json({ success: true, message: `Recrutement clôturé : ${outcome}` })
  } catch (err) {
    next(err)
  }
}

import { supabase } from '../config/db.js'
import { workflowService } from '../services/workflow.service.js'

export const getEvents = async (req, res, next) => {
  try {
    const { status, page, limit } = req.query
    const result = await workflowService.getRequestsForUser(
      req.user.id, req.user.roles.code, req.user.agency_id,
      { type: 'EVENT', status, page: parseInt(page) || 1, limit: parseInt(limit) || 20 }
    )
    res.json({ success: true, ...result })
  } catch (err) {
    next(err)
  }
}

export const getEventById = async (req, res, next) => {
  try {
    const data = await workflowService.getRequestById(parseInt(req.params.id))
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
}

export const createEvent = async (req, res, next) => {
  try {
    const { title, description, agency_id, data } = req.body
    const request = await workflowService.createRequest({
      type: 'EVENT',
      title,
      description,
      data,
      requesterId: req.user.id,
      agencyId: parseInt(agency_id),
      departmentId: req.user.department_id,
    })
    res.status(201).json({ success: true, data: request, message: 'Demande d\'événement créée' })
  } catch (err) {
    next(err)
  }
}

export const decideEvent = async (req, res, next) => {
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

export const submitEventReport = async (req, res, next) => {
  try {
    const { report } = req.body
    const { data: existing, error: fetchErr } = await supabase
      .from('workflow_requests')
      .select('data')
      .eq('id', req.params.id)
      .single()

    if (fetchErr) throw fetchErr

    const updatedData = { ...existing.data, post_event_report: report, report_submitted_at: new Date().toISOString() }
    const { error } = await supabase
      .from('workflow_requests')
      .update({ data: updatedData, updated_at: new Date().toISOString() })
      .eq('id', req.params.id)

    if (error) throw error
    res.json({ success: true, message: 'Compte-rendu soumis avec succès' })
  } catch (err) {
    next(err)
  }
}

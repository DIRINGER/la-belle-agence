import { supabase } from '../config/db.js'
import { workflowService } from '../services/workflow.service.js'

export const getBudgetRequests = async (req, res, next) => {
  try {
    const { status, page, limit } = req.query
    const result = await workflowService.getRequestsForUser(
      req.user.id, req.user.roles.code, req.user.agency_id,
      { type: 'BUDGET', status, page: parseInt(page) || 1, limit: parseInt(limit) || 20 }
    )
    res.json({ success: true, ...result })
  } catch (err) {
    next(err)
  }
}

export const getBudgetRequestById = async (req, res, next) => {
  try {
    const data = await workflowService.getRequestById(parseInt(req.params.id))
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
}

export const createBudgetRequest = async (req, res, next) => {
  try {
    const { title, description, agency_id, data } = req.body
    const request = await workflowService.createRequest({
      type: 'BUDGET',
      title,
      description,
      data,
      requesterId: req.user.id,
      agencyId: parseInt(agency_id),
      departmentId: req.user.department_id,
    })
    res.status(201).json({ success: true, data: request, message: 'Demande de budget créée' })
  } catch (err) {
    next(err)
  }
}

export const decideBudgetRequest = async (req, res, next) => {
  try {
    const { id } = req.params
    const { decision, comment } = req.body

    const result = await workflowService.processDecision({
      requestId: parseInt(id),
      approverId: req.user.id,
      approverRoleCode: req.user.roles.code,
      decision,
      comment,
    })

    // Si approuvé définitivement, met à jour l'enveloppe consommée
    if (result.status === 'APPROVED') {
      const { data: request } = await supabase
        .from('workflow_requests')
        .select('data, agency_id, department_id')
        .eq('id', id)
        .single()

      if (request) {
        const { amount, category, fiscal_year } = request.data
        const entityType = request.department_id ? 'department' : 'agency'
        const entityId = request.department_id || request.agency_id

        await supabase.from('budget_envelopes')
          .update({ consumed: supabase.rpc('increment_value', { row_id: entityId, inc: amount }) })
          .eq('entity_type', entityType)
          .eq('entity_id', entityId)
          .eq('fiscal_year', fiscal_year)
          .eq('category', category)
      }
    }

    res.json({ success: true, data: result, message: `Décision enregistrée : ${result.status}` })
  } catch (err) {
    next(err)
  }
}

export const getBudgetEnvelopes = async (req, res, next) => {
  try {
    const { fiscal_year = new Date().getFullYear(), entity_type, entity_id } = req.query
    let query = supabase
      .from('budget_envelopes')
      .select('*')
      .eq('fiscal_year', parseInt(fiscal_year))

    if (entity_type) query = query.eq('entity_type', entity_type)
    if (entity_id) query = query.eq('entity_id', parseInt(entity_id))

    const { data, error } = await query
    if (error) throw error
    res.json({ success: true, data })
  } catch (err) {
    next(err)
  }
}

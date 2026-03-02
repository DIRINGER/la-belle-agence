import { supabase } from '../config/db.js'
import { notificationService } from './notification.service.js'

// Définition des étapes par type de workflow
const WORKFLOW_STEPS = {
  BUDGET: [
    { step_order: 1, step_name: 'Validation Directeur Agence', approver_role: 'DIRECTEUR_AGENCE' },
    { step_order: 2, step_name: 'Validation Finance Siège', approver_role: 'FINANCE_MANAGER' },
  ],
  RECRUITMENT: [
    { step_order: 1, step_name: 'Validation Directeur / Responsable', approver_role: 'DIRECTEUR_AGENCE' },
    { step_order: 2, step_name: 'Analyse RH Siège', approver_role: 'RH_MANAGER' },
    { step_order: 3, step_name: 'Validation Finance Siège', approver_role: 'FINANCE_MANAGER' },
  ],
  EVENT: [
    { step_order: 1, step_name: 'Validation Directeur Agence', approver_role: 'DIRECTEUR_AGENCE' },
    { step_order: 2, step_name: 'Validation Marketing Siège', approver_role: 'MKT_MANAGER' },
    { step_order: 3, step_name: 'Validation Finance Siège', approver_role: 'FINANCE_MANAGER' },
  ],
}

export const workflowService = {
  async createRequest({ type, title, description, data, requesterId, agencyId, departmentId }) {
    const { data: request, error } = await supabase
      .from('workflow_requests')
      .insert({
        type,
        title,
        description,
        data,
        requester_id: requesterId,
        agency_id: agencyId,
        department_id: departmentId || null,
        status: 'SUBMITTED',
      })
      .select()
      .single()

    if (error) throw error

    const steps = WORKFLOW_STEPS[type] || []
    if (steps.length > 0) {
      const { error: stepsError } = await supabase
        .from('workflow_approvals')
        .insert(steps.map((s) => ({ ...s, request_id: request.id, status: 'PENDING' })))
      if (stepsError) throw stepsError
    }

    await notificationService.notifyApproversForStep(request.id, 1, agencyId)
    return request
  },

  async processDecision({ requestId, approverId, approverRoleCode, decision, comment }) {
    // Trouve l'étape PENDING correspondant au rôle de l'approbateur
    const { data: step, error: stepError } = await supabase
      .from('workflow_approvals')
      .select('*')
      .eq('request_id', requestId)
      .eq('approver_role', approverRoleCode)
      .eq('status', 'PENDING')
      .single()

    if (stepError || !step) {
      const err = new Error('Étape non trouvée ou déjà traitée')
      err.status = 404
      throw err
    }

    const { error: updateError } = await supabase
      .from('workflow_approvals')
      .update({
        status: decision,
        approver_id: approverId,
        comment,
        decided_at: new Date().toISOString(),
      })
      .eq('id', step.id)

    if (updateError) throw updateError

    if (decision === 'REJECTED') {
      await supabase
        .from('workflow_requests')
        .update({ status: 'REJECTED', updated_at: new Date().toISOString() })
        .eq('id', requestId)
      await notificationService.notifyRequester(requestId, 'REJECTED')
      return { status: 'REJECTED' }
    }

    // Cherche la prochaine étape PENDING
    const { data: nextStep } = await supabase
      .from('workflow_approvals')
      .select('*')
      .eq('request_id', requestId)
      .eq('status', 'PENDING')
      .order('step_order', { ascending: true })
      .limit(1)
      .maybeSingle()

    if (nextStep) {
      await supabase
        .from('workflow_requests')
        .update({ status: 'PENDING_APPROVAL', updated_at: new Date().toISOString() })
        .eq('id', requestId)
      await notificationService.notifyApproversForStep(requestId, nextStep.step_order)
      return { status: 'PENDING_APPROVAL' }
    }

    // Toutes les étapes validées
    await supabase
      .from('workflow_requests')
      .update({ status: 'APPROVED', updated_at: new Date().toISOString() })
      .eq('id', requestId)
    await notificationService.notifyRequester(requestId, 'APPROVED')
    return { status: 'APPROVED' }
  },

  async getRequestsForUser(userId, roleCode, agencyId, { type, status, page = 1, limit = 20 }) {
    let query = supabase
      .from('workflow_requests')
      .select(
        `*, users ( first_name, last_name ), agencies ( name, city ), workflow_approvals ( step_order, step_name, status, approver_role )`,
        { count: 'exact' }
      )
      .order('created_at', { ascending: false })
      .range((page - 1) * limit, page * limit - 1)

    if (type) query = query.eq('type', type)
    if (status) query = query.eq('status', status)

    if (roleCode === 'DIRECTION_GENERALE') {
      // Voit toutes les demandes
    } else if (['DIRECTEUR_AGENCE', 'RH_MANAGER', 'FINANCE_MANAGER', 'MKT_MANAGER', 'ACH_MANAGER', 'IT_MANAGER', 'QUA_MANAGER', 'JUR_MANAGER'].includes(roleCode)) {
      query = query.eq('agency_id', agencyId)
    } else {
      query = query.eq('requester_id', userId)
    }

    const { data, count, error } = await query
    if (error) throw error
    return { data, total: count, page, limit }
  },

  async getRequestById(id) {
    const { data, error } = await supabase
      .from('workflow_requests')
      .select(`
        *,
        users ( first_name, last_name, email ),
        agencies ( name, city ),
        workflow_approvals ( * )
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  },
}

import { supabase } from '../config/db.js'

export const notificationService = {
  async create({ userId, title, message, type = 'INFO', relatedRequestId }) {
    const { error } = await supabase.from('notifications').insert({
      user_id: userId,
      title,
      message,
      type,
      related_request: relatedRequestId || null,
    })
    if (error) console.error('Erreur création notification:', error.message)
  },

  async notifyApproversForStep(requestId, stepOrder, agencyId) {
    const { data: step } = await supabase
      .from('workflow_approvals')
      .select('approver_role, workflow_requests ( title )')
      .eq('request_id', requestId)
      .eq('step_order', stepOrder)
      .single()

    if (!step) return

    // Cherche les utilisateurs ayant le rôle requis
    // Pour DIRECTEUR_AGENCE, filtre par agence
    let query = supabase
      .from('users')
      .select('id, roles ( code )')
      .eq('is_active', true)

    const { data: roleData } = await supabase
      .from('roles')
      .select('id')
      .eq('code', step.approver_role)
      .single()

    if (!roleData) return
    query = query.eq('role_id', roleData.id)

    if (step.approver_role === 'DIRECTEUR_AGENCE' && agencyId) {
      query = query.eq('agency_id', agencyId)
    }

    const { data: approvers } = await query
    for (const approver of approvers || []) {
      await this.create({
        userId: approver.id,
        title: 'Action requise',
        message: `La demande "${step.workflow_requests?.title}" attend votre validation.`,
        type: 'ACTION_REQUIRED',
        relatedRequestId: requestId,
      })
    }
  },

  async notifyRequester(requestId, decision) {
    const { data: request } = await supabase
      .from('workflow_requests')
      .select('title, requester_id')
      .eq('id', requestId)
      .single()

    if (!request) return

    await this.create({
      userId: request.requester_id,
      title: decision === 'APPROVED' ? 'Demande approuvée ✓' : 'Demande rejetée',
      message: `Votre demande "${request.title}" a été ${decision === 'APPROVED' ? 'approuvée' : 'rejetée'}.`,
      type: decision === 'APPROVED' ? 'SUCCESS' : 'WARNING',
      relatedRequestId: requestId,
    })
  },

  async getForUser(userId, page = 1, limit = 20) {
    const { data, count, error } = await supabase
      .from('notifications')
      .select('*', { count: 'exact' })
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .range((page - 1) * limit, page * limit - 1)

    if (error) throw error
    return { data, total: count }
  },

  async markRead(ids, userId) {
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .in('id', ids)
      .eq('user_id', userId)
    if (error) throw error
  },
}

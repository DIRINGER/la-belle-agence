import api from './api.js'

export const budgetService = {
  getAll: (params) => api.get('/budget', { params }),
  getById: (id) => api.get(`/budget/${id}`),
  create: (data) => api.post('/budget', data),
  decide: (id, data) => api.post(`/budget/${id}/decide`, data),
  getEnvelopes: (params) => api.get('/budget/envelopes', { params }),
}

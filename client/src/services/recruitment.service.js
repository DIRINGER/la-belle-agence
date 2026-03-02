import api from './api.js'

export const recruitmentService = {
  getAll: (params) => api.get('/recruitment', { params }),
  getById: (id) => api.get(`/recruitment/${id}`),
  create: (data) => api.post('/recruitment', data),
  decide: (id, data) => api.post(`/recruitment/${id}/decide`, data),
  close: (id, data) => api.post(`/recruitment/${id}/close`, data),
}

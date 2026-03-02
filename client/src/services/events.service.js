import api from './api.js'

export const eventsService = {
  getAll: (params) => api.get('/events', { params }),
  getById: (id) => api.get(`/events/${id}`),
  create: (data) => api.post('/events', data),
  decide: (id, data) => api.post(`/events/${id}/decide`, data),
  submitReport: (id, data) => api.post(`/events/${id}/report`, data),
}

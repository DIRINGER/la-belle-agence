import { useState, useEffect, useCallback } from 'react'
import api from '../services/api.js'

export function useWorkflow(type, params = {}) {
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const load = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const endpoint = { BUDGET: '/budget', RECRUITMENT: '/recruitment', EVENT: '/events' }[type]
      const res = await api.get(endpoint, { params })
      setData(res.data.data || [])
      setTotal(res.data.total || 0)
    } catch (err) {
      setError(err.response?.data?.error?.message || 'Erreur de chargement')
    } finally {
      setLoading(false)
    }
  }, [type, JSON.stringify(params)])

  useEffect(() => { load() }, [load])

  return { data, total, loading, error, refresh: load }
}

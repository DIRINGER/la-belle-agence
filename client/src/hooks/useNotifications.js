import { useState, useEffect, useCallback } from 'react'
import api from '../services/api.js'

export function useNotifications() {
  const [notifications, setNotifications] = useState([])
  const [unreadCount, setUnreadCount] = useState(0)

  const load = useCallback(async () => {
    try {
      const res = await api.get('/notifications')
      const data = res.data.data || []
      setNotifications(data)
      setUnreadCount(data.filter((n) => !n.is_read).length)
    } catch {
      // silently fail
    }
  }, [])

  useEffect(() => {
    load()
    const interval = setInterval(load, 30000) // Poll toutes les 30s
    return () => clearInterval(interval)
  }, [load])

  const markRead = async (ids) => {
    await api.patch('/notifications/read', { ids })
    load()
  }

  return { notifications, unreadCount, markRead, refresh: load }
}

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://pjfqhrdnxncbpdnehawl.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqZnFocmRueG5jYnBkbmVoYXdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE5MjExMTEsImV4cCI6MjA4NzQ5NzExMX0.PugVZ6aVKx0aDOhQmesbUYcxAmMIyjcGVhQK_fH4Jrs'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

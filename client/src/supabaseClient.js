import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://bvrfyvekxxxqkumjylfw.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2cmZ5dmVreHh4cWt1bWp5bGZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk1MDIxODcsImV4cCI6MjA4NTA3ODE4N30.tjRvXxoKr6zWQ5XHnLFIyTfd-y663-AboXo0lYFIaSU'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

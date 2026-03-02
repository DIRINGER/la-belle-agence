import { createClient } from '@supabase/supabase-js'
import { env } from './env.js'

// Client admin avec service_role — contourne les RLS policies
// À utiliser côté serveur uniquement, jamais exposé au client
export const supabase = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
)

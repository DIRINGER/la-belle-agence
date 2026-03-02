import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import { env } from './config/env.js'
import { errorHandler } from './middleware/errorHandler.js'
import authRoutes from './routes/auth.routes.js'
import usersRoutes from './routes/users.routes.js'
import budgetRoutes from './routes/budget.routes.js'
import recruitmentRoutes from './routes/recruitment.routes.js'
import eventsRoutes from './routes/events.routes.js'
import agenciesRoutes from './routes/agencies.routes.js'

const app = express()

app.use(cors({ origin: env.CLIENT_URL, credentials: true }))
app.use(express.json())

app.get('/api/v1/health', (_req, res) => res.json({ status: 'ok' }))

app.use('/api/v1/auth', authRoutes)
app.use('/api/v1/users', usersRoutes)
app.use('/api/v1/budget', budgetRoutes)
app.use('/api/v1/recruitment', recruitmentRoutes)
app.use('/api/v1/events', eventsRoutes)
app.use('/api/v1/agencies', agenciesRoutes)

app.use(errorHandler)

app.listen(env.PORT, () => {
  console.log(`🚀 Serveur démarré sur le port ${env.PORT} (${env.NODE_ENV})`)
})

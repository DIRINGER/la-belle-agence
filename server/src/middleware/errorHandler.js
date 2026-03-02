export const errorHandler = (err, req, res, _next) => {
  console.error(`[${new Date().toISOString()}] ${err.message}`, err.stack)

  if (err.status) {
    return res.status(err.status).json({
      success: false,
      error: { code: err.code || 'ERROR', message: err.message },
    })
  }

  res.status(500).json({
    success: false,
    error: { code: 'INTERNAL_ERROR', message: 'Erreur serveur interne' },
  })
}

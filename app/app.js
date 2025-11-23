const express = require('express');
const app = express();

// Get configuration from environment variables
// These will come from ConfigMap and Secret in Kubernetes
const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || 'CSOD App';
const ENVIRONMENT = process.env.ENVIRONMENT || 'development';
const DATABASE_URL = process.env.DATABASE_URL || 'not-set';
const API_KEY = process.env.API_KEY || 'not-set';
const API_SECRET = process.env.API_SECRET || 'not-set';

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

// Main test endpoint at /test
app.get('/test', (req, res) => {
  res.status(200).json({
    message: 'Test endpoint working!',
    app: APP_NAME,
    environment: ENVIRONMENT,
    timestamp: new Date().toISOString(),
    config: {
      port: PORT,
      database_url_set: DATABASE_URL !== 'not-set',
      api_key_set: API_KEY !== 'not-set',
      api_secret_set: API_SECRET !== 'not-set'
    },
    headers: req.headers,
    query: req.query
  });
});

// Test POST endpoint
app.post('/test', express.json(), (req, res) => {
  res.status(200).json({
    message: 'POST request received',
    body: req.body,
    timestamp: new Date().toISOString()
  });
});

// Test database connection endpoint
app.get('/test/db', (req, res) => {
  res.status(200).json({
    message: 'Database connection test',
    database_url: DATABASE_URL.substring(0, 20) + '...', // Show only first 20 chars for security
    status: DATABASE_URL !== 'not-set' ? 'configured' : 'not configured'
  });
});

// Test API credentials endpoint
app.get('/test/api', (req, res) => {
  res.status(200).json({
    message: 'API credentials test',
    api_key_length: API_KEY.length,
    api_secret_length: API_SECRET.length,
    status: API_KEY !== 'not-set' && API_SECRET !== 'not-set' ? 'configured' : 'not configured'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    path: req.path,
    message: 'The requested endpoint does not exist'
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log('='.repeat(60));
  console.log(`${APP_NAME} started successfully`);
  console.log(`Environment: ${ENVIRONMENT}`);
  console.log(`Port: ${PORT}`);
  console.log(`Time: ${new Date().toISOString()}`);
  console.log('='.repeat(60));
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully...');
  process.exit(0);
});

module.exports = app; // export app for testing

// Start server only if not in test mode
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, '0.0.0.0', () => {
    console.log('='.repeat(60));
    console.log(`${APP_NAME} started successfully`);
    console.log(`Environment: ${ENVIRONMENT}`);
    console.log(`Port: ${PORT}`);
    console.log(`Time: ${new Date().toISOString()}`);
    console.log('='.repeat(60));
  });
}


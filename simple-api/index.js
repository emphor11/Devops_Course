const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({
    status: 'success',
    message: 'API is up and running!',
    timestamp: new Date().toISOString()
  });
});

app.get('/', (req, res) => {
  res.send('Welcome to the Simple API. Check /health for status.');
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`🚀 Server is running on http://localhost:${port}`);
  });
}

module.exports = app;

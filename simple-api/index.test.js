const request = require('supertest');
const app = require('./index');

describe('API Routes', () => {
  test('GET /health should return status 200', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('status', 'success');
  });

  test('GET / should return frontend page', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.text).toContain('Simple API Dashboard');
  });
});

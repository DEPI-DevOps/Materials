const request = require('supertest');
const app = require('./index');

describe('GET /', () => {
  it('should respond with the index.html file', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.header['content-type']).toBe('text/html; charset=UTF-8');
  });
});

const request = require("supertest");
const app = require("../app");

describe("API Test", () => {

  test("GET /health should return healthy", async () => {
    const res = await request(app).get("/health");
    expect(res.status).toBe(200);
    expect(res.body.status).toBe("healthy");
  });

  test("GET /test should return test message", async () => {
    const res = await request(app).get("/test");
    expect(res.status).toBe(200);
    expect(res.body.message).toBe("Test endpoint working!");
  });

});


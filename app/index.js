const fastify = require("fastify")({ logger: true });
fastify.get("/", async () => {
  return { message: "Welcome to Fastify!" };
});

fastify.get("/health", async () => {
  return { status: "ok working " };
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: "0.0.0.0" });
    console.log("hai Server running on http://localhost:3000");
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();

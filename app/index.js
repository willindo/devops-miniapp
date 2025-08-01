const fastify = require("fastify")({ logger: true });
fastify.get("/", async () => {
  return { message: "Welcome check to Fastify!" };
});

fastify.get("/health", async () => {
  return { status: "ok nice added what working " };
});
fastify.get("/user", async () => {
  return { message: "User endpoint is working!" };
});


const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: "0.0.0.0" });
    console.log(" Server running on http://localhost:3000");
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();

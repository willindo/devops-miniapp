const fastify = require('fastify')({ logger: true });

fastify.get('/health', async () => {
  return { status: 'ok' };
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: '0.0.0.0' });
    console.log(' Server running on http://localhost:3000');
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();

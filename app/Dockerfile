# Dockerfile.dev
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --save-dev nodemon

COPY . .

EXPOSE 3000

CMD ["npx", "nodemon", "--legacy-watch", "index.js"]


#!/bin/bash

set -e

PROJECT=devops-miniapp
DOCKER_USER="your-badshanoordeen"   # <-- Change this

echo "Creating project structure..."
mkdir -p $PROJECT/{app,k8s/base,.github/workflows,argocd}

# --- app/index.js ---
cat > $PROJECT/app/index.js <<EOF
const fastify = require('fastify')({ logger: true });

fastify.get('/health', async () => {
  return { status: 'ok' };
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: '0.0.0.0' });
    console.log('Server running on http://localhost:3000');
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
EOF

# --- app/package.json ---
cat > $PROJECT/app/package.json <<EOF
{
  "name": "devops-miniapp",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "fastify": "^4.0.0"
  }
}
EOF

# --- app/Dockerfile ---
cat > $PROJECT/app/Dockerfile <<EOF
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
EOF

# --- k8s/base/deployment.yaml ---
cat > $PROJECT/k8s/base/deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-miniapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: devops-miniapp
  template:
    metadata:
      labels:
        app: devops-miniapp
    spec:
      containers:
        - name: devops-miniapp
          image: $DOCKER_USER/devops-miniapp:latest
          ports:
            - containerPort: 3000
EOF

# --- k8s/base/service.yaml ---
cat > $PROJECT/k8s/base/service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: devops-miniapp
spec:
  type: NodePort
  selector:
    app: devops-miniapp
  ports:
    - port: 80
      targetPort: 3000
      nodePort: 30080
EOF

# --- k8s/kustomization.yaml ---
cat > $PROJECT/k8s/kustomization.yaml <<EOF
resources:
  - base/deployment.yaml
  - base/service.yaml
EOF

# --- .github/workflows/ci.yml ---
cat > $PROJECT/.github/workflows/ci.yml <<EOF
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Log in to DockerHub
      uses: docker/login-action@v2
      with:
        username: \${{ secrets.badsha }}
        password: \${{ secrets.Newword/1 }}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: ./app
        push: true
        tags: $DOCKER_USER/devops-miniapp:latest
EOF

# --- argocd/app.yaml ---
cat > $PROJECT/argocd/app.yaml <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-miniapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/willindo/$PROJECT
    targetRevision: HEAD
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

# --- README.md ---
cat > $PROJECT/README.md <<EOF
# DevOps MiniApp

A sample DevOps project with:

- Fastify Node.js app
- Dockerized container
- Kubernetes deployment using Kustomize
- GitHub Actions CI
- ArgoCD GitOps CD

## Run locally (optional)

\`\`\`bash
docker build -t devops-miniapp ./app
docker run -p 3000:3000 devops-miniapp
\`\`\`
EOF

echo "✅ Project created at: $PROJECT"

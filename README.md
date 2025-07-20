# DevOps MiniApp

A sample DevOps project with:

- Fastify Node.js app
- Dockerized container
- Kubernetes deployment using Kustomize
- GitHub Actions CI
- ArgoCD GitOps CD

## Run locally (optional)

```bash
docker build -t devops-miniapp ./app
docker run -p 3000:3000 devops-miniapp
```
  
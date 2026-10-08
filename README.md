# CloudForge ☁️

A cloud-native DevOps portfolio project demonstrating application containerization, Kubernetes deployment, infrastructure as code, and AWS integration.

## Overview

CloudForge is a Python Flask API packaged with Docker and deployed to a local Kubernetes cluster using Helm.

The project also includes Terraform configuration for AWS infrastructure, including networking, compute, load balancing, IAM, and Amazon ECR.

## Technology Stack

- **Application:** Python, Flask, Gunicorn
- **Containers:** Docker
- **Orchestration:** Kubernetes (k3d)
- **Package Management:** Helm
- **Infrastructure as Code:** Terraform
- **Cloud:** AWS (ECR, EC2, VPC, ALB, IAM)
- **Version Control:** Git and GitHub

## Verified Results

- Docker image built successfully
- Docker image pushed to Amazon ECR
- Kubernetes cluster running locally with k3d
- Application deployed successfully using Helm
- Two application Pods running and ready
- `/health` endpoint returned HTTP 200
- `/ready` endpoint returned a ready status
- `/version` endpoint returned application version information
- Terraform configuration passed validation

## Deployment Status

The application has been deployed and tested on local Kubernetes.

Amazon ECR is configured and contains the application image. The full AWS infrastructure defined in Terraform has not yet been deployed.

## API Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | API home |
| `/health` | Health check |
| `/ready` | Readiness check |
| `/version` | Application version |

## Local Kubernetes Deployment

Prerequisites:
- Docker
- k3d
- kubectl
- Helm

Create a local Kubernetes cluster:

```bash
k3d cluster create cloudforge --servers 1 --agents 0 --no-lb
```

### Import Docker Image

```bash
k3d image import cloudforge-api:v0.3 -c cloudforge
```

### Deploy with Helm

```bash
helm install cloudforge ./helm/cloudforge --kube-context k3d-cloudforge
```

### Verify Kubernetes Pods

```bash
kubectl --context k3d-cloudforge get pods
```

### Test the API

Start port-forwarding:

```bash
kubectl --context k3d-cloudforge port-forward svc/cloudforge-api 8085:80
```

In a second terminal:

```bash
curl http://127.0.0.1:8085/health
curl http://127.0.0.1:8085/ready
curl http://127.0.0.1:8085/version
```

# ☁️ CloudForge Platform

### A Hands-On DevOps Platform Built with Kubernetes, GitOps, CI/CD, Monitoring, and Container Security

CloudForge is a DevOps portfolio project demonstrating how to build, containerize, deploy, monitor, and secure a Python application using modern cloud-native tools.

The project includes a Flask REST API backed by PostgreSQL, Kubernetes deployments managed with Helm, GitOps configuration using Argo CD, automated GitHub Actions workflows, and observability with Prometheus and Grafana.

---

## 🏗️ Architecture

```text
                  Developer
                      |
                      v
                 GitHub Repo
                      |
           +----------+----------+
           |                     |
           v                     v
      GitHub Actions       Container Security
       CI Pipeline          Trivy Scanner
           |                     |
           +----------+----------+
                      |
                      v
                 Docker Image
                      |
                      v
                  Kubernetes
                   (k3d)
                      |
              +-------+-------+
              |               |
              v               v
          Flask API       PostgreSQL
              |
              v
       Prometheus Metrics
              |
              v
            Grafana

       Argo CD + Helm: GitOps
```

---

## 🛠️ Technology Stack

| Category | Technologies |
|---|---|
| Application | Python, Flask, Gunicorn |
| Database | PostgreSQL |
| Containers | Docker, Alpine Linux |
| Orchestration | Kubernetes, k3d |
| Packaging | Helm |
| GitOps | Argo CD |
| CI/CD | GitHub Actions |
| Security | Trivy |
| Monitoring | Prometheus, Grafana |
| Logging | Loki, Promtail |
| Infrastructure as Code | Terraform |
| Cloud Infrastructure | AWS configuration (not deployed) |

---

## 🚀 Features

### REST API
- Python Flask application
- PostgreSQL-backed CRUD functionality
- Containerized application
- Non-root container user

### Kubernetes
- Local Kubernetes environment using k3d
- Helm-managed application deployment
- Two running API replicas
- Horizontal Pod Autoscaler configuration
- Persistent storage for PostgreSQL

### CI/CD
- Automated GitHub Actions CI workflow
- Python test execution
- Helm validation
- Container security scanning

### GitOps
- Argo CD Application configuration
- Helm-based deployment management
- Git repository as the source of deployment configuration

### Observability
- Prometheus metrics collection
- Grafana monitoring dashboard
- API replica, CPU, and memory monitoring
- Loki and Promtail logging components

### Security
- Trivy container image vulnerability scanning
- HIGH and CRITICAL vulnerability gate
- Alpine-based Python container image
- Non-root application execution

---

## 🔐 Container Security

CloudForge uses Trivy to scan its container image for known vulnerabilities.

During development, the original Debian-based image produced multiple HIGH-severity findings.

Switching to an Alpine-based Python image reduced the reported findings in the local scan:

| Severity | Local Scan Result |
|---|---|
| HIGH | 0 |
| CRITICAL | 0 |

The GitHub Actions Container Security workflow also passed after the change.

**Note:** Vulnerability scan results reflect the image and vulnerability database at scan time. They do not guarantee that an application is free from security risks.

### Security Workflow

[![Container Security](https://github.com/danielye3005-a11y/cloudforge-platform/actions/workflows/security.yml/badge.svg)](https://github.com/danielye3005-a11y/cloudforge-platform/actions/workflows/security.yml)

---

## 🔄 Continuous Integration

The CI workflow validates the application and deployment configuration.

[![CloudForge CI](https://github.com/danielye3005-a11y/cloudforge-platform/actions/workflows/ci.yml/badge.svg)](https://github.com/danielye3005-a11y/cloudforge-platform/actions/workflows/ci.yml)

The latest verified run after the Alpine migration completed successfully.

---

## 📊 Monitoring

CloudForge includes a Grafana dashboard with panels for:

- Desired API replicas
- Available API replicas
- API CPU usage
- API memory usage
- Pod CPU usage
- Pod memory usage

Prometheus collects Kubernetes metrics used by the dashboard.

### Access Grafana

```bash
kubectl -n monitoring port-forward \
  svc/cloudforge-monitoring-grafana 3000:80
```

Open Grafana locally on port `3000`.

---

## ☸️ Kubernetes & GitOps

The application is deployed to a local k3d Kubernetes cluster.

Helm manages the Kubernetes application resources.

Argo CD tracks the Git repository and Helm configuration.

The application previously reached:

- Argo CD: **Synced**
- Argo CD: **Healthy**
- API Deployment: **2/2 Ready**

**Deployment note:** The latest Alpine image has passed local tests and CI, but has not yet been rolled out to the running Kubernetes deployment.

---

## 🧪 Testing

The project includes automated Python tests.

The latest verified test execution completed with:

```text
5 passed
```

---

## 📁 Repository Structure

```text
cloudforge-platform/
├── .github/workflows/   # CI and security workflows
├── app/                 # Flask application
├── gitops/              # GitOps configuration
├── helm/cloudforge/     # Helm chart
├── k8s/                 # Kubernetes manifests
├── monitoring/          # Observability configuration
├── terraform/           # Infrastructure as Code
├── tests/               # Automated tests
├── Dockerfile           # Application container
└── README.md            # Project documentation
```

---

## ☁️ Infrastructure as Code

The repository includes Terraform configuration for AWS infrastructure.

**Current status:** Infrastructure code is prepared, but AWS resources have not been deployed as part of this project.

---

## 📌 Project Status

| Component | Status |
|---|---|
| Flask API | Implemented |
| PostgreSQL | Running locally in Kubernetes |
| Docker | Working |
| Kubernetes / k3d | Working |
| Helm | Working |
| Argo CD | Synced & Healthy in last verification |
| GitHub Actions CI | Passed |
| Trivy Security Workflow | Passed |
| Prometheus | Working |
| Grafana Dashboard | Working |
| Loki | Working |
| Promtail | Requires troubleshooting |
| Terraform | Configuration prepared |
| AWS Deployment | Not deployed |

---

## 🎯 Project Goals

CloudForge was built to gain practical experience with:

- Containerization
- Kubernetes application deployment
- GitOps workflows
- CI/CD automation
- Container vulnerability management
- Infrastructure as Code
- Monitoring and observability

---

## 👨‍💻 Author

**DevOps Portfolio Project**

Built as a hands-on learning project demonstrating practical DevOps engineering skills.

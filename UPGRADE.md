# CloudForge DevOps Upgrade

CloudForge is a Python Flask API with PostgreSQL, Docker,
Kubernetes, Helm, Pytest, GitHub Actions, and monitoring.

## Added components
- Argo CD: GitOps controller
- Loki and Promtail: centralized logging
- HPA: CPU-based autoscaling configuration
- Trivy: container image security workflow
- Prometheus Flask exporter: dependency for future app metrics integration

## Important notes
- Argo CD is installed, but GitOps application synchronization is not yet configured.
- HPA requires metrics-server and CPU requests on the running Deployment.
- Prometheus Flask exporter is not yet initialized in Flask.
- Grafana dashboards and alert rules require additional configuration.
- AWS infrastructure is not deployed by this script.

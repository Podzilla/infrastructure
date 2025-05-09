# Microservices Kubernetes Infrastructure

This repository contains the Kubernetes configurations for deploying microservices.

## Structure

- `helm/charts/spring-boot-microservice/`: A reusable Helm chart for deploying standard Spring Boot microservices.
- `helm/values/`: Service-specific `values.yaml` files used to configure the Helm chart for each microservice.
- `kubernetes-secrets/`: Documentation and scripts related to securely managing Kubernetes Secrets (plaintext secrets are NOT stored here).
- `kubernetes-gateway/`: Kubernetes manifests related to external access, such as the API Gateway Ingress.

## Prerequisites

1.  A running Kubernetes cluster.
2.  `kubectl` configured to connect to your cluster.
3.  Helm v3+ installed.
4.  An Ingress Controller installed in your cluster (e.g., Nginx Ingress Controller, Traefik, cloud provider default).
5.  Microservice Docker images built and pushed to a container registry accessible by your cluster.
6.  Kubernetes Secrets created securely in your cluster for each microservice (see `kubernetes-secrets/README.md`).

## Workflow

1.  **Build & Push Microservice Images:** Ensure your microservice CI pipelines build and push updated Docker images to your container registry (e.g., `your-registry/auth-backend:v1.0.0`).
2.  **Manage Kubernetes Secrets:** Create or update the necessary Kubernetes Secret resources in your cluster. **Do not commit plaintext secrets to this repository.** Refer to `kubernetes-secrets/README.md` for guidance.
3.  **Deploy/Update Microservices:** Use Helm to deploy or update individual microservices using the common chart and service-specific values.
4.  **Apply API Gateway Ingress:** Apply the Ingress manifest to expose your services externally via the API Gateway.

## Deploying a Microservice

Use the Helm chart with the corresponding service values file. Replace `auth-service` and `-f ./helm/values/auth-service-values.yaml` with the actual service name and file path.

```bash
# To install a new service (first time)
helm install auth-service ./helm/charts/spring-boot-microservice -f ./helm/values/auth-service-values.yaml --create-namespace --namespace your-microservices-namespace

# To upgrade an existing service deployment
helm upgrade auth-service ./helm/charts/spring-boot-microservice -f ./helm/values/auth-service-values.yaml --namespace your-microservices-namespace
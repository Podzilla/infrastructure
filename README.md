# Infrastructure Setup Guide

This guide outlines the steps to set up the core infrastructure components in a Kubernetes cluster, including Argo CD, RabbitMQ, Ingress, and Sealed Secrets.

## Prerequisites

* Access to a Kubernetes cluster.
* `kubectl` installed and configured to connect to your cluster.
* PowerShell (for running the `create_secrets_from_ci.ps1` script).

## Installation Steps

1.  **Open Kubernetes:** Ensure you have access to your Kubernetes cluster.

2.  **Create Development Namespace:**
    ```bash
    kubectl create namespace dev
    ```

3.  **Install Argo CD:**
    * Create the `argocd` namespace:
        ```bash
        kubectl create namespace argocd
        ```
    * Apply the Argo CD installation manifests:
        ```bash
        kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
        ```
    [cite: 1]

4.  **Install RabbitMQ:**
    * Install cert-manager:
        ```bash
        kubectl apply -f [https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml](https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml)
        ```
    * Install the RabbitMQ Messaging Topology Operator:
        ```bash
        kubectl apply -f [https://github.com/rabbitmq/messaging-topology-operator/releases/latest/download/messaging-topology-operator-with-certmanager.yaml](https://github.com/rabbitmq/messaging-topology-operator/releases/latest/download/messaging-topology-operator-with-certmanager.yaml)
        ```
    * Install the RabbitMQ Cluster Operator:
        ```bash
        kubectl apply -f [https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml](https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml)
        ```
    [cite: 1]

5.  **Install Ingress (NGINX Controller):**
    ```bash
    kubectl apply -f [https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml)
    ```
    [cite: 1]

6.  **Install Sealed Secrets:**
    * Apply the Sealed Secrets controller manifest:
        ```bash
        kubectl apply -f [https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml](https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/controller.yaml)
        ```
    * Fetch the kubeseal certificate:
        ```bash
        kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=kube-system -w kubeseal-cert.pem
        ```
    [cite: 1]

7.  **Set Environment Variables Locally:** Set the necessary environment variables on your local machine. (Note: Specific environment variables are not detailed in the provided steps, you may want to add more information here). [cite: 1]

8.  **Create Secrets from CI:** Run the PowerShell script to create secrets:
    ```bash
    .\kubernetes-secrets\create_secrets_from_ci.ps1
    ```
    [cite: 1]

9.  **Apply Argo CD Applications:**
    ```bash
    kubectl apply -f argocd-apps/
    ```
    [cite: 1]

## Accessing Argo CD

1.  **Port Forward the Argo CD Server:**
    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    [cite: 1]

2.  **Access in Browser:** Open your web browser and go to `https://localhost:8080`. [cite: 1]

3.  **Get Initial Admin Password:**
    ```bash
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | % { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
    ```
    [cite: 2]

4.  **Login:** Login with the username `admin` and the retrieved password. [cite: 2]

This README provides a clear overview and step-by-step instructions for setting up your infrastructure components. You can further enhance it by adding sections on configuration, troubleshooting, and specific details about the applications managed by Argo CD.
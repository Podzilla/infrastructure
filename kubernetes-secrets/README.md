# Secure Kubernetes Secret Management

**DO NOT COMMIT PLAINTEXT SECRET FILES (.env, .yaml with base64 data) TO THIS REPOSITORY.**

This directory contains documentation and potentially scripts or encrypted manifests for managing Kubernetes Secrets securely.

## Recommended Methods:

1.  **Manual Creation (for development/testing):**
    * Ensure you have a `secret.env` file locally for the specific microservice (this file should **NEVER** be in Git).
    * Use `kubectl` to create the Secret in your target cluster:
        ```bash
        kubectl create secret generic <service-name>-secrets --from-env-file=path/to/local/secret.env --namespace your-microservices-namespace
        ```
      Replace `<service-name>-secrets` with the name specified in the service's Helm `values.yaml` (e.g., `auth-secrets`).
    * If the secret already exists and you need to update it, you can delete and recreate (simple but causes temporary downtime if pods are rolling) or use a more robust update method (like fetching, modifying, re-applying base64 encoded values).
        ```bash
        kubectl delete secret <service-name>-secrets --namespace your-microservices-namespace
        kubectl create secret generic <service-name>-secrets --from-env-file=path/to/local/secret.env --namespace your-microservices-namespace
        ```

2.  **CI/CD Integration (Recommended for Automation):**
    * Store your sensitive secrets in a secure secret management system (e.g., GitHub Actions Secrets, GitLab CI/CD Variables, HashiCorp Vault, AWS Secrets Manager, Google Secret Manager, Azure Key Vault).
    * Configure your CI/CD pipeline (likely in this `infrastructure` repo's pipeline) to:
        * Fetch the necessary secrets for the service being deployed from the secure store at runtime.
        * Dynamically create or update the Kubernetes Secret resource in the target cluster using the fetched secrets. This might involve generating a temporary `secret.env` file or constructing the Secret YAML directly, then using `kubectl apply` or `kubectl create/replace`.

3.  **Sealed Secrets (for storing encrypted secrets in Git):**
    * If you need to store secret definitions in Git, use Sealed Secrets.
    * Install the Sealed Secrets controller in your cluster.
    * Encrypt your Secret manifest using the `kubeseal` tool and the controller's public key.
    * Store the resulting `SealedSecret` manifest (e.g., `auth-sealed-secret.yaml`) in this directory. This file is safe to commit.
    * The controller in the cluster will automatically decrypt the `SealedSecret` into a regular Kubernetes `Secret`.

**Example Scripts (Illustrative - Adapt for your needs):**

```bash
#!/bin/bash
# kubernetes-secrets/create_auth_secret.sh
# Example script to create auth-secrets from a local file

SERVICE_NAME="auth"
SECRET_NAME="${SERVICE_NAME}-secrets"
NAMESPACE="your-microservices-namespace" # <-- Set your target namespace
ENV_FILE="../../auth-service/secret.env" # <-- Adjust path to your local secret.env

# --- Security Warning ---
# This script reads secrets from a local file. Ensure this file is NOT in Git
# and its permissions are restricted. This method is primarily for manual use.
# For CI/CD, fetching from a secure store is preferred.
# -----------------------

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Secret environment file not found at $ENV_FILE"
    exit 1
fi

echo "Creating/Updating Kubernetes Secret '$SECRET_NAME' in namespace '$NAMESPACE'..."

# Use --dry-run=client and -o yaml to generate the YAML, then apply it.
# This is one way to handle updates idempotently with --from-env-file.
kubectl create secret generic "$SECRET_NAME" --from-env-file="$ENV_FILE" --dry-run=client -o yaml | kubectl apply -f - --namespace "$NAMESPACE"

if [ $? -eq 0 ]; then
    echo "Secret '$SECRET_NAME' created/updated successfully."
else
    echo "Error creating/updating Secret '$SECRET_NAME'."
    exit 1
fi
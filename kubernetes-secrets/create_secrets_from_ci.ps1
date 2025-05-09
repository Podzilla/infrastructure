# Requires: kubectl, kubeseal, and environment variables set

# Auth service (PostgreSQL + SECRET_KEY)
kubectl create secret generic auth-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:AUTH_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:AUTH_DB_PASSWORD" `
  --from-literal=SECRET_KEY="$env:AUTH_SECRET_KEY" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/auth-sealed-secret.yaml

# ERP service (PostgreSQL)
kubectl create secret generic erp-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:ERP_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:ERP_DB_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/erp-sealed-secret.yaml

# Order service (PostgreSQL)
kubectl create secret generic order-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:ORDER_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:ORDER_DB_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/order-sealed-secret.yaml

# Warehouse service (PostgreSQL)
kubectl create secret generic warehouse-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:WAREHOUSE_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:WAREHOUSE_DB_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/warehouse-sealed-secret.yaml

# Cart service (MongoDB)
kubectl create secret generic cart-secrets `
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$env:CART_MONGO_USERNAME" `
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$env:CART_MONGO_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/cart-sealed-secret.yaml

# Courier service (MongoDB)
kubectl create secret generic courier-secrets `
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$env:COURIER_MONGO_USERNAME" `
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$env:COURIER_MONGO_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/courier-sealed-secret.yaml
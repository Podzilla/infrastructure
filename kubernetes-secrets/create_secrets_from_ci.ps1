# Requires: kubectl, kubeseal, and environment variables set



# Auth service (PostgreSQL + SECRET_KEY)
kubectl create secret generic auth-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:AUTH_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:AUTH_DB_PASSWORD" `
  --from-literal=AUTH_DB_NAME="$env:AUTH_DB_NAME" `
  --from-literal=SECRET_KEY="$env:AUTH_SECRET_KEY" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/auth-sealed-secret.yaml

# ERP service (PostgreSQL)
kubectl create secret generic erp-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:ERP_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:ERP_DB_PASSWORD" `
  --from-literal=ERP_DB_NAME="$env:ERP_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/erp-sealed-secret.yaml

# Order service (PostgreSQL)
kubectl create secret generic order-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:ORDER_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:ORDER_DB_PASSWORD" `
  --from-literal=ORDER_DB_NAME="$env:ORDER_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/order-sealed-secret.yaml

# Warehouse service (PostgreSQL)
kubectl create secret generic warehouse-secrets `
  --from-literal=SPRING_DATASOURCE_USERNAME="$env:WAREHOUSE_DB_USERNAME" `
  --from-literal=SPRING_DATASOURCE_PASSWORD="$env:WAREHOUSE_DB_PASSWORD" `
  --from-literal=WAREHOUSE_DB_NAME="$env:WAREHOUSE_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/warehouse-sealed-secret.yaml

# Cart service (MongoDB)
kubectl create secret generic cart-secrets `
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$env:CART_MONGO_USERNAME" `
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$env:CART_MONGO_PASSWORD" `
  --from-literal=CART_DB_NAME="$env:CART_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/cart-sealed-secret.yaml

# Courier service (MongoDB)
kubectl create secret generic courier-secrets `
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$env:COURIER_MONGO_USERNAME" `
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$env:COURIER_MONGO_PASSWORD" `
  --from-literal=COURIER_DB_NAME="$env:COURIER_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/courier-sealed-secret.yaml

kubectl create secret generic mongo-cart-secrets `
  --from-literal=MONGO_INITDB_ROOT_USERNAME="$env:CART_MONGO_USERNAME" `
  --from-literal=MONGO_INITDB_ROOT_PASSWORD="$env:CART_MONGO_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/mongo-cart-sealed-secret.yaml

kubectl create secret generic mongo-courier-secrets `
  --from-literal=MONGO_INITDB_ROOT_USERNAME="$env:COURIER_MONGO_USERNAME" `
  --from-literal=MONGO_INITDB_ROOT_PASSWORD="$env:COURIER_MONGO_PASSWORD" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/mongo-courier-sealed-secret.yaml

# PostgreSQL secrets (all services)
kubectl create secret generic psql-auth-secrets `
  --from-literal=POSTGRES_USER="$env:AUTH_DB_USERNAME" `
  --from-literal=POSTGRES_PASSWORD="$env:AUTH_DB_PASSWORD" `
  --from-literal=POSTGRES_DB="$env:AUTH_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/psql-auth-sealed-secret.yaml

kubectl create secret generic psql-erp-secrets `
  --from-literal=POSTGRES_USER="$env:ERP_DB_USERNAME" `
  --from-literal=POSTGRES_PASSWORD="$env:ERP_DB_PASSWORD" `
  --from-literal=POSTGRES_DB="$env:ERP_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/psql-erp-sealed-secret.yaml

kubectl create secret generic psql-order-secrets `
  --from-literal=POSTGRES_USER="$env:ORDER_DB_USERNAME" `
  --from-literal=POSTGRES_PASSWORD="$env:ORDER_DB_PASSWORD" `
  --from-literal=POSTGRES_DB="$env:ORDER_DB_NAME" `
  --namespace=dev `
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/psql-order-sealed-secret.yaml

kubectl create secret generic psql-warehouse-secrets `
    --from-literal=POSTGRES_USER="$env:WAREHOUSE_DB_USERNAME" `
    --from-literal=POSTGRES_PASSWORD="$env:WAREHOUSE_DB_PASSWORD" `
    --from-literal=POSTGRES_DB="$env:WAREHOUSE_DB_NAME" `
    --namespace=dev `
    --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/psql-warehouse-sealed-secret.yaml



kubectl apply -f kubernetes-secrets/auth-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/erp-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/order-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/warehouse-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/cart-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/courier-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/mongo-cart-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/mongo-courier-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/psql-auth-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/psql-erp-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/psql-order-sealed-secret.yaml
kubectl apply -f kubernetes-secrets/psql-warehouse-sealed-secret.yaml
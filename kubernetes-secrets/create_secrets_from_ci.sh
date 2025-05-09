#!/bin/bash
set -e

# Auth service (PostgreSQL + SECRET_KEY)
kubectl create secret generic auth-secrets \
  --from-literal=SPRING_DATASOURCE_USERNAME="$AUTH_DB_USERNAME" \
  --from-literal=SPRING_DATASOURCE_PASSWORD="$AUTH_DB_PASSWORD" \
  --from-literal=SECRET_KEY="$AUTH_SECRET_KEY" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/auth-sealed-secret.yaml

# ERP service (PostgreSQL)
kubectl create secret generic erp-secrets \
  --from-literal=SPRING_DATASOURCE_USERNAME="$ERP_DB_USERNAME" \
  --from-literal=SPRING_DATASOURCE_PASSWORD="$ERP_DB_PASSWORD" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/erp-sealed-secret.yaml

# Order service (PostgreSQL)
kubectl create secret generic order-secrets \
  --from-literal=SPRING_DATASOURCE_USERNAME="$ORDER_DB_USERNAME" \
  --from-literal=SPRING_DATASOURCE_PASSWORD="$ORDER_DB_PASSWORD" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/order-sealed-secret.yaml

# Warehouse service (PostgreSQL)
kubectl create secret generic warehouse-secrets \
  --from-literal=SPRING_DATASOURCE_USERNAME="$WAREHOUSE_DB_USERNAME" \
  --from-literal=SPRING_DATASOURCE_PASSWORD="$WAREHOUSE_DB_PASSWORD" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/warehouse-sealed-secret.yaml

# Cart service (MongoDB)
kubectl create secret generic cart-secrets \
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$CART_MONGO_USERNAME" \
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$CART_MONGO_PASSWORD" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/cart-sealed-secret.yaml

# Courier service (MongoDB)
kubectl create secret generic courier-secrets \
  --from-literal=SPRING_DATA_MONGODB_USERNAME="$COURIER_MONGO_USERNAME" \
  --from-literal=SPRING_DATA_MONGODB_PASSWORD="$COURIER_MONGO_PASSWORD" \
  --dry-run=client -o yaml |
kubeseal --format yaml --cert kubeseal-cert.pem > kubernetes-secrets/courier-sealed-secret.yaml
#!/bin/bash

# Set the project directory (change this to your project root directory if needed)
PROJECT_DIR=$(pwd)

# Step 1: Start Minikube
echo "Starting Minikube..."
minikube start --driver=docker

# Step 2: Enable Ingress (if you want to expose services through Ingress)
# echo "Enabling Ingress..."
# minikube addons enable ingress

# Step 3: Build the Docker images for frontend and backend
echo "Building frontend Docker image..."
docker build -t frontend $PROJECT_DIR/frontend

echo "Building backend Docker image..."
docker build -t backend $PROJECT_DIR/backend

# Step 4: Set the Minikube Docker environment (so we can use the Minikube Docker daemon)
echo "Setting Minikube Docker environment..."
eval $(minikube -p minikube docker-env)

# Step 5: Build the Docker images in Minikube's Docker environment
echo "Building Docker images inside Minikube..."
docker build -t frontend $PROJECT_DIR/frontend
docker build -t backend $PROJECT_DIR/backend

# Step 6: Apply Kubernetes configurations (create pods, deployments, services)
echo "Applying Kubernetes configurations..."
kubectl apply -f k8s/

# Step 7: Wait for the services to be created and become available
echo "Waiting for the services to be created..."
kubectl rollout status deployment/frontend
kubectl rollout status deployment/backend
kubectl rollout status deployment/mongo

# Step 8: Get the Minikube IP address to access the frontend
MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"

# Step 9: Access the frontend service (frontend should be exposed via NodePort)
FRONTEND_PORT=$(kubectl get svc frontend -o=jsonpath='{.spec.ports[0].nodePort}')
echo "Frontend is accessible at http://$MINIKUBE_IP:$FRONTEND_PORT"

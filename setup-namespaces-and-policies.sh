#!/bin/bash

# Create namespaces
echo "Creating namespaces..."
kubectl create ns mmtc
kubectl create ns embb
kubectl create ns urllc
kubectl create ns core

# Deploy backend and frontend services in each namespace
echo "Deploying services in namespaces..."
kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n mmtc
kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n embb
kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n urllc

# Deploy the core service
echo "Deploying core service..."
kubectl apply -f core-deployment.yaml

# Expose the core service
echo "Exposing core-service with a ClusterIP..."
kubectl apply -f core-service.yaml

# Deploy debug pods in each namespace
echo "Deploying debug pods..."
kubectl run debug-pod -n mmtc --image=nicolaka/netshoot --restart=Never -- sleep 3600
kubectl run debug-pod -n embb --image=nicolaka/netshoot --restart=Never -- sleep 3600
kubectl run debug-pod -n urllc --image=nicolaka/netshoot --restart=Never -- sleep 3600

# Apply existing policies
echo "Applying policies..."
kubectl apply -f mmtc-dns-only.yaml -n mmtc
kubectl apply -f embb-egress-policy.yaml -n embb
kubectl apply -f urllc-to-core.yaml -n urllc
kubectl apply -f urllc-intra-namespace.yaml -n urllc
kubectl apply -f urllc-block-egress.yaml -n urllc

# Apply DNS allow policy for urllc
echo "Applying DNS allow policy for urllc..."
kubectl apply -f allow-dns5g.yaml -n urllc

# Validate setup
echo "Validating setup..."
kubectl get pods -n mmtc
kubectl get pods -n embb
kubectl get pods -n urllc
kubectl get pods -n core
kubectl get svc -n core

echo "Setup complete! Namespaces, services, debug pods, and policies are configured."

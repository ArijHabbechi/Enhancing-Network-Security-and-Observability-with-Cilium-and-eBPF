#!/bin/bash

NAMESPACE="tenant-a"
FRONTEND_POD=$(kubectl get pod -n $NAMESPACE -l app=frontend-service -o jsonpath='{.items[0].metadata.name}')
BACKEND_SERVICE="backend-service"

echo "Simulating traffic from $FRONTEND_POD to $BACKEND_SERVICE..."

# Infinite loop to generate traffic
while true; do
  echo "Requesting backend-service..."
  kubectl exec -n $NAMESPACE $FRONTEND_POD -- curl -s http://$BACKEND_SERVICE:80 > /dev/null
  echo "Request completed!"
  sleep 2  # Adjust the delay as needed
done

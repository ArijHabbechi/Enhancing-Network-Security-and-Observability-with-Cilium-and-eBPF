#!/bin/bash

echo "### Scenario 1: Default Deny with Specific Allow ###"
kubectl apply -f deny-all.yaml
echo "Applied deny-all policy: All traffic should now be denied."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -s http://backend-service:80 || echo "Traffic Denied as expected."

kubectl apply -f allow-http-frontend-to-backend.yaml
echo "Applied allow-http-frontend-to-backend policy: Only HTTP GET traffic should now be allowed."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -s http://backend-service:80 && echo "Traffic Allowed as expected."
kubectl exec -n tenant-a frontend-service -- curl -X POST http://backend-service:80 || echo "POST Denied as expected."

echo "### Cleanup ###"
kubectl delete cnp -n tenant-a deny-all
kubectl delete cnp -n tenant-a allow-http-frontend-to-backend

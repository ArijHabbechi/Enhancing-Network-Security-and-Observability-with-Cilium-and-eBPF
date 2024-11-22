#!/bin/bash

echo "### Scenario 2: L3 Allow with L7 Restriction ###"
kubectl apply -f allow-frontend-to-backend.yaml
echo "Applied allow-frontend-to-backend policy: All traffic from frontend-service should now be allowed."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -X POST http://backend-service:80 && echo "POST Allowed."

kubectl apply -f allow-http-get-only.yaml
echo "Applied allow-http-get-only policy: Only HTTP GET requests should now be allowed."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -s http://backend-service:80 && echo "GET Allowed as expected."
kubectl exec -n tenant-a frontend-service -- curl -X POST http://backend-service:80 || echo "POST Denied as expected."

echo "### Cleanup ###"
kubectl delete cnp -n tenant-a allow-frontend-to-backend
kubectl delete cnp -n tenant-a allow-http-get-only

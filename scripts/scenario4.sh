#!/bin/bash

echo "### Scenario 4: Overlapping Policies (Conflict) ###"
kubectl apply -f allow-all.yaml
echo "Applied allow-all policy: All traffic should now be allowed."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -X POST http://backend-service:80 && echo "POST Allowed."

kubectl apply -f block-http-post.yaml
echo "Applied block-http-post policy: POST requests should now be denied despite allow-all."
sleep 2

kubectl exec -n tenant-a frontend-service -- curl -X POST http://backend-service:80 || echo "POST Denied as expected."
kubectl exec -n tenant-a frontend-service -- curl -s http://backend-service:80 && echo "GET Still Allowed."

echo "### Cleanup ###"
kubectl delete cnp -n tenant-a allow-all
kubectl delete cnp -n tenant-a block-http-post

#!/bin/bash

# Set a timeout for blocked tests
TIMEOUT=5  # Timeout in seconds

echo "Starting tests for the architecture..."

# Function to check if a pod is ready
check_pod_ready() {
  local namespace=$1
  local pod=$2
  kubectl wait --for=condition=Ready pod/$pod -n $namespace --timeout=30s > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "❌ Pod $pod in namespace $namespace is not ready. Skipping related tests."
    return 1
  fi
  return 0
}

# Pre-check for debug pods
echo "Checking if debug pods are ready..."
check_pod_ready "mmtc" "debug-pod" || exit 1
check_pod_ready "embb" "debug-pod" || exit 1
check_pod_ready "urllc" "debug-pod" || exit 1

# Deploy a netshoot pod for comprehensive tests
echo "Deploying netshoot pod for additional tools (if needed)..."
kubectl run netshoot-pod -n urllc --image=nicolaka/netshoot --restart=Never -- sleep 3600
check_pod_ready "urllc" "netshoot-pod"

# Test 1: DNS Resolution in mmtc
echo "Testing DNS resolution in 'mmtc' namespace (Allowed)..."
timeout $TIMEOUT kubectl exec -n mmtc debug-pod -- nslookup google.com
if [ $? -eq 0 ]; then
  echo "✅ DNS resolution in 'mmtc' succeeded."
else
  echo "❌ DNS resolution in 'mmtc' failed. Check CoreDNS or network policies."
fi

# Test 2: External HTTP Traffic in mmtc
echo "Testing external HTTP traffic in 'mmtc' namespace (Blocked)..."
timeout $TIMEOUT kubectl exec -n mmtc debug-pod -- wget -qO- http://example.com
if [ $? -ne 0 ]; then
  echo "✅ External HTTP traffic in 'mmtc' blocked as expected."
else
  echo "❌ External HTTP traffic in 'mmtc' succeeded unexpectedly."
fi

# Test 3: HTTP Traffic to Core in mmtc
echo "Testing HTTP traffic to 'core-service' from 'mmtc' namespace (Blocked)..."
timeout $TIMEOUT kubectl exec -n mmtc debug-pod -- wget -qO- http://core-service.core.svc.cluster.local
if [ $? -ne 0 ]; then
  echo "✅ Traffic to 'core-service' from 'mmtc' blocked as expected."
else
  echo "❌ Traffic to 'core-service' from 'mmtc' succeeded unexpectedly."
fi

# Test 4: External HTTP Traffic in embb
echo "Testing external HTTP traffic in 'embb' namespace (Allowed)..."
timeout $TIMEOUT kubectl exec -n embb debug-pod -- wget -qO- http://example.com
if [ $? -eq 0 ]; then
  echo "✅ External HTTP traffic in 'embb' succeeded as expected."
else
  echo "❌ External HTTP traffic in 'embb' failed unexpectedly."
fi

# Test 5: Cross-Namespace Traffic from embb to urllc
echo "Testing traffic from 'embb' to 'urllc' namespace (Blocked)..."
timeout $TIMEOUT kubectl exec -n embb debug-pod -- wget -qO- http://backend-service.urllc.svc.cluster.local
if [ $? -ne 0 ]; then
  echo "✅ Traffic from 'embb' to 'urllc' blocked as expected."
else
  echo "❌ Traffic from 'embb' to 'urllc' succeeded unexpectedly."
fi

# Test 6: Communication to Core from urllc
echo "Testing traffic to 'core-service' from 'urllc' namespace (Allowed)..."
timeout $TIMEOUT kubectl exec -n urllc debug-pod -- wget -qO- http://core-service.core.svc.cluster.local
if [ $? -eq 0 ]; then
  echo "✅ Traffic to 'core-service' from 'urllc' succeeded as expected."
else
  echo "❌ Traffic to 'core-service' from 'urllc' failed unexpectedly. Check policies or CoreDNS."
fi

# Test 7: Intra-Namespace Communication in urllc (Frontend to Backend)
echo "Testing intra-namespace communication in 'urllc' namespace (Allowed: frontend to backend)..."
timeout $TIMEOUT kubectl exec -n urllc frontend-service -- wget -qO- http://backend-service.urllc.svc.cluster.local
if [ $? -eq 0 ]; then
  echo "✅ Frontend-to-backend communication in 'urllc' succeeded as expected."
else
  echo "❌ Frontend-to-backend communication in 'urllc' failed unexpectedly. Verify pod labels or policies."
fi

# Test 8: Blocked Intra-Namespace Communication in urllc (Other Pods to Backend)
echo "Testing blocked communication to backend-service from other pods in 'urllc' namespace..."
timeout $TIMEOUT kubectl exec -n urllc debug-pod -- wget -qO- http://backend-service.urllc.svc.cluster.local
if [ $? -ne 0 ]; then
  echo "✅ Other pods to backend communication in 'urllc' blocked as expected."
else
  echo "❌ Other pods to backend communication in 'urllc' succeeded unexpectedly."
fi

echo "Cleaning up netshoot pod..."
kubectl delete pod netshoot-pod -n urllc > /dev/null 2>&1

echo "All tests completed!"

# User Guide

## Deploying a Network Policy
1. Apply a policy:
   ```bash
   kubectl apply -f policies/allow-http.yaml
   ```

2. Verify the policy:
   ```bash
   kubectl get cnp
   ```

## Monitoring with Hubble
1. Install Hubble CLI:
   ```bash
   curl -L --remote-name https://github.com/cilium/hubble/releases/latest/download/hubble-linux-amd64.tar.gz
   tar -xvzf hubble-linux-amd64.tar.gz
   mv hubble /usr/local/bin
   ```

2. Observe network traffic:
   ```bash
   hubble observe
   ```

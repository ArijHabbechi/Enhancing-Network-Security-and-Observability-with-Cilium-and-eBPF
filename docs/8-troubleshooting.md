# Troubleshooting

## Issue: Policy not applied
- **Solution**: Verify the policy syntax and Cilium logs:
  ```bash
  kubectl logs -n kube-system -l k8s-app=cilium
  ```

## Issue: No traffic observed
- **Solution**: Ensure Hubble is running:
  ```bash
  kubectl get pods -n kube-system | grep hubble
  ```

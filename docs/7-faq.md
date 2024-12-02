# Frequently Asked Questions

## How do I install Cilium?
Refer to the [Installation Guide](installation.md).

## How do I debug network issues?
Use Hubble CLI:
```bash
hubble observe --since 1h
```

## How do I reset policies?
```bash
kubectl delete -f policies/
```

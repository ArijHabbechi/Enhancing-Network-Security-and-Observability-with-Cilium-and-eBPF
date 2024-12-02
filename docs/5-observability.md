# Observability with eBPF and Hubble

## Introduction
eBPF provides in-kernel programmability for efficient observability and security.

## Setting Up Observability
1. Enable Hubble in Cilium:
   ```bash
   helm upgrade cilium cilium/cilium --namespace kube-system --set hubble.relay.enabled=true --set hubble.ui.enabled=true
   ```

2. Access Hubble UI:
   ```bash
   hubble ui
   ```

3. Observe flows:
   ```bash
   hubble observe
   ```

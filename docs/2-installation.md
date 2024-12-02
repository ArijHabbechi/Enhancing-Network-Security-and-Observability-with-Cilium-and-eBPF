# Installation Guide

## Prerequisites
- Kubernetes cluster
- Docker
- Helm

## Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/ArijHabbechi/Enhancing-Network-Security-and-Observability-with-Cilium-and-eBPF.git
   cd Enhancing-Network-Security-and-Observability-with-Cilium-and-eBPF
   ```

2. Install Cilium:
   ```bash
   helm install cilium cilium/cilium --namespace kube-system
   ```

3. Deploy configurations:
   ```bash
   kubectl apply -f configs/
   ```

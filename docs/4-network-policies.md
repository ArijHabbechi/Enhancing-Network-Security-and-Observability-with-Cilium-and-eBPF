# Network Policies

## Policy Examples
1. **Allow HTTP Traffic**:
   ```yaml
   apiVersion: cilium.io/v2
   kind: CiliumNetworkPolicy
   metadata:
     name: allow-http
   spec:
     endpointSelector:
       matchLabels:
         app: web
     ingress:
       - fromEndpoints:
           - matchLabels:
               app: backend
         toPorts:
           - ports:
               - port: "80"
                 protocol: TCP
   ```

2. **Deny All Traffic**:
   ```yaml
   apiVersion: cilium.io/v2
   kind: CiliumNetworkPolicy
   metadata:
     name: deny-all
   spec:
     endpointSelector:
       matchLabels: {}
     ingress: []
   ```

## Use Cases
- Protecting backend services.
- Isolating namespaces.
- Egress restrictions for compliance.

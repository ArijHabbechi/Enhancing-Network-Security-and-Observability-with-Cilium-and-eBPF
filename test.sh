kubectl create ns tenant-a
kubectl create ns tenant-b
kubectl create ns tenant-c

kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n tenant-a

kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n tenant-b

kubectl apply -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/tenant-services.yaml -n tenant-c

kubectl apply -n tenant-a -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/allow-all-within-ns.yaml

kubectl apply -n tenant-a -f https://raw.githubusercontent.com/seanmwinn/cilium-hands-on-lab/master/to-dns-only.yaml

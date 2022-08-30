---
title: "Kubernetes setup using kind"
date: 2022-05-26
draft: false
authors:
- bhuwanupadhyay
categories:
- Kubernetes
tags:
- kind
- metallb
- nginx-ingress
---

This article explains method of installing the kubernetes cluster locally using kind tool. Also, it describes how to create kubernetes local cluster, install metallb load balancer, enable local docker registry and install nginx ingress controller.

<!--more-->

## Prerequisites

### Build Tools

- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries) used version `v0.14.0`
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)used version `v1.19.8`

> Recommend using the latest version of those tools.

### Environment variables

```bash
# kindest version
export kindest_version='v1.23.0'

# local docker registry name
export reg_name='kind-registry'

# local docker registry container exposed port
export reg_port='5001'
```

## Kubernetes cluster

Following commands will create local kubernetes cluster.

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
# cluster with the local registry enabled in containerd
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:$reg_port"]
    endpoint = ["http://$reg_name:5000"]
nodes:
- role: control-plane
  image: kindest/node:$kindest_version
  kubeadmConfigPatches:
  # cluster with the ingress enabled
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
  image: kindest/node:$kindest_version
EOF
```

Verify pods are running by using following command

```bash
kubectl get pods --all-namespaces -o wide
```

## Docker registry

Following commands will enable local docker registry in local kubernetes cluster.

```bash
# create registry container unless it already exists
docker run -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" registry:2

# connect the registry to the cluster network if not already connected
docker network connect "kind" "${reg_name}"

# Document the local registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:$reg_port"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF
```

## MetalLB load balancer

Following commands will install metallb load balancer in local kubernetes cluster.

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

kubectl wait deployment -n metallb-system controller --for condition=Available=True --timeout=90s

IP=$(docker network inspect -f '{{.IPAM.Config}}' kind | awk '{print $1}' | awk '{ split(substr($1,3), i,"."); print i[1]"."i[2]}')

echo "Kind Network IP Prefix: $IP"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $IP.255.200-$IP.255.250
EOF

kubectl rollout restart deployment -n metallb-system controller
```

## Nginx Ingress Controller

Following commands will install ngnix ingress controller in local kubernetes cluster.

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Example Usage

### Using local registry

Following commands will use local docker registry to push docker images.

```bash
# pull an image
docker pull hashicorp/http-echo:0.2.3

# tag the image to use the local registry
docker tag hashicorp/http-echo:0.2.3 localhost:5001/http-echo:0.2.3

# push it to the registry
docker push localhost:5001/http-echo:0.2.3
```

### Using metallb loadbalancer

All the requests incoming to this loadbalancer ip address will be routed in ngnix service.

```bash
# get external ip for loadbalancer service
export LB_IP=$(kubectl get svc/ingress-nginx-controller -n ingress-nginx -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') && echo $LB_IP
```

### Using ngnix ingress controller

Following commands will deploy simple application with ingress host url.

```bash
# configure root domain for foo service
export ROOT_DOMAIN='localdev.me'

# apply manifests for foo service
cat <<EOF | kubectl apply -f -
---
kind: Namespace
apiVersion: v1
metadata:
  name: foo-system
---
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  namespace: foo-system
  labels:
    app: foo
spec:
  containers:
  - name: foo-app
    image: localhost:5001/http-echo:0.2.3
    args:
    - "-text=foo"
---
kind: Service
apiVersion: v1
metadata:
  name: foo-service
  namespace: foo-system
spec:
  selector:
    app: foo
  ports:
  - port: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: foo-ingress
  namespace: foo-system
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: foo.$ROOT_DOMAIN
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: foo-service
            port:
              number: 5678
---
EOF
```

Verify ingress host url for foo service:

- Using directly host url

```bash
# append host url in /etc/hosts file
printf "%s\t%s\n" "$LB_IP" "foo.$ROOT_DOMAIN" | sudo tee -a /etc/hosts > /dev/null

# verify /etc/hosts
cat /etc/hosts

# get foo service
curl -D- http://foo.$ROOT_DOMAIN
```

- Using external ip address and host header

```bash
curl -D- http://$LB_IP -H "Host: foo.$ROOT_DOMAIN"
```

## Cleanup resources

Following commands will delete local kubernetes cluster and other resources.

```bash
# delete cluster
kind delete cluster

# delete local registry
docker rm -f -v kind-registry

# manually remove line if added in /etc/hosts using above `printf` command while testing `Using directly host url`
sudo vi /etc/hosts
```

## References

- <https://kind.sigs.k8s.io/>
- <https://kubernetes.github.io/ingress-nginx/>
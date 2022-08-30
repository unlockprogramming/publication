---
title: "Logging kubernetes using loki"
date: 2022-06-19
draft: false
authors:
- bhuwanupadhyay
categories:
- Kubernetes
tags:
- loki
- logging
---

This article explains method of installing the helm chart `loki-stack` in kubernetes cluster. Also, it describes how to configure `loki-stack` with grafana dashboard to see loging from application that running in kubernetes cluster.

<!--more-->

## Prerequisites

### Packages & Tools

- [kubernetes cluster should be ready]({{< ref "/blog/kubernetes/kubernetes-setup-using-kind" >}})
- [kube-prometheus-stack should be already installed]({{< ref "/blog/kubernetes/notification-using-kube-prometheus-stack" >}})

### Environment variables

```bash
export LOG_STORAGE_SIZE="5Gi"
```

## Install Loki Stack

Add helm repository and update charts.

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Below command is used to download [values.yaml](https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/logging-kubernetes-using-loki/values.yaml) and replace with environment variables.

```bash
curl -o values.raw.yaml https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/logging-kubernetes-using-loki/values.yaml && \
envsubst < "values.raw.yaml" > "values.out.yaml" && rm -rf values.raw.yaml
```

Install `loki-stack` chart.

```bash
helm upgrade --install --wait --timeout 600s loki grafana/loki-stack \
  --version 2.6.5 \
  --namespace monitoring --create-namespace \
  -f values.out.yaml
```

## Port Forwarding

Visit here for [how to port forward to access grafana dashboard]({{< ref "/blog/kubernetes/notification-using-kube-prometheus-stack" >}}#grafana).

## App Deployment

```bash
curl -o foo.raw.yaml https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/logging-kubernetes-using-loki/deployment.yaml && \
envsubst < "foo.raw.yaml" > "foo.out.yaml" && rm -rf foo.raw.yaml && \
kubectl apply -f foo.out.yaml
```

## Explore Log Output

![Grafana](loki-logging-output.png?width=800px&height=700px)
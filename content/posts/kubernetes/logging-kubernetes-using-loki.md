+++
draft = false
author = "Bhuwan Prasad Upadhyay"
title = "Logging kubernetes using loki"
date = "2022-06-19"
description = "A brief description of Hugo Shortcodes"
featured = false
comment = true
toc = true
categories = [
  "Kubernetes"
]
tags = [
    "loki",
    "loki-stack",
    "logging",
]
images = [
]
+++

This article explains method of installing the helm chart `loki-stack` in kubernetes cluster. Also, it describes how to configure `loki-stack` with grafana dashboard to see loging from application that running in kubernetes cluster.

<!--more-->

## Prerequisites

### Packages & Tools

- [kubernetes cluster should be ready]({{< ref "/posts/kubernetes/kubernetes-setup-using-kind" >}})
- [kube-prometheus-stack should be already installed]({{< ref "/posts/kubernetes/notification-using-kube-prometheus-stack" >}})

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

Visit here for [how to port forward to access grafana dashboard]({{< ref "/posts/kubernetes/notification-using-kube-prometheus-stack" >}}#grafana).

## App Deployment

```bash
curl -o foo.raw.yaml https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/logging-kubernetes-using-loki/deployment.yaml && \
envsubst < "foo.raw.yaml" > "foo.out.yaml" && rm -rf foo.raw.yaml && \
kubectl apply -f foo.out.yaml
```

## Explore Log Output

![Grafana](/images/posts/loki-logging-output.png?width=800px&height=700px)

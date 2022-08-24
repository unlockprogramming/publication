+++
draft = false
author = "Bhuwan Prasad Upadhyay"
title = "Metrics server setup in kubernetes"
date = "2022-06-01"
description = "A detailed blog post that shows how to set up metrics server in kubernetes and see metrics from cluster."
featured = false
comment = true
toc = true
categories = [
"Kubernetes"
]
tags = [
"metrics-server"
]
images = [
]
+++

This article explains method of installing the helm chart `metrics-server` in kubernetes cluster. Also, it shows how to use different commands to see metrics details from cluster.

<!--more-->

## Introduction

The metrics server collects metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API.

## Install Metrics Server

Add helm repository and update charts.

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
```

Install `metrics-server` chart.

```bash
helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system
```

The above steps install metrics server in kubernetes cluster, however in local cluster for example cluster created by kind need extra argument to support without CA verification.

Following command can be used to install metrics server in kind local kubernetes cluster.

```bash
helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system --set 'args[0]=--kubelet-insecure-tls'
```

## Useful Commands

Once Metrics Server is installed in the cluster, we can fetch metrics like current CPU and memory utilization from the Metrics API by using `kubectl top` command.

### View top nodes

Following command to display resource usage of all cluster nodes.

```bash
kubectl top nodes
```

### View top pods

Following command to display resource usage of pods for specified namespace.

```bash
kubectl top pod --namespace <namespace>
```

### View top containers

Following command to display resource usage of containers for specified namespace and pod.

```bash
kubectl top pod <pod> --namespace <namespace> --containers
```

### View node details

Following command to display resource usage for specified node

```bash
kubectl describe node <node>
```

## References

- [metrics-server](https://github.com/kubernetes-sigs/metrics-server)
- [kubectl top](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#top)

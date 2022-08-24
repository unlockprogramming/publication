+++
draft = false
author = "Bhuwan Prasad Upadhyay"
title = "Notification using kube prometheus stack"
date = "2022-06-12"
description = "A detailed blog post that shows how to set up kube prometheus stack in kubernetes cluster to publish email and slack notifications."
featured = false
comment = true
toc = true
categories = [
"Kubernetes"
]
tags = [
"grafana",
"prometheus",
"alertmanager",
"kube-prometheus-stack",
]
images = [
]
+++

This article explains method of installing the helm chart `kube-prometheus-stack` in kubernetes cluster. Also, it describes how to configure `kube-prometheus-stack` to publish notification using email and slack channel to get insight from running kubernetes cluster.

<!--more-->

## Prerequisites

### Packages & Tools

- [kubernetes cluster should be ready]({{< ref "/posts/kubernetes/kubernetes-setup-using-kind" >}})
- [metrics-server should be already installed]({{< ref "/posts/kubernetes/metrics-server-setup-in-kubernetes" >}})

### Environment variables

```bash
export SMTP_HOSTNAME="smtp.mailtrap.io"
export SMTP_HOSTPORT="2525"
export SMTP_FROM="from@example.com"
export SMTP_USERNAME="username"
export SMTP_PASSWORD="password"
export SMTP_REQUIRE_TLS="true"
export SMTP_SKIP_SSL_VERIFY="false"
export LOG_LEVEL="debug"
export EMAIL_ADDRESS="to@example.com"
export SLACK_INCOMING_WEBHOOK_URL="https://hooks.slack.com/services/XXXX"
export SLACK_CHANNEL="#monitoring-test"
export HTTP_SCHEME="http"
export CLUSTER_FQDN="localnetwork.dev"
export ALERTMANAGER_EXTERNAL_HOST="localhost:9093"
export PROMETHEUS_EXTERNAL_HOST="localhost:9090"
export N_BYTES=50000000
export N_TIMES=30
```

## Install Kube Prometheus Stack

Add helm repository and update charts.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Below command is used to download [values.yaml](https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/notification-using-kube-prometheus-stack/values.yaml) and replace with environment variables.

```bash
curl -o values.raw.yaml https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/notification-using-kube-prometheus-stack/values.yaml && \
envsubst < "values.raw.yaml" > "values.out.yaml" && rm -rf values.raw.yaml
```

Install `kube-prometheus-stack` chart.

```bash
helm upgrade --install --wait --timeout 600s prometheus prometheus-community/kube-prometheus-stack \
  --version 36.0.2 \
  --namespace monitoring --create-namespace \
  -f values.out.yaml
```

## Port Forwarding

### Grafana

Kubectl port-forwarding can be used to connect to the grafana server without exposing the service.

```bash
kubectl port-forward svc/prometheus-grafana -n monitoring 8088:80
```

The grafana server can then be accessed using following url [http://localhost:8088](http://localhost:8088)

You can simply retrieve grafana admin user and this user initial password using `kubectl`:

```bash
eval "echo \"username=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 -d)\""
eval "echo \"password=$(kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d)\""
```

### Prometheus

Kubectl port-forwarding can be used to connect to the prometheus server without exposing the service.

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

The prometheus server can then be accessed using url [http://localhost:9090](http://localhost:9090).

### AlertManager

Kubectl port-forwarding can be used to connect to alertmanager server without exposing the service.

```bash
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager -n monitoring 9093:9093
```

The alertmanger server can then be accessed using url [http://localhost:9093](http://localhost:9093).

## Testing alerts

Create prometheus rule for an alert when container memory use is above 80%.

```bash
kubectl apply -f https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/notification-using-kube-prometheus-stack/docker-containers.yaml
```

## App Deployment

Let's run foo system application to load `N_TIMES` of `N_BYTES` data into the memory.

```bash
curl -o foo.raw.yaml https://raw.githubusercontent.com/unlockprogramming/kubernetes/main/notification-using-kube-prometheus-stack/deployment.yaml && \
envsubst < "foo.raw.yaml" > "foo.out.yaml" && rm -rf foo.raw.yaml && \
kubectl apply -f foo.out.yaml
```

After some time, you will receive notification message on your slack channel and email address that you defined in your configuration for `kube-prometheus-stack`.

## References
- [kube-prometheus-stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)
- [sending-alert-notifications-to-multiple-destinations](https://www.robustperception.io/sending-alert-notifications-to-multiple-destinations)
- [awesome-prometheus-alerts](https://github.com/samber/awesome-prometheus-alerts/blob/master/dist/rules/docker-containers/google-cadvisor.yml)
- [grafana-contact-points](https://grafana.com/docs/grafana/next/alerting/contact-points/)
+++
draft = false
title = "Kubernetes command line snippets"
date = "2022-05-21"
+++

My curated list of kubernetes command line snippets that might be useful for developer.

<!--more-->

## List all container images loaded inside k8s nodes

```bash
kubectl get nodes -o json | jq -r '.items[].status.images[] | .names[1]' | awk '$1 != "null"' | awk '$1 !~ /\.dkr\.ecr\./'  | sort | uniq -c
```

## List all container images running inside k8s cluster 

```bash
kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c
```
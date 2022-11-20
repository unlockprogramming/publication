---
title: "List of docker some useful commands"
date: "2022-09-15"
draft: false
authors: bhuwanupadhyay
categories:
- Docker
---

This note contains list of some very useful commands.

<!--more-->

- To stop all running containers

```bash
docker stop $(docker ps -a -q)
```

- Cleanup all docker resources

```bash
docker system prune && docker volume prune
```

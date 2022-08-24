+++
draft = false
title = "Block sites in ubuntu"
date = "2022-05-21"
+++

In this note, We will explore how to block some websites in ubuntu machine.

<!--more-->

## Open `/etc/hosts` in editor

```bash
sudo gedit /etc/hosts
```

## Modify `/etc/host`

We can add list of website to block them from our local machine.

```text
127.0.0.1 facebook.com
127.0.0.1 www.facebook.com
127.0.0.1 www.youtube.com
127.0.0.1 youtube.com
127.0.0.1 anynews.anydomain
```

## Restart hosts changes

```bash
pkill -HUP dnsmasq
```

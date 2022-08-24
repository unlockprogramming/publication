+++
draft = false
title = "Networking command line snippets"
date = "2022-05-21"
+++

My curated list of networking command line snippets that might be useful for developer.

<!--more-->

## Edit `/etc/hosts`

```bash
export IP=192.168.1.1
export HOSTNAME='abc.localdev.me'

printf "%s\t%s\n" "$IP" "$HOSTNAME" | sudo tee -a /etc/hosts > /dev/null
```

## Expose local machine port using `ngrok`

```bash
# for localhost
ngrok http 8080

# for non localhost or specific ip address
ngrok http 192.168.1.1:8080
```

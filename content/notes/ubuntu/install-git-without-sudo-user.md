

---
title: "Install git without sudo user"
date: 2022-11-15
draft: false
authors:
- bhuwanupadhyay
categories:
- Ubuntu
tags:
- git
- sudo
- rootless
---

In this note, We will explore how to install git without sudo user.

<!--more-->

## Install git without sudo user

```bash
mkdir -p "$HOME/git/"
cd "$HOME/git/"
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.4.tar.gz
tar -xvf git-2.9.4.tar.gz
cd "$HOME/git/git-2.9.4/"
./configure --prefix=$HOME/git/git-2.9.4/
make
make install
./git --version
```

## Update the PATH variable `export PATH=$PATH:$HOME/git/git-2.9.4/`

```bash
vi ~/.bashrc
exec "$SHELL"
```

## Access `git` command

```bash
git version
```
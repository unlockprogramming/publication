# [Unlock Programming](https://unlockprogramming.com)

---

[![Netlify Status](https://api.netlify.com/api/v1/badges/02a40afc-0c92-411b-8015-333f0bf62121/deploy-status)](https://app.netlify.com/sites/unlockprogramming/deploys)

---

This repository contains [unlockprogramming.com](https://unlockprogramming.com) blog contents.

## Prerequisites Setup

* Install `nvm`

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm version
nvm install v17.6.0
nvm use v17.6.0
```

* Install `go`

```bash
curl -L https://dl.google.com/go/go1.18.9.linux-amd64.tar.gz >/tmp/go1.18.9.linux-amd64.tar.gz
tar -xf /tmp/go1.18.9.linux-amd64.tar.gz -C $HOME
echo -e "export GOROOT=\"\$HOME/go\"" | tee -a ~/.bashrc
echo -e "export PATH=\"\$HOME/go:\$PATH\"" | tee -a ~/.bashrc
source ~/.profile
go version
```

* Install `hugo extended`

```bash
curl -L https://github.com/gohugoio/hugo/releases/download/v0.109.0/hugo_extended_0.109.0_linux-amd64.tar.gz >/tmp/hugo_extended_0.109.0_linux-amd64.tar.gz
tar -xf /tmp/hugo_extended_0.109.0_linux-amd64.tar.gz -C /tmp
chmod +x /tmp/hugo
sudo mv /tmp/hugo /usr/local/bin/
hugo version
```

## How to run?

* To install dependencies

```bash
make site_install
```

* To run development hugo server

```bash
make site_dev 
```

* Access development server at: [http://localhost:1313](http://localhost:1313)

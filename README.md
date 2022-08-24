# Site - Unlock Programming

The site for Unlock Programming.

## Usage

Please make sure you have installed the [build tools](#build-tools) prior to using this site.

### Build Tools

- [Git](https://git-scm.com/downloads).
- [Hugo](https://gohugo.io/getting-started/installing/): **extended** version `0.84.0` or above.
- [npm](https://nodejs.org/en/download/): used for installing CSS and JS dependencies.
- [Go](https://go.dev/dl/): version `1.12` or above, required only when installed as a [Hugo Module].

> We recommend using the latest version of those tools.

## Server

**1. Install dependencies**

```shell
$ npm i
```

Generally, this step only needs to be performed once for each local project.

**2. Start server**

```shell
$ hugo server
```

## Upgrade theme

```shell
$ hugo mod get -u
$ hugo mod npm pack
$ npm i
$ git add go.mod go.sum
$ git commit -m 'Update the theme'
```

## Deployment

Please make sure you've change the `baseURL` on `/config/production/config.toml` before deploying your site.

## Theme Credit Goes To
- https://github.com/razonyang/hugo-theme-bootstrap


---
title: "Fetch Access Token from Okta OICD app with user credentials using unix commands"
date: "2022-12-12"
draft: false
authors: bhuwanupadhyay
categories:
- Okta
---

In this note, we will see how to use unix commands to fetch okta access token from okta oidc web application with user credentials.

<!--more-->

## Okta OIDC Setup

First, we need to okta oidc web app in Okta Dashboard.

- Sign In  [Okta Dashboard](https://developer.okta.com/login/)
- Applications > Create a new app integration
- Select Sign-in method: OIDC - OpenID Connect & Application type: Web Application
- Assign users and groups in this app integration

## Setup environment variables

```bash
echo "1. Getting authentication session token"
export OKTA_DOMAIN="dev-3716300.okta.com"
export OKTA_USERNAME='bhuwan.upadhyay49@gmail.com'
export OKTA_PASSWORD="P@ssw0rd"
export OKTA_CLIENT_ID="0oa7lhbovnO7niFME5d7"
export OKTA_CLIENT_SECRET="H4IC6tyuoE6xrl-44kGm_ftlxGIlKqWTjU3xQS0A"
export REDIRECT_URL=http://localhost:8080/authorization-code/callback

```


## Get authentication session token

```bash
echo "2. Getting authentication session token"
rm -rf auth.json auth.html auth_token.json
curl -s --location --request POST "https://$OKTA_DOMAIN/api/v1/authn" \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{
  \"username\": \"$OKTA_USERNAME\",
  \"password\": \"$OKTA_PASSWORD\",
  \"options\": {
    \"multiOptionalFactorEnroll\": false,
    \"warnBeforePasswordExpired\": false
  }
}" > auth.json
SESSION_TOKEN=$(jq -r '.sessionToken' auth.json)
```

## Get authorization code

```bash
echo "3. Getting authorization_code"
APP_STATE=mystate
APP_NONCE=mynonce
wget -O auth.html -q "https://$OKTA_DOMAIN/oauth2/v1/authorize?client_id=$OKTA_CLIENT_ID&response_type=code&response_mode=form_post&sessionToken=$SESSION_TOKEN&redirect_uri=$REDIRECT_URL&scope=openid+groups&state=$APP_STATE&nonce=$APP_NONCE"
APP_CODE=$(cat auth.html | grep -Po '<input.*code.*value="\K[^"]+' | recode html..ascii)
```

## Get access token

```bash
echo "4. Getting Token"
curl -s --location --request POST "https://$OKTA_DOMAIN/oauth2/v1/token?client_id=$OKTA_CLIENT_ID&client_secret=$OKTA_CLIENT_SECRET&code=$APP_CODE&grant_type=authorization_code&redirect_uri=$REDIRECT_URL" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
  > auth_token.json

ACCESS_JWT_TOKEN=$(jq -r '.access_token' auth_token.json)
echo ""
echo "--------- Access Token: ---------"
echo ""
echo "$ACCESS_JWT_TOKEN"
```

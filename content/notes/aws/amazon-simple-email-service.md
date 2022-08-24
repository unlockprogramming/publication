+++
draft = false
title = "Amazon Simple Email Service (SES)"
date = "2022-05-21"
+++

In this note, we will explore how to set up Amazon SES to send an email.

<!--more-->

## Sender identity

First, we need to create and verify our sender identity in Amazon SES.

In order to create sender identity we can use domain or email address.

> Important Notes:
>
> When domain is used then sender email address `sender@domain`
>
> When email is used then identity email is sender email address itself

## SMTP credentials

- To create smtp credentials we can go to [ses account dashboard](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1#/account).
- Click on `Create SMTP credentials` button and the follow the next screen.
- After that this will generate credentials.

## Usage

We need to use correct sender email address and credentials in our application in order to send an email successfully.

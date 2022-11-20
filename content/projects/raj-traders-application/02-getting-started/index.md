---
title: "RTA: Getting Started"
date: 2022-11-19
draft: true
authors: ["bhuwanupadhyay"]
categories: ["Spring Boot"]
tags: ["fullstack"]
---

This articles explain how to start spring boot application using Spring Initializer.

<!--more-->

## Create Project

To create spring based project we need go to [http://start.spring.io](http://start.spring.io), select the Spring Boot
version and the different
dependencies you think you need, and download the project.

As an example screenshot shown below for Project.

![](create-project.png)

You can open downloaded project on your favorite IDE such as Intellij, VSCode, Eclipse, etc.

## PostgreSQL Database

User docker command to start postgres database.

```bash
docker run -it --rm --name rta-postgres -p 5455:5432 -e POSTGRES_PASSWORD=rtapostgrespw -d postgres
```

## Connect with PostgreSQL

## Create Webpage Controller

## Run Application

## Verify Application
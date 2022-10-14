---
title: "Detect Loop in a Linked List"
date: "2022-10-01"
draft: true
authors: bhuwanupadhyay
categories:
- Algorithms
---

This article explains methods of checking cyclic linked list using various .

<!--more-->

## Problem Statement

In this problem, we need to check whether a linked list contains a cycle.

Example-1:

```
 5 -> 1 -> 13 -> 11 -> 19
```

> It has no cycle.

Example-2: 

```
 5 -> 1 -> 13 -> 11 -> 19
           |           |
           15 <- 12 <- 12
```

> It has cycle.

##
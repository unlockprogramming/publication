---
title: "How to install different version of jdk"
date: "2022-09-23"
draft: true
authors: bhuwanupadhyay
categories:
- Java
---

This small note that shows how to install different version of jdk using sdk manager.

<!--more-->

To get list of open jdk java version identifiers using sdk manager.

```bash
sdk list java | grep open
```

The output of above command will be in below format. Now, from here you need to pick appropriate version identifiers.

```
================================================================================
 Vendor        | Use | Version      | Dist    | Status     | Identifier
--------------------------------------------------------------------------------        
....
```

To install specific version identifier using sdk manager.

```bash
sdk install java <version_identifier>
```

For example, to install jdk 19.

```bash
sdk install java 19-open
```
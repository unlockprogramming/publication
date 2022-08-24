+++
draft = false
title = "Do not make unnecessary comparisons"
description = ""
date = 2022-06-03
featured = false
comment = true
toc = true
categories = [
"Java"
]
tags = [
]
series = [
"Java Best Practices"
]
images = []
+++

This article shows how to avoid unnecessary comparisons in java.

<!--more-->

## Comparison with a boolean literal

```java
Bad Practice: if (student.isPresent() == true) { }
Simplified: if (student.isPresent()) { }
```

```java
Bad Practice: if (student.isPresent() == false) { }
Simplified: if (!student.isPresent()) { }
```

```java
Bad Practice: if (student.isPresent() != true) { }
Simplified: if (!student.isPresent()) { }
```

```java
Bad Practice: if (student.isPresent() != false) { }
Simplified: if (student.isPresent()) { }
```

## `&&`-ing or `||`-ing with false

```java
Bad Practice: if (student.isPresent() && false) { }
Simplified: Condition will be always false so better to move code in else case
```

```java
Bad Practice: if (student.isPresent() || false) { }
Simplified: if (student.isPresent()) { }
```

## `&&`-ing or `||`-ing with true

```java
Bad Practice: if (student.isPresent() && true) { }
Simplified: if (student.isPresent()) { }
```

```java
Bad Practice: if (student.isPresent() || true) { }
Simplified: Condition will be always false so remove if condition
```
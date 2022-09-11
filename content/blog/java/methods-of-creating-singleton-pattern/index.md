---
title: "Methods of creating singleton pattern in Java"
date: "2022-09-11"
authors: "sujitsharma"
categories:
- Java
tags:
- java
- design pattern
- singleton
---

This article introduces the concept and implementation of the singleton design pattern in Java. It also describes different ways to make a class singleton. This article shows thread safe singleton, the effect of seriliazation on singleton instances as well as how reflection breaks singleton. 

<!--more-->

## Singleton Pattern

A singleton is a class that restricts object creation to exactly one object. This pattern defines rules for object creation and thus comes under the creational design pattern. The Singleton pattern is used for file system drivers, video display drivers, caching, thread pools, as well as other design patterns like the Builder pattern, Facade pattern.

## Implementation

There are so many variations of the singleton pattern. The implementation of the singleton pattern is dependent on the developer and system requirements. However, the typical implementation is done by:
- Declaring all constructors private 
- Providing a static method or field that has a global point of access

In this article we will discuss the following approaches to the singleton pattern:
1. Eager Initialization
2. Lazy Initialization
3. Inner Class Singleton
4. Enum Singleton

### Eager Initialization

With this approach, the instance of a class is initiated at class load time, so we need to call private constructor during declaring a static data member as below:
```java

public static final EagerInitializedSingleton INSTANCE = new EagerInitializedSingleton();

private EagerInitializedSingleton() {} 
```

However, by using the Java reflection API, it is possible to easily violate the singleton principle and create multiple instances of a class.
```java

Constructor<EagerInitializedSingleton> constructor = EagerInitializedSingleton.class.getDeclaredConstructor();
            constructor.setAccessible(true);
            constructor.newInstance();
```
To protect from reflection attack we should throw exception from constructor if an instance already exist.
```java

private EagerInitializedSingleton() {
        if (INSTANCE != null) {
            throw new RuntimeException("This Singleton Class is already initialized.");
        }
    }
```

Still if we made singleton class serilizable, JVM creates another instance while deserilizing. To prevent creating multiple instances while deserilizing we should implement readResolve method and return instance from there
```java

protected Object readResolve() {
        return INSTANCE;
    }
```

The implementation of eager initialized singleton class look like
```java

import java.io.Serializable;

public class EagerInitializedSingleton implements Serializable {

    public static final EagerInitializedSingleton INSTANCE = new EagerInitializedSingleton();

    private static final long serialVersionUID = 1L;

    private EagerInitializedSingleton() {
        if (INSTANCE != null) {
            throw new RuntimeException("This Singleton Class is already initialized.");
        }
    }

    protected Object readResolve() {
        return INSTANCE;
    }

//    other method implementation
}
```

### Lazy Initialization

With this approach, an instance is created only when needed. This will help to utilize resources properly. Like above to protect against reflection attacks, the constructor should throw an exception if an instance has already been created and should implement the ```readResolve ()``` method when serilization is needed. The lazy initialized singleton should have a private field for the instance and should have a static method that returns the instance as below.

```java

 public  static LazyInitializedSingleton getInstance() {
        if (instance == null){
            instance = new LazyInitializedSingleton();
        }
        return instance;
    }
```
To make thread safe, we should synchronize the object creation block. Otherwise, different threads can create numbers of objects.

```java

public static LazyInitializedSingleton getInstance() {
        if (instance == null){
            synchronized (LazyInitializedSingleton.class){
                if (instance == null)  instance = new LazyInitializedSingleton();
            }
        }
        return instance;
    }
```
The implementation of eager initialized singleton class look like

```java

import java.io.Serializable;

public class LazyInitializedSingleton implements Serializable {

    private static final long serialVersionUID = 2L;

    private static volatile LazyInitializedSingleton instance = null;

    private LazyInitializedSingleton() {
        if (instance != null) {
            throw new RuntimeException("This Singleton Class is already initialized. Use getInstance Method instead");
        }
    }

    public static LazyInitializedSingleton getInstance() {
        if (instance == null){
            synchronized (LazyInitializedSingleton.class){
                if (instance == null)  instance = new LazyInitializedSingleton();
            }
        }
        return instance;
    }

    protected Object readResolve() {
        return instance;
    }

//    Other method implementation
}
```

### Inner Class Singleton

Inner static class is loaded only after its enclosing class is loaded, so this type of singleton is implemented to lazily initialize thread-safe instance. They are neither reflection nor serilization safe. Hence, we need to consider those in our implementation.

```java
import java.io.Serializable;

public class InnerClassSingleton implements Serializable {

    private static final long serialVersionUID = 3L;

    private InnerClassSingleton() {
        if (getInstance() != null) {
            throw new RuntimeException("This Singleton Class is already initialized. Use getInstance Method instead");
        }
    }

    private static class Helper {
        private static final InnerClassSingleton INSTANCE = new InnerClassSingleton();
    }

    public static InnerClassSingleton getInstance() {
        return Helper.INSTANCE;
    }

    protected Object readResolve() {
        return getInstance();
    }

    // other method implementation
}
```

### Enum Singleton

Enums are initialized only once during load time, so by default they guarantee a single instance even using reflection and in multi-threaded environments. Enums are inherently serilizable and handle serilization themselves, so there is no need to implement ```readResolve()``` method. A single element enum type is the recommended way to implement an enum singleton.

``` java

public enum EnumSingletonRectangle {
    INSTANCE;

    private Double length;
    private Double width;

    public Double getLength() {
        return length;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getWidth() {
        return width;
    }

    public void setWidth(Double width) {
        this.width = width;
    }
    public Double findArea() {
        return length * width;
    }

    public Double findPerimeter() {
        return 2*(length+ width);
    }
}
```

## Source code

The complete source code  of different singleton pattern described above along with their unit tests are available on github [Methods of Creating Singleton pattern](https://github.com/unlockprogramming/methods-of-creating-singleton-pattern-in-java/tree/singleton-creation-method)

## Reference

[Effevtive Java by Josha Bloch](https://www.amazon.com/Effective-Java-Joshua-Bloch/dp/0134685997)
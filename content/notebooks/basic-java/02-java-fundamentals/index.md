---
title: "Basic Java: Java Fundamentals"
date: 2022-12-25
draft: true
authors: ["satyarajawasthi"]
categories: ["Basic Java"]
tags: [java]
---

This article..
After getting introduced with java. You might be thinking of objects and class. Lets grasp Java Fundamentals before we start learning OOP.

## **Writing your first java program.**
Start to write a java program is not too much hard. Lets start with the welcome message "Lets unlock java":
``` java
class ClassName{  
    public static void main(String args[]){  
     System.out.println("Lets unlock java");  
    }  
} 
```
This will print a line **Lets unlock java** on the console when the program is compiled and run. We will learn what each of the word mean and do few steps ahead.

The above was just a warmup lets start running. 
### **Editing, Compiling and executing java program**
   its easy to do all. Just follow these steps:
![image](https://user-images.githubusercontent.com/77236280/210098519-9adc4d32-a000-42a9-b840-ce72c6dc8980.png)

> Be sure that the extension for the java code file should be .java and file name is as same as class name.
#### **Comments in java**
Single line comment: ``` // This is single line comment ```

Multi line comment: 
```java
 /*
this
    is
        multline
                comment
*/ 
```
Documentation comment: 
``` java
/**  
* 
*We can use various tags to depict the parameter 
*or heading or author name 
*We can also use HTML tags   
* 
*/  
````
You have learned to setup ***jdk*** and ***IDE*** ( IntellijIdea) in [previous section](https://unlockprogramming.com).

### **Creating a Java Project using Intellij :**
+ Open Intellij Idea 
+ On the project section, go to New Project ![intellij project 01](https://user-images.githubusercontent.com/77236280/210136924-4acd047b-8266-44d9-b037-79a3fa69b564.png)
+ Select the scheme of project and set the name, location of project
+ Select java as language and intellij as build system 
+ Select the appropriate JDK you want to use. We will be using openJDK 17 which is a latest LTS version of java
 ![new project](https://user-images.githubusercontent.com/77236280/210137042-55037179-701d-4f3a-afd5-e9bf7f399300.png)
Our project will look like : ![project home view](https://user-images.githubusercontent.com/77236280/210137299-072d91bb-8945-4ae0-841d-2fd36457d1eb.png)
    + All the java source code files are kept inside the src folder.
> The Main class and main method is automatically generated due we selected Add sample code option while creating the project.
Dont worry we will be discussing about all the other stuffs there in our comming tutorials.
+ Replace " Hello world " on above code by " Lets, unlock java"
+ To run the code just press **ctrl+shift+f10**  or click on play button by selecting the configurations and class. (Be sure you are running the class with main method as execution of every program always start from main method.) 
+ Output for the above code: ![hello world output](https://user-images.githubusercontent.com/77236280/210138759-afc2a889-5562-4e9f-8cc1-7c4b966cd7be.png)
<!--more-->

---
title: "Support SQL And NoSQL Database In Spring Boot Application"
date: "2022-11-11"
authors: "sujitsharma"
categories:
- Spring Boot
tags:
- sql
- nosql
- postgres
- mongodb
---

In this article, we are going to learn how to connect sql and nosql database in a spring boot application. This article shows database connections with postgres and mongodb in a single Spring project.

<!--more-->

## Requirements
- Docker
- Jdk 8 or later
- Apache Maven 3.6.0 or later

## Creating Spring Boot Project
Go to [Spring Initializer](https://start.spring.io) and create a java 11 maven project by adding following dependencies.
- Spring Data JPA (for sql database)
- Postgres Driver 
- Spring Data MongoDb (for nosql database)
- Mongodb-driver
- Spring Web (for apis and web)
- Actuator (for dev)

To generate spring application and download its .zip file, click the "Generate" button below the spring initializer page.


![Grafana](initializing-spring-project.png?width=800px&height=700px)

Now, extract and open downloaded project in your preferred IDE. I am using IntelliJ Idea.

## Creating Entity & Repository
This is our student entity class
```Java 

@Entity
@Document
@Getter
@Setter
public class Student {

    @Id
    @javax.persistence.Id
    private String id;

    private String name;

    private String email;

    private String address;

    private LocalDate dateOfBirth;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return Objects.equals(id, student.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

}
```

The repository will be same as usual. we are going to extend ```PagingAndSortingRepository``` to create ```StudentRepository``` shown below

```java

package com.unlockprogramming.example;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface StudentRepository extends PagingAndSortingRepository<Student, String> {
    
}
```


## Creating Apis
First we will create student request with following attributes

```java
@Data
public class StudentRequest {

    private String name;

    private String email;

    private String address;

    private LocalDate dateOfBirth;

}
```
Then we will define student controller

```java

@RestController
@RequestMapping("/students")
@RequiredArgsConstructor
public class StudentController {
    
    private final StudentRepository repository;

    @PostMapping
    public Student saveStudent(@RequestBody StudentRequest request) {
        Student student = new Student();
        student.setId(UUID.randomUUID().toString());
        student.setName(request.getName());
        student.setEmail(request.getEmail());
        student.setAddress(request.getAddress());
        student.setDateOfBirth(request.getDateOfBirth());
        return repository.save(student);
    }

    @GetMapping
    public Page<Student> listStudents(@PageableDefault Pageable pageable) {
        return repository.findAll(pageable);
    }

    @GetMapping
    @RequestMapping("/{studentId}")
    public ResponseEntity<Student> findStudentById(@PathVariable String studentId) {
        Optional<Student> student = repository.findById(studentId);
        if (!student.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().body(student.get());
    }


    @PutMapping("/{studentId}")
    public ResponseEntity<Student> updateStudent(@RequestBody StudentRequest request, @PathVariable String studentId) {
        if (studentId == null && studentId.isEmpty())   {
            return ResponseEntity.notFound().build();
        }
        Student student = repository.findById(studentId).orElseThrow(EntityNotFoundException::new);

        student.setName(request.getName());
        student.setEmail(request.getEmail());
        student.setAddress(request.getAddress());
        student.setDateOfBirth(request.getDateOfBirth());

        return ResponseEntity.ok().body(repository.save(student));
    }

    @DeleteMapping("/{studentId}")
    public ResponseEntity<Object> deleteStudent(@PathVariable String studentId) {
        if (studentId == null || studentId.isEmpty() || ( !repository.findById(studentId).isPresent()))   {
            return ResponseEntity.notFound().build();
        }
        repository.deleteById(studentId);
        return ResponseEntity.notFound().build();
    }

}

```

Finally, we are almost done with our code that will execute on both sql and nosql databases. We just need to configure our application on properties file.

## Running Spring Application That Support Sql & Nosql

We will see how to run spring application with sql and nosql database one by one.

### Running with postgres database
On application.properties file define sql as  active profile
```java
spring.profiles.active=sql
```
To start application with postgres database we need to run postgres. For running postgres docker image execute following command in your terminal.
``` bash
docker run --name example-postgres -e POSTGRES_DB=example-postgres -e POSTGRES_PASSWORD=postgrespw -d -p 5432:5432 postgres
``` 
Now create new ```application-sql.properties``` file and put database credencials there.
Also, Because our POM file has data-jpa and data-mongodb starter both, spring attempts to auto configure mongodb as well. To prevent from auto configuration we need to exclude ```MongoAutoConfiguration``` and ```MongoDataAutoConfiguration```

```java

spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.username=postgres
spring.datasource.password=postgrespw
spring.datasource.url=jdbc:postgresql://localhost:5432/example-postgres
spring.jpa.hibernate.ddl-auto=update
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.mongo.MongoRepositoriesAutoConfiguration, org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration, org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration

```

Press run button on your IDE to start application. <br/>

Now, we can get and post student using Apis. Use following curl command to post student.
```bash
curl -H "Content-Type: application/json" -X POST -d '{"name": "Hari","email":"hari@gmail.com","address":"haribhawan ktm","dateOfBirth":"2013-06-19"}' http://localhost:8080/students
```

For get request use this command
```bash
curl -H "Contrent-Type: application/json" -X GET http://localhost:8080/students
```

This is the output of get command 

![Grafana](student-get-request.png?width=700px&height=100px)

### Running with mongodb
On application.properties file define sql as  active profile

```java
spring.profiles.active=nosql
```
start your mongodb docker instance with following command

```bash
docker run --name example-mongo -e MONGO_INITDB_ROOT_USERNAME=mongo-user -e MONGO_INITDB_ROOT_PASSWORD=mongopw -p 27017:27017 mongo
```

Now create new ```application-nosql.properties``` file and put database credencials there by excluding ```DataSourceAutoConfiguration```and ```HibernetJpaAutoConfiguration```

```java
spring.data.mongodb.username=mongo-user
spring.data.mongodb.password=mongopw
spring.data.mongodb.port=27017
spring.data.mongodb.host=127.0.0.1
spring.data.mongodb.authentication-database=admin
spring.jpa.hibernate.ddl-auto=update
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration, org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
```
Now run your application and use above curl commands inorder to test Apis expose using nosql.

Finally, we have learned how to use sql and nosql database in a spring boot appliction.


## Source Code
You can get complete source code on github [Spring boot application with sql and nosql persistence database](https://github.com/unlockprogramming/deploy-spring-boot-application-with-sql-and-nosql-persistence-databases/)


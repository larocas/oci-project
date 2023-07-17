FROM openjdk:11
COPY target/dropwizard-example-4.0.2-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

FROM openjdk:21-jdk-slim
WORKDIR /app

# copy in the fat JAR
COPY target/*.jar app.jar

# we run on 8080 inside the container
EXPOSE 8080

# force Spring Boot to use port 8080
ENTRYPOINT ["java","-Dserver.port=8080","-jar","app.jar"]

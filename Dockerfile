FROM openjdk:21-jdk-slim
WORKDIR /app

# copy the JAR that mvn has produced
COPY target/*.jar app.jar

# tell Docker this container listens on 8080
EXPOSE 8080

# pass -Dserver.port=8080 explicitly
ENTRYPOINT ["java","-Dserver.port=8080","-jar","app.jar"]

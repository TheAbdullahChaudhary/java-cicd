# Use a slim OpenJDK 21 image
FROM openjdk:21-jdk-slim

# Create app dir
WORKDIR /app

# Copy the fat JAR in
COPY target/*.jar app.jar

# Tell Spring Boot to listen on 8080, so we can always map host→8081
ENV SERVER_PORT=8080

# Expose the container port
EXPOSE ${SERVER_PORT}

# Launch with server.port override
ENTRYPOINT ["java","-Dserver.port=${SERVER_PORT}","-jar","app.jar"]

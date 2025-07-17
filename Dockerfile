FROM openjdk:17-jdk-alpine

# Install coreutils (includes nohup)
RUN apk update && apk add --no-cache coreutils

WORKDIR /app
COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
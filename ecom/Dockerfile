# ===== Stage 1: Build the JAR using Maven =====
FROM maven:3.9.1-eclipse-temurin-21-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the project and package it as a JAR
RUN mvn clean package -DskipTests

# ===== Stage 2: Run the JAR file =====
FROM eclipse-temurin:21-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/ecom-0.0.1-SNAPSHOT.jar app.jar

# Expose the port the app will run on
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]

# ===== Stage 1: Build the JAR using Maven =====
FROM maven:3.9.1-eclipse-temurin-21 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the pom.xml first to cache dependencies
COPY pom.xml .

# Download Maven dependencies (offline mode to speed up builds)
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Build the Spring Boot application, skipping tests for faster build
RUN mvn clean package -DskipTests

# ===== Stage 2: Run the Spring Boot app using lightweight Java image =====
FROM eclipse-temurin:21-jdk-alpine

# Set working directory inside the runtime container
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your Spring Boot app will use
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]

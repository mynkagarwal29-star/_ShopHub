# ============================
# Stage 1: Build the application
# ============================
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Set working directory
WORKDIR /ecom

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the project (skip tests for faster builds)
RUN mvn clean package -DskipTests

# ============================
# Stage 2: Run the application
# ============================
FROM eclipse-temurin:21

# Set working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/ecom-0.0.1-SNAPSHOT.jar app.jar

# Expose port (Spring Boot default)
EXPOSE 8090

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

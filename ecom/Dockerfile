# ============================
# Stage 1: Build the application
# ============================
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build the WAR (skip tests)
RUN mvn clean package -DskipTests

# ============================
# Stage 2: Run the application
# ============================
FROM eclipse-temurin:21

WORKDIR /app

# Copy the WAR from builder
COPY --from=builder /app/target/ecom-0.0.1-SNAPSHOT.war app.war

# Expose port
EXPOSE 8080

# Run WAR as executable
ENTRYPOINT ["java", "-jar", "app.war"]

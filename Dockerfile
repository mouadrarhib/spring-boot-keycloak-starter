# ---- Build stage ----
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Leverage dependency cache
COPY pom.xml .
RUN mvn -q -ntp -DskipTests dependency:go-offline

# Copy sources
COPY src ./src

# Build + repackage into an executable boot JAR
# finalName keeps it predictable, but we’ll still copy by pattern later
RUN mvn -q -ntp -DskipTests -DfinalName=app package spring-boot:repackage

# ---- Runtime stage (Temurin JRE) ----
FROM eclipse-temurin:17-jre

# Non-root user
RUN addgroup --system spring && adduser --system --ingroup spring --home /app spring
WORKDIR /app

# Copy the single jar produced by the build
# (works whether it’s app.jar or app-0.0.1-SNAPSHOT.jar)
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080
USER spring
ENTRYPOINT ["java","-jar","/app/app.jar"]

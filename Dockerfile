# ---- Build stage ----
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only the pom first to leverage dependency layer caching
COPY pom.xml .
RUN mvn -q -ntp -DskipTests dependency:go-offline

# Now copy sources
COPY src ./src

# Produce a single, predictable artifact name
# (You can also set <finalName>app</finalName> in the POM if you prefer)
RUN mvn -q -ntp -DskipTests -DfinalName=app package

# ---- Runtime stage (Temurin JRE) ----
FROM eclipse-temurin:17-jre
# Create non-root user
RUN addgroup --system spring && adduser --system --ingroup spring --home /app spring
WORKDIR /app

# Copy the fat jar with a deterministic name
COPY --from=build /app/target/app.jar /app/app.jar

# Expose app port
EXPOSE 8080

# Drop privileges
USER spring

# (Optional) JVM ergonomics for containers; Spring Boot 3 generally handles this,
# but these flags can help in constrained environments:
# ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0"

ENTRYPOINT ["java","-jar","/app/app.jar"]

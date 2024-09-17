# Use gradle image with jdk 21 to build the project
FROM gradle:8-jdk21 AS builder

WORKDIR /app

# Copy the project files
COPY . .

# Update the gradle wrapper
RUN gradle wrapper

# Read secrets and build the project
RUN --mount=type=secret,id=repo_url \
    --mount=type=secret,id=repo_password \
    --mount=type=secret,id=repo_username \
    gradle clean build -x check \
    -Prepo.url="$(cat /run/secrets/repo_url)" \
    -Prepo.username="$(cat /run/secrets/repo_username)" \
    -Prepo.password="$(cat /run/secrets/repo_password)"

# Remove javadoc, sources and plain jar files
RUN rm -rf build/libs/*-javadoc.jar
RUN rm -rf build/libs/*-sources.jar
RUN rm -rf build/libs/*-plain.jar

# Rename the jar file
RUN mv build/libs/*.jar build/libs/server.jar

# Use amazoncorretto image to run the project
FROM amazoncorretto:21-alpine

WORKDIR /app

# Copy the built jar file from the builder image
COPY --from=builder /app/build/libs/server.jar server.jar

# Expose the port
EXPOSE 8080

# Run the jar file
CMD ["java", "-jar", "server.jar"]

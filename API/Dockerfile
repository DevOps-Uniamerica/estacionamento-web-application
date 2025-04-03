FROM eclipse-temurin:20.0.2_9-jdk-jammy AS build
WORKDIR /app
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:20.0.2_9-jre-jammy
WORKDIR /app
COPY --from=build /app/target/estacionamento-0.0.1-SNAPSHOT.jar ./app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
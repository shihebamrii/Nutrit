# Build stage
FROM openjdk:17-jdk-slim AS build

# Install Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy project files
COPY . .

# Build the WAR file using Ant
RUN ant -Dnb.internal.action.name=rebuild clean dist

# Runtime stage
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage to Tomcat webapps
# Note: Adjust the path if 'dist/Nutrit.war' name differs
COPY --from=build /app/dist/Nutrit.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

# Build stage
FROM eclipse-temurin:17-jdk-jammy AS build

# Install Ant and wget
RUN apt-get update && apt-get install -y ant wget && rm -rf /var/lib/apt/lists/*

# Download and extract Tomcat for build classpath
ENV TOMCAT_VERSION=10.1.18
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt \
    && mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
    && rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

WORKDIR /app

# Copy project files
COPY . .

# Build the WAR file using Ant, providing the Tomcat path
RUN ant -Dj2ee.server.home=/opt/tomcat clean dist

# Runtime stage
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage to Tomcat webapps
COPY --from=build /app/dist/Nutrit.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]


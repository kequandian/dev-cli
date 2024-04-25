FROM zelejs/allin-web:m2 as m2

FROM maven:3.6-openjdk-11-slim as root
WORKDIR /root/.m2
COPY --from=m2 /root/.m2/settings.xml .
WORKDIR /root

RUN mvn -s /root/.m2/settings.xml org.apache.maven.plugins:maven-dependency-plugin:3.2.0:copy -Dartifact='com.tools:dev-dependency:1.0:jar' -DoutputDirectory=/var/tmp

#final-stage
FROM adoptopenjdk:11-jre-hotspot 
WORKDIR /var/tmp
ADD ./tmp/fatjar-cfr /usr/local/bin/fatjar-cfr
ADD ./tmp/fatjar-diff /usr/local/bin/fatjar-diff
ADD ./tmp/fatjar-find /usr/local/bin/fatjar-find
RUN chmod +x /usr/local/bin/fatjar-cfr /usr/local/bin/fatjar-diff /usr/local/bin/fatjar-find
WORKDIR /

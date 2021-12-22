FROM alpine:3.15.0

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=17

# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN apk add --no-cache \
    curl \
    openjdk17-jre=17.0.1_p12-r0 \
  && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security

# Agent bond including Jolokia and jmx_exporter
COPY agent-bond-opts /opt/run-java-options

RUN mkdir -p /opt/agent-bond \
  && curl https://repo.maven.apache.org/maven2/io/fabric8/agent-bond-agent/1.2.0/agent-bond-agent-1.2.0.jar \
          -o /opt/agent-bond/agent-bond.jar \
  && chmod 444 /opt/agent-bond/agent-bond.jar \
  && chmod 755 /opt/run-java-options 

COPY jmx_exporter_config.yml /opt/agent-bond/

EXPOSE 8778 9779

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh



CMD [ "/deployments/run-java.sh" ]

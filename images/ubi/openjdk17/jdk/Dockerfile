FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5-204

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=17


# /dev/urandom is used as random source, which is prefectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN microdnf install java-17-openjdk-headless-17.0.1.0.12-2.el8_5 \
      openssl curl ca-certificates \
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/jre/lib/security/java.security \
    && microdnf clean all

ENV JAVA_HOME /etc/alternatives/jre
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

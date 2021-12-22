FROM ubuntu:20.04

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=17

# /dev/urandom is used as random source, which is prefectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN apt-get update \
  && apt-get install -y --no-install-recommends openjdk-17-jre-headless=17.0.1+12-1~20.04 -V \
  && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/java-17-openjdk-amd64/lib/security/java.security \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Agent bond including Jolokia and jmx_exporter
COPY agent-bond-opts /opt/run-java-options

RUN mkdir -p /opt/agent-bond \
  && apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && curl https://repo.maven.apache.org/maven2/io/fabric8/agent-bond-agent/1.2.0/agent-bond-agent-1.2.0.jar \
          -o /opt/agent-bond/agent-bond.jar \
  && chmod 444 /opt/agent-bond/agent-bond.jar \
  && chmod 755 /opt/run-java-options \
  && apt-get remove -y curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY jmx_exporter_config.yml /opt/agent-bond/

EXPOSE 8778 9779

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

# Run under user "jboss" and prepare for be running under OpenShift, too
RUN groupadd -r jboss -g 1000 \
  && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin jboss \
  && chmod 755 /opt/jboss \
  && chown -R jboss /deployments \
  && usermod -g root -G "$(id -g jboss)" jboss \
  && chmod -R "g+rwX" /deployments \
  && chown -R jboss:root /deployments

USER jboss

CMD [ "/deployments/run-java.sh" ]

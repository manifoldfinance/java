FROM {{= fp.config.base.from + (fp.config.base.tagFromMajorVersion ? ":" + fp.config.version.major : "") }}

USER root

RUN mkdir -p {{= fp.config.base.baseDir }}

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR={{= fp.config.base.baseDir }} \
    JAVA_MAJOR_VERSION={{= fp.config.version.major }}

{{= fp.block("java-pkg-" + fp.param.base) || '' }}
{{= fp.block(fp.config.base.agent + "-install", { dest: "/opt/run-java-options" }) }}

{{= fp.block("run-java-sh","copy",{dest: fp.config.base.baseDir}) }}
{{= fp.block("run-under-user") }}

CMD [ "{{= fp.config.base.baseDir }}/run-java.sh" ]

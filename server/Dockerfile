ARG BASE_IMAGE
# Create image containing server distribution
FROM $BASE_IMAGE as dist
USER root
ARG DISTRIBUTION_PREFIX
ARG DISTRIBUTION_SHA
ARG DISTRIBUTION_URL
ARG HOME
ARG JBOSS_HOME

# TODO remove in favour of curl
COPY jboss-datagrid-7.2.1-server.zip /tmp/server.zip
COPY infinispan-server-9.4.0.Final.zip /tmp/server.zip
RUN sha1sum /tmp/server.zip | grep $DISTRIBUTION_SHA \
    && unzip -q /tmp/server.zip -d $HOME \
    && mv $HOME/$DISTRIBUTION_PREFIX* $JBOSS_HOME \
    && rm /tmp/server.zip \
    && chown -R 1000.0 $JBOSS_HOME \
    && chmod -R g+rw $JBOSS_HOME \
    && find $JBOSS_HOME -type d -exec chmod g+x {} +

#RUN curl -o /tmp/server.zip $DISTRIBUTION_URL \
#    && sha1sum /tmp/server.zip | grep $DISTRIBUTION_SHA \
#    && unzip -q /tmp/server.zip -d $HOME && mv $HOME/* $JBOSS_HOME && rm /tmp/server.zip \
#    && chown -R 1000.0 $JBOSS_HOME \
#    && chmod -R g+rw $JBOSS_HOME \
#    && find $JBOSS_HOME -type d -exec chmod g+x {} +

# Copy server from dist stage and add configuration scripts
FROM $BASE_IMAGE as add-scripts
ARG JBOSS_HOME
ENV JBOSS_HOME=$JBOSS_HOME
WORKDIR $JBOSS_HOME
USER 1000
COPY --from=dist $JBOSS_HOME .

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin
COPY is_healthy.sh /usr/local/bin
COPY is_running.sh /usr/local/bin
COPY .s2i /usr/local/s2i

ENTRYPOINT ["docker-entrypoint.sh"]



## Multi-stag builds
## https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
## https://medium.com/@tonistiigi/advanced-multi-stage-build-patterns-6f741b852fae
#
## ARG variables -- Define all parameterised args here - only available during image build
#ARG ARTIFACT_VERSION=9.4.0.Final
#ARG DISPLAY_NAME="Infinispan Server"
#ARG DISPLAY_VERSION="9.4.0.Final"
#ARG DISTRIBUTION_URL="https://downloads.jboss.org/infinispan/$ARTIFACT_VERSION/infinispan-server-$ARTIFACT_VERSION.zip"
#ARG JBOSS_COMPONENT
## TODO does this really need to be configurable, could we just use /opt/datagrid everywhere?
#ARG JBOSS_HOME="/opt/jboss/infinispan-server"
#ARG JBOSS_PRODUCT="infinispan"
#
## ENV variables -- Define all environment variables here - available at runtime in container
## TODO put all together an put in alphabetical order
#ENV JBOSS_HOME $JBOSS_HOME
#ENV JBOSS_PRODUCT $JBOSS_PRODUCT
#ENV INFINISPAN_VERSION $DISPLAY_VERSION
#ENV JBOSS_DATAGRID_VERSION $DISPLAY_VERSION
#ENV PRODUCT_VERSION $DISPLAY_VERSION
#
## Inherited from downstram - ARe these still required?
#ENV LAUNCH_JBOSS_IN_BACKGROUND true
##ENV DEFAULT_ADMIN_USERNAME "jdgadmin"
##ENV JBOSS_MODULES_SYSTEM_PKGS "org.jboss.logmanager,jdk.nashorn.api"
#
## Labels
#LABEL architecture="x86_64"
#LABEL com.redhat.component=$JBOSS_COMPONENT
#LABEL com.redhat.deployments-dir=$JBOSS_HOME/standalone/deployments
#LABEL com.redhat.dev-mode="DEBUG:true"
#LABEL com.redhat.dev-mode.port="DEBUG_PORT:8787"
#LABEL io.k8s.description="Provides a scalable in-memory distributed database designed for fast access to large volumes of data."
#LABEL io.k8s.display-name=$DISPLAY_NAME
#LABEL io.openshift.expose-services="8080:http,11222:hotrod"
#LABEL io.openshift.s2i.scripts-url="image:///usr/local/s2i"
#LABEL io.openshift.tags="datagrid,java,jboss"
#LABEL name=$DISPLAY_NAME
#LABEL org.jboss.product=$JBOSS_PRODUCT
#LABEL org.jboss.product.datagrid.version=$DISPLAY_VERSION
#LABEL org.jboss.product.version=$DISPLAY_VERSION
#LABEL org.jboss.deployments-dir=$JBOSS_HOME/standalone/deployments
#LABEL release=$INFINISPAN_VERSION
#LABEL version=$INFINISPAN_VERSION
#
## Download and extract the Infinispan Server
#USER root
#
#ENV HOME /opt/jboss/
#
#RUN INFINISPAN_SHA=$(curl $DISTRIBUTION_URL.sha1); curl -o /tmp/server.zip $DISTRIBUTION_URL && sha1sum /tmp/server.zip | grep $INFINISPAN_SHA \
#    && unzip -q /tmp/server.zip -d $HOME && mv $HOME/infinispan-server-* $HOME/infinispan-server && rm /tmp/server.zip \
#    && chown -R 1000.0 $JBOSS_HOME \
#    && chmod -R g+rw $JBOSS_HOME \
#    && find $JBOSS_HOME -type d -exec chmod g+x {} +
#
#USER 1000
#
## TODO rework
## Copy entrypoint script
#COPY docker-entrypoint.sh /usr/local/bin
#COPY is_healthy.sh /usr/local/bin
#COPY is_running.sh /usr/local/bin
## S2I Scripts
#COPY .s2i /usr/local/s2i
#
#ENTRYPOINT ["docker-entrypoint.sh"]
#
## TODO how much of this is required?
## Expose Infinispan server  ports
#EXPOSE 7600 8080 8181 8888 9990 11211 11222 57600

#!/bin/bash

ARTIFACT_VERSION=9.4.0.Final
DISTRIBUTION_URL="https://downloads.jboss.org/infinispan/$ARTIFACT_VERSION/infinispan-server-$ARTIFACT_VERSION.zip"
DISTRIBUTION_SHA=$(curl ${DISTRIBUTION_URL}.sha1)

docker build server --tag test-image --target add-scripts \
--build-arg BASE_IMAGE="jboss/base-jdk:8" \
--build-arg DISTRIBUTION_PREFIX="infinispan-server" \
--build-arg DISTRIBUTION_SHA=${DISTRIBUTION_SHA} \
--build-arg DISTRIBUTION_URL=${DISTRIBUTION_URL} \
--build-arg HOME="/opt/jboss" \
--build-arg JBOSS_HOME="/opt/jboss/infinispan-server"

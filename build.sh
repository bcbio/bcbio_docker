#!/bin/bash
set -ex -o pipefail

BCBIO_VERSION="1.0.3a"
BCBIO_REVISION="a5aa1aa"
TOOLS="bcbio-align"
NS="quay.io/bcbio"
TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# build bcbio base
docker pull ubuntu:16.04
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" -t "${NS}/bcbio-base:${TAG}" -t "${NS}/bcbio-base:latest" - < Dockerfile.base

# build bcbio + task specific tools
for TOOL in ${TOOLS}
do
    docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" --build-arg "tool_yaml=`pwd`/packages/${TOOL}.yaml" -t "${NS}/${TOOL}:${TAG}" -t "${NS}/${TOOL}:latest" - < Dockerfile.tools
done

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail
docker push "${NS}/bcbio-base:${TAG}"
docker push "${NS}/bcbio-base:latest"
for TOOL in ${TOOLS}
do
    docker push "${NS}/${TOOL}:${TAG}"
    docker push "${NS}/${TOOL}:latest"
done

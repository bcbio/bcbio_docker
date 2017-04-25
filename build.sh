#!/bin/bash
set -ex -o pipefail

BCBIO_VERSION="1.0.3a"
BCBIO_REVISION="3be5db2"
TOOLS="bcbio-align bcbio-vc bcbio-qc"
NS="quay.io/bcbio"
TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# build bcbio base
docker pull ubuntu:16.04
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" -t "${NS}/bcbio-base:${TAG}" -t "${NS}/bcbio-base:latest" - < Dockerfile.base

# build bcbio + task specific tools
for TOOL in ${TOOLS}
do
    docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" --build-arg "tool=${TOOL}" -t "${NS}/${TOOL}:${TAG}" -t "${NS}/${TOOL}:latest" -f Dockerfile.tools .
done

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail

parallel -v -j 4 "docker push ${NS}/{}:${TAG}" ::: "bcbio-base" $TOOLS
parallel -v -j 4 "docker push ${NS}/{}:latest" ::: "bcbio-base" $TOOLS

#!/bin/bash
set -ex -o pipefail

BCBIO_VERSION="1.0.3a"
BCBIO_REVISION="c11d222"
NS="quay.io/bcbio"
VERSION_TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# build bcbio base
docker pull ubuntu:16.04
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" -t "${NS}/bcbio-base:${BASE_TAG}" -t "${NS}/bcbio-base:latest" - < Dockerfile.base
# build bcbio + task specific tools

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail
docker push "${NS}/bcbio-base:latest"
docker push "${NS}/bcbio-base:${BASE_TAG}"

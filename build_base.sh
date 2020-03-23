#!/bin/bash
set -ex -o pipefail

TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# build bcbio base
docker pull debian:stretch-slim
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" -t "${NS}/bcbio-base:${TAG}" -t "${NS}/bcbio-base:latest" - < Dockerfile.base

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail
docker push "${NS}/bcbio-base:${TAG}"
docker push "${NS}/bcbio-base:latest"

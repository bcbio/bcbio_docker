#!/bin/bash
set -ex -o pipefail

TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

df -h
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" --build-arg "tool=${TOOL}" -t "${NS}/${TOOL}:${TAG}" -t "${NS}/${TOOL}:latest" -f Dockerfile.tools .
df -h

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail

docker push "${NS}/${TOOL}:${TAG}"
docker push "${NS}/${TOOL}:latest"

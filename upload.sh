#!/bin/bash

TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# log in to quay.io
set +x # avoid leaking encrypted password into travis log
docker login -u="bcbio+travis" -p="$QUAY_PASSWORD" quay.io

# push images
set -ex -o pipefail

parallel --line-buffer -v -j 4 "docker push ${NS}/{}:${TAG}" ::: "bcbio-base" $TOOLS
parallel --line-buffer -v -j 4 "docker push ${NS}/{}:latest" ::: "bcbio-base" $TOOLS

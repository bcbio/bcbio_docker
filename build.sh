#!/bin/bash
set -ex -o pipefail

TAG="${BCBIO_VERSION}-${BCBIO_REVISION}"

# build bcbio base
docker pull ubuntu:16.04
docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" -t "${NS}/bcbio-base:${TAG}" -t "${NS}/bcbio-base:latest" - < Dockerfile.base

# build bcbio + task specific tools
for TOOL in ${TOOLS}
do
    docker build --no-cache --build-arg "git_revision=${BCBIO_REVISION}" --build-arg "tool=${TOOL}" -t "${NS}/${TOOL}:${TAG}" -t "${NS}/${TOOL}:latest" -f Dockerfile.tools .
done

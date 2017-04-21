# bcbio automated Docker builds

[![Build Status](https://travis-ci.org/bcbio/bcbio_docker.svg?branch=master)](https://travis-ci.org/bcbio/bcbio_docker)

Use [Travis CI](https://travis-ci.org/bcbio/bcbio_docker) and
[Quay](https://quay.io/repository/bcbio/bcbio-base?tab=tags) to build Docker images for
[bcbio](https://github.com/chapmanb/bcbio-nextgen).

A work in progress to automate and split up the current monolithic bcbio/bcbio
Docker container.

## Docker images

This builds a variety of Docker images, supporting runs using bcbio generated
CWL:

- [bcbio-base](https://quay.io/repository/bcbio/bcbio-base?tab=tags) --
  A base version of bcbio containing the code and no tools. This is the building
  block for application specific containers.
- bcbio-alignment -- bcbio with alignment programs
- bcbio-variantcall -- bcbio with small variant callers
- bcbio-svcall -- bcbio with structural variant callers

The YAML files defining tools installed in the target Docker images are in
`packages`. We autogenerate these from tool requirements in CWL specification
files.

## Under the hood

When you push an update to this repository, Travis CI notices and, according to `.travis.yml` above, runs `build.sh` which:

- uses `docker build` to build images (on the Travis CI worker)
- logs in to Quay using an authentication token for the `bcbio+travis` robot account, stored using a Travis secure environment variable.
- pushes the images to Quay.

Thanks to [vg_docker](https://github.com/vgteam/vg_docker) for the automation
code.

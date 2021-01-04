# bcbio automated Docker builds

![Build Status](https://github.com/bcbio/bcbio_docker/workflows/bcbio-docker-publish/badge.svg)

Uses [GitHub actions](https://github.com/features/actions) and
[Quay](https://quay.io/organization/bcbio) to build Docker images for
[bcbio](https://github.com/chapmanb/bcbio-nextgen).
Automates and splits up the monolithic bcbio/bcbio Docker container.

## Docker images

This builds a variety of Docker images, supporting runs using bcbio generated
CWL:

- [bcbio-base](https://quay.io/repository/bcbio/bcbio-base?tab=tags) --
  A base version of bcbio containing the code and no tools. This is the building
  block for application specific containers.
- [bcbio-vc](https://quay.io/repository/bcbio/bcbio-vc?tab=tags) --
  bcbio with tools for variant calling: alignment; quality control;
  SNP, indel and structural variant callers
- [bcbio-rnaseq](https://quay.io/repository/bcbio/bcbio-rnaseq?tab=tags) --
  bcbio with tools for RNA-seq analysis: trimming, alignment quantitation and
  quality control.

The YAML files defining tools installed in the target Docker images are in
`packages`. We autogenerate these from tool requirements in CWL specification
files.

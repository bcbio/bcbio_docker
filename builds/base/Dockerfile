# Build bcbio base image with code and framework

#FROM continuumio/miniconda
FROM ubuntu:18.04
LABEL maintainer="bcbio (https://github.com/bcbio/bcbio-nextgen)"
ARG git_revision=master

# Setup a base system 
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget git unzip tar gzip bzip2 xz-utils pigz ttf-dejavu && \
# Support inclusion in Arvados pipelines
    apt-get install -y --no-install-recommends libcurl4-gnutls-dev mbuffer python2.7-dev python-virtualenv && \
# Not added by default to save space
#   apt-get install -y libglu1-mesa && \
# bcbio-nextgen installation
    mkdir -p /tmp/bcbio-nextgen-install && cd /tmp/bcbio-nextgen-install && \
    wget --no-check-certificate \
      https://raw.github.com/chapmanb/bcbio-nextgen/master/scripts/bcbio_nextgen_install.py && \
    python bcbio_nextgen_install.py /usr/local/share/bcbio-nextgen \
      --isolate --minimize-disk --nodata -u development --revision "$git_revision" && \
#    /usr/local/share/bcbio-nextgen/anaconda/bin/conda install -y nomkl && \
    /usr/local/share/bcbio-nextgen/anaconda/bin/bcbio_nextgen.py upgrade -u development --revision "$git_revision" && \
# add user run script
    wget --no-check-certificate -O createsetuser \
      https://raw.github.com/chapmanb/bcbio-nextgen-vm/master/scripts/createsetuser && \
    chmod a+x createsetuser && mv createsetuser /sbin && \
# setup paths
    cd /usr/local/bin && ln -sfr /usr/local/share/bcbio-nextgen/anaconda/bin/bcbio_nextgen.py /usr/local/bin && \
    echo 'export PATH=/usr/local/bin:$PATH' >> /etc/profile.d/bcbio.sh && \
# clean filesystem
    cd /usr/local && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* && \
#    /usr/local/share/bcbio-nextgen/anaconda/bin/conda clean --yes --tarballs --packages && \
    /usr/local/share/bcbio-nextgen/anaconda/bin/conda clean -afy && \
    /usr/local/share/bcbio-nextgen/anaconda/bin/conda build purge-all && \
    rm -rf /usr/local/share/bcbio-nextgen/anaconda/pkgs/qt* && \
    rm -rf /usr/local/share/bcbio-nextgen/anaconda/pkgs/scipy-0.19.1-np113py27_nomkl_0 && \
    rm -rf /usr/local/share/bcbio-nextgen/anaconda/zulu*.tar.gz && \
    rm -rf /usr/local/.git && \
    rm -rf /.cpanm && \
    rm -rf /tmp/bcbio-nextgen-install && \
# Create directories and symlinks for data 
    mkdir -p /mnt/biodata && \
    mkdir -p /tmp/bcbio-nextgen && \
    mv /usr/local/share/bcbio-nextgen/galaxy/bcbio_system.yaml /usr/local/share/bcbio-nextgen/config && \
    rmdir /usr/local/share/bcbio-nextgen/galaxy && \
    ln -s /mnt/biodata/galaxy /usr/local/share/bcbio-nextgen/galaxy && \
    ln -s /mnt/biodata/gemini_data /usr/local/share/bcbio-nextgen/gemini_data && \
    ln -s /mnt/biodata/genomes /usr/local/share/bcbio-nextgen/genomes && \
    ln -s /mnt/biodata/liftOver /usr/local/share/bcbio-nextgen/liftOver && \
    chmod a+rwx /usr/local/share/bcbio-nextgen && \
    chmod a+rwx /usr/local/share/bcbio-nextgen/config && \
    chmod a+rwx /usr/local/share/bcbio-nextgen/config/*.yaml && \
# Ensure permissions are set for update in place by arbitrary users
    find /usr/local -perm /u+x -execdir chmod a+x {} \; && \
    find /usr/local -perm /u+w -execdir chmod a+w {} \; && \
# remove unneeded files .a .pyc
    find /usr/local/share/bcbio-nextgen -follow -type f -name "*.pyc" -delete && \
    find /usr/local/share/bcbio-nextgen -follow -type f -name "*.a" -delete && \
    find /usr/local/share/bcbio-nextgen -follow -type f -name "*.js.map" -delete && \
# Ensure permissions for updating for users not present in /etc/passwd
# https://blog.openshift.com/jupyter-on-openshift-part-6-running-as-an-assigned-user-id/
    chmod a+w /etc/passwd

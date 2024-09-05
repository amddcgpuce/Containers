# ROCm + OMPI v5 + UCX Dockerfile
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Revision: V1.1
# V1.1 Fix ucx and ompi versions, build steps, add args with defaults
# V1.0 initial version

ARG base_rocm_docker
FROM docker.io/${base_rocm_docker}
MAINTAINER srinivasan.subramanian@amd.com 

# Readme:
# Docker build command
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'docker build --no-cache --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-ompi5 -f rocm.ompi5.ub22.Dockerfile `pwd`'
# Podman build command (selinux disable)
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-ompi5 -f rocm.ompi5.ub22.Dockerfile `pwd`'

ARG OMPI_VERSION="v5.0.5"
ARG UCX_VERSION="v1.17.0"

#Lables
LABEL "com.amd.container.description"="ROCm + OMPIv5 + UCX Container for Development"

LABEL "com.amd.container.ompi.version"=${OMPI_VERSION}
LABEL "com.amd.container.ucx.version"=${UCX_VERSION}

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libfabric-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get remove -y \
    libpmix2 \
    libpmix-dev && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    git clone https://github.com/openucx/ucx && \
    cd ucx && \
    git checkout tags/${UCX_VERSION} && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    mkdir -p build && \
    cd build && \
    ../contrib/configure-release --prefix=/opt/ucx --disable-logging --disable-debug --disable-assertions --enable-params-check -without-knem --without-cuda --with-rocm=${ROCM_PATH} --enable-gtest --without-java --enable-mt --without-mpi && \
    make V=1 install  && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    git clone https://github.com/open-mpi/ompi && \
    cd ompi && \
    git checkout tags/${OMPI_VERSION} && \
    git submodule update --init --recursive && \
    ./autogen.pl && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=/opt/ompi --with-rocm --with-ucx --sysconfdir=/opt/ompi/etc --localstatedir=/var --runstatedir=/run --with-verbs --with-libfabric --with-ucx=/opt/ucx --with-pmix --with-libevent=external --with-hwloc=external --enable-ipv7 --with-devel-headers --with-slurm --with-sge --without-tm --sysconfdir=/opt/ompi/etc --libdir=/opt/ompi/lib --includedir=/opt/ompi/lib/include && \
    make V=1 install && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    rm -rf ucx && \
    git clone https://github.com/openucx/ucx && \
    cd ucx && \
    git checkout tags/${UCX_VERSION} && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    mkdir -p build && \
    cd build && \
    ../contrib/configure-release --prefix=/opt/ucx --disable-logging --disable-debug --disable-assertions --enable-params-check -without-knem --without-cuda --with-rocm=${ROCM_PATH} --enable-gtest --without-java --enable-mt --with-mpi=/opt/ompi && \
    make V=1 install  && \
    echo "/opt/ompi/lib" | tee -a /etc/ld.so.conf.d/ompilib.conf && \
    echo "/opt/ucx/lib" | tee -a /etc/ld.so.conf.d/ucxlib.conf && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    cd $HOME && \
    rm -rf $HOME/ompi && \
    rm -rf $HOME/ucx && \
    rm -rf $HOME/rocminstall.py && \
    rm -rf $HOME/downloads && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV MPI_HOME=/opt/ompi
ENV UCX_HOME=/opt/ucx
ENV PATH="${MPI_HOME}/bin:${UCX_HOME}/bin:${PATH}"
ENV CPATH="${MPI_HOME}/lib/include:${MPI_HOME}/include:${UCX_HOME}/include:${CPATH}"
ENV LIBRARY_PATH="${MPI_HOME}/lib:${UCX_HOME}/lib:${LIBRARY_PATH}"
ENV LD_RUN_PATH="${MPI_HOME}/lib:${UCX_HOME}/lib:${LD_RUN_PATH}"
ENV LD_LIBRARY_PATH="${MPI_HOME}/lib:${UCX_HOME}/lib:${LD_LIBRARY_PATH}"

# Allow mpi to run as root inside container
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


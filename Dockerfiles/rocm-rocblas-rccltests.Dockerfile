# ROCm/rocBLAS Clients and RCCL Tests
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Revision: V1.0
# V1.0 initial version, rocblas and rccltests, transferbench

ARG base_rocm_docker
FROM docker.io/${base_rocm_docker}
MAINTAINER srinivasan.subramanian@amd.com 

# Readme:
# Docker build command
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22-rocblas bash -c 'docker build --no-cache --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-rccltests -f rocblas-rccltests.Dockerfile `pwd`'
# Podman build command (selinux disable)
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22-rocblas bash -c 'podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-rccltests -f rocm-rocblas-rccltests.Dockerfile `pwd`'


ARG rccltests_ver="develop"
ARG transferbench_ver="develop"

#Lables
LABEL "com.amd.container.description"="ROCm/rocblas clients and RCCL Tests, TransferBench"

LABEL "com.amd.container.rccltests.version"=${rccltests_ver}
LABEL "com.amd.container.transferbench.version"=${transferbench_ver}

# Set up paths
ENV PATH="/root/downloads/rccl-tests/build:/root/downloads/TransferBench/:${PATH}"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libmsgpack-dev \
    python3-joblib && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    git clone https://github.com/ROCm/rccl-tests && \
    cd rccl-tests && \
    git checkout ${rccltests_ver} && \
    mkdir build && \
    cd build && \
    CXX=hipcc cmake -DCMAKE_VERBOSE_MAKEFILE=1 -DCMAKE_PREFIX_PATH=${ROCM_PATH}/lib .. && \
    make VERBOSE=1 && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    git clone https://github.com/ROCm/TransferBench && \
    cd TransferBench && \
    git checkout ${transferbench_ver} && \
    mkdir build && \
    cd build && \
    CXX=hipcc cmake -DCMAKE_VERBOSE_MAKEFILE=1 .. && \
    make VERBOSE=1 && \
    ldconfig && \
    hash -r && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 

#
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


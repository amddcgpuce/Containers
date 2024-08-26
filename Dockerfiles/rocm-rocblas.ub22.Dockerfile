# ROCm/rocBLAS Clients
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Revision: V1.0
# V1.0 initial version

ARG base_rocm_docker
FROM docker.io/${base_rocm_docker}
MAINTAINER srinivasan.subramanian@amd.com 

# Readme:
# Docker build command
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'docker build --no-cache --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-rocblas -f rocblas.ub22.Dockerfile `pwd`'
# Podman build command (selinux disable)
# BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-rocblas -f rocm-rocblas.ub22.Dockerfile `pwd`'

#Lables
LABEL "com.amd.container.description"="ROCm/rocblas clients"
LABEL "com.amd.container.rocblas.version"="v6.2.0"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libmsgpack-dev \
    python3-joblib && \
    cd $HOME && \
    git clone https://github.com/ROCm/rocBLAS && \
    cd $HOME/rocBLAS && \
    git checkout tags/rocm-6.2.0 && \
    sed -i -e "s/xvf blis.tar.gz/xvf blis.tar.gz --no-same-owner/" install.sh && \
    sed -i -e "/BUILD_CLIENTS ON/  s/$/\n   set( BUILD_CLIENTS_TESTS OFF )\n/" CMakeLists.txt && \
    ./install.sh -c && \
    cd $HOME/rocBLAS/build/release && \
    make package/fast && \
    dpkg-deb -xv $HOME/rocBLAS/build/release/rocblas-benchmarks_4.2.0.60200-54f305c1~dirty_amd64.deb / && \
    dpkg-deb -xv $HOME/rocBLAS/build/release/rocblas-clients_4.2.0.60200-54f305c1~dirty_amd64.deb / && \
    dpkg-deb -xv $HOME/rocBLAS/build/release/rocblas-clients-common_4.2.0.60200-54f305c1~dirty_amd64.deb / && \
    dpkg-deb -xv $HOME/rocBLAS/build/release/rocblas-dev_4.2.0.60200-54f305c1~dirty_amd64.deb / && \
    dpkg-deb -xv $HOME/rocBLAS/build/release/rocblas-samples_4.2.0.60200-54f305c1~dirty_amd64.deb / && \
    ldconfig && \
    cd $HOME && \
    git clone https://github.com/ROCm/hipBLAS-common && \
    cd $HOME/hipBLAS-common && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make package && \
    make install && \
    ldconfig && \
    cd $HOME && \
    git clone https://github.com/ROCm/hipBLASLt.git && \
    cd $HOME/hipBLASLt && \
    git checkout tags/rocm-6.2.0 && \
    sed -i -e "s/xvf blis.tar.gz/xvf blis.tar.gz --no-same-owner/" install.sh && \
    sed -i -e "s/BUILD_CLIENTS_TESTS=ON/BUILD_CLIENTS_TESTS=OFF/" install.sh && \
    ./install.sh -cd && \
    cd build/release/clients && \
    make package/fast && \
    dpkg-deb -xv $HOME/hipBLASLt/build/release/hipblaslt-benchmarks_0.8.0.60200-50015815*amd64.deb / && \
    dpkg-deb -xv $HOME/hipBLASLt/build/release/hipblaslt-clients_0.8.0.60200-50015815*amd64.deb / && \
    dpkg-deb -xv $HOME/hipBLASLt/build/release/hipblaslt-clients-common_0.8.0.60200-50015815*amd64.deb / && \
    dpkg-deb -xv $HOME/hipBLASLt/build/release/hipblaslt-samples_0.8.0.60200-50015815*amd64.deb / && \
    ldconfig && \
    hash -r && \
    rm -rf $HOME/rocBLAS && \
    rm -rf $HOME/hipBLAS-common && \
    rm -rf $HOME/hipBLASLt && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 

#
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


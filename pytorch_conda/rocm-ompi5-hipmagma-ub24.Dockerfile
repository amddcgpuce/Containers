# ROCm HIP MAGMA Dockerfile
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author(s): srinivasan.subramanian@amd.com
#V1.1
ARG base_rocm_docker=amddcgpuce/rocm:6.2.0-ub24-ompi5-ucx17
FROM docker.io/${base_rocm_docker}
#FROM rocm:6.2.0-ub22-ompi5-ucx17

# Add rocm_version build arg to use in dockerbuild dir name
ARG rocm_version="6.2.0"

MAINTAINER srinivasan.subramanian@amd.com

# README - podman command line to build rocm-pytorch docker
# time podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=amddcgpuce/rocm:6.2.0-ub22-ompi5-ucx17 --build-arg rocm_version=6.2.0 -v $HOME:/workdir -t amddcgpuce/rocm:6.2.0-ub22-hipmagmav280 -f rocm-ompi5-hipmagma.Dockerfile `pwd`

# Labels
LABEL "com.amd.container.aisw.description"="HIP MAGMA on Latest ROCm GA Release Container for Development"
LABEL "com.amd.container.aisw.gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942, gfx1030"
LABEL "com.amd.container.aisw.python3.version"="3.10"

# NOTE: Update MAGMA version when newer release is available
ARG MAGMA_VERSION="v2.8.0"
LABEL "com.amd.container.aisw.magma.version"=${MAGMA_VERSION}

# Update MKL when newer release is available
ARG MKL_VERSION="2024.1.0"
LABEL "com.amd.container.aisw.mkl.version"=${MKL_VERSION}

ARG dockerbuild_dirname="hipmagma.${MAGMA_VERSION}.${rocm_version}"

ENV MKLROOT="/usr/local"
ENV MAGMA_HOME="/usr/local/magma"
ENV PKG_CONFIG_PATH="${MAGMA_HOME}/pkgconfig:${PKG_CONFIG_PATH}"
ENV LIBRARY_PATH="${LIBRARY_PATH}:${MAGMA_HOME}/lib"
ENV LD_RUN_PATH="${LD_RUN_PATH}:${MAGMA_HOME}/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${MAGMA_HOME}/lib"
ENV CPATH="${CPATH}:${MAGMA_HOME}/include"

# limit parallel jobs to 8
ENV MAX_JOBS="8"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 \
    python3-pip \
    zstd \
    libzstd-dev \
    ninja-build \
    pipx \
    wget && \
    cd $HOME && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    cd $HOME && \
    mkdir -p $HOME/.config/pip && \
    echo "[global]\nbreak-system-packages = true\n" | tee -a $HOME/.config/pip/pip.conf && \
    mkdir -p $HOME/dockerbuild/${dockerbuild_dirname}/ && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    pip3 install --no-cache-dir cmake ninja  && \
    pip3 install --no-cache-dir mkl==${MKL_VERSION} mkl-devel==${MKL_VERSION} && \
    ln -s /usr/local/lib/libmkl_gf_lp64.so.2 /usr/local/lib/libmkl_gf_lp64.so && \
    ln -s /usr/local/lib/libmkl_gnu_thread.so.2 /usr/local/lib/libmkl_gnu_thread.so && \
    ln -s /usr/local/lib/libmkl_core.so.2 /usr/local/lib/libmkl_core.so && \
    ln -s /usr/local/lib/libmkl_tbb_thread.so.2 /usr/local/lib/libmkl_tbb_thread.so && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    git clone https://bitbucket.org/icl/magma && \
    cd magma && \
    git checkout tags/${MAGMA_VERSION} && \
    git submodule update --init --recursive && \
    cp make.inc-examples/make.inc.hip-gcc-mkl make.inc && \
    sed -i -e "/LIBDIR.*ROCM_PATH.*MKLROOT/ s/$/ -L\$\(MKLROOT\)\/lib/" make.inc && \
    MKLROOT=/usr/local make lib/libmagma.so install && \
    cd $HOME && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    hash -r && \
    pip3 list -v && \
    rm -rf $HOME/dockerbuild && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]



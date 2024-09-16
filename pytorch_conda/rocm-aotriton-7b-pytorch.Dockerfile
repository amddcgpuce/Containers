# ROCm Stable PyTorch Dockerfile to build pytorch, vision on preinstalled AOTriton
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author(s): srinivasan.subramanian@amd.com
#V1.1
# V1.1: Workaround for aotriton, pytorch compile error
#
ARG base_rocm_docker=amddcgpuce/rocm:6.2.0-ub22-hipmagmav280-aot7b
FROM docker.io/${base_rocm_docker}
#FROM rocm:6.2.0-ub22-hipmagmav280-aot7b

# README
# time podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=amddcgpuce/rocm:6.2.0-ub22-hipmagmav280-aot7b --build-arg rocm_version=6.2.0 -v $HOME:/workdir -t amddcgpuce/rocm:6.2.0-ub22-aot7b-pt241_py310_0191 -f rocm-aotrition-7b-pytorch.Dockerfile `pwd`

# Add rocm_version build arg to use in dockerbuild dir name
ARG rocm_version="6.2.0"

MAINTAINER srinivasan.subramanian@amd.com

# Labels
LABEL "com.amd.container.aisw.description"="Stable Pytorch on Latest ROCm GA Release Container for Development"
LABEL "com.amd.container.aisw.gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942, gfx1030"
LABEL "com.amd.container.aisw.python3.version"="3.10"

ARG PYTORCH_VERSION="v2.4.1"
LABEL "com.amd.container.aisw.torch.version"=${PYTORCH_VERSION}

ARG TORCHVISION_VERSION="v0.19.1"
LABEL "com.amd.container.aisw.torchvision.version"=${TORCHVISION_VERSION}

ARG dockerbuild_dirname="pytorch.${PYTORCH_VERSION}.${TORCHVISION_VERSION}.${rocm_version}"

ENV PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942;gfx1030"

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
    wget && \
    cd $HOME && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    mkdir -p $HOME/dockerbuild/${dockerbuild_dirname}/ && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    pip3 install --no-cache-dir cmake ninja  && \
    git clone https://github.com/pytorch/pytorch && \
    cd pytorch && \
    git checkout tags/${PYTORCH_VERSION} && \
    git submodule update --init --recursive && \
    pip3 install --no-cache-dir -r requirements.txt && \
    sed -i -e '/Wno-unused-but-set-parameter/ a  target_compile_options_if_supported(test_api \"-Wno-error=nonnull\")' test/cpp/api/CMakeLists.txt && \
    python3 tools/amd_build/build_amd.py && \
    PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942;gfx1030" USE_ROCM=1 USE_CUDA=OFF CMAKE_VERBOSE_MAKEFILE=1 CMAKE_CXX_COMPILER=g++ CMAKE_C_COMPILER=gcc COMAKE_Fortran_COMPILER=gfortran python3 setup.py install && \
    cd $HOME && \
    rm -f /etc/ld.so.cache && \
    ldconfig && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    git clone https://github.com/pytorch/vision.git && \
    cd vision && \
    git checkout tags/${TORCHVISION_VERSION} && \
    git submodule update --init --recursive && \
    sed -i -e "s/^    pytorch_dep,//" setup.py && \
    PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942;gfx1030" USE_ROCM=1 USE_CUDA=OFF CMAKE_VERBOSE_MAKEFILE=1 CMAKE_CXX_COMPILER=g++ CMAKE_C_COMPILER=gcc COMAKE_Fortran_COMPILER=gfortran python3 setup.py install && \
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



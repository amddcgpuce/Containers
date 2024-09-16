# Ubuntu 24 based ROCm with Latest main PyTorch version Dockerfile
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author(s): srinivasan.subramanian@amd.com
#V1.0
# V1.0: 
#
ARG base_rocm_docker=amddcgpuce/rocm:6.2.0-ub24-hipmagmav280-aot6b
FROM docker.io/${base_rocm_docker}

# README
# time podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=amddcgpuce/rocm:6.2.0-ub24-hipmagmav280-aot6b --build-arg rocm_version=6.2.0 -v $HOME:/workdir -t amddcgpuce/rocm:6.2.0-ub24-aot6b-ptmain_py312 -f rocm-aotriton-6b-pytorch-main-ub24.Dockerfile `pwd`

# Add rocm_version build arg to use in dockerbuild dir name
ARG rocm_version="6.2.0"

MAINTAINER srinivasan.subramanian@amd.com

# Labels
LABEL "com.amd.container.aisw.description"="Latest Pytorch, Vision on Latest ROCm GA Release Container for Development"
LABEL "com.amd.container.aisw.gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942, gfx1030"
LABEL "com.amd.container.aisw.python3.version"="3.12"

ARG USE_PYTORCH_VERSION="latest"
LABEL "com.amd.container.aisw.torch.version"=${USE_PYTORCH_VERSION}

ARG TORCHVISION_VERSION="latest"
LABEL "com.amd.container.aisw.torchvision.version"=${TORCHVISION_VERSION}

ARG dockerbuild_dirname="pytorch.${USE_PYTORCH_VERSION}.${TORCHVISION_VERSION}.${rocm_version}"

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
    pipx \
    wget && \
    cd $HOME && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    mkdir -p $HOME/dockerbuild/${dockerbuild_dirname}/ && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    pip3 install --no-cache-dir cmake ninja  && \
    cd $HOME && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    git clone https://github.com/pytorch/pytorch && \
    cd pytorch && \
    git submodule update --init --recursive && \
    pip3 install --no-cache-dir -r requirements.txt && \
    sed -i -e '/Wno-unused-but-set-parameter/ a  target_compile_options_if_supported(test_api \"-Wno-error=nonnull\")' test/cpp/api/CMakeLists.txt && \
    sed -i -e '/Workaround for https:/ a  set_source_files_properties(src/UtilsAvx512.cc PROPERTIES COMPILE_FLAGS \"-Wno-error=maybe-uninitialized\")' third_party/fbgemm/CMakeLists.txt && \
    python3 tools/amd_build/build_amd.py && \
    sed -i -e "s#gtest_main#gtest_main /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so#" c10/hip/test/CMakeLists.txt && \
    sed -i -e "s#gtest unbox_lib#gtest unbox_lib /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so#" test/edge/CMakeLists.txt && \
    sed -i -e "s#ARGN}#ARGN} /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so#"  test/cpp/c10d/CMakeLists.txt && \
    sed -i -e 's#example_allreduce pthread torch_cpu#example_allreduce pthread torch_cpu /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so#' test/cpp/c10d/CMakeLists.txt && \
    sed -i -e 's#shm c10#shm c10 /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so#' torch/lib/libshm/CMakeLists.txt && \
    sed -i -e 's#target_link_libraries(torch PUBLIC torch_hip_library)#target_link_libraries(torch PUBLIC torch_hip_library /opt/rocm-6.2.0/lib/libhsa-runtime64.so /opt/rocm-6.2.0/lib/librocprofiler-register.so)#' caffe2/CMakeLists.txt && \
    PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942;gfx1030" USE_ROCM=1 USE_CUDA=OFF CMAKE_VERBOSE_MAKEFILE=1 CMAKE_CXX_COMPILER=g++ CMAKE_C_COMPILER=gcc COMAKE_Fortran_COMPILER=gfortran python3 setup.py install && \
    cd $HOME && \
    rm -f /etc/ld.so.cache && \
    ldconfig && \
    cd $HOME/dockerbuild/${dockerbuild_dirname} && \
    git clone https://github.com/pytorch/vision.git && \
    cd vision && \
    git submodule update --init --recursive && \
    sed -i -e "s/^        pytorch_dep,//" setup.py && \
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



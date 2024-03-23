# ROCm Build  (internal artifactory) Dockerfile
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author: srinivasan.subramanian@amd.com
# Revision: V1.2
# V1.2 add g++-12, override baseurl=default option V1.72 rocminstall script
# V1.1 add gawk, python3-venv (corresponding to V1.6 rocm.ub22.Dockerfile)
# V1.0 initial version based on rocm.ub22.Dockerfile V1.4

FROM ubuntu:22.04

MAINTAINER sid.srinivasan@amd.com 
MAINTAINER srinivasan.subramanian@amd.com 

# Readme:
# Docker build command for ROCm CI build for 6.0.1
# docker build --no-cache --build-arg rocm_repo=6.0.1 --build-arg rocm_version=6.0.1 --build-arg rocm_lib_version=60001 --build-arg rocm_path=/opt/rocm-6.0.1 --build-arg ROCM_CI_ARTIFACTORY_BUILD_URL=<url> -t amddcgpuce/rocm-ci:6.0.1-ub22 -f rocm.ci.ub22.Dockerfile `pwd`
# Docker build command for ROCm RC release (ubuntu22)
# docker build --no-cache --build-arg rocm_repo=6.1.0 --build-arg rocm_version=6.1.0 --build-arg rocm_lib_version=60100 --build-arg rocm_path=/opt/rocm-6.1.0 --build-arg ROCM_CI_ARTIFACTORY_BUILD_URL=https://repo.radeon.com/rocm/apt/.apt_6.1/ -t amddcgpuce/rocm-ci:6.1.0-rc3-ub22 -f rocm.ci.ub22.Dockerfile `pwd`
# Podman build command (selinux disable)
# podman build --no-cache --security-opt label=disable --build-arg rocm_repo=6.0.1 --build-arg rocm_version=6.0.1 --build-arg rocm_lib_version=60001 --build-arg rocm_path=/opt/rocm-6.0.1 --build-arg ROCM_CI_ARTIFACTORY_BUILD_URL=<url> -t amddcgpuce/rocm-ci:6.0.1-ub22 -f rocm.ci.ub22.Dockerfile `pwd`
# Podman build command (selinux disable) for ROCm RC release (example 6.1 RC)
# podman build --no-cache --security-opt label=disable --build-arg rocm_repo=6.1.0 --build-arg rocm_version=6.1.0 --build-arg rocm_lib_version=60100 --build-arg rocm_path=/opt/rocm-6.1.0 --build-arg ROCM_CI_ARTIFACTORY_BUILD_URL=https://repo.radeon.com/rocm/apt/.apt_6.1/ -t amddcgpuce/rocm-ci:6.1.0-rc3-ub22 -f rocm.ci.ub22.Dockerfile `pwd`

ARG rocm_repo
ENV ROCM_REPO=${rocm_repo}
ARG rocm_path
ENV ROCM_PATH=${rocm_path}
ENV HIP_PATH=${rocm_path}
ARG rocm_lib_version
ENV ROCM_LIBPATCH_VERSION=${rocm_lib_version}
ARG rocm_version
ENV ROCM_VERSION=${rocm_version}
#ARG ROCM_CI_ARTIFACTORY_BUILD_URL="https://compute-artifactory.amd.com/artifactory/list/rocm-osdb-22.04-deb/compute-rocm-rel-6.0-112/"
ARG ROCM_CI_ARTIFACTORY_BUILD_URL="default"

#Lables
LABEL "com.amd.container.description"="Base ROCm Release Container for Development"
LABEL "com.amd.container.baseos.type"="Ubuntu 22"
LABEL "com.amd.container.rocm.version"=$rocm_version
LABEL "com.amd.container.rocm.gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    aria2 \
    autoconf \
    bison \
    bzip2 \
    check \
    cifs-utils \
    cmake \
    curl \
    dos2unix \
    doxygen \
    flex \
    texinfo \
    gcc-12 \
    g++-12 \
    gfortran-12 \
    g++-multilib \
    gcc-multilib \
    git \
    locales \
    libatlas-base-dev \
    libbabeltrace1 \
    libboost-all-dev \
    libboost-program-options-dev \
    libelf-dev \
    libelf1 \
    libfftw3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libnuma-dev \
    libopenblas-base \
    libopenblas-dev \
    libopencv-dev \
    libpci3 \
    libpython3.8 \
    libfile-which-perl \
    libprotobuf-dev \
    libstdc++-12-dev \
    libsnappy-dev \
    libssl-dev \
    gawk libtinfo-dev libfile-copy-recursive-perl libfile-basedir-perl libomp-dev libdrm-dev libtinfo5 libncurses5 mesa-common-dev kmod pciutils libsystemd-dev libpciaccess-dev libxml2-dev libyaml-cpp-dev \
    libunwind-dev \
    libyaml-cpp0.7 \
    ocl-icd-dev \
    ocl-icd-opencl-dev \
    pkg-config \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    libpython3-dev \
    python3-venv \
    software-properties-common \
    ssh \
    swig \
    sudo \
    unzip \
    vim \
    xsltproc && \
    pip3 install Cython && \
    pip3 install numpy && \
    pip3 install optionloop && \
    pip3 install setuptools && \
    pip3 install CppHeaderParser argparse && \
    ldconfig && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel  --baseurl ${ROCM_CI_ARTIFACTORY_BUILD_URL} --rev ${ROCM_REPO} --nomiopenkernels --ubuntudist=jammy && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads && \
    wget https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0.tar.gz && \
    tar zxvf cmake-3.29.0.tar.gz && \
    cd cmake-3.29.0 && \
    ./bootstrap && \
    make && \
    make install && \
    hash -r && \
    cd $HOME && \
    rm -rf cmake-3.29* && \
    cd $HOME && \
    apt clean && \
    apt-get update && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3.8 libpython3.8-dev && \
    rm -rf /var/lib/apt/lists/* downloads && \
    cd $HOME && \
    echo "/opt/rocm-${rocm_version}/lib" | sudo tee -a /etc/ld.so.conf.d/rocmlib.conf && \
    sudo ldconfig && \
    cd $HOME && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 



#
RUN /bin/sh -c 'ln -sf ${ROCM_PATH} /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="${ROCM_PATH}/bin:${ROCM_PATH}/llvm/bin:${ROCM_PATH}/opencl/bin:${PATH}"
ENV CMAKE_PREFIX_PATH="${ROCM_PATH}:${CMAKE_PREFIX_PATH}"
ENV CPATH="${ROCM_PATH}/include:${ROCM_PATH}/include/hip:${ROCM_PATH}/hsa/include:${ROCM_PATH}/llvm/include:${CPATH}"
ENV LIBRARY_PATH="${ROCM_PATH}/lib:${ROCM_PATH}/hip/lib:${ROCM_PATH}/hsa/lib:${ROCM_PATH}/lib64:${ROCM_PATH}/opencl/lib:${ROCM_PATH}/opencl/lib/x86_64:${ROCM_PATH}/llvm/lib:${LIBRARY_PATH}"
ENV LD_RUN_PATH="${ROCM_PATH}/lib:${ROCM_PATH}/hip/lib:${ROCM_PATH}/hsa/lib:${ROCM_PATH}/lib64:${ROCM_PATH}/opencl/lib:${ROCM_PATH}/opencl/lib/x86_64:${ROCM_PATH}/llvm/lib:${LD_RUN_PATH}"
ENV LD_LIBRARY_PATH="${ROCM_PATH}/lib:${ROCM_PATH}/hip/lib:${ROCM_PATH}/hsa/lib:${ROCM_PATH}/lib64:${ROCM_PATH}/opencl/lib:${ROCM_PATH}/opencl/lib/x86_64:${ROCM_PATH}/llvm/lib:${LD_LIBRARY_PATH}"
ENV PKG_CONFIG_PATH="${ROCM_PATH}/lib/pkgconfig:${PKG_CONFIG_PATH}"
ENV MANPATH="${ROCM_PATH}/share/man:${MANPATH}"

ENV ROCM_LLVM="${ROCM_PATH}/llvm"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


# ROCm Dockerfile
# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.
# Author: srinivasan.subramanian@amd.com
# Edited By: sid.srinivasan@amd.com
# Revision: V1.2
# V1.2 use rocblas tag 5.3.0
# V1.1 added rocm_version build arg
# V1.0 initial version

FROM ubuntu:20.04

# 5.3
# BUILD ARGS specified using --build-arg rocm_repo=5.3 --build-arg rocm_version=5.3.0 --build-arg rocm_lib_version=50300 --build-arg rocm_path=/opt/rocm-5.3.0 --build-arg rocblas_ver=5.3.0
#
# BUILD ARGS specified using --build-arg rocm_repo=5.2.3 --build-arg rocm_version=5.2.3 --build-arg rocm_lib_version=50203 --build-arg rocm_path=/opt/rocm-5.2.3 --build-arg rocblas_ver=5.2
# BUILD ARGs specified using --build-arg rocm_repo=5.2 --build-arg rocm_version=5.2 --build-arg rocm_lib_version=50200 --build-arg rocm_path=/opt/rocm-5.2.0 --build-arg rocblas_ver=5.2
# BUILD ARGs specified using --build-arg rocm_repo=5.1.3 --build-arg rocm_version=5.1.3 --build-arg rocm_lib_version=50103 --build-arg rocm_path=/opt/rocm-5.1.3 --build-arg rocblas_ver=5.1

ARG rocm_repo
ENV ROCM_REPO=${rocm_repo}
ARG rocm_path
ENV ROCM_PATH=${rocm_path}
# need to fix hardcoded
# ENV ROCM_LIBPATCH_VERSION=50100
ARG rocm_lib_version
ENV ROCM_LIBPATCH_VERSION=${rocm_lib_version}
#ENV ROCM_VERSION=5.1.0
ARG rocm_version
ENV ROCM_VERSION=${rocm_version}
ARG rocblas_ver

RUN echo "Build docker for ROCM VERSION $rocm_version"

RUN sed -i -e "s/\/archive.ubuntu/\/us.archive.ubuntu/" /etc/apt/sources.list && \
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
    dkms \
    dos2unix \
    doxygen \
    flex \
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
    libsnappy-dev \
    libssl-dev \
    libunwind-dev \
    ocl-icd-dev \
    ocl-icd-opencl-dev \
    pkg-config \
    protobuf-compiler \
    python-numpy \
    python-pip-whl \
    python-yaml \
    python3-dev \
    python3-pip \
    ssh \
    swig \
    sudo \
    unzip \
    vim \
    xsltproc && \
    pip3 install Cython && \
    pip3 install numpy && \
    pip3 install optionloop && \
    pip install Cython && \
    pip install numpy && \
    pip install optionloop && \
    pip install setuptools && \
    pip install CppHeaderParser argparse && \
    ldconfig && \
    cd $HOME && \
    mkdir -p downloads && \
    cd downloads && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel --rev ${ROCM_REPO} --nomiopenkernels && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads && \
    wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2.tar.gz && \
    tar zxvf cmake-3.22.2.tar.gz && \
    cd cmake-3.22.2 && \
    ./bootstrap && \
    make && \
    make install && \
    hash -r && \
    cd $HOME && \
    rm -rf cmake-3.22* && \
    cd $HOME && \
    git clone --recurse-submodules https://github.com/ROCmSoftwarePlatform/rocBLAS && \
    cd rocBLAS && \
    git checkout --recurse-submodules tags/rocm-${rocblas_ver} && \
    ./install.sh -cd && \
    cd build/release && \
    make package/fast && \
    cd $HOME/rocBLAS && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-clients_*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-clients-common_*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-benchmarks*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-tests*.deb / && \
    cd $HOME && \
    rm -rf rocBLAS && \
    cd $HOME



#
RUN /bin/sh -c 'ln -sf ${ROCM_PATH} /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="/opt/${ROCM_PATH}/bin:/opt/${ROCM_PATH}/opencl/bin:${PATH}"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]

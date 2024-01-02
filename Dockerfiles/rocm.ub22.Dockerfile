# ROCm Dockerfile
# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.
# Author: srinivasan.subramanian@amd.com
# Edited By: sid.srinivasan@amd.com
# Revision: V1.1
# V1.0 initial version
# V1.1 6/29/2023 ROCm 5.6 Version
# For 5.6.0 use branch develop for rocblas
# V1.2 8/15/2023 ROCm 5.7 Version
# V1.3 1/2/2024 ROCm 6.0 Version


FROM ubuntu:22.04
MAINTAINER Sid.srinivasan@amd.com 
#5.5.1
#sudo docker build --no-cache --build-arg rocm_repo=5.5.1 --build-arg rocm_version=5.5.1 --build-arg rocm_lib_version=50501 --build-arg rocm_path=/opt/rocm-5.5.1 --build-arg rocblas_ver=5.5.1 -t amddcgpuce/rocm:5.5.1-ub22 -f rocm.ub22.Dockerfile `pwd`
# 5.5 docker build, rocblas_ver is 5.5 to checkout branch, not tag. If using tag, use rocblas_ver=5.5.0 and update git checkout
#sudo docker build --no-cache --build-arg rocm_repo=5.5 --build-arg rocm_version=5.5.0 --build-arg rocm_lib_version=50500 --build-arg rocm_path=/opt/rocm-5.5.0 --build-arg rocblas_ver=5.5 -t amddcgpuce/rocm:5.5.0-ub22 -f rocm.ub22.Dockerfile `pwd`
#5.4.3 docker build for ubuntu 20 based
#sudo docker build --no-cache --build-arg rocm_repo=5.4.3 --build-arg rocm_version=5.4.3 --build-arg rocm_lib_version=50403 --build-arg rocm_path=/opt/rocm-5.4.3 --build-arg rocblas_ver=5.4.3 -t srinivamd/rocm:5.4.3-ub20 -f rocm.ub20.Dockerfile `pwd`
# 5.6 
#sudo docker build --no-cache --build-arg rocm_repo=5.6 --build-arg rocm_version=5.6.0 --build-arg rocm_lib_version=50600 --build-arg rocm_path=/opt/rocm-5.6.0 --build-arg rocblas_ver=5.6.0 -t amddcgpuce/rocm:5.6.0-ub22 -f rocm.ub22.Dockerfile `pwd`
# 5.6.1
# sudo docker build --no-cache --build-arg rocm_repo=5.6.1 --build-arg rocm_version=5.6.1 --build-arg rocm_lib_version=506001 --build-arg rocm_path=/opt/rocm-5.6.1 --build-arg rocblas_ver=5.6 -t amddcgpuce/rocm:5.6.1-ub22 -f rocm.ub22.Dockerfile `pwd`

#5.7
# sudo docker build --no-cache --build-arg rocm_repo=5.7 --build-arg rocm_version=5.7.0 --build-arg rocm_lib_version=50700 --build-arg rocm_path=/opt/rocm-5.7.0 --build-arg rocblas_ver=5.7.0 -t amddcgpuce/rocm:5.7.0-ub22 -f rocm.ub22.Dockerfile `pwd`
#5.7.1 
# sudo docker build --no-cache --build-arg rocm_repo=5.7.1 --build-arg rocm_version=5.7.1 --build-arg rocm_lib_version=507001 --build-arg rocm_path=/opt/rocm-5.7.1 --build-arg rocblas_ver=5.7.1 -t amddcgpuce/rocm:5.7.1-ub22 -f rocm.ub22.Dockerfile `pwd`
#6.0
# sudo docker build --no-cache --build-arg rocm_repo=6.0 --build-arg rocm_version=6.0.0 --build-arg rocm_lib_version=60000 --build-arg rocm_path=/opt/rocm-6.0.0 --build-arg rocblas_ver=6.0.0 -t amddcgpuce/rocm:6.0.0-ub22 -f rocm.ub22.Dockerfile `pwd`


ARG rocm_repo
ENV ROCM_REPO=${rocm_repo}
ARG rocm_path
ENV ROCM_PATH=${rocm_path}
ENV HIP_PATH=${rocm_path}
# need to fix hardcoded
# ENV ROCM_LIBPATCH_VERSION=50100
ARG rocm_lib_version
ENV ROCM_LIBPATCH_VERSION=${rocm_lib_version}
#ENV ROCM_VERSION=5.1.0
ARG rocm_version
ENV ROCM_VERSION=${rocm_version}
ARG rocblas_ver

ENV HIPCC_COMPILE_FLAGS_APPEND="--offload-arch=gfx940 --offload-arch=gfx941 --offload-arch-gfx942 --offload-arch=gfx90a --offload-arch=gfx908"
RUN echo "Build docker for ROCM VERSION $rocm_version"

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
    dkms \
    dos2unix \
    doxygen \
    flex \
    texinfo \
    gcc-11 \
    gfortran-11 \
    gcc-12 \
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
    libunwind-dev \
    ocl-icd-dev \
    ocl-icd-opencl-dev \
    pkg-config \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    python3.10-dev \
    libpython3.10-dev \
    python3-pip \
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
    python3 ./rocminstall.py --nokernel  --rev ${ROCM_REPO} --nomiopenkernels --ubuntudist=jammy && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads && \
    wget https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz && \
    tar zxvf cmake-3.28.1.tar.gz && \
    cd cmake-3.28.1 && \
    ./bootstrap && \
    make && \
    make install && \
    hash -r && \
    cd $HOME && \
    rm -rf cmake-3.28* && \
    cd $HOME && \
    apt clean && \
    apt-get update && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3.8 libpython3.8-dev && \
    git clone --recurse-submodules https://github.com/ROCmSoftwarePlatform/rocBLAS && \
    cd rocBLAS && \
    git checkout tags/rocm-${rocblas_ver} && \
    ./install.sh -cd && \
    cd build/release && \
    make package/fast && \
    cd $HOME/rocBLAS && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-clients_*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-clients-common_*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-benchmarks*.deb / && \
    /usr/bin/dpkg-deb -xv build/release/rocblas-tests*.deb / && \
    cd $HOME && \
    echo "/opt/rocm-${rocm_version}/lib" | sudo tee -a /etc/ld.so.conf.d/rocmlib.conf && \
    sudo ldconfig && \
    cd $HOME && \
    rm -rf rocBLAS && \
    cd $HOME && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 



#
RUN /bin/sh -c 'ln -sf ${ROCM_PATH} /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="${ROCM_PATH}/bin:${ROCM_PATH}/llvm/bin:${ROCM_PATH}/opencl/bin:${PATH}"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


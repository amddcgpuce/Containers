# ROCm Dockerfile
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author(s): sid.srinivasan@amd.com, srinivasan.subramanian@amd.com
# Revision: V1.12
# V1.12 Simply args, rocm_ver and repo baseurl
# V1.11 Fix for ROCm 6.2, use amdgpuinstall to install mesa libs
# V1.10 setup link to system libgomp.so
# V1.9 add gdb, update-alternatives make gcc 12 default
# V1.8 add g++-12, cmake 3.29
# V1.7 add python3-venv
# V1.6 add gawk for awk
# V1.5 add ROCm package dependencies
# V1.4 Fix labels, add libyaml-cpp0.7 for rvs
# V1.3 1/2/2024 ROCm 6.0 Version, remove rocblas
# V1.2 8/15/2023 ROCm 5.7 Version
# V1.1 6/29/2023 ROCm 5.6 Version
# V1.0 initial version

FROM ubuntu:22.04
MAINTAINER sid.srinivasan@amd.com 
MAINTAINER srinivasan.subramanian@amd.com 

# Readme:
# Docker build command for ROCm release version X.Y.Z (Ex: 6.2.0 for 6.2 release)
# ROCM_VERSION="6.2.0" bash -c 'docker build --no-cache --build-arg rocm_version=${ROCM_VERSION} --build-arg rocm_repo_baseurl=https://repo.radeon.com/rocm/apt/6.2/ --build-arg amdgpu_repo_baseurl=https://repo.radeon.com/amdgpu/6.2/ubuntu -t amddcgpuce/rocm:${ROCM_VERSION}-ub22 -f rocm.ub22.Dockerfile `pwd` '
# ROCM_VERSION="6.2.1" bash -c 'docker build --no-cache --build-arg rocm_version=${ROCM_VERSION} --build-arg rocm_repo_baseurl=https://repo.radeon.com/rocm/apt/6.2.1/ --build-arg amdgpu_repo_baseurl=https://repo.radeon.com/amdgpu/6.2.1/ubuntu -t amddcgpuce/rocm:${ROCM_VERSION}-ub22 -f rocm.ub22.Dockerfile `pwd` '
# Podman build command (selinux disable)
# ROCM_VERSION="6.2.0" bash -c 'podman build --no-cache --security-opt label=disable --build-arg rocm_version=${ROCM_VERSION} --build-arg rocm_repo_baseurl=https://repo.radeon.com/rocm/apt/6.2/ --build-arg amdgpu_repo_baseurl=https://repo.radeon.com/amdgpu/6.2/ubuntu -t amddcgpuce/rocm:${ROCM_VERSION}-ub22 -f rocm.ub22.Dockerfile `pwd`'
# ROCM_VERSION="6.2.1" bash -c 'podman build --no-cache --security-opt label=disable --build-arg rocm_version=${ROCM_VERSION} --build-arg rocm_repo_baseurl=https://repo.radeon.com/rocm/apt/6.2.1/ --build-arg amdgpu_repo_baseurl=https://repo.radeon.com/amdgpu/6.2.1/ubuntu -t amddcgpuce/rocm:${ROCM_VERSION}-ub22 -f rocm.ub22.Dockerfile `pwd`'
#


ARG rocm_version="6.2.1"
ENV ROCM_VERSION=${rocm_version}
# Pointer to Ubuntu 22 ROCm packages repo
ARG rocm_repo_baseurl="https://repo.radeon.com/rocm/apt/6.2.1"
# Pointer to Ubuntu 22 AMDGPU packages repo
ARG amdgpu_repo_baseurl="https://repo.radeon.com/amdgpu/6.2.1/ubuntu"

# Set up ROCm environment variables
ENV ROCM_PATH="/opt/rocm-"${rocm_version}
ENV HIP_PATH=${ROCM_PATH}
ENV ROCM_HOME=${ROCM_PATH}
# Removed ROCM_LIBPATCH_VERSION env variable

#Lables for Docker
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
    gcc-11 \
    gdb \
    g++-11 \
    gfortran-11 \
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
    wget -O amdgpuinst.py --no-cache --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/amdgpuinst.py && \
    python3 ./amdgpuinst.py --rev ${ROCM_VERSION} --nokernel --baseurl ${amdgpu_repo_baseurl} --ubuntudist jammy && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel  --rev ${ROCM_VERSION} --baseurl ${rocm_repo_baseurl} --nomiopenkernels --ubuntudist=jammy && \
    cd $HOME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* downloads && \
    wget https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2.tar.gz && \
    tar zxvf cmake-3.30.2.tar.gz && \
    cd cmake-3.30.2 && \
    ./bootstrap && \
    make && \
    make install && \
    hash -r && \
    cd $HOME && \
    rm -rf cmake-3.30* && \
    cd $HOME && \
    apt clean && \
    apt-get update && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install -y python3.8 libpython3.8-dev && \
    rm -rf /var/lib/apt/lists/* downloads && \
    cd $HOME && \
    echo "/opt/rocm-${rocm_version}/lib" | tee -a /etc/ld.so.conf.d/rocmlib.conf && \
    ln -sr /usr/lib/x86_64-linux-gnu/libgomp.so.1 /usr/lib/x86_64-linux-gnu/libgomp.so && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    cd $HOME && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 20 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 20 && \
    update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-12 20 && \
    update-alternatives --install /bin/cpp cpp /usr/bin/cpp-12 20 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-12 20 && \
    update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-12 20 && \
    update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-12 20 && \
    update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-12 20 && \
    update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-12 20 && \
    update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-12 20 && \
    update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-12 20 && \
    update-alternatives --install /usr/bin/lto-dump lto-dump /usr/bin/lto-dump-12 20 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 10 && \
    update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-11 10 && \
    update-alternatives --install /bin/cpp cpp /usr/bin/cpp-11 10 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-11 10 && \
    update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 10 && \
    update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-11 10 && \
    update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11 10 && \
    update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-11 10 && \
    update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-11 10 && \
    update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-11 10 && \
    update-alternatives --install /usr/bin/lto-dump lto-dump /usr/bin/lto-dump-11 10


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


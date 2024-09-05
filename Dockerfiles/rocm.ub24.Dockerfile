# ROCm Dockerfile for Ubuntu 24
# Copyright (c) 2024 Advanced Micro Devices, Inc. All Rights Reserved.
# Author(s): srinivasan.subramanian@amd.com
# Revision: V1.0
# V1.0 initial version for ROCm 6.2

FROM ubuntu:24.04

MAINTAINER srinivasan.subramanian@amd.com 

# Readme: how to build container for 6.2 release
# podman build --no-cache --security-opt label=disable --build-arg rocm_repo=6.2 --build-arg rocm_version=6.2.0 --build-arg rocm_lib_version=60200 --build-arg rocm_path=/opt/rocm-6.2.0 -t amddcgpuce/rocm:6.2.0-ub24 -f rocm.ub24.Dockerfile `pwd` 

ARG rocm_repo
ENV ROCM_REPO=${rocm_repo}
ARG rocm_path
ENV ROCM_PATH=${rocm_path}
ENV HIP_PATH=${rocm_path}
ARG rocm_lib_version
ENV ROCM_LIBPATCH_VERSION=${rocm_lib_version}
ARG rocm_version
ENV ROCM_VERSION=${rocm_version}

#Lables
LABEL "com.amd.container.description"="Base ROCm Release Container for Development"
LABEL "com.amd.container.baseos.type"="Ubuntu 24"
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
    gcc-13 \
    gdb \
    g++-13 \
    gfortran-13 \
    gcc-14 \
    gcc-14-offload-amdgcn \
    cpp-14 \
    g++-14 \
    gfortran-14 \
    g++-multilib \
    gcc-multilib \
    g++-14-multilib \
    gcc-14-multilib \
    gfortran-14-multilib \
    g++-13-multilib \
    gcc-13-multilib \
    gfortran-13-multilib \
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
    libopenblas-dev \
    libopencv-dev \
    libpci3 \
    libpython3.12 \
    libfile-which-perl \
    libprotobuf-dev \
    libstdc++-13-dev \
    libstdc++-14-dev \
    libsnappy-dev \
    libssl-dev \
    gawk libtinfo-dev libfile-copy-recursive-perl libfile-basedir-perl libomp-dev libdrm-dev mesa-common-dev kmod pciutils libsystemd-dev libpciaccess-dev libxml2-dev libyaml-cpp-dev \
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
    cd $HOME && \
    mkdir -p $HOME/downloads && \
    cd $HOME/downloads && \
    wget -O amdgpuinst.py --no-cache --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/amdgpuinst.py && \
    python3 ./amdgpuinst.py --rev ${ROCM_VERSION} --nokernel --ubuntudist noble && \
    wget -O rocminstall.py --no-check-certificate https://raw.githubusercontent.com/srinivamd/rocminstaller/master/rocminstall.py && \
    python3 ./rocminstall.py --nokernel  --rev ${ROCM_REPO} --nomiopenkernels --ubuntudist=noble && \
    cd $HOME && \
    cd $HOME/downloads && \
    wget https://github.com/Kitware/CMake/releases/download/v3.30.2/cmake-3.30.2.tar.gz && \
    tar zxvf cmake-3.30.2.tar.gz && \
    cd cmake-3.30.2 && \
    ./bootstrap && \
    make && \
    make install && \
    hash -r && \
    cd $HOME/downloads && \
    rm -rf cmake-3.30* && \
    cd $HOME && \
    echo "/opt/rocm-${rocm_version}/lib" | tee -a /etc/ld.so.conf.d/rocmlib.conf && \
    ln -sr /usr/lib/x86_64-linux-gnu/libgomp.so.1 /usr/lib/x86_64-linux-gnu/libgomp.so && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    apt clean && \
    hash -r && \
    cd $HOME && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf $HOME/downloads && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache 

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 20 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 20 && \
    update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-14 20 && \
    update-alternatives --remove cpp /usr/bin/cpp && \
    update-alternatives --remove cpp /bin/cpp && \
    update-alternatives --install /bin/cpp cpp /usr/bin/cpp-14 20 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-14 20 && \
    update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-14 20 && \
    update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-14 20 && \
    update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-14 20 && \
    update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-14 20 && \
    update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-14 20 && \
    update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-14 20 && \
    update-alternatives --install /usr/bin/lto-dump lto-dump /usr/bin/lto-dump-14 20 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 10 && \
    update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-13 10 && \
    update-alternatives --install /bin/cpp cpp /usr/bin/cpp-13 10 && \
    update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-13 10 && \
    update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-13 10 && \
    update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-13 10 && \
    update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-13 10 && \
    update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-13 10 && \
    update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-13 10 && \
    update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-13 10 && \
    update-alternatives --install /usr/bin/lto-dump lto-dump /usr/bin/lto-dump-13 10


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


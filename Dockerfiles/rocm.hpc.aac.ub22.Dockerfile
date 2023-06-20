# ROCm Dockerfile
# Copyright (c) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
# Author: srinivasan.subramanian@amd.com
# Edited By: sid.srinivasan@amd.com
# Revision: V1.0
# V1.0 initial version

FROM amddcgpuce/rocm:5.4.3-ub22
MAINTAINER sid.srinivasan@amd.com

#sudo docker build --no-cache --build-arg ucx_version=v1.13.1 --build-arg ompi_version=v4.1.4 -t amddcgpuce/rocm-aac-hpc:5.4.3_ucx1.13.1_ompi4.1.4 -f rocm.hpc.aac.ub22.Dockerfile `pwd`

ARG ucx_version
ENV UCX_HOME=/opt/ucx

ARG ompi_version
ENV MPI_HOME=/opt/ompi

RUN echo "Build docker for ROCM for HPC applications UCX ${ucx_version} OMPI ${ompi_version}"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    cd $HOME && \
    git clone --recursive https://github.com/openpmix/openpmix && \
    cd openpmix && \
    git checkout tags/v4.2.1 && \
    ./autogen.pl && \
    ./configure  && \
    make && \
    sudo make install && \
    cd $HOME && \
    git clone https://github.com/openucx/ucx.git  && \
    cd ucx/ && \
    git checkout tags/${ucx_version}   && \
    ./autogen.sh && \
    mkdir build  && \
    cd build && \
    ../contrib/configure-release --prefix=/opt/ucx --disable-logging --disable-debug --disable-assertions --enable-params-check -without-knem --without-cuda --with-rocm=$ROCM_PATH --enable-gtest --without-java --enable-mt  && \
    make   && \
    sudo make install   && \
    cd $HOME && \
    git clone https://github.com/open-mpi/ompi.git && \
    cd ompi/ && \
    git checkout tags/${ompi_version} && \
    ./autogen.pl  && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/opt/ompi --with-ucx=/opt/ucx --with-pmix=/usr/local --with-pmix-libdir=/usr/local/lib  && \
    make  && \
    sudo make install && \
    cd $HOME && \
    cd ucx && \
    ./autogen.sh  && \
    mkdir build-with-mpi && \
    cd build-with-mpi/ && \
    ../contrib/configure-release --prefix=/opt/ucx --disable-logging --disable-debug --disable-assertions --enable-params-check -without-knem --without-cuda --with-rocm=$ROCM_PATH --enable-gtest --without-java --enable-mt --with-mpi=/opt/ompi  && \
    make   && \
    sudo make install   && \
    hash -r && \
    cd $HOME && \
    echo "/usr/local/lib" | sudo tee -a /etc/ld.so.conf.d/usrlocal.conf && \
    sudo rm /etc/ld.so.cache && \
    sudo ldconfig && \
    cd $HOME && \
    rm -rf ucx && \
    rm -rf ompi && \
    rm -rf openpmix && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache && \
    cd $HOME


#
RUN /bin/sh -c 'ln -sf ${ROCM_PATH} /opt/rocm'

#
RUN locale-gen en_US.UTF-8

# Set up paths
ENV PATH="/opt/ompi/bin:/opt/ucx/bin:${PATH}"
ENV UCX_HOME="/opt/ucx"
ENV MPI_HOME="/opt/ompi"
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]


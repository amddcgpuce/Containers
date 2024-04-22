#V1.0
FROM rocm:6.1.0-ub22-ompi5

MAINTAINER srinivasan.subramanian@amd.com

# Labels
LABEL "com.amd.container.aisw.description"="Pytorch on Latest ROCm GA Release Container for Development"
LABEL "com.amd.container.aisw.gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942"
LABEL "com.amd.container.aisw.python3.version"="3.10"

ARG PYTORCH_VERSION="v2.3.0-rc12"
LABEL "com.amd.container.aisw.torch.version"=${PYTORCH_VERSION}

ARG TORCHVISION_VERSION="v0.18.0-rc4"
LABEL "com.amd.container.aisw.torchvision.version"=${TORCHVISION_VERSION}

# NOTE: Update MAGMA version when newer release is available
ARG MAGMA_VERSION="v2.8.0"
LABEL "com.amd.container.aisw.magma.version"=${MAGMA_VERSION}

# Update MKL when newer release is available
ARG MKL_VERSION="2024.1.0"
LABEL "com.amd.container.aisw.mkl.version"=${MKL_VERSION}

ARG dockerbuild_dirname="pytorch.${PYTORCH_VERSION}.${TORCHVISION_VERSION}"

ENV MKLROOT="/usr/local"
ENV MAGMA_HOME="/usr/local/magma"
ENV PKG_CONFIG_PATH="${MAGMA_HOME}/pkgconfig:${PKG_CONFIG_PATH}"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/magma/lib"
ENV LD_RUN_PATH="${LD_RUN_PATH}:/usr/local/magma/lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/magma/lib"
ENV CPATH="${CPATH}:${MAGMA_HOME}/include"
ENV PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942"

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 \
    python3-pip \
    wget && \
    cd $HOME && \
    mkdir -p /workdir/dockerbuild/${dockerbuild_dirname}/ && \
    cd /workdir/dockerbuild/${dockerbuild_dirname} && \
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
    sed -i -e "s/env python/env python3/" tools/codegen.py && \
    cp make.inc-examples/make.inc.hip-gcc-mkl make.inc && \
    sed -i -e "/LIBDIR.*ROCM_PATH.*MKLROOT/ s/$/ -L\$\(MKLROOT\)\/lib/" make.inc && \
    MKLROOT=/usr/local make lib/libmagma.so install && \
    cd /workdir/dockerbuild/${dockerbuild_dirname} && \
    git clone https://github.com/pytorch/pytorch && \
    cd pytorch && \
    git checkout tags/${PYTORCH_VERSION} && \
    git submodule update --init --recursive && \
    pip3 install --no-cache -r requirements.txt && \
    tools/amd_build/build_amd.py && \
    PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942" USE_ROCM=1 USE_CUDA=OFF CMAKE_VERBOSE_MAKEFILE=1 CMAKE_CXX_COMPILER=g++ CMAKE_C_COMPILER=gcc COMAKE_Fortran_COMPILER=gfortran python3 setup.py install && \
    cd /workdir/dockerbuild/${dockerbuild_dirname} && \
    git clone https://github.com/pytorch/vision.git && \
    cd vision && \
    git checkout tags/${TORCHVISION_VERSION} && \
    git submodule update --init --recursive && \
    PYTORCH_ROCM_ARCH="gfx908;gfx90a;gfx940;gfx941;gfx942" USE_ROCM=1 USE_CUDA=OFF CMAKE_VERBOSE_MAKEFILE=1 CMAKE_CXX_COMPILER=g++ CMAKE_C_COMPILER=gcc COMAKE_Fortran_COMPILER=gfortran python3 setup.py install && \
    cd $HOME && \
    rm /etc/ld.so.cache && \
    ldconfig && \
    hash -r && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]



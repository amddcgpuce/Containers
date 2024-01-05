FROM ubuntu:22.04

ARG CONDA_ENV_NAME="py39_pyt201_rocm600"

MAINTAINER sid.srinivasan@amd.com

LABEL "rocm_version"="6.0.0"
LABEL "os"="Ubuntu 22"
LABEL "gfxarch"="gfx908, gfx90a, gfx940, gfx941, gfx942"
LABEL "description"="PyTorch ROCm Miniconda container"
LABEL "python3_version"="3.9"
LABEL "torch_version"="2.0.1"
LABEL "torchvision_version"="0.15.2"
LABEL "conda_env_name"=${CONDA_ENV_NAME}

RUN apt clean && \
    apt-get clean && \
    apt-get -y update --fix-missing --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    locales \
    python3 \
    python3-pip \
    wget && \
    cd $HOME && \
    mkdir -p $HOME/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda3/miniconda.sh && \
    bash $HOME/miniconda3/miniconda.sh -b -u -p $HOME/miniconda3 && \
    rm -rf $HOME/miniconda3/miniconda.sh && \
    . $HOME/miniconda3/etc/profile.d/conda.sh && \
    $HOME/miniconda3/bin/conda init bash && \
    $HOME/miniconda3/bin/conda create --name ${CONDA_ENV_NAME} python=3.9 && \
    $HOME/miniconda3/bin/conda run -n ${CONDA_ENV_NAME} pip3 install --no-cache-dir torch==2.0.1 torchvision==0.15.2 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-6.0/ && \
    cd $HOME && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf $HOME/.cache

ENV PATH="${HOME}/miniconda3/bin:${PATH}"

RUN echo "source activate ${CONDA_ENV_NAME}" >> ${HOME}/.bashrc

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default to a login shell
CMD ["bash", "-l"]



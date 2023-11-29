FROM docker://amddcgpuce/rocm-aac-hpc:5.7.1_ucx1.15.0_ompi4.1.6
MAINTAINER Sid.srinivasan@amd.com

RUN cd $HOME && \
    git clone -b develop_2022_amd https://github.com/ROCmSoftwarePlatform/Gromacs.git && \
    cd $HOME/Gromacs && \
    mkdir -p build && \
    cd $HOME/Gromacs/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/gromacs/ -DBUILD_SHARED_LIBS=off -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-Ofast" -DCMAKE_CXX_FLAGS="-Ofast" -DGMX_BUILD_OWN_FFTW=ON -DGMX_BUILD_FOR_COVERAGE=off -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DGMX_MPI=off -DGMX_GPU=HIP -DGMX_OPENMP=on -DCMAKE_HIP_ARCHITECTURES="gfx90a;gfx908" -DGMX_SIMD=AVX2_256 -DREGRESSIONTEST_DOWNLOAD=OFF -DBUILD_TESTING=ON -DGMXBUILD_UNITTESTS=ON -DGMX_GPU_USE_VKFFT=on -DHIP_HIPCC_FLAGS="-O3 --offload-arch=gfx90a --offload-arch=gfx908" -DCMAKE_EXE_LINKER_FLAGS="-fopenmp" .. && \
    make -j `nproc` && \
    make install && \
    cd $HOME/Gromacs && \
    mkdir -p build_mpi && \
    cd $HOME/Gromacs/build_mpi && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/gromacs_mpi -DBUILD_SHARED_LIBS=off -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-Ofast" -DCMAKE_CXX_FLAGS="-Ofast" -DGMX_BUILD_OWN_FFTW=ON -DGMX_BUILD_FOR_COVERAGE=off -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DGMX_MPI=on -DGMX_GPU=HIP -DGMX_OPENMP=on -DCMAKE_HIP_ARCHITECTURES="gfx90a;gfx908" -DGMX_SIMD=AVX2_256 -DREGRESSIONTEST_DOWNLOAD=OFF -DBUILD_TESTING=ON -DGMXBUILD_UNITTESTS=ON -DGMX_GPU_USE_VKFFT=on -DHIP_HIPCC_FLAGS="-O3 --offload-arch=gfx90a --offload-arch=gfx908" -DCMAKE_EXE_LINKER_FLAGS="-fopenmp" .. && \
    make -j `nproc` && \
    make install && \
    cd $HOME && \
    git clone https://github.com/jychang48/benchmark-gromacs.git && \
    cd $HOME/benchmark-gromacs/stmv &&  \
    tar -vxf stmv.tar.gz && \
    cd $HOME

# Set up paths
ENV GMX_GPU_DD_COMMS=1
ENV GMX_GPU_PME_PP_COMMS=1
ENV GMX_FORCE_UPDATE_DEFAULT_GPU=1
ENV GMX_ENABLE_DIRECT_GPU_COMM=1
ENV AMD_DIRECT_DISPATCH=1
ENV GMX_GPU_PME_DECOMPOSITION=1
ENV GMX_FORCE_CUDA_AWARE_MPI=1
ENV GMX_GPU_DD_COMMS=true
ENV GMX_GPU_PME_PP_COMMS=true
ENV GMX_FORCE_GPU_AWARE_MPI=true
ENV GMX_FORCE_UPDATE_DEFAULT_GPU=true

# Default to a login shell
CMD ["bash", "-l"]

# Docker build command
# For ROCm 5.7.1 rocm:5.7.1-ub22 docker
```
sudo docker build --no-cache --build-arg rocm_repo=5.7.1 --build-arg rocm_version=5.7.1 --build-arg rocm_lib_version=507001 --build-arg rocm_path=/opt/rocm-5.7.1 --build-arg rocblas_ver=5.7.1 -t amddcgpuce/rocm:5.7.1-ub22 -f rocm.ub22.Dockerfile `pwd`
```

## For ROCm 5.7.1 with UCX 1.15.0 and OMPI 4.1.6 rocm-aac-hpc:5.7.1_ucx1.15.0_ompi4.1.6 docker
```
sudo docker build --no-cache --build-arg rocm_version=5.7.1 --build-arg ucx_version=v1.15.0 --build-arg ompi_version=v4.1.6 -t amddcgpuce/rocm-aac-hpc:5.7.1_ucx1.15.0_ompi4.1.6 -f rocm.hpc.aac.ub22.Dockerfile `pwd`
```

## For Gromacs gromacs:5.7.1_ucx1.15.0_ompi4.1.6 docker
```
sudo docker build --no-cache -t amddcgpuce/gromacs:5.7.1_ucx1.15.0_ompi4.1.6 -f gromacs.Dockerfile `pwd`
```

### NOTE: To build using podman, replace ``sudo docker`` with ``podman``

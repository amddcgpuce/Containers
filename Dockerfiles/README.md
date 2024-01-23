# Docker build command for ROCm Base Container: `amddcgpuce/rocm`
## Docker Build Command for ROCm 6.0.0 GA Release container: `amddcgpuce/rocm:6.0.0-ub22`
### Dockerfile: `rocm.ub22.Dockerfile`
The ROCm base container includes all of the version-specific packages included in ROCm release except for miopenkernel packages.
```
docker build --no-cache --build-arg rocm_repo=6.0 --build-arg rocm_version=6.0.0 --build-arg rocm_lib_version=60000 --build-arg rocm_path=/opt/rocm-6.0.0 -t amddcgpuce/rocm:6.0.0-ub22 -f rocm.ub22.Dockerfile `pwd`
```

## Podman Build Command for ROCm 6.0.0 GA Release container: `amddcgpuce/rocm:6.0.0-ub22`
### Dockerfile: `rocm.ub22.Dockerfile`
The ROCm base container includes all of the version-specific packages included in ROCm release except for miopenkernel packages.
```
podman build --no-cache --security-opt label=disable --build-arg rocm_repo=6.0 --build-arg rocm_version=6.0.0 --build-arg rocm_lib_version=60000 --build-arg rocm_path=/opt/rocm-6.0.0 -t amddcgpuce/rocm:6.0.0-ub22 -f rocm.ub22.Dockerfile `pwd`
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

# Description of the Tags for the amddcgpuce/rocm container and the build commands
# Build command for different tags of ROCm Base Container: `amddcgpuce/rocm`
## Build Command for ROCm 6.2.0 GA Release container: `amddcgpuce/rocm:6.2.0-ub22`
### Dockerfile: `rocm.ub22.Dockerfile`
The ROCm base container includes all of the version-specific packages included in ROCm release except for miopenkernel packages.
## Podman Build Command for ROCm 6.2.0 GA Release container: `amddcgpuce/rocm:6.2.0-ub22`
```
podman build --no-cache --security-opt label=disable --build-arg rocm_repo=6.0 --build-arg rocm_version=6.0.0 --build-arg rocm_lib_version=60000 --build-arg rocm_path=/opt/rocm-6.0.0 -t amddcgpuce/rocm:6.0.0-ub22 -f rocm.ub22.Dockerfile `pwd`
```

## Build Command for ROCm 6.2.0 GA Release container: `amddcgpuce/rocm:6.2.0-ub22`
```
docker build --no-cache --build-arg rocm_repo=6.0 --build-arg rocm_version=6.0.0 --build-arg rocm_lib_version=60000 --build-arg rocm_path=/opt/rocm-6.0.0 -t amddcgpuce/rocm:6.0.0-ub22 -f rocm.ub22.Dockerfile `pwd`
```

## Build rocm with rocblas and hipblaslt clients: `amddcgpuce/rocm:6.2.0-ub22-rocblas`
### Dockerfile: `rocm-rocblas.ub22.Dockerfile`
```
BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-rocblas -f rocm^Cocblas.ub22.Dockerfile `pwd`' 2>&1 | tee rocblas.Docker.BUILD.log
```

## Build ROCm + OMPI v5.x and UCX 1.17.0 container: `amddcgpuce/rocm:6.2.0-ub22-ompi5-ucx17`
### Dockerfile: `rocm.ompi5.ub22.Dockerfile`
Using `amddcgpuce/rocm:6.2.0-ub22` as base container image build OMPI and UCX.
```
BASE_ROCM_DOCKER=amddcgpuce/rocm:6.2.0-ub22 bash -c 'podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=${BASE_ROCM_DOCKER} -t ${BASE_ROCM_DOCKER}-ompi5-ucx17 -f rocm.ompi5.ub22.Dockerfile `pwd`'
```



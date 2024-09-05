# ROCm docker containers to build PyTorch from sources
## ROCm plus HIPMAGMA
## Dockerfile: rocm-ompi5-hipmagma.Dockerfile
Build using ROCm + UCX + OMPI container as base image
```
time podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=amddcgpuce/rocm:6.2.0-ub22-ompi5-ucx17 --build-arg rocm_version=6.2.0 -v $HOME:/workdir -t amddcgpuce/rocm:6.2.0-ub22-hipmagmav280 -f rocm-ompi5-hipmagma.Dockerfile `pwd`
```

## Pytorch 2.4.0 with ROCm 6.2.0
### Dockerfile: rocm-ompi5-pytorch-6b.Dockerfile
Build using `amddcgpuce/rocm:6.2.0-ub22-hipmagmav280` as base docker
```
time podman build --no-cache --security-opt label=disable --build-arg base_rocm_docker=amddcgpuce/rocm:6.2.0-ub22-hipmagmav280 --build-arg rocm_version=6.2.0 -v $HOME:/workdir -t amddcgpuce/rocm:6.2.0-ub22-pt240-py310_0190_06b -f rocm-ompi5-pytorch-6b.Dockerfile `pwd`
```


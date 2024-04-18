# Podman Build Command
# For PyTorch Version 2.0.1 with ROCm 6.0.0
```
podman build --no-cache -t srinivamd/pytorch_conda:py39_pyt201_rocm600_v1 -f Dockerfile `pwd`
```
# Podman Run Command
```
podman run -it --privileged --network=host --ipc=host  -v /shared/prod/home/ssubrama1:/workdir -v /shareddata:/shareddata -v /shareddata.ai:/shareddata.ai -v /shared/apps:/shared/apps --workdir /workdir localhost/srinivamd/pytorch_conda:py39_pyt201_rocm600_v1 bash
```

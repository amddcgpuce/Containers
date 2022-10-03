# Docker build command
# For ROCm 5.3 rocm:5.3.0-ub20 docker
```
sudo docker build --build-arg rocm_repo=5.3 --build-arg rocm_version=5.3.0 --build-arg rocm_lib_version=50300 --build-arg rocm_path=/opt/rocm-5.3.0 --build-arg rocblas_ver=5.3.0 -t amddcgpuce/rocm:5.3.0-ub20 -f rocm.ub20.Dockerfile `pwd`
```

## For ROCm 5.2
```
sudo docker build --build-arg rocm_repo=5.2 --build-arg rocm_version=5.2 --build-arg rocm_lib_version=50200 --build-arg rocm_path=/opt/rocm-5.2.0 --build-arg rocblas_ver=5.2 -f rocm.ub20.Dockerfile `pwd`
```

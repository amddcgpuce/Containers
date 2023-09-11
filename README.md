# Containers
Team container development

# Docker Files
`rocm.ub22.Dockerfile` is used to build ROCm with `rocblas-bench`

### Docker build command:

```
sudo docker build --no-cache --build-arg ubuntu_ver=22.04 --build-arg rocm_repo=5.6.1 --build-arg rocm_version=5.6.1 --build-arg rocm_lib_version=506001 --build-arg rocm_path=/opt/rocm-5.6.1 --build-arg rocblas_ver=5.6 -t amddcgpuce/rocm:5.6.1-ub22 -f rocm.ub22.Dockerfile `pwd`
```

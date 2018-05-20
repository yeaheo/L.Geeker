## Docker - 镜像的使用

### 获取镜像
- docker 默认从 Docker Hub 上拉取镜像，在国内从 Docker Hub 上拉取镜像一般速度会很慢，我们可以配置加速器来提高镜像下载速度，具体加速器配置参见：[配置 docker 镜像加速器](./docker-image-accelerator-installation.md)
- 从 Docker 镜像仓库获取镜像的命令是 `docker pull`。其命令格式为：
  
  ```bash
  docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
  ```
- 

## Docker-配置镜像加速器

- 国内从 Docker Hub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。Docker 官方和国内很多云服务商都提供了国内加速器服务，例如：
- [Docker 官方提供的中国 registry mirror](https://docs.docker.com/registry/recipes/mirror/#use-case-the-china-registry-mirror)
- [阿里云镜像加速器](https://cr.console.aliyun.com/?spm=a2c4e.11153940.blogcont29941.9.69a569d6cUxp04#/accelerator)
- [DaoCloud 镜像加速器](https://www.daocloud.io/mirror#accelerator-doc)

- 这里我们以阿里云和 docker 官方提供的中国镜像加速器来说明 docker 如何配置镜像加速器

### 配置阿里云镜像加速器

- **安装／升级Docker客户端**
- 你可以通过阿里云的镜像仓库下载:[阿里云 docker 镜像加速器](https://cr.console.aliyun.com/?spm=a2c4e.11153940.blogcont29941.9.69a569d6cUxp04#/accelerator)

- **配置镜像加速器**
- 修改 daemon 配置文件 `/etc/docker/daemon.json` 来使用加速器：
  
  ```bash
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<-'EOF'
  {
    "registry-mirrors": ["https://xx.mirror.aliyuncs.com"]  ## "XX"需要用你自己的阿里云账号登陆获取
  }
  EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```

### 配置官方中国镜像加速器
- 编辑 `/etc/docker/daemon.json` 文件，添加如下内容：
 
  ```json
  {
  "registry-mirrors": ["https://registry.docker-cn.com"]
  }
  ```
- 添加后保存退出，重启 docker 服务：

  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```
  > 注意，一定要保证该文件符合 json 规范，否则 Docker 将不能启动。

### 检查加速器是否生效
- 配置加速器之后，在命令行执行 `docker info`，如果从结果中看到了如下内容，说明配置成功。
 
  ```bash
  Registry Mirrors:
  https://registry.docker-cn.com/
  ```


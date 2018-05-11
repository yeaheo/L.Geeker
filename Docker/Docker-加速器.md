## Docker-配置镜像加速器

- **安装／升级Docker客户端**
- 你可以通过阿里云的镜像仓库下载:[阿里云 docker 镜像加速器](https://cr.console.aliyun.com/?spm=a2c4e.11153940.blogcont29941.9.69a569d6cUxp04#/accelerator)

- **配置镜像加速器**
- 修改daemon配置文件/etc/docker/daemon.json来使用加速器：
  ``` xml
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<-'EOF'
  {
    "registry-mirrors": ["https://xx.mirror.aliyuncs.com"]  ## "XX"需要用你自己的阿里云账号登陆获取
  }
  EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```
- 至此，阿里云镜像加速器配置完成！

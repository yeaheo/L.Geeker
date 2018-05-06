## Docker-配置镜像加速器

- **安装／升级Docker客户端**
- 你可以通过阿里云的镜像仓库下载:[mirrors.aliyun.com/help/docker-engine](http://mirrors.aliyun.com/help/docker-engine?spm=a2c1q.8351553.0.0.468c7ecb3yKZ7b)

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

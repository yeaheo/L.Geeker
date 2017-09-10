# Docker-配置镜像加速器

#### 安装／升级你的Docker客户端
- 您可以通过阿里云的镜像仓库下载:[mirrors.aliyun.com/help/docker-engine](http://mirrors.aliyun.com/help/docker-engine?spm=a2c1q.8351553.0.0.468c7ecb3yKZ7b)

#### 配置镜像加速器
- 修改daemon配置文件/etc/docker/daemon.json来使用加速器：
  ``` xml
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<-'EOF'
  {
    "registry-mirrors": ["https://4u0uxtf7.mirror.aliyuncs.com"]
  }
  EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```
- 完成！！！尽情享受下载镜像的快感吧，哈哈

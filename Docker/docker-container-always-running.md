## Docker-配置 docker 服务重启后容器依然存在

- 有时候我们需要的是当 docker 服务重启后以前运行的容器依然在运行，但是官方默认的是当 docker 服务停止后，以前运行的容器就会停止，需要重新启动
- Docker 官方参考链接：<https://docs.docker.com/engine/admin/live-restore>

### 配置Docker

- 在Linux系统中Docker服务默认的配置文件是`/etc/docker/daemon.json`
- 创建上述文件添加如下内容：
  ```bash
  vim /etc/docker/daemon.json
  ```

  ```json
  {
      "live-restore": true
  }
  ```
- 修改完成，重启 docker 使其生效即可

  ```bash
  systemctl restart docker.service
  ```



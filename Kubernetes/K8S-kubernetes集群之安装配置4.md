## Kubernetes集群安装部署—Node

- 本部分主要是Node节点安装及配置各种组件
- Kubernetes集群Node节点组件主要有：
  ``` xml
  docker
  kubelet
  kube-proxy
  flannel
  ```
  
### 安装Docker
- 因为Master及node在一台机器上，所以master和node节点都需要安装docker
- docker安装参考：[Docker安装部署](../Docker/docker-install.md)
- 所有node节点也需要安装Docker，操作同上。

### 配置kubelet
- 添加服务文件，并添加为系统服务
- `vim /usr/lib/systemd/system/kubelet.service`
- 添加如下内容：
  ``` xml
  [Unit]
  Description=Kubernetes Kubelet Server
  Documentation=https://github.com/GoogleCloudPlatform/kubernetes
  After=docker.service
  Requires=docker.service
  
  [Service]
  WorkingDirectory=/var/lib/kubelet
  EnvironmentFile=-/etc/kubernetes/config
  EnvironmentFile=-/etc/kubernetes/kubelet
  ExecStart=/usr/bin/kubelet \
      $KUBE_LOGTOSTDERR \
      $KUBE_LOG_LEVEL \
      $KUBELET_API_SERVER \
      $KUBELET_ADDRESS \
      $KUBELET_PORT \
      $KUBELET_HOSTNAME \
      $KUBE_ALLOW_PRIV \
      $KUBELET_ARGS
  Restart=on-failure
  
  [Install]
  WantedBy=multi-user.target
  ```

- 添加`/etc/kubernetes/kubelet`文件
- `vim /etc/kubernetes/kubelet`
- 添加如下内容：
  ``` xml
  ###
  ## kubernetes kubelet (minion) config
  #
  ## The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
  KUBELET_ADDRESS="--address=0.0.0.0"
  #
  ## The port for the info server to serve on
  KUBELET_PORT="--port=10250"
  #
  ## You may leave this blank to use the actual hostname
  KUBELET_HOSTNAME="--hostname-override=test-node7"
  #
  ## location of the api-server
  KUBELET_API_SERVER="--api-servers=http://192.168.8.60:8080"
  #
  ## pod infrastructure container
  #KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"
  #
  ## Add your own!
  KUBELET_ARGS=""
  ```
- KUBELET_POD_INFRA_CONTAINER在生产环境中配置成自己私有仓库里的image。在这里我们注释掉了

- 注意：
  - 在启动服务的时候需要先做些准备工作，否则启动会报错。
  - `mkdir /var/lib/kubelet`

- 启动并校验
  - `systemctl start kubelet.service`
  - `systemctl status kubelet.service`
  - `systemctl enable kubelet.service`
  
### 配置kube-proxy
- 添加服务文件，并添加为系统服务
- `vim /usr/lib/systemd/system/kube-proxy.service`
- 添加如下内容：
  ``` xml
  [Unit]
  Description=Kubernetes Kube-Proxy Server
  Documentation=https://github.com/GoogleCloudPlatform/kubernetes
  After=network.target
  
  [Service]
  EnvironmentFile=-/etc/kubernetes/config
  EnvironmentFile=-/etc/kubernetes/proxy
  ExecStart=/usr/bin/kube-proxy \
      $KUBE_LOGTOSTDERR \
      $KUBE_LOG_LEVEL \
      $KUBE_MASTER \
      $KUBE_PROXY_ARGS
  Restart=on-failure
  LimitNOFILE=65536
  
  [Install]
  WantedBy=multi-user.target
  ```
  
- 添加`/etc/kubernetes/proxy`文件
- `vim /etc/kubernetes/proxy`
- 添加如下内容：
  ``` xml
  ###
  # kubernetes proxy config
  
  # default config should be adequate
  
  # Add your own!
  KUBE_PROXY_ARGS=""                        
  ```
- 需要注意的是：
- kube-proxy的配置与master节点的kube-proxy配置相同。
- node节点kubelet的配置需要修改KUBELET_HOST为node节点的hostname，其它配置与master相同。

### 配置flannel
- node上的flannel的配置过程和master上的一致，详情参见[flannel配置](K8S-kubernetes集群之安装配置2.md)

### 启动并校验
  ``` xml
  for SERVICES in kube-proxy kubelet flanneld; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
  done
  ```
  

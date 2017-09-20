## Kubernetes集群安装部署—Master
- 此部分主要是记录K8S集群中，master的各个组件的配置

### Master节点配置
- Master节点需要配置的kubernetes的组件有：
  ``` xml
  etcd
  flannel
  kube-apiserver
  kube-controller-manager
  kube-scheduler
  ```
### 配置etcd、flannel
- 配置etcd服务，在第一部分已经配置完成，详情参见[etcd配置](K8S-kubernetes集群之安装配置1.md)
- 配置flannel服务，在第二部分已经配置完成，详情参见[flannel配置](K8S-kubernetes集群之安装配置2.md)

### 配置kube-apiserver
- 准备系统服务文件，并添加为系统服务
- `vim /usr/lib/systemd/system/kube-apiserver.service`
- 添加如下内容：
  ``` xml
  [Unit]
  Description=Kubernetes API Service
  Documentation=https://github.com/GoogleCloudPlatform/kubernetes
  After=network.target
  After=etcd.service
  
  [Service]
  EnvironmentFile=-/etc/kubernetes/config
  EnvironmentFile=-/etc/kubernetes/apiserver
  ExecStart=/usr/bin/kube-apiserver \
      $KUBE_LOGTOSTDERR \
      $KUBE_LOG_LEVEL \
      $KUBE_ETCD_SERVERS \
      $KUBE_API_ADDRESS \
      $KUBE_API_PORT \
      $KUBELET_PORT \
      $KUBE_ALLOW_PRIV \
      $KUBE_SERVICE_ADDRESSES \
      $KUBE_ADMISSION_CONTROL \
      $KUBE_API_ARGS
  Restart=on-failure
  Type=notify
  LimitNOFILE=65536
  
  [Install]
  WantedBy=multi-user.target
  ```
- 创建kubernetes的配置文件目录`/etc/kubernetes`
  - `mkdir /etc/kubernetes`
- 添加`/etc/kubernetes/config`文件
  - `vim /etc/kubernetes/config`
  - 添加如下内容：
  
  ``` xml
  ###
  # kubernetes system config
  #
  # The following values are used to configure various aspects of all
  # kubernetes services, including
  #
  #   kube-apiserver.service
  #   kube-controller-manager.service
  #   kube-scheduler.service
  #   kubelet.service
  #   kube-proxy.service
  # logging to stderr means we get it in the systemd journal
  KUBE_LOGTOSTDERR="--logtostderr=true"
  
  # journal message level, 0 is debug
  KUBE_LOG_LEVEL="--v=0"
  
  # Should this cluster be allowed to run privileged docker containers
  KUBE_ALLOW_PRIV="--allow-privileged=false"
  
  # How the controller-manager, scheduler, and proxy find the apiserver
  KUBE_MASTER="--master=http://192.168.8.60:8080"
  ```
  
- 添加`/etc/kubernetes/apiserver`文件
  - `vim /etc/kubernetes/apiserver`
  - 添加如下内容：
  ``` xml
  ###
  ## kubernetes system config
  ##
  ## The following values are used to configure the kube-apiserver
  ##
  #
  ## The address on the local server to listen to.
  KUBE_API_ADDRESS="--address=192.168.8.60"
  #
  ## The port on the local server to listen on.
  KUBE_API_PORT="--port=8080"
  #
  ## Port minions listen on
  KUBELET_PORT="--kubelet-port=10250"
  #
  ## Comma separated list of nodes in the etcd cluster
  KUBE_ETCD_SERVERS="--etcd-servers=http://127.0.0.1:2379"
  #
  ## Address range to use for services
  KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
  #
  ## default admission control policies
  KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
  #
  ## Add your own!
  #KUBE_API_ARGS=""
  ```
  

## Kubernetes集群安装部署—Master

- 本部分主要是MASTER节点安装Flannel、Kubernetes服务

### 安装Flannel
- 因为网络这块的配置比较复杂，可以直接使用yum进行安装。
- `yum -y install flannel`

- 在启动`flannel`前需要配置一下，否则启动会报错
- Start ETCD and configure it to hold the network overlay configuration on master: Warning This network must be unused in your network infrastructure! 172.30.0.0/16 is free in our network.
- `etcdctl mkdir /kube-centos/network`
- `etcdctl mk /kube-centos/network/config "{ \"Network\": \"172.30.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"`

- Configure flannel to overlay Docker network in /etc/sysconfig/flanneld on the master (also in the nodes as we’ll see):
- `vim /etc/sysconfig/flanneld`
- 配置如下：
  ``` xml
  # Flanneld configuration options  
  
  # etcd url location.  Point this to the server where etcd runs
  FLANNEL_ETCD_ENDPOINTS="http://192.168.8.60:2379"
  
  # etcd config key.  This is the configuration key that flannel queries
  # For address range assignment
  FLANNEL_ETCD_PREFIX="/kube-centos/network"
  
  # Any additional options that you want to pass
  #FLANNEL_OPTIONS=""
  ```
- 启动并校验
  - `systemctl start flanneld`
  - `systemctl status flanneld`
  - `systemctl enable flanneld`

### 安装Kubernetes
- 在这里，为了能够安装最新版本的Kubernetes，我是直接使用GitHub上的release里的二进制文件安装
- GitHub上的kubernetes地址：<https://github.com/kubernetes/kubernetes/releases>
- 执行下面命令进行安装：
  - `wget https://codeload.github.com/kubernetes/kubernetes/tar.gz/v1.7.6`
  - `tar xf kubernetes.tar.gz`
  - `cd kubernetes`
  - `./cluster/get-kube-binaries.sh`
  - `cd server`
  - `tar xvf kubernetes-server-linux-amd64.tar.gz`
  - `cd kubernetes/server/bin`
  - `rm -f *_tag *.tar`
  - `chmod 755 *`
  - `cp * /usr/bin` & `mv * /usr/bin`
  - 解压完后获得的二进制文件如下：
    ``` xml
    cloud-controller-manager
    hyperkube
    kubeadm
    kube-aggregator
    kube-apiserver
    kube-controller-manager
    kubectl
    kubefed
    kubelet
    kube-proxy
    kube-scheduler
    ```
  - 在`cluster/juju/layers/kubernetes-master/templates`目录下有service和环境变量配置文件的模板，这个模板本来是为了使用[juju](https://jujucharms.com/)安装写的。

### Master节点配置
- Master节点需要配置的kubernetes的组件有：
  ``` xml
  kube-apiserver
  kube-controller-manager
  kube-scheduler
  kube-proxy
  kubectl
  ```
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
- 配置`/etc/kubernetes/config`文件
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
  



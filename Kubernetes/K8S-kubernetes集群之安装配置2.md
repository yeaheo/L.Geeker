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
  

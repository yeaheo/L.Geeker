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


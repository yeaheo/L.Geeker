## Kubernetes集群安装部署—基于Flannel的网络配置

- 本部分主要是基于Flannel的网络配置
- 先前安装Flannel的时候用的是直接用yum安装，详细安装请参考[Flannel安装](K8S-kubernetes集群之安装配置2.md)

### 配置Flannel
- 先前我们只是简单的配置了Flannel，详情请参见[Flannel配置](K8S-kubernetes集群之安装配置2.md)
- 安装好后会生成/usr/lib/systemd/system/flanneld.service配置文件。
  ``` xml
  [Unit]
  Description=Flanneld overlay address etcd agent
  After=network.target
  After=network-online.target
  Wants=network-online.target
  After=etcd.service
  Before=docker.service
  
  [Service]
  Type=notify
  EnvironmentFile=/etc/sysconfig/flanneld
  EnvironmentFile=-/etc/sysconfig/docker-network
  ExecStart=/usr/bin/flanneld-start $FLANNEL_OPTIONS
  ExecStartPost=/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
  Restart=on-failure
  
  [Install]
  WantedBy=multi-user.target
  RequiredBy=docker.service
  ```
- 此部分不需要修改
- flannel环境变量配置文件在/etc/sysconfig/flanneld
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
- etcd的地址 "FLANNEL_ETCD_ENDPOINT"
- etcd查询的目录，包含docker的IP地址段配置  "FLANNEL_ETCD_PREFIX"

### 在etcd中创建网络配置
- 为docker分配IP地址段：
  - `etcdctl mkdir /kube-centos/network`
  - `etcdctl mk /kube-centos/network/config "{ \"Network\": \"172.30.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"`

### 配置docker
- 这里我们需要一个环境变量文件：
  ``` xml
  [root@test-node7 ~]# cat /run/flannel/subnet.env
  FLANNEL_NETWORK=172.30.0.0/16
  FLANNEL_SUBNET=172.30.48.1/24
  FLANNEL_MTU=1450
  FLANNEL_IPMASQ=false
  ```
- `source /run/flannel/subnet.env`
- `docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} &`
- 注意：
  - 当我们执行第二条命令的时候会提示我们先关掉docker，并且需要使用`dockerd`代替`docker daemon`即：
  - `dockerd --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} &`
- 现在查询etcd中的内容可以看到：
  ``` xml
  [root@test-node7 ~]# etcdctl ls /kube-centos/network/subnets
  /kube-centos/network/subnets/172.30.19.0-24
  /kube-centos/network/subnets/172.30.39.0-24
  /kube-centos/network/subnets/172.30.48.0-24
  [root@test-node7 ~]# etcdctl get /kube-centos/network/config
  { "Network": "172.30.0.0/16", "SubnetLen": 24, "Backend": { "Type": "vxlan" } }
  [root@test-node7 ~]# etcdctl get /kube-centos/network/subnets/172.30.19.0-24
  {"PublicIP":"192.168.8.61","BackendType":"vxlan","BackendData":{"VtepMAC":"9e:d1:da:63:9b:93"}}
  [root@test-node7 ~]# etcdctl get /kube-centos/network/subnets/172.30.39.0-24
  {"PublicIP":"192.168.8.62","BackendType":"vxlan","BackendData":{"VtepMAC":"72:66:83:33:e5:83"}}
  [root@test-node7 ~]# etcdctl get /kube-centos/network/subnets/172.30.48.0-24
  {"PublicIP":"192.168.8.60","BackendType":"vxlan","BackendData":{"VtepMAC":"f2:fc:d9:db:52:74"}}
  ```
- 设置docker0网桥的IP地址：
  - `source /run/flannel/subnet.env`
  - `ifconfig docker0 $FLANNEL_SUBNET`
- 这时docker0和flannel网桥会在同一个子网中，如：
  ``` xml
  3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 02:42:3a:04:be:7f brd ff:ff:ff:ff:ff:ff
    inet 172.30.19.1/24 scope global docker0
       valid_lft forever preferred_lft forever
  4: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN 
    link/ether 9e:d1:da:63:9b:93 brd ff:ff:ff:ff:ff:ff
    inet 172.30.19.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::9cd1:daff:fe63:9b93/64 scope link 
       valid_lft forever preferred_lft forever
   ```
- 重启docker
  - `systemctl restart docker.service`
  - 注意：
    - 此时docker会启动失败，原因是还存在与docker相关的进程
    - 解决办法是杀掉docker相关进程
    - `ps axf | grep docker | grep -v grep | awk '{print "kill -9 " $1}' | sudo sh `
- 重启kubelet
  - `systemctl restart kubelet.service`
  - 一般没问题的，至少我没有遇到
- 重启flannel
  - `systemctl restart flanneld.service`

  



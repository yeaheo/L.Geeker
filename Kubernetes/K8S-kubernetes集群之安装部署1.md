## Kubernetes集群安装部署——Master

### 安装部署参考资料
- Kubernetes官方网站：<https://kubernetes.io>
- Kubernetes中文社区：<https://www.kubernetes.org.cn/>
- Kubernetes官网翻译：<https://www.kubernetes.org.cn/k8s>
- Kubernetes Handbook：<https://jimmysong.io/kubernetes-handbook/>
- 具体参考：<https://jimmysong.io/blogs/kubernetes-installation-on-centos/>

### Kubernetes集群之Master安装部署
- 本文是在没有启用TLS的情况下安装的kubernetes，还请大家参照[kubernetes-handbook](https://jimmysong.io/kubernetes-handbook/)安装。
- 本文采用的是二进制的安装方式

#### 安装环境
- 所有实验主机都是虚拟机，系统CentOS7.3
  ``` xml
  192.168.8.60   test-node7 master/node  kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy etcd flannel
  192.168.8.61   test-node6 node         kubectl kube-proxy docker flannel
  192.168.8.62   test-node8 node         kubectl kube-proxy docker flannel
  ```
- 具体环境
  - CentOS 7.3.1611
  - Docker 17.06.2-ce
  - ETCD   3.2
  - kubernetes 1.7.6
  - flannel 0.7.0-1
  
#### 安装Docker
- 因为Master及node在一台机器上，所以master和node节点都需要安装docker
- docker安装参考：[Docker安装部署](../Docker/docker-install.md)

#### 安装ETCD
- etcd下载地址：<https://github.com/coreos/etcd/releases>
- etcd官方地址：<https://storage.googleapis.com/etcd>
- 下载二进制文件
  - 我们需要选择一个版本进行下载
  - Linux的下载相关如下所示：
  ``` xml
  ETCD_VER=v3.2.7

  # choose either URL
  GOOGLE_URL=https://storage.googleapis.com/etcd
  GITHUB_URL=https://github.com/coreos/etcd/releases/download
  DOWNLOAD_URL=${GOOGLE_URL}

  rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
  rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

  curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
  tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
  ```
- 解压二进制软件包
  - `tar xf `

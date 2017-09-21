## Kubernetes集群之master和node

### Kubernetes集群master组件
- Master组件提供集群的管理控制中心。
- Master组件可以在集群中任何节点上运行。但是为了简单起见，通常在一台VM/机器上启动所有Master组件，并且不会在此VM/机器上运行用户容器。
- 如果想构建高可用集群，请参考[构建高可用群集](https://kubernetes.io/docs/admin/high-availability/)来构建multi-master-VM。

#### kube-apiserver
- `kube-apiserver`用于暴露`Kubernetes API`。任何的资源请求/调用操作都是通过`kube-apiserver`提供的接口进行。

#### ETCD
- `etcd`是Kubernetes提供默认的存储系统，保存所有集群数据，使用时需要为etcd数据提供备份计划。

#### kube-controller-manager
- `kube-controller-manager`运行管理控制器，它们是集群中处理常规任务的后台线程。逻辑上，每个控制器是一个单独的进程，但为了降低复杂性，它们都被编译成单个二进制文件，并在单个进程中运行。
- 这些控制器包括：
  - 节点（Node）控制器。
  - 副本（Replication）控制器：负责维护系统中每个副本中的pod。
  - 端点（Endpoints）控制器：填充Endpoints对象（即连接Services＆Pods）。
  - Service Account和Token控制器：为新的Namespace 创建默认帐户访问API Token。

#### kube-scheduler
- `kube-scheduler` 监视新创建没有分配到Node的Pod，为Pod选择一个Node。

#### flanneld
- `flanneld`一般是和网络有关的

### Kubernetes集群node组件
- 节点组件运行在Node，提供Kubernetes运行时环境，以及维护Pod。
- 一般包括：kubelet、kube-proxy、docker、flanneld
#### kubelet
- kubelet负责管理pods和它们上面的容器，images镜像、volumes、etc。
- kubelet是主要的节点代理，它会监视已分配给节点的pod，具体功能：
  - 安装Pod所需的volume。
  - 下载Pod的Secrets。
  - Pod中运行的 docker（或experimentally，rkt）容器。
  - 定期执行容器健康检查。
  - Reports the status of the pod back to the rest of the system, by creating a mirror pod if necessary.
  - Reports the status of the node back to the rest of the system

#### kube-proxy
- kube-proxy通过在主机上维护网络规则并执行连接转发来实现Kubernetes服务抽象。
- 每一个节点也运行一个简单的网络代理和负载均衡（详见[services FAQ](https://github.com/kubernetes/kubernetes/wiki/Services-FAQ) )（PS:官方 英文）。 正如Kubernetes API里面定义的这些服务（详见[the services doc](https://github.com/kubernetes/kubernetes/blob/release-1.2/docs/user-guide/services.md)）（PS:官方 英文）也可以在各种终端中以轮询的方式做一些简单的TCP和UDP传输。

#### docker
- docker用于运行容器。

#### flanneld


#### Master和node架构图
- Master架构图如下图所示：
- ![Master架构图](../images/k8smaster.png "Master架构图")
- Node架构图如下图所示：
- ![Node架构图](../images/k8snode.png "Node架构图")

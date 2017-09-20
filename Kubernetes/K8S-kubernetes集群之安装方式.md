## kubernetes集群之安装方式
- 目前，kubernetes主流的安装方式大体分为三种：
  - yum安装
  - 使用二进制文件安装
  - 用Kubeadm方式安装
  
- 下面对三种安装方式进行比较

### yum安装
- 配置yum源后，使用yum安装，好处是简单，坏处也很明显，需要google更新yum源才能获得最新版本的软件，而所有软件的依赖又不能自己指定，
尤其是你的操作系统版本如果低的话，使用yum源安装的kubernetes的版本也会受到限制。

### 二进制方式安装
- 使用二进制文件安装，好处是可以安装任意版本的kubernetes，坏处是配置比较复杂。

### Kubeadm方式安装
- kubernetes核心组件的Pod化，即：kube-apiserver、kube-controller-manager、kube-scheduler、kube-proxy、kube-discovery
以及etcd等核心组件都运行在集群中的Pod里的，只有一个组件是例外的，那就是负责在node上与本地容器引擎交互的Kubelet。
- 具体安装方法参见[Kubeadm方式安装k8s集群](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)
- 推荐大神的安装教程[Kubeadm方式安装k8s集群的探索](http://tonybai.com/2017/01/24/explore-kubernetes-cluster-installed-by-kubeadm/)

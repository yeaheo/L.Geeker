## kubernetes实践-安装 kubectl 工具
- 其实 kubernetes 的 server 软件包基本涵盖了 kubernetes 几乎所有的工具，所以我们只需要下载 kubernetes 的 server 软件包即可。
- kubernetes 源码下载地址： <https://github.com/kubernetes/kubernetes/releases/>

- 本文档是基于 v1.9.6 版本部署 kubernetes 集群，其他版本基本类似，相较老版本（v1.6）参数会有变化，我会在对应位置注明。

- **下载并准备 kubectl 工具**
  ``` bash
  wget https://dl.k8s.io/v1.9.6/kubernetes-server-linux-amd64.tar.gz
  tar -xzvf kubernetes-server-linux-amd64.tar.gz
  cd kubernetes
  tar -xzvf  kubernetes-src.tar.gz
  cd server/bin
  将二进制文件拷贝到指定路径
  cp kubectl /usr/local/bin
  ```
- **创建 kubectl kubeconfig 文件**
  ``` bash
  export KUBE_APISERVER="https://192.168.8.66:6443"
  # 设置集群参数
  kubectl config set-cluster kubernetes \
    --certificate-authority=/etc/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER}
  # 设置客户端认证参数
  kubectl config set-credentials admin \
    --client-certificate=/etc/kubernetes/ssl/admin.pem \
    --embed-certs=true \
    --client-key=/etc/kubernetes/ssl/admin-key.pem
  # 设置上下文参数
  kubectl config set-context kubernetes \
    --cluster=kubernetes \
    --user=admin
  # 设置默认上下文
  kubectl config use-context kubernetes
  ```
- 参数说明：
- `admin.pem` 证书 OU 字段值为 `system:masters`；
- `kube-apiserver` 预定义的 RoleBinding cluster-admin 将 Group system:masters 与 Role cluster-admin 绑定，该 Role 授予了调用 kube-apiserver 相关 API 的权限；
- 生成的 `kubeconfig` 被保存到 `~/.kube/config` 文件中，如下所示：
  ``` bash
  [root@k8s-master1 ~]# ls /root/.kube/
  cache  config  schema
  ```
- 现在基本可以使用 kubectl 工具了。

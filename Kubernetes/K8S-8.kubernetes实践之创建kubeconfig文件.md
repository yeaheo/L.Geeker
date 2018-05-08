## kubernetes实践-创建kubeconfig相关文件
- 需要说明的是 kubelet、kube-proxy 等 Node 机器上的进程与 Master 机器的 kube-apiserver 进程通信时需要认证和授权；
- kubernetes v1.4 版本开始支持由 kube-apiserver 为客户端生成 TLS 证书的 TLS Bootstrapping功能，这样就不需要为每个客户端生成证书了，但目前只支持为 kubectl 生成证书。
  > 以下操作只需要在 `master` 上执行即可，生成的 `*.kubeconfig` 文件可以直接拷贝到node节点的 `/etc/kubernetes` 目录下。

### 创建 TLS Bootstrapping Token
- token 可以是任意的包涵128 bit的字符串，可以使用安全的随机数发生器生成。
- 具体配置参考如下：
  ``` bash
  cd /etc/kubernetes
  export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
  
  cat > token.csv <<EOF
  ${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
  EOF
  ```
  > 需要注意的是在进行后续操作前请检查 token.csv 文件，确认其中的 ${BOOTSTRAP_TOKEN} 环境变量已经被真实的值替换。
- BOOTSTRAP_TOKEN 将被写入到 kube-apiserver 使用的 token.csv 文件和 kubelet 使用的 bootstrap.kubeconfig 文件，如果后续重新生成了 BOOTSTRAP_TOKEN，则需要进行如下操作：
* 1.更新 `token.csv` 文件，分发到所有机器 (master 和 node）的 `/etc/kubernetes/` 目录下，分发到node节点上非必需；
* 2.重新生成 `bootstrap.kubeconfig` 文件，分发到所有 node 机器的 `/etc/kubernetes/` 目录下；
* 3.重启 `kube-apiserver` 和 `kubelet` 进程；
* 4.重新 approve kubelet 的 csr 请求。

### 创建 kubelet bootstrapping kubeconfig 文件
- 具体配置参考如下：
  ``` bash
  cd /etc/kubernetes
  export KUBE_APISERVER="https://192.168.8.66:6443"
  
  # 设置集群参数
  kubectl config set-cluster kubernetes \
    --certificate-authority=/etc/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=bootstrap.kubeconfig
  
  # 设置客户端认证参数
  kubectl config set-credentials kubelet-bootstrap \
    --token=${BOOTSTRAP_TOKEN} \
    --kubeconfig=bootstrap.kubeconfig

  # 设置上下文参数
  kubectl config set-context default \
    --cluster=kubernetes \
    --user=kubelet-bootstrap \
    --kubeconfig=bootstrap.kubeconfig
  
  # 设置默认上下文
  kubectl config use-context default --kubeconfig=bootstrap.kubeconfig
  ```
- 参数说明：
- `--embed-certs` 为 `true` 时表示将 `certificate-authority` 证书写入到生成的 `ootstrap.kubeconfig` 文件中；
- 设置客户端认证参数时没有指定秘钥和证书，后续由 `kube-apiserver` 自动生成；

### 创建 kube-proxy kubeconfig 文件
- 创建 kube-proxy的 kubeconfig 文件参考如下：
  ``` bash
  cd /etc/kubernetes
  export KUBE_APISERVER="https://192.168.8.66:6443"
  # 设置集群参数
  kubectl config set-cluster kubernetes \
    --certificate-authority=/etc/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-proxy.kubeconfig
  # 设置客户端认证参数
  kubectl config set-credentials kube-proxy \
    --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
    --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig
  # 设置上下文参数
  kubectl config set-context default \
    --cluster=kubernetes \
    --user=kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig
  # 设置默认上下文
  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
  ```
- 参数说明：
- 设置集群参数和客户端认证参数时 `--embed-certs` 都为 `true`，这会将 `certificate-authority、client-certificate` 和 `client-key` 指向的证书文件内容写入到生成的 `kube-proxy.kubeconfig` 文件中；
- `kube-proxy.pem` 证书中 CN 为 system:kube-proxy，`kube-apiserver` 预定义的 RoleBinding cluster-admin 将User system:kube-proxy 与 Role system:node-proxier 绑定，该 Role 授予了调用 `kube-apiserver` Proxy 相关 API 的权限；

### 分发 kubeconfig 文件
- 创建完成后，我们需要将生成的两个 kubeconfig 文件分发到所有 Node 上的 `/etc/kubernetes/` 目录中。
  ``` bash
  cp bootstrap.kubeconfig kube-proxy.kubeconfig /etc/kubernetes/
  scp bootstrap.kubeconfig kube-proxy.kubeconfig node-ip:/etc/kubernetes/
  # /etc/kubernetes/目录需要在node节点上提前创建，在制作证书和密钥的时候已经创建了所以不再赘述
  ```



  


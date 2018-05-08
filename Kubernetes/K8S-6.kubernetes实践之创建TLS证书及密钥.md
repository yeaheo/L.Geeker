## kubernetes实践-创建TLS证书及密钥
- 集群环境如下：
  ``` bash
  k8s-master: 192.168.8.66
  k8s-nodes:  192.168.8.67 192.168.8.68
  k8s-harbor: 192.168.8.69
  ```
### 创建TLS证书及密钥
- `kubernetes`系统的各组件需要使用 `TLS` 证书对通信进行加密，本文档使用 CloudFlare 的 PKI 工具集 `cfssl` 来生成 Certificate Authority (CA) 和其它证书；
- 集群TLS认证需要的证书及密钥如下：
  ``` bash
  admin-key.pem
  admin.pem
  ca-key.pem
  ca.pem
  kube-proxy-key.pem
  kube-proxy.pem
  kubernetes-key.pem
  kubernetes.pem
  ```
- 集群各组件对证书的依赖如下：
  ``` bash
  etcd：使用 ca.pem、kubernetes-key.pem、kubernetes.pem；
  kube-apiserver：使用 ca.pem、kubernetes-key.pem、kubernetes.pem；
  kubelet：使用 ca.pem；
  kube-proxy：使用 ca.pem、kube-proxy-key.pem、kube-proxy.pem；
  kubectl：使用 ca.pem、admin-key.pem、admin.pem；
  kube-controller-manager：使用 ca-key.pem、ca.pem
  ```
#### 安装证书制作工具-CFSSL
- 安装前需要在 `/etc/profile` 文件中配置 `GOPATH` 变量，内容如下：
  ``` bash
  ...
  export GOPATH=/usr/local/go
  ...
  source /etc/profile
  ```
- 安装CFSSL
  ``` bash
  $ go get -u github.com/cloudflare/cfssl/cmd/...
  $ echo $GOPATH
  /usr/local/go
  $ ls /usr/local/go/bin/
  cfssl  cfssl-bundle  cfssl-certinfo  cfssljson  cfssl-newkey  cfssl-scan  mkbundle  multirootca
  ```
#### 创建CA证书
- **创建CA配置文件**
  ``` bash
  mkdir /root/ssl
  cd /root/ssl
  cfssl print-defaults config > config.json
  cfssl print-defaults csr > csr.json
  # 根据config.json文件的格式创建如下的ca-config.json文件
  # 过期时间设置成了 87600h
  cat > ca-config.json <<EOF
  {
    "signing": {
      "default": {
        "expiry": "87600h"
      },
      "profiles": {
        "kubernetes": {
          "usages": [
              "signing",
              "key encipherment",
              "server auth",
              "client auth"
          ],
          "expiry": "87600h"
        }
      }
    }
  }
  EOF
  ```
- 字段说明如下：
- `ca-config.json`：可以定义多个 profiles，分别指定不同的过期时间、使用场景等参数；后续在签名证书时使用某个 profile；
- `signing`：表示该证书可用于签名其它证书；生成的 ca.pem 证书中 CA=TRUE；
- `server auth`：表示client可以用该 CA 对server提供的证书进行验证；
- `client auth`：表示server可以用该 CA 对client提供的证书进行验证；

- **创建 CA 证书签名请求**
  ``` bash
  cat > ca-csr.json << EOF
  {
    "CN": "kubernetes",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "System"
      }
    ]
  }
  EOF
  ```
- 字段说明如下：
- "CN"：Common Name，kube-apiserver 从证书中提取该字段作为请求的用户名 (User Name)；浏览器使用该字段验证网站是否合法；
- "O"：Organization，kube-apiserver 从证书中提取该字段作为请求用户所属的组 (Group)；

- **生成 CA 证书和密钥**
  ``` bash
  # cfssl gencert -initca ca-csr.json | cfssljson -bare ca
  # ls ca*
  ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem
  ```
#### 创建 kubernetes 证书
- **创建 kubernetes 证书签名请求文件**
  ``` bash
  cat > kubernetes-csr.json << EOF
  {
    "CN": "kubernetes",
    "hosts": [
      "127.0.0.1",
      "192.168.8.66",
      "192.168.8.67",
      "192.168.8.68",
      "192.168.8.69",
      "10.254.0.1",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "BeiJing",
            "L": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
  }
  EOF
  ```
- 如果 hosts 字段不为空则需要指定授权使用该证书的 IP 或域名列表，由于该证书后续被 etcd 集群和 kubernetes master 集群使用，所以上面分别指定了 etcd 集群、kubernetes master 集群的主机 IP 和 kubernetes 服务的服务 IP（一般是 kube-apiserver 指定的 service-cluster-ip-range 网段的第一个IP，如 10.254.0.1。hosts 中的内容可以为空，即使按照上面的配置，向集群中增加新节点后也不需要重新生成证书。

- **生成 kubernetes 证书和私钥**
  ``` bash
  # cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes
  # ls kubernetes*
  kubernetes.csr  kubernetes-csr.json  kubernetes-key.pem  kubernetes.pem
  ```
#### 创建 admin 证书
- **创建 admin 证书签名请求文件**
  ``` bash
  cat > admin-csr.json << EOF
  {
    "CN": "admin",
    "hosts": [],
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "system:masters",
        "OU": "System"
      }
    ]
  }
  EOF
  ```
- 字段说明：
- 后续 kube-apiserver 使用 RBAC 对客户端(如 kubelet、kube-proxy、Pod)请求进行授权，kube-apiserver 预定义了一些 RBAC 使用的 RoleBindings，如 cluster-admin 将 Group system:masters 与 Role cluster-admin 绑定，该 Role 授予了调用kube-apiserver 的所有 API的权限；
- OU 指定该证书的 Group 为 system:masters，kubelet 使用该证书访问 kube-apiserver 时 ，由于证书被 CA 签名，所以认证通过，同时由于证书用户组为经过预授权的 system:masters，所以被授予访问所有 API 的权限；

#### 创建 kube-proxy 证书
- **创建 kube-proxy 证书签名请求文件**
  ``` bash
  cat > kube-proxy-csr.json << EOF
  {
    "CN": "system:kube-proxy",
    "hosts": [],
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "System"
      }
    ]
  }
  EOF
  ```
- 字段说明如下：
- CN 指定该证书的 User 为 system:kube-proxy；
- kube-apiserver 预定义的 RoleBinding cluster-admin 将User system:kube-proxy 与 Role system:node-proxier 绑定，该 Role 授予了调用 kube-apiserver Proxy 相关 API 的权限；

### 校验证书
- 以 kubernetes 证书为例
- **使用 openssl 命令校验**
  ``` bash
  openssl x509  -noout -text -in  kubernetes.pem
  ```
- 需要确认的信息如下：
- 确认 Issuer 字段的内容和 ca-csr.json 一致；
- 确认 Subject 字段的内容和 kubernetes-csr.json 一致；
- 确认 X509v3 Subject Alternative Name 字段的内容和 kubernetes-csr.json 一致；
- 确认 X509v3 Key Usage、Extended Key Usage 字段的内容和 ca-config.json 中 kubernetes profile 一致；

- **使用 fssl-certinfo 命令校验**
  ``` bash
  cfssl-certinfo -cert kubernetes.pem
  ```
### 分发证书
- 将生成的证书和秘钥文件（后缀名为.pem）拷贝到所有机器的 `/etc/kubernetes/ssl` 目录下备用；
  ``` bash
  mkdir -p /etc/kubernetes/ssl
  cp *.pem /etc/kubernetes/ssl
  ```
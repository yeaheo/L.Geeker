## 使用国内源部署 Ceph
- 由于网络方面的原因，ceph 的部署经常受到干扰，通常为了加速部署，基本上大家都是将 ceph 的源同步到本地进行安装。根据 ceph 中国社区的统计，当前已经有国内的网站定期将 ceph 安装源同步，极大的方便了我们的测试。本文就是介绍如何使用国内源，加速 ceph-deploy 部署 ceph 集群。

### 关于国内源
- 根据 ceph 中国社区的统计，国内已经有四家网站开始同步 ceph 源，分别是：
- 网易镜像源: <http://mirrors.163.com/ceph>
- 阿里镜像源: <http://mirrors.aliyun.com/ceph>
- 中科大镜像源: <http://mirrors.ustc.edu.cn/ceph>
- 宝德镜像源: <http://mirrors.plcloud.com/ceph>
  
### 国内源分析

- 以网易源为例，是以天为单位向回同步 Ceph 源，完全可以满足大多数场景的需求，同步的源也非常全，包含了 calamari，debian 和 rpm 的全部源，最近几个版本的源也能从中找到。

### 安装指定版本的 Ceph
- 这里以安装最新版本的 Jewel 为例，由于 Jewel 版本中已经不提供 el6 的镜像源，所以只能使用 CentOS 7 以上版本进行安装。我们并不需要在 repos 里增加相应的源，只需要设置环境变量，即可让 ceph-deploy 使用国内源，具体过程如下：

  ```bash
  export CEPH_DEPLOY_REPO_URL=http://mirrors.163.com/ceph/rpm-jewel/el7
  export CEPH_DEPLOY_GPG_URL=http://mirrors.163.com/ceph/keys/release.asc
  ```

- 之后的过程就没有任何区别了，大概参考步骤如下所示：
  
  ```bash
  # Create monitor node
  ceph-deploy new node1 node2 node3

  # Software Installation
  ceph-deploy install deploy node1 node2 node3

  # Gather keys
  ceph-deploy mon create-initial

  # Ceph deploy parepare and activate
  ceph-deploy osd prepare node1:/dev/sdb node2:/dev/sdb node3:/dev/sdb
  ceph-deploy osd activate node1:/var/lib/ceph/osd/ceph-0 node2:/var/lib/ceph/osd/ceph-1 node3:/var/lib/ceph/osd/ceph-2

  # Make 3 copies by default
  echo "osd pool default size = 3" | tee -a $HOME/ceph.conf

  # Copy admin keys and configuration files
  ceph-deploy --overwrite-conf admin deploy node1 node2 node3
  ```
- 如果服务器在香港或者国外，这些操作可以不做，用官方提供的源即可！

## 在 CentOS 7 系统上安装较新版本的 git 工具
- 有些时候我们需要安装较新版本的 git 工具，因为有的操作需要在 git 较新版本的基础上才能正常运行。
- 系统版本信息：
  
  ```bash
  [root@ns1 ~]# cat /etc/redhat-release 
  CentOS Linux release 7.5.1804 (Core)
  ```

- git 官方地址：<https://git-scm.com/>
- git 源码官方下载地址：<https://mirrors.edge.kernel.org/pub/software/scm/git/>

### 源码安装 git
- 获取源码包(根据自己需要下载指定版本的源码包):
  
  ```bash
  cd /opt/soft
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.13.6.tar.gz
  ```
  
- 安装相关依赖包：

  ```bash
  yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker openssh-clients -y
  ```
 
- 编译并安装:

  ```bash
  tar xf /opt/soft/git-2.13.6.tar.gz -C /usr/src
  cd /usr/src/git-2.13.6
  make prefix=/usr/local/git all   # prefix 参数用于指定 git 安装目录
  make prefix=/usr/local/git install
  ```
- 设置相关环境变量：
- 修改 `/etc/profile` 文件，增加如下内容：

  ```bash
  export GIT_HOME=/usr/local/git
  export PATH=$PATH:$GIT_HOME/bin
  ```
- 执行 `/etc/profile` 文件使配置生效：

  ```bash
  source /etc/profile
  ```


  
  

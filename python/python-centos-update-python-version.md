## CentOS 7 升级默认 Python 版本至较新版本
- CentOS7 系统目前默认 python 环境版本号为 `2.7.5`，在实际的开发、测试环境中我们可能需要较高的版本，但是 `Centos` 操作系统自带软件可能依赖 `python2.7.5`版本，所以本次我们保留旧版本的 `pthon` ，实现多版本 `python` 共存。

- **查看系统版本及默认 python 版本**
  
  ```bash
  [root@ceph-node1 ~]# cat /etc/redhat-release 
  CentOS Linux release 7.4.1708 (Core) 
  [root@ceph-node1 ~]# python --version
  Python 2.7.5
  ```
- **从官网下载相应的 Python 包(本次版本为 2.7.14)**
  
  ```bash
  cd /opt/soft
  wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz
  ```
- **解压 Python 包**
  
  ```bash
  tar xf Python-2.7.14.tgz -C /usr/src
  ```
- **配置编译环境**
  
  ```bash
  yum install gcc* openssl openssl-devel ncurses-devel.x86_64  bzip2-devel sqlite-devel python-devel zlib -y
  ```
- **配置并安装 Python2.7.14 版本**
  
  ```bash
  cd /usr/src/Python-2.7.14
  ./configure --prefix=/usr/local
  make 
  make altinstall   # 不要使用make install，否则会覆盖系统自带python
  ```
- **Python 环境配置**
- 备份旧版本的 Python
  
  ```bash
  [root@ceph-node1 ~]# which python
  /usr/bin/python
  
  mv /usr/bin/python /usr/bin/python2.7.5
  ```
- **配置新版本的 Python 并查看版本信息**
  
  ```bash
  ln -s /usr/local/bin/python2.7 /usr/bin/python
  
  [root@ceph-node1 ~]# python -V
  Python 2.7.14
  ```
- 修改`yum`配置
  
  ```bash
  vim /usr/bin/yum
  首行的#!/usr/bin/python 改为 #!/usr/bin/python2.7.5
  
  vim /usr/libexec/urlgrabber-ext-down
  首行的#!/usr/bin/python 改为 #!/usr/bin/python2.7.5
  ```
- **安装pip**
  
  ```bash
  wget https://bootstrap.pypa.io/get-pip.py
  python get-pip.py
  ln -s /usr/local/bin/pip2.7 /usr/bin/pip   #建立软连接
  ```
- **升级其他版本的 Python 与此类似只是将 python2.7 改为 python3.x 即可**


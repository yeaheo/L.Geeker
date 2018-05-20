## CentOS 系统更换国内的 yum 源(CentOS7)
- 目前国内常用的镜像源有阿里云源和网易源两种：

- 国内阿里源 <http://mirrors.aliyun.com/repo>
- 国内163源 <http://mirrors.163.com/.help/centos.html>
  
  > 在更换 yum 源之前最好先备份一下默认的 yum 源

### 更换国内的阿里云的yum源
- 阿里源
  
  ```bash
  cd /etc/yum.repos.d/
  cp CentOS-Base.repo /opt/CentOS-Base.repo.bak
  mv ./* /tmp
  wget http://mirrors.aliyun.com/repo/Centos-7.repo
  yum clean all
  yum makecache
  ```

### 更换国内的网易的yum源
- 网易源
  
  ```bash
  cd /etc/yum.repos.d/
  cp CentOS-Base.repo /opt/CentOS-Base.repo.bak
  mv ./* /tmp
  wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
  yum clean all
  yum makecache
  ```

### 将新安装的系统更新到最新的状态
- 更新系统
  
  ```bash
  cd /etc/pki/rpm-gpg/
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*
  yum update -y
  ```

### 为新安装（最小化）的系统安装一些必要的软件包
- 安装一些常用的软件包
  
  ```bash
  yum -y install vim wget gcc* tree telnet dos2unix sysstat lrzsz nc nmap pcre-devel zlib-devel openssl-devel openssh-clients bash-com*
  ```

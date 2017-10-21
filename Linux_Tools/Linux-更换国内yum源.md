## CentOS系统更换国内的yum源(CentOS7)
- 注意：在更换yum源之前最好先备份一下默认的yum源
  - 国内阿里源 <http://mirrors.aliyun.com/repo>
  - 国内163源 <http://mirrors.163.com/.help/centos.html>

#### 更换国内的阿里云的yum源
``` xml
cd /etc/yum.repos.d/
cp CentOS-Base.repo /opt/CentOS-Base.repo.bak
mv ./* /tmp
wget http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache
```
#### 更换国内的网易的yum源
``` xml
cd /etc/yum.repos.d/
cp CentOS-Base.repo /opt/CentOS-Base.repo.bak
mv ./* /tmp
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum clean all
yum makecache
```
#### 将新安装的系统更新到最新的状态
``` xml
cd /etc/pki/rpm-gpg/
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*
yum update -y
```
#### 为新安装（最小化）的系统安装一些必要的软件包
`yum -y install vim wget gcc* tree telnet dos2unix sysstat lrzsz nc nmap pcre-devel zlib-devel openssl-devel openssh-clients bash-com*`

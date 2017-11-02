#!/bin/bash
# Description: CentOS7更换国内163源
# Date: 2017-07-23
# Author: Lv Xiaoteng
# Email: youger.lv@gmail.com

# 备份原yum源
cd /etc/yum.repos.d/
cp CentOS-Base.repo /opt/CentOS-Base.repo.bak
mv ./* /tmp

# 下载163yum源
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
# 下载aliyun的yum源
#wget http://mirrors.aliyun.com/repo/Centos-7.repo

# 清理yum仓库
yum clean all

# 做缓存
yum makecache

# 更新系统软件包
yum update -y

# 安装一些必要的软件包
yum -y install vim wget gcc* tree telnet dos2unix sysstat lrzsz nc nmap pcre-devel zlib-devel openssl-devel openssh-clients bash-com*

#!/bin/bash
# Description: the script install mysqld
# Date: 2017-07-05
# Author: Lv Xiaoteng
# Email: <yeah6066@gmail.com>


# 检查MySQL依赖包
echo "正在检查依赖包"
rpm -q wget &> /dev/null || yum -y install wget
rpm -q ncurses-devel &> /dev/null || yum -y install ncurses-devel
echo "依赖包符合要求,将继续..."

# 下载MySQL官方安装源
[ -d /opt/soft ] &> /dev/null || mkdir -p /opt/soft
cd /opt/soft

[ -f /opt/soft/mysql57-community-release-el7-11.noarch.rpm ] &> /dev/null
if [ $? -eq 0 ] ; then
    rpm -ih  mysql57-community-release-el7-11.noarch.rpm &> /dev/null
else
    echo "正在下载MySQL数据库官方源" && wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm && rpm -ih  mysql57-community-release-el7-11.noarch.rpm &> /dev/null
fi

# 安装MySQL数据库
yum makecache
echo "正在安装MySQL..."
yum -y install mysql-server mysql mysql-devel

# 安装后检查是否安装成功
rpm -q mysql-community-server mysql-community-client  mysql-community-devel &> /dev/null
if [ $? -eq 0 ] ; then
    echo "MySQL数据库安装成功！"
else
    echo "MySQL数据库安装失败，请检查~"
fi








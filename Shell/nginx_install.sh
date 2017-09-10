#!/bin/bash
# Description: the script install nginx
# Date: 2017-06-27
# Author: Lv Xiaoteng
# Email: yeah6066@gmail.com

# 自定义环境变量来获取主机IP地址
NET_NAME=$(ls /sys/class/net | grep 'e')
IPADDR=$(ifconfig $NET_NAME | grep netmask | awk '{print $2}')

# 安装nginx依赖包
echo -e "\033[33m 正在检查软件依赖包！ \033[0m"
rpm -q zlib-devel &> /dev/null || yum -y install zlib-devel
rpm -q pcre-devel &> /dev/null || yum -y install pcre-devel
echo -e "\033[33m 检查软件依赖包完成，符合要求，哈哈！ \033[0m"

# 判断目录是否存在
echo -e "\033[33m 检查系统目录是否存在！ \033[0m"
[ -d /opt/soft ] &> /dev/null
if [ $? -eq 0 ] ; then
        cd /opt/soft
else
        mkdir -p /opt/soft && cd /opt/soft
fi
echo -e "\033[33m 检查完成！ \033[0m"

# 下载nginx软件包
echo -e "\033[33m 开始下载相关软件包！ \033[0m"
rpm -q wget &> /dev/null || yum -y install wget
wget http://nginx.org/download/nginx-1.12.0.tar.gz

echo -e "\033[33m 软件下载完成,软件所在目录/opt/soft！ \033[0m"

# 建立用于启动服务的nginx用户
echo -e "\033[33m 正在建立用于启动服务的nginx用户！ \033[0m"
useradd -M -s /sbin/nologin nginx
sleep 2
echo -e "\033[33m nginx用户创建完成！ \033[0m"

# 安装nginx软件包
echo -e "\033[33m 开始安装nginx软件包！ \033[0m"
tar zxf /opt/soft/nginx-1.12.0.tar.gz -C /usr/src/
sleep 1
cd /usr/src/nginx-1.12.0/
/usr/src/nginx-1.12.0/configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module &> /dev/null
sleep 2
make &> /dev/null
sleep 1
make install &> /dev/null

# 判断nginx是否安装成功
[ -d /usr/local/nginx ] &> /dev/null
if [ $? -eq 0 ] ; then
        echo  -e "\033[32m Nginx server insalled! \033[0m"
else
        echo  -e "\033[32m Nginx server not installed please install Nginx!\033[0m"
exit 1
fi

# 安装成功后执行的工作
# 优化系统启动路径，建立软连接
/usr/bin/ln -s /usr/local/nginx/sbin/* /usr/sbin &> /dev/null

# 启动服务
echo -e "\033[33m 正在启动nginx服务！ \033[0m"
nginx
/usr/bin/netstat -antpu | grep nginx &> /dev/null
sleep 2
if [ $? -eq 0 ] ; then
        echo  -e "\033[32m nginx服务已经启动完成,测试地址为 http://$IPADDR ! \033[0m"
else
        echo  -e "\033[32m nginx服务启动失败,建议查看相关日志文件! \033[0m"
exit 1
fi













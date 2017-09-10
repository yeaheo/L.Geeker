# 常用WEB服务器-Nginx的安装
- Nginx官网：<http://nginx.org>
- Nginx官方库：<http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm>
### 安装依赖包
- 为了确保能在Nginx中使用正则表达式进行更灵活的配置，安装之前需要确定系统是否安装有PCRE和zlib
  - `rpm -q pcre-devel || yum -y install pcre-devel`
  - `rpm -q zlib-devel || yum -y install zlib-devel`

### 新建用户nginx，用于nginx服务器的启动用户
- 新建用户
  - `useradd -M -s /sbin/nologin nginx`
- 下载Nginx软件包,习惯把软件安装在`/usr/local`目录下
  - `wget http://nginx.org/download/nginx-1.12.1.tar.gz`
  - `tar zxf /opt/soft/nginx-1.12.1.tar.gz`
  - `cd nginx-1.12.1`
  - `./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module`
    - 1.--with-http_stub_status_module是为了启用 nginx 的 NginxStatus 功能，用来监控 Nginx 的当前状态
    - 2.--with-http_ssl_module是启用nginx支持https等协议
  - `make && make install`

### 安装完成后的一些优化配置
- 路径优化
  - `ln -s /usr/local/nginx/sbin/* /usr/sbin/`
- 程序运行参数
  - Nginx 安装后只有一个程序文件，本身并不提供各种管理程序，它是使用参数和系统信号机制对 Nginx 进程本身进行控制的
  - Nginx 的参数包括有如下几个:
    - `-c <path_to_config>` 使用指定的配置文件而不是 conf 目录下的 nginx.conf
    - `-t` 测试配置文件是否正确，在运行时需要重新加载配置的时候，此命令非常重要，用来检测所修改的配置文件是否有语法错误
    - `-v` 显示 nginx 版本号
    - `-V` 显示 nginx 的版本号以及编译环境信息以及编译时的参数
- Nginx常用运行命令
  - `nginx` 启动Nginx服务，前提是已经做过路径优化了
  - `nginx -s stop` 停止Nginx服务
  - `nginx -s reload` 重新加载Nginx服务，使配置文件生效

### 通过Shell脚本安装Nginx也是非常方便的
- nginx安装脚本内容如下
  ``` xml
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
  /usr/src/nginx-1.12.0/configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module&> /dev/null
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
  /usr/bin/ln -s /usr/local/nginx/sbin/* /usr/sbin/ &> /dev/null

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
  ```
#### 用yum的方式安装nginx
- 安装nginx库文件
  - `rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm`
- yum安装nginx
  - `yum -y install nginx`
- 启动、停止和重启nginx服务
``` xml 
  systemctl start nginx.service 或 nginx
  systemctl stop nginx.service 或 nginx -s stop
  systemctl restart nginx.service 或 nginx -s reload
  systemctl enable nginx.service
```
- nginx配置文件位置`/etc/nginx/`

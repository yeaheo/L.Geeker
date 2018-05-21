## Nginx 安装
- Nginx 官网：<http://nginx.org>
- Nginx 官方库：<http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm>

- Nginx 的安装方式有很多种，本文档只介绍两种方法，即源码编译安装和 rpm 包管理工具 yum 安装。

### 源码编译安装

#### 安装依赖包
- 为了确保能在 Nginx 中使用正则表达式进行更灵活的配置，安装之前需要确定系统是否安装有 PCRE 和 zlib：
  
  ```bash
  rpm -q pcre-devel || yum -y install pcre-devel
  rpm -q zlib-devel || yum -y install zlib-devel
  ```

#### 新建用户 nginx，用于 nginx 服务的启动用户
- 新建用户
  
  ```bash
  useradd -M -s /sbin/nologin nginx
  ```
- 下载 Nginx 软件包,习惯把软件安装在 `/usr/local` 目录下
  
  ```bash
  wget http://nginx.org/download/nginx-1.12.1.tar.gz
  tar zxf /opt/soft/nginx-1.12.1.tar.gz
  cd nginx-1.12.1
  ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_ssl_module
  # 1.--with-http_stub_status_module是为了启用 nginx 的 NginxStatus 功能，用来监控 Nginx 的当前状态
  # 2.--with-http_ssl_module是启用nginx支持https等协议
  make && make install
  ```

#### 安装完成后的优化配置
- 路径优化
  
  ```bash
  ln -s /usr/local/nginx/sbin/* /usr/sbin/
  ```

- 程序运行参数
- Nginx 安装后只有一个程序文件，本身并不提供各种管理程序，它是使用参数和系统信号机制对 Nginx 进程本身进行控制的
- Nginx 的参数包括有如下几个:
  
  ```bash
  -c <path_to_config> #使用指定的配置文件而不是 conf 目录下的 nginx.conf
  -t                  #测试配置文件是否正确，在运行时需要重新加载配置的时候，此命令非常重要，用来检测所修改的配置文件是否有语法错误
  -v                  #显示 nginx 版本号
  -V                  #显示 nginx 的版本号以及编译环境信息以及编译时的参数
  ```

- Nginx 常用运行命令
  
  ```bash
  nginx -t        #检查 nginx 配置文件逻辑错误
  nginx           #启动Nginx服务，前提是已经做过路径优化了
  nginx -s stop   #停止Nginx服务
  nginx -s reload #重新加载Nginx服务，使配置文件生效
  ```
  > 为了安装方便我写了个安装脚本做参考 [nginx-install-script](https://github.com/yeaheo/hello.linux/blob/master/Shell/nginx_install.sh)

### 用 yum 的方式安装 nginx
- 安装nginx库文件
  
  ```bash
  rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
  ```
- yum 安装 nginx
  
  ```bash
  yum -y install nginx
  ```
- 启动、停止和重启 nginx 服务
  
  ```bash
  systemctl start nginx.service    或 nginx
  systemctl stop nginx.service     或 nginx -s stop
  systemctl restart nginx.service  或 nginx -s reload
  systemctl enable nginx.service
  ```
- nginx 配置文件位置 `/etc/nginx/`


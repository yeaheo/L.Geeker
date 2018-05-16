## 利用二进制方式安装MySQL数据库
- 此方式是利用二进制包安装MySQL数据库

### 下载二进制mysql软件包
- 下载 MySQL 软件包：
  
  ``` bash 
  # wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz
  ```
  > MySQL 官方下载地址：<https://cdn.mysql.com//Downloads/>，可以在这里找到最新版的 MySQL 软件包进行下载，这里只是做个例子进行说明

### 添加mysql用户
- 添加 MySQL 相关用户：
  
  ``` bash
  # useradd -M -s /sbin/nologin mysql
  ```

### 准备MySQL数据库的安装目录
- 安装 MySQL：
  
  ``` bash
  # mv mysql-5.7.17-linux-glibc2.5-x86_64 /usr/local/mysql
  # mkdir -pv /usr/local/mysql/data
  # chown -R mysql.mysql /usr/local/mysql
  ```

### 初始化数据库
- 当我们安装好 MySQL 后需要初始化数据库，具体如下：
  
  ``` bash
  # /usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql/data --  basedir=/usr/local/mysql
  # /usr/local/mysql/bin/mysql_ssl_rsa_setup  --datadir=/usr/local/mysql/data
  ```
  > 注：初始化数据库的时候会提供一个初始密码，初次登陆数据库的时候会使用到这个密码

### 准备系统配置文件
- 准备 MySQL 服务配置文件：
  ``` bash
  cd /usr/local/mysql/support-files
  cp my-default.cnf /etc/my.cnf
  ```

- 修改配置文件关键位置如下： 
  ``` cnf
  basedir = /usr/local/mysql
  datadir = /usr/local/mysql/data
  port = 3306
  server_id = 123
  socket = /tmp/mysql.sock
  ```

  > 如果有自己的一套配置文件，可以使用自己已经写好的配置文件

### 准备系统服务
- 添加 MySQL 至系统服务，方便服务的启动和停止：
  ``` bash
  cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
  ```

- 编辑 MySQL 服务配置文件 `/etc/init.d/mysqld` 添加如下内容:
  ``` cnf
  basedir=/usr/local/mysql
  datadir=/usr/local/mysql/data
  ```
- 授权并添加系统服务：
  ``` bash
  chmod +x /etc/init.d/mysqld
  chkconfig --add mysqld
  chkconfig --list mysqld
  ```

### 启动服务修改密码
- 启动 MySQL 服务，并修改 MySQL 密码：
  
  ``` bash
  bin/mysqld_safe --user=mysql &
  ```
- 修改 MySQL 密码：
  
  ``` bash
  mysql -uroot -p
  
  mysql>
  mysql> set password=password('admin123');
  mysql> grant all on *.* to 'root'@'localhost' identified by 'admin123';
  mysql> flush privileges;
  Query OK, 0 rows affected (0.07 sec)
  mysql> quit
  Bye
  ```

### 设置Mysql数据库开机自启
- 设置 MySQL 数据库开机自启动：
  
  ``` bash
  chkconfig mysqld on
  ```
  


  

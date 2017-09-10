# 利用二进制方式安装MySQL数据库
- 此方式是利用二进制包安装MySQL数据库

### 下载最新版二进制mysql软件包
- `wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz`
### 添加mysql用户
- `useradd -M -s /sbin/nologin mysql`
### 准备MySQL数据库的安装目录
-  
   ``` xml
   # mv mysql-5.7.17-linux-glibc2.5-x86_64 /usr/local/mysql
   # mkdir -pv /usr/local/mysql/data
   # chown -R mysql.mysql /usr/local/mysql
   ```
### 初始化数据库
- `/usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql/data --basedir=/usr/local/mysql`
- `/usr/local/mysql/bin/mysql_ssl_rsa_setup  --datadir=/usr/local/mysql/data`
- 注：初始化数据库的时候会提供一个初始密码，初次登陆数据库的时候会使用到这个密码

### 准备系统配置文件
- `cd /usr/local/mysql/support-files`
- `cp my-default.cnf /etc/my.cnf`
- 修改配置文件关键位置如下：
-  
  ``` xml
  basedir = /usr/local/mysql
  datadir = /usr/local/mysql/data
  port = 3306
  server_id = 123
  socket = /tmp/mysql.sock
  ```
- 如果有自己的一套配置文件，可以使用自己已经写好的配置文件
### 准备系统服务
- `cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld`
- `vim /etc/init.d/mysqld`
  
  ``` xml
  basedir=/usr/local/mysql
  datadir=/usr/local/mysql/data
  ```
- `chmod +x /etc/init.d/mysqld`
- `chkconfig --add mysqld`
- `chkconfig --list mysqld`

### 启动服务修改密码
- `bin/mysqld_safe --user=mysql &`
- `mysql -uroot -p`
  
  ``` xml
  mysql>
  mysql> set password=password('admin123');
  mysql> grant all on *.* to 'root'@'localhost' identified by 'admin123';
  mysql> flush privileges;
  Query OK, 0 rows affected (0.07 sec)
  mysql> quit
  Bye
  ```
### 设置Mysql数据库开机自启
- `chkconfig mysqld on`
  


  

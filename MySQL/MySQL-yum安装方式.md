## 利用rpm方式安装MySQL数据库
- 本总结适合于利用rpm的方式安装MySQL数据库

### 下载MySQL官方安装源
- `wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm`

### 安装相关rpm包
- `rpm -ivh mysql57-community-release-el7-11.noarch.rpm`

### 安装MySQL数据库
-  
  ``` xml
  yum makecache
  yum -y install mysql-server mysql mysql-devel
  ```
### 安装MySQL数据库后需要设置MySQL的root密码
- 首先需要修改配置文件/etc/my.cnf，在[mysqld]中添加如下一行：
  ``` xml
  skip-grant-tables  #表示跳过密码验证
  保存退出
  然后重启MySQL服务
  service mysqld restart
  ```
- 进入MySQL数据库，并修改密码
  ``` xml
  mysql –u root
  use mysql;
  update mysql.user set authentication_string=password('123456') where user='root' and Host = 'localhost';
  flush privileges;
  ```
- 修改MySQL配置文件/etc/my.cnf注释掉skip-grant-tables
- 重启服务
  `service mysqld restart`
### 重置密码
- `alter user 'root'@'localhost' identified by 'Mtl@.com123';`
  

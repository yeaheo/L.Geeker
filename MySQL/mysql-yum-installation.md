## 利用 rpm 方式安装 MySQL 数据库
- 本总结适合于利用 rpm 的方式安装 MySQL 数据库

### 下载 MySQL 官方安装源
- 下载 MySQL 管方 yum 源：
  
  ```bash
  wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm
  ```

### 安装相关 rpm 包
- 安装依赖：
  
  ```bash
  rpm -ivh mysql57-community-release-el7-11.noarch.rpm
  ```

### 安装 MySQL 数据库
- 安装 MySQL 相关软件包：
  
  ```bash
  yum makecache
  yum -y install mysql-server mysql mysql-devel
  ```

### 安装 MySQL 数据库后需要设置 MySQL 的 root 密码
- 首先需要修改配置文件 `/etc/my.cnf`，在 `[mysqld]` 中添加如下一行：
  
  ```bash
  skip-grant-tables  #表示跳过密码验证
  # 保存退出
  # 然后重启MySQL服务
  service mysqld restart
  ```

- 进入 MySQL 数据库，并修改密码
  
  ```bash
  mysql –u root
  use mysql;
  update mysql.user set authentication_string=password('123456') where user='root' and Host = 'localhost';
  flush privileges;
  ```

- 修改 MySQL 配置文件 `/etc/my.cnf` 注释掉 `skip-grant-tables`
- 重启服务
  
  ```bash
  service mysqld restart
  ```

### 重置密码
- 重置 MySQL 密码：
  
  ```bash
  alter user 'root'@'localhost' identified by 'Mtl@.com123';
  ```
  

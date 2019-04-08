## MySQL 主从/主主复制配置
- 参考环境:
  ```bash
  1主   ：192.168.8.31
  从/2主：192.168.8.128
  ```
  
### 修改配置文件开启二进制日志
- 192.168.8.31
- 修改 `/etc/my.cnf` 文件，添加如下内容：

  ```bash
  log-bin=mysql-bin
  relay-log=relay-log-bin
  relay-log-index=slave-relay-log-bin.index
  server-id = 31
  binlog_format = mixed
  expire_logs_days = 30
  
  #配置主主复制需要添加以下内容，主从复制不需要
  auto_increment_increment=2     #步进值auto_imcrement。一般有n台主MySQL就填n
  auto_increment_offset=1        #起始值。一般填第n台主MySQL。此时为第一台主MySQL
  binlog-ignore-db=mysql         #忽略mysql库【我一般都不写】
  binlog-ignore-db=information_schema   #忽略information_schema库【我一般都不写】
  #replicate-do-db=aa   #要同步的数据库，默认所有库
  ```
- 192.168.8.128
- 修改 `/etc/my.cnf` 文件，添加如下内容：

  ```bash
  log-bin=mysql-bin
  relay-log=relay-log-bin
  relay-log-index=slave-relay-log-bin.index
  server-id = 128
  binlog_format = mixed
  expire_logs_days = 30
  
  #配置主主复制需要添加以下内容，主从复制不需要
  auto_increment_increment=2     #步进值auto_imcrement。一般有n台主MySQL就填n
  auto_increment_offset=1        #起始值。一般填第n台主MySQL。此时为第一台主MySQL
  ```
### 配置主从复制
- 在主数据库(192.168.8.31)上授权从数据库相关账号，使其可以访问主数据库
  
  ```bash
  mysql> grant replication slave on *.* to 'myslave'@'192.168.8.128' identified by 'Myslave@2017';
  mysql> flush privileges;
  mysql> show master status;
  +------------------+----------+--------------+------------------+-------------------+
  | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
  +------------------+----------+--------------+------------------+-------------------+
  | mysql-bin.000001 |      604 |              |                  |                   |
  +------------------+----------+--------------+------------------+-------------------+
  ```
- 在从数据库(192.168.8.128)上设置主数据库的相关信息
  
  ```bash
  mysql> change master to   master_host="192.168.8.31",master_user="myslave",master_password="Myslave@2017",master_port=32016,master_log_ffile="mysql-bin.000001",master_log_pos=604;
  mysql> start slave;
  mysql> show slave status\G;
  ```
- 出现以下信息表示主从设置完成，128为31的从数据库
  
  ```bash
  ......
  Slave_IO_Running: Yes
  Slave_SQL_Running: Yes
  ......
  ```
### 配置主主复制
- 主主复制是从主从复制基础上配置的，可以说是192.168.8.31和192.168.8.128互为主从
- 在主数据库(192.168.8.128)上授权从数据库相关账号，使其可以访问主数据库
  
  ```bash
  mysql> grant replication slave on *.* to 'myslave'@'192.168.8.31' identified by 'Myslave@2017';
  mysql> flush privileges;
  mysql> show master status;
  +------------------+----------+--------------+------------------+-------------------+
  | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
  +------------------+----------+--------------+------------------+-------------------+
  | mysql-bin.000002 |      613 |              |                  |                   |
  +------------------+----------+--------------+------------------+-------------------+
  ```
- 在从数据库(192.168.8.31)上设置主数据库的相关信息
  
  ```bash
  mysql> change master to   master_host="192.168.8.128",master_user="myslave",master_password="Myslave@2017",master_port=32016,master_log_ffile="mysql-bin.000002",master_log_pos=613;
  mysql> start slave;
  mysql> show slave status\G;
  ```
- 出现以下信息表示主从设置完成，31为128的从数据库
  
  ```bash
  ......
  Slave_IO_Running: Yes
  Slave_SQL_Running: Yes
  ......
  ```
- 至此，主从/主主配置完成！

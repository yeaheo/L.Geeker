## 定期清理binlog日志
- MySQL 中，binlog 日志占用很大的磁盘资源，如若长期放任不管，最后将造成资源浪费。我们先手动清理，然后设置成自动清理。

### 查看指定删除日志
- 查看 MySQL 数据库的二进制日志及占用空间
  
  ``` bash
  mysql> show binary logs;
  +------------------+------------+
  | Log_name         | File_size  |
  +------------------+------------+
  | mysql-bin.000052 |  914368613 |
  | mysql-bin.000053 | 1073742506 |
  | mysql-bin.000054 |  324515751 |
  +------------------+------------+
  3 rows in set (0.00 sec)
  ```

- 清理相关日志
  
  ``` bash
  mysql> purge master logs to 'mysql-bin.000054';   ## 删除二进制日志mysql-bin.000054以前的所有binlog，这样删除可以保证*.index信息与binlog文件同步
  Query OK, 0 rows affected (2.46 sec)
  ```

### 手动清理日志
- 手动清理指定日期的 binlog 文件
  
  ``` bash
  PURGE MASTER LOGS BEFORE DATE_SUB(CURRENT_DATE, INTERVAL 5 DAY);
  ## 手动清理5天前的 binlog
  ```

### 设置自动清理
- 利用命令行清理：
  ``` bash
  mysql> set global expire_logs_days = 5;
  mysql> flush logs;
  ```

- 配置完成后需要刷新一下日志，否则不生效

- 为保证在 MySQL 服务重启后仍然有效，需要修改配置文件，在 `[mysqld]` 段中添加如下内容：
  ``` bash
  expire_logs_days = 5
  ```

### 直接命令行不需要登陆MySQL
- 有时候我们不需要登陆MySQL数据库来执行命令，可以直接在命令行执行即可，但这样MySQL的相关账号信息或暴露，不安全
- 示例：
 
  ``` bash
  mysql -uroot -pctsig126 -e "show global variables like '%expire_logs_days%';"
  ```

- 一般在 `-e` 后添加需要执行的命令即可。

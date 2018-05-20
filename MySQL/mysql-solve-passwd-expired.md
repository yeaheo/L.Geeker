## MySQL 的密码过期问题
- 有些时候我们在连接数据库的时候报错，大概意思就是密码过期了，需要重置密码
- 具体报错信息如下：
- 在 mysql 终端提示信息为：
  
  ```bash
  ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
  ```
- 远程访问提示信息为：
  
  ```bash
  ERROR 1862 (HY000): Your password has expired. To log in you must change it using a client that supports expired passwords.
  ```

### 解决办法：
  > 注：MySQL版本为5.7
- 修改root密码:

- MySQL 5.7.6 and later 则内容为:
  
  ```bash
  ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
  ```

- MySQL 5.7.5 and earlier则为:
  
  ```bash
  SET PASSWORD FOR 'root'@'localhost' = PASSWORD('MyNewPass');
  ```
- 密码过期：
- mysql 内执行  修改密码永不过期。
  
  ```bash
  ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;  NEVER全局用户
  或者
  SET GLOBAL default_password_lifetime = 0;
  或者
  ALTER USER 'root'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;  90天过期
  ```
### 设置密码永不失效
- 修改 MySQL 的配置文件 `my.cnf` ，在其中加入如下内容：
  
  ```bash
  [mysqld]
  default_password_lifetime=0  #设置密码永不失效
  ```
- 修改完成，重启 MySQL 服务器即可。

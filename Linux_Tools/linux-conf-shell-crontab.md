## 如何让脚本定时执行
- 黑客执行脚本的方式一般分为三种方式：
- 1、设置计划任务crontab
- 2、设置开机启动
- 3、替换系统命令，设定触发条件
  
### 设置计划任务 crontab
- 设置计划任务（默认以 root 用户添加计划任务）
  
  ```bash
  [root@www ~]# crontab -e
  #然后输入以下内容：
  1 2 * * *  echo "Hello World"
  #保存退出即可
  ```
- 查看 root 用户的计划任务
  
  ```bash
  crontab -l
  ```
- 以非 root 用户添加计划任务，最好采用系统本身存在的用户
  
  ```bash
  crontab -u bin -e  #以bin用户添加计划任务
  ```
- 查看非 root 用户的计划任务
  
  ```bash
  crontab -u bin -l  #查看bin用户的计划任务
  ```
- 查看所有用户的计划任务
- 要想查看所有用户的计划任务，需要查看 `/var/spool/cron` 文件
    ```bash
    [root@www cron]# ll /var/spool/cron/
    -rw-------. 1 root root 17 9月   2 20:02 bin
    -rw-------. 1 root root 30 9月   2 19:55 root
    ```

### 高级 crontab,篡改某个系统级别的计划任务
- 系统级别的计划任务，相关文件位置
  
  ```bash
  [root@www ~]# ll /etc/cron   需要tab键补全
  cron.d/       cron.daily/   cron.deny     cron.hourly/  cron.monthly/ crontab     cron.weekly/
  ```
- 各个文件的用途说明：
- `cron.d`       系统级别的计划任务
- `cron.daily`   系统每天要执行的计划任务
- `cron.hourly`  系统每小时要执行的计划任务
- `cron.monthly` 系统每月要执行的计划任务
- `cron.weekly`  系统每周要执行的计划任务

- 查看可以添加计划任务的文件
  
  ```bash
  [root@www etc]# find /etc/cron*
  /etc/cron.d
  /etc/cron.d/0hourly
  /etc/cron.daily
  /etc/cron.daily/logrotate
  /etc/cron.daily/man-db.cron
  /etc/cron.deny
  /etc/cron.hourly
  /etc/cron.hourly/0anacron
  /etc/cron.monthly
  /etc/crontab
  /etc/cron.weekly
  ```
- 排查计划任务文件是否被篡改
- 利用`md5sum`检查文件一致性
  
  ```bash
  md5sum /etc/cron.daily/logrotate
  ```
- 提前建立相关文件的MD5
  
  ```bash
  find /etc/cron* -type f -exec md5sum {} \; > /opt/file_md5.v1
  ```
- 如果事前忘记生成相关文件的 MD5 值可以找一台正常的机器生成对应 MD5 值，再做比较

### 开机自动启动程序
- 开机启动脚本一般为： `/etc/rc.local`
  
  > 一般用 `cat` 查看，有时候黑客会在中间插入很多空行

### 替换相关系统命令
- 举例说明：
  
  ```bash
  [root@www ~]# which  find
  /usr/bin/find
  ```
  
  ```bash
  cp /usr/bin/find /usr/bin/find.bak
  rm -rf /usr/bin/find
  vim /usr/bin/find
  #添加如下内容：
  echo "aaa"
  #保存退出
  chmod +x /usr/bin/find
  [root@www ~]# find
  aaa
  ```
  



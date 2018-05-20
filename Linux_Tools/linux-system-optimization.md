## Linux系统一般优化

### 锁定关键系统文件，防止被提权篡改
- 有时候我们需要锁死一些文件，防止被篡改：
  
  ```bash
  chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab
  ```

### 解锁命令：
- 解锁加锁的文件：
  
  ```bash
  chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab
  ```
  
  > 上锁后如需修改文件，可以先解锁再修改，修改完成后再加锁

### 查看被上锁文件的属性：
- 查看被加锁的文件：
  
  ```bash
  [root@localhost ~]# lsattr /etc/passwd
  ----i--------e- /etc/passwd
  ```

- 为了更安全，可以修改相应命令的名称
  ```bash
  mv /usr/bin/chattr /usr/bin/lvxiaoteng
  ```

### 隐藏 Linux 版本显示信息
- 有些时候我们需要隐藏 Linux 系统的版本信息，操作如下:
  ```bash
  [root@localhost ~]# cat /etc/issue
  CentOS release 6.8 (Final)
  Kernel \r on an \m

  [root@localhost ~]# > /etc/issue   #清除Linux系统版本和内核信息
  [root@localhost ~]# cat /etc/issue
  ```

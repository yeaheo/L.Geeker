# Linux系统一般优化

#### 锁定关键系统文件，防止被提权篡改
`chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab`

#### 解锁命令：
`chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/inittab`
- 上锁后如需修改文件，可以先解锁再修改，修改完成后再加锁

#### 查看被上锁文件的属性：
``` xml
[root@localhost ~]# lsattr /etc/passwd
----i--------e- /etc/passwd
```

- 为了更安全，可以修改相应命令的名称
`mv /usr/bin/chattr /usr/bin/lvxiaoteng`

#### 隐藏Linux版本显示信息
``` xml
[root@localhost ~]# cat /etc/issue
CentOS release 6.8 (Final)
Kernel \r on an \m

[root@localhost ~]# > /etc/issue   #清除Linux系统版本和内核信息
[root@localhost ~]# cat /etc/issue
```

## CentOS 7 安装 RabbitMQ 服务

![RabbitMQ](../images/rabbitmq.jpg "RabbirMQ")

### RabbitMQ 介绍
- **RabbitMQ** 是由 LShift 提供的一个 Advanced Message Queuing Protocol (AMQP) 的开源实现，由以高性能、健壮以及可伸缩性出名的 Erlang 写成，因此也是继承了这些优点。

- 在这里，我们尝试在 CentOS7 系统上安装 RabbitMQ ，安装方式选择 yum 的安装方式。

### 准备工作
- **RabbitMQ** 是用 Erlang 语言编写的，所以我们必须先安装 Erlang 环境才能进行下一步的安装。

- 在 CentOS 7 上安装Erlang和Elixir参见如下链接:
- [Install Erlang and Elixir in CentOS 7](linux-centos-erlang-elixir-installation.md)

### 安装 RabbitMQ
![RabbitMQ](../images/RabbirMQ.png "RabbirMQ")
- 上一步安装好了Erlang后，我们需要去官网下载最新版的RabbitMQ，如下所示：
  
  >注意：有时侯在安装的过程中会报错，这个可能是由于 RabbitMQ 和 Erlang 的版本问题，当我们遇到相关错误的时候，可以尝试更换版本。
  
  ```bash
  cd /opt/soft
  wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.14/rabbitmq-server-3.6.14-1.el7.noarch.rpm
  ```
- 增加相关签名 key:
  
  ```bash
  rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
  ```
- 最后，使用如下命令进行安装:
  
  ```bash
  yum install rabbitmq-server-3.6.14-1.el7.noarch.rpm
  ```
- 安装时输出内容如下:
  
  ```bash
  Loaded plugins: fastestmirror, langpacks
  Examining rabbitmq-server-3.6.14-1.el7.noarch.rpm: rabbitmq-server-3.6.14-1.el7.noarch
  Marking rabbitmq-server-3.6.14-1.el7.noarch.rpm to be installed
  Resolving Dependencies
  --> Running transaction check
  ---> Package rabbitmq-server.noarch 0:3.6.14-1.el7 will be installed
  --> Processing Dependency: socat for package: rabbitmq-server-3.6.14-1.el7.noarch
  Loading mirror speeds from cached hostfile
  * epel: mirrors.tongji.edu.cn
  --> Running transaction check
  ---> Package socat.x86_64 0:1.7.3.2-2.el7 will be installed
  --> Finished Dependency Resolution
  
  Dependencies Resolved
  
  =======================================================================================================================
   Package                  Arch            Version                  Repository                                     Size
  =======================================================================================================================
   Installing:
   rabbitmq-server          noarch          3.6.14-1.el7             /rabbitmq-server-3.6.14-1.el7.noarch          5.6 M
   Installing for dependencies:
   socat                    x86_64          1.7.3.2-2.el7            base                                          290 k
   
   Transaction Summary
   =======================================================================================================================
   Install  1 Package (+1 Dependent package)
   
   Total size: 5.8 M
   Total download size: 290 k
   Installed size: 6.7 M
   Is this ok [y/d/N]: y
   Downloading packages:
   socat-1.7.3.2-2.el7.x86_64.rpm                                                                  | 290 kB  00:00:00     
   Running transaction check
   Running transaction test
   Transaction test succeeded
   Running transaction
     Installing : socat-1.7.3.2-2.el7.x86_64                                                                          1/2 
     Installing : rabbitmq-server-3.6.14-1.el7.noarch                                                                 2/2 
     Verifying  : rabbitmq-server-3.6.14-1.el7.noarch                                                                 1/2 
     Verifying  : socat-1.7.3.2-2.el7.x86_64                                                                          2/2 
   
   Installed:
     rabbitmq-server.noarch 0:3.6.14-1.el7                                                                                
   
   Dependency Installed:
     socat.x86_64 0:1.7.3.2-2.el7                                                                                         
   
   Complete!
   ```
- 如上所示，RabbitMQ 基本安装完成。

- 启动相关服务:
  
  ```bash
  systemctl start rabbitmq-server
  systemctl enable rabbitmq-server
  ```
- 检查 RabbitMQ 服务的状态:
  
  ```bash
  rabbitmqctl status
  ```
- 输出内容如下:
  
  ```bash
  Status of node 'rabbit@lv-test-node'
  [{pid,4257},
   {running_applications,
       [{rabbit,"RabbitMQ","3.6.14"},
        {mnesia,"MNESIA  CXC 138 12","4.15.1"},
        {rabbit_common,
            "Modules shared by rabbitmq-server and rabbitmq-erlang-client",
            "3.6.14"},
        {recon,"Diagnostic tools for production use","2.3.2"},
        {ranch,"Socket acceptor pool for TCP protocols.","1.3.0"},
        {ssl,"Erlang/OTP SSL application","8.2.1"},
        {public_key,"Public key infrastructure","1.5"},
        {asn1,"The Erlang ASN1 compiler version 5.0.3","5.0.3"},
        {os_mon,"CPO  CXC 138 46","2.4.3"},
        {compiler,"ERTS  CXC 138 10","7.1.2"},
        {crypto,"CRYPTO","4.1"},
        {syntax_tools,"Syntax tools","2.1.3"},
        {xmerl,"XML parser","1.3.15"},
        {sasl,"SASL  CXC 138 11","3.1"},
        {stdlib,"ERTS  CXC 138 10","3.4.2"},
        {kernel,"ERTS  CXC 138 10","5.4"}]},
   {os,{unix,linux}},
   {erlang_version,
       "Erlang/OTP 20 [erts-9.1] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:64] [hipe] [kernel-poll:true]\n"},
   {memory,
       [{connection_readers,0},
        {connection_writers,0},
        {connection_channels,0},
        {connection_other,0},
        {queue_procs,2840},
        {queue_slave_procs,0},
        {plugins,0},
        {other_proc,22859320},
        {metrics,184376},
        {mgmt_db,0},
        {mnesia,61680},
        {other_ets,1616648},
        {binary,45952},
        {msg_index,42712},
        {code,21586863},
        {atom,951465},
        {other_system,8267024},
        {allocated_unused,13181632},
        {reserved_unallocated,0},
        {total,61210624}]},
   {alarms,[]},
   {listeners,[{clustering,25672,"::"},{amqp,5672,"::"}]},
   {vm_memory_calculation_strategy,rss},
   {vm_memory_high_watermark,0.4},
   {vm_memory_limit,1590031155},
   {disk_free_limit,50000000},
   {disk_free,36678062080},
   {file_descriptors,
       [{total_limit,924},{total_used,2},{sockets_limit,829},{sockets_used,0}]},
   {processes,[{limit,1048576},{used,153}]},
   {run_queue,0},
   {uptime,23},
   {kernel,{net_ticktime,60}}]
   ```
### 配置RabbitMQ
- RabbitMQ 有一个 web 页面可以辅助我们查看 RabbitMQ 的状态等信息。

- 开启web功能:
  
  ```bash
  rabbitmq-plugins enable rabbitmq_management
  chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
  ```
- 在浏览器访问 web ui：<http://ip-address:15672/>

- 默认登陆账号密码均为 `guest`
  
  > 注意：当我们首次登陆的时候会报错，报错信息如下：
  
  ```bash
  User can only log in via localhost 
  ```
- 在这里 我们需要创建一个新的管理员账号：
  ```bash
  rabbitmqctl add_user mqadmin mqadmin
  rabbitmqctl set_user_tags mqadmin administrator
  rabbitmqctl set_permissions -p / mqadmin ".*" ".*" ".*"
  ```
- 至此，就可以用新建的管理员账号登陆 WEB 页面了。

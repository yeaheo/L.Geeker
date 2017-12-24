# Install RabbitMQ server in CentOS 7

![RabbitMQ](../images/rabbitmq.jpg "RabbirMQ")

### **About RabbitMQ**
- **RabbitMQ** is an open source message broker software, also sometimes known as message-oriented middleware, that implements the Advanced Message Queuing Protocol (AMQP). It is very easy to use, and runs almost on all modern operating systems. It is built on the Open Telecom Platform framework for clustering and failover. RabbitMQ is written in the Erlang programming language, and is actively being developed by Rabbit Technologies Ltd.

- In this tutorial, we will see how to install RabbitMQ server in CentOS 7 minimal server.

### **Prerequisites**
- **RabbitMQ** is written using Erlang programming language. So, it is must to install Erlang before installing RabbitMQ.

- To install and configure Erlang in CentOS 7 server:
- [Install Erlang and Elixir in CentOS 7](https://github.com/yeaheo/youger/blob/master/Linux_Tools/Linux-Install%20Erlang%20and%20Elixir%20in%20CentOS%207.md)

### **Install RabbitMQ**
![RabbitMQ](../images/RabbirMQ.png "RabbirMQ")
- Once you install Erlang, head over to the RabbitMQ download page for RPM based installers, and download the latest version using command:
  ``` bash
  cd /opt/soft
  # wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.14/rabbitmq-server-3.6.14-1.el7.noarch.rpm
  ```
- Then, run the following command as root user to add rabbitmq signing key:
  ``` bash
  # rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
  ```
- Finally, install RabbitMQ server using command:
  ``` bash
  # yum install rabbitmq-server-3.6.14-1.el7.noarch.rpm
  ```
- 安装时输出内容如下:
  ``` bash
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
- That’s it. We have installed RabbitMQ.

- Run the following command to start and enable RabbitMQ service:
  ``` bash
  systemctl start rabbitmq-server
  systemctl enable rabbitmq-server
  ```
- check the status of RabbitMQ server using the following commands:
  ``` bash
  rabbitmqctl status
  ```
- 输出内容如下:
  ``` bash
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
### **Access RabbitMQ management console**
- RabbitMQ management console will allow you to monitor the server processes via a web browser.

- To enable the RabbitMQ management console, run the following command:
  ``` bash
  rabbitmq-plugins enable rabbitmq_management
  chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
  ```
- Now. open your web browser and navigate to the following URL to access your RabbitMQ server management console.
- **http://ip-address:15672/**
- The default user name and password of RabbitMQ Management console is ‘guest’ and ‘guest’ .
- **NOTICE**:When a guest user is logged in, the login fails, so we need to build a new administrator account at this time.

- Run the following command:
  ``` bash
  rabbitmqctl add_user mqadmin mqadmin
  rabbitmqctl set_user_tags mqadmin administrator
  rabbitmqctl set_permissions -p / mqadmin ".*" ".*" ".*"
  ```
- Then,you can enter the username and password to access RabbitMQ web console:

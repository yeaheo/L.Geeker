### Haproxy配置文件模板
``` xml
  global                              
      log 127.0.0.1 local3 info         #在本机记录日志
      maxconn 65535                     #每个进程可用的最大连接数
      chroot /usr/local/haproxy         #haproxy 安装目录
      uid 99                            #运行haproxy的用户uid（cat /etc/passwd 查看，这里是nobody的uid）
      gid 99                            #运行haproxy的用户组id（cat /etc/passwd 查看，这里是nobody组id）
      daemon                            #以后台守护进程运行
 
  defaults
      log global
      mode http                         #运行模式 tcp、 http、 health
      retries 3                         #三次连接失败，则判断服务不可用
      option redispatch                 #如果后端有服务器宕机，强制切换到正常服务器
      stats uri /haproxy                #统计页面 URL 路径
      stats refresh 30s                 #统计页面自动刷新时间
      stats realm haproxy-status        #统计页面输入密码框提示信息
      stats auth admin:dxInCtFianKtL]36   #统计页面用户名和密码
      stats hide-version                 #隐藏统计页面上 HAProxy 版本信息
      maxconn 65535                     #每个进程可用的最大连接数
      timeout connect 5000              #连接超时
      timeout client 50000              #客户端超时
      timeout server 50000              #服务器端超时
 
  frontend http-in                     #自定义描述信息
      mode http                         #运行模式 tcp、 http、 health
      maxconn 65535                     #每个进程可用的最大连接数
      bind :80                          #监听 80 端口
      log global                       
      option httplog                   
      option httpclose                  #每次请求完毕后主动关闭 http 通道
      acl is_a hdr_beg(host) -i www.wangshibo.com        #规则设置，-i 后面是要访问的域名
      acl is_b hdr_beg(host) -i www.guohuihui.com        #如果多个域名，就写多个规则，一规则对应一个域名；即后面有多个域名，就写 is_c、 is-d….，这个名字可以随意起。但要与下面的use_backend 对应
      use_backend web-server if is_a    #如果访问 is_a 设置的域名，就负载均衡到下面backend 设置的对应 web-server 上。web-server所负载的域名要都部署到下面的web01和web02上。如果是不同的域名部署到不同的机器上，就定义不同的web-server。
      use_backend web-server if is_b
 
  backend web-server
      mode http
      balance roundrobin                #设置负载均衡模式，source 保存 session 值，roundrobin 轮询模式
      cookie SERVERID insert indirect nocache
      option httpclose
      option forwardfor
      server web01 182.148.15.233:80 weight 1 cookie 3 check inter 2000 rise 2 fall 5
      server web02 182.148.15.238:80 weight 1 cookie 4 check inter 2000 rise 2 fall 5
 
   注意参数解释：inter 2000 心跳检测时间；rise 2 两次连接成功，表示服务器正常；fall 5 三次连接失败，表示服务器异常； weight 1 权重设置
```


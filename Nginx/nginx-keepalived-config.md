## Nginx+Keepalived实现双主负载均衡的配置
- 实验环境： 
  
  ``` xml
  192.168.8.130  Keepalived+Nginx
  192.168.8.131  Keepalived+Nginx
  ```

- 两台机器上分别安装 Nginx 和 Keepalived

### 安装Nginx请参见: [Nginx安装教程](Nginx-Install.md)
- 具体Nginx编译参数如下：
  - `--with-http_stub_status_module`     ：（enable ngx_http_stub_status_module）支持Nginx状态查询
  - `--with-http_ssl_module`             ：（enable ngx_http_ssl_module）支持https
  - `--with-http_v2_module`              ：（enable ngx_http_v2_module）支持Google的spdy，需要ssl支持
  - `--with-pcre`                        ：（force PCRE library usage）为了支持rewrite重写功能，必须指定pcre
  

### 安装Keepalived
- 在这里为了方便，我们采用yum的方式安装Keepalived
  - `yum -y install keepalived`
- 其实我们也可以源码安装keepalived,其官网地址：<http://www.keepalived.org/software>，具体安装方法参见官网。


### 配置Nginx双负载均衡（利用虚拟主机）
- 编辑8.130主机Nginx配置文件
  - `mkdir /usr/local/nginx/conf.d`
  - `vim /usr/local/nginx/conf/nginx.conf`
  - 具体内容如下：
    ``` xml
    http {
        ......
        include /usr/local/nginx/conf.d/*.conf;
    server {
        listen       80;
        server_name  localhost;

        charset utf-8;
        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass http://loada;
            }
        ......
     }
     server {
        listen       8000;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /nginx_status {
            stub_status on;
            access_log off;
        }
     }
     ```
   - `vim /usr/local/nginx/conf.d/loada.conf`
   - 具体内容如下：
     ``` xml
     upstream loada {
         server 192.168.8.130:8000 weight=1;
         server 192.168.8.131:8000 weight=1;
     }
     ```
   - 8.131主机的Nginx配置和8.130主机的类似。
   
### 配置两台主机的Keepalived，实现高可用
- Keepaliced-A 192.168.8.130/外网IP  VIP：192.168.8.88
- Keepalived-B 192.168.8.131/外网IP  VIP：192.168.8.89

- 编辑192.168.8.130的keepalived配置文件
  - `cp  /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak`
  - `vim /etc/keepalived/keepalived.conf`
    ``` xml
    vrrp_script check_http_port {
        script "</dev/tcp/127.0.0.1/80"
        interval 1
        #weight -2
    }

    vrrp_script check_nginx {
        script "killall -0 nginx"
        interval 1
        #weight -2
    }
    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 50
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
    
    virtual_ipaddress {
        192.168.8.88
    }

    track_script {
        check_nginx
    }
    }
    vrrp_instance VI_2 {
        state BACKUP
        interface eth0
        virtual_router_id 51
        priority 90
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
    virtual_ipaddress {
        192.168.8.89
    }
    track_script {
        check_nginx
    }
    }
    ```
- 编辑192.168.8.130的keepalived配置文件
  - `cp  /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak`
  - `vim /etc/keepalived/keepalived.conf`
    ``` xml
    vrrp_script check_http_port {
    script "</dev/tcp/127.0.0.1/80"
    interval 1
    #weight -2
    }

    vrrp_script check_nginx {
        script "killall -0 nginx"
        interval 1
        #weight -2
    }
    
    vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 50
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.8.88
    }
    track_script {
        check_nginx
    }
    }

    vrrp_instance VI_2 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
           auth_type PASS
           auth_pass 1111
        }
    virtual_ipaddress {
        192.168.8.89
    }
    track_script {
        check_nginx
    }
    }
    ```
- 配置完成，分别启动两台机器的nginx和keepalived服务即可。
- NOTICE:
  - keepalived配置文件中关于脚本的`weight -2`一定要注释掉才能正常切换。

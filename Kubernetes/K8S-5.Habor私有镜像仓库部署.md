## kubernetes集群安装部署——habor私有镜像仓库
- 本部分主要配置私有docke镜像仓库harbor，为的是将自己生成的镜像push到私有镜像仓库中，方便以后拉取。
- Habor软件Github官方网站：<https://github.com/vmware/harbor>
- Harbor安装部署详情可以参考：[habor安装部署](https://github.com/vmware/harbor/blob/master/docs/installation_guide.md)

### 安装Docker和docker-compose
- 在这里安装harbor需要docker版本大于1.10，docker-compose版本需要是1.6以上
- Docker安装请参考：[docker安装](https://docs.docker.com/engine/installation)
- 安装Docker其实也可以参考本笔记：[docker-ce安装](../Docker/docker-install.md)

- docker-compose安装请参考：[docker-compose安装](https://docs.docker.com/compose/install)
- 另一种安装docker-compose的方式是通过pip来安装：
  - `yum -y install epel-release`
  - `yum install python-pip -y`
  - `pip install docker-compose`

### 安装Harbor
- 同样的，harbor的安装方式有两种，一种是在线安装，一种是离线安装，在这里为了快速安装我们选择离线安装，因为在线安装会在线下载所需镜像，速度较慢。
- 下载安装包
  - harbor下载地址：<https://github.com/vmware/harbor/releases>，在这里可以选择自己所需要的安装包进行下载。

- Harbor安装步骤
  - 1、下载软件包
  - 2、配置harbor.cfg文件
  - 3、执行脚本文件install.sh进行安装

- 解压软件包
  - `tar xvf harbor-online-installer-<version>.tgz`
- 修改harbor.cfg文件
  - 在这里，我们只需要修改以下参数：
    ``` cfg
    ......
    hostname = 192.168.8.56
    ......
    harbor_admin_password = admin@123.
    ......
    ```
   - 注意事项：
     - harbor.cfg只需要修改hostname为你自己的机器IP或者域名，harbor默认的db连接密码为root123，可以自己修改，也可以保持默认，harbor初始管理员密码为Harbor12345，可以根据自己需要进行修改，email选项是用来忘记密码重置用的，根据实际情况修改，如果使用163或者qq邮箱等，需要使用授权码进行登录，此时就不能使用密码登录了，会无效的
- 执行脚本文件install.sh
  - `cd /usr/local/harbor`
  - `./install.sh`
  - 等待即可，离线安装速度还是很快的
- 待脚本跑完之后使用docke-compose ps即可查看，常用命令包含以下几个：
  - `docker-compose up -d`  后台启动，如果容器不存在根据镜像自动创建
  - `docker-compose down -v` 停止容器并删除容器
  - `docker-compose start`  启动容器，容器不存在就无法启动，不会自动创建镜像
  - `docker-compose stop`  停止容器
  - 注意：
    - 注：其实上面是停止docker-compose.yml中定义的所有容器，默认情况下docker-compose就是操作同目录下的docker-compose.yml文件，如果使用其他yml文件，可以使用-f自己指定。

- 至此，harbor基本安装完成！

### 访问方式
- 安装完成，可以通过浏览器输入地址http://192.168.8.56 即可访问。登陆账号/密码为：admin/$harbor_admin_password

### 遇到的问题
- docker访问私有镜像仓库默认是通过https方式访问的，当我们用`docker login 192.168.8.56`登陆时会报错，如下：
  ``` bash
  Error response from daemon: Get https://192.168.8.56/v2/: dial tcp 192.168.8.56
  ```
- 解决方案
  - 修改docker配置，添加docker启动相关文件`/etc/docker/daemon.json`
  - `vim /etc/docker/daemon.json`
  - 添加如下内容:
  ``` json
  { "insecure-registries":["192.168.8.56"] }
  ```
  - 重启docker即可
  - `systemctl restart docker.service`
  - 在做测试的时候，重启docker后发现依然报错，提示“拒绝访问”,后来发现80端口不是开启状态，需要重新启动harbor
  - `docker-compose stop`
  - `docker-compose start`
- 至此，所有操作基本完成！

### 验证
- 登陆：
  ``` bash
  [root@test-node2 ~]# docker login 192.168.8.56
  Username (admin): admin
  Password: 
  Login Succeeded
  ```
- push镜像
  ``` bash
  docker tag hello-world:latest 192.168.8.56/library/hello-world:v1
  docker push 192.168.8.56/library/hello-world:v1
  ```
- pull镜像
  ``` bash
  docker pull 192.168.8.56/library/hello-world:v1
  ```
  

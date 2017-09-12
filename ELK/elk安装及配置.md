## ELK安装及配置
## ELK安装及配置
- ELK官方教程: <https://www.elastic.co/guide/index.html>

### 安装顺序
- We recommend that you install the Elastic Stack in the following order.
- Elasticsearch
  - X-Pack for Elasticsearch
- Kibana
  - X-Pack for Kibana
- Logstash
- Beats
- Elasticsearch Hadoop
- This helps to ensure that the right parts of your infrastructure are running before other parts attempt to use them (e.g., Logstash sending data to Elasticsearch).

### 安装JDK(1.8)
- 现在有两种方式安装JDK1.8：
  - 直接yum安装
  - 源码安装
#### 直接yum安装
- `yum -y install java`
#### 源码安装
- `tar xf jdk-8u131-linux-x64.tar.gz -C /usr/local/`
- `cd /usr/local`
- `mv jdk1.8.0_131/ jdk1.8`
- 修改`/etc/profile`文件，配置JAVA环境，添加如下内容：
``` xml
export JAVA_HOME=/usr/local/jdk1.8
export PATH=$PATH:$JAVA_HOME/bin
```
- `source /etc/profile`
- 验证：
``` xml
[root@test-node5 local]# java -version
openjdk version "1.8.0_141"
OpenJDK Runtime Environment (build 1.8.0_141-b16)
OpenJDK 64-Bit Server VM (build 25.141-b16, mixed mode)
```
- 至此，JDK安装完成！

### 安装Elasticsearch
- 为了方便，我们采用rpm的方式安装Elasticsearch

#### Import the Elasticsearch PGP Key
- `rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch`
#### Create the repo file
- Create a file called elasticsearch.repo in the `/etc/yum.repos.d/` directory for RedHat based distributions
- `vim /etc/yum.repos.d/elasticsearch.repo`
- 将以下内容写到此文件中
``` repo
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

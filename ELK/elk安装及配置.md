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
#### Install
  - `yum -y install elasticsearch`
#### start/stop elasticsearch service
  - `systemctl start/stop elasticsearch`
#### 查看elasticsearch版本
  - `/usr/share/elasticsearch/bin/elasticsearch -V`
- You can test that your Elasticsearch node is running by sending an HTTP request to port 9200 on localhost:
- 访问输出内容如下：
``` xml
{
  "name" : "Cp8oag6",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "AT69_T_DTp-1qgIJlatQqA",
  "version" : {
    "number" : "5.6.0",
    "build_hash" : "f27399d",
    "build_date" : "2016-03-30T09:51:41.449Z",
    "build_snapshot" : false,
    "lucene_version" : "6.6.0"
  },
  "tagline" : "You Know, for Search"
}
```
- elasticsearch默认配置文件为`/etc/elasticsearch/elasticsearch.yml`，需要修改配置文件可以修改此参数。

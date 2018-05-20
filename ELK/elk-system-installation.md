## ELK 安装及配置
- ELK 官方教程: <https://www.elastic.co/guide/index.html>

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

### 安装 JDK(1.8)
- 现在有两种方式安装 JDK1.8：
- 直接 yum 安装
- 源码安装

#### 直接 yum 安装
- yum 安装 JDK 比较简单
  
  ```bash
  yum -y install java
  ```

#### 源码安装
- 源码安装 JDK 参考如下：
  
  ```bash
  tar xf jdk-8u131-linux-x64.tar.gz -C /usr/local/
  cd /usr/local
  mv jdk1.8.0_131/ jdk1.8
  ```

- 修改 `/etc/profile` 文件，配置 JAVA 环境，添加如下内容：

  ```bash
  export JAVA_HOME=/usr/local/jdk1.8
  export PATH=$PATH:$JAVA_HOME/bin
  ```
  ```bash
  source /etc/profile
  ```

- 验证：
  ```bash
  [root@test-node5 local]# java -version
  openjdk version "1.8.0_141"
  OpenJDK Runtime Environment (build 1.8.0_141-b16)
  OpenJDK 64-Bit Server VM (build 25.141-b16, mixed mode)
  ```
- 至此，JDK安装完成！

### 安装 Elasticsearch
- 为了方便，我们采用 rpm 的方式安装 Elasticsearch

#### Import the Elasticsearch PGP Key
- 导入 key：
  ```bash
  rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  ```

#### Create the repo file
- Create a file called elasticsearch.repo in the `/etc/yum.repos.d/` directory for RedHat based distributions
  ```bash
  vim /etc/yum.repos.d/elasticsearch.repo
  ```
- 将以下内容写到此文件中
  ```bash
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
- 安装：
  ```bash
  yum -y install elasticsearch
  ```

#### start/stop elasticsearch service
- 启动/停止相关服务：
  ```bash
  systemctl start/stop elasticsearch
  ```

#### 查看 elasticsearch 版本
- 查看 elasticsearch 版本信息：
  
  ```bash
  /usr/share/elasticsearch/bin/elasticsearch -V
  ```

- You can test that your Elasticsearch node is running by sending an HTTP request to port 9200 on localhost:
- 访问输出内容如下：
  ```json
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
- elasticsearch 默认配置文件为 `/etc/elasticsearch/elasticsearch.yml` ，需要修改配置文件可以修改此参数。

### 安装 Kibana
- 为了方便，我们采用 rpm 的方式安装 Kibana

#### Import the Elastic PGP Key
- 导入相关 key:
  ```bash
  rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  ```

#### Create the repo file
- Create a file called kibana.repo in the `/etc/yum.repos.d/` directory for RedHat based distributions
  ```bash
  vim /etc/yum.repos.d/kibana.repo
  ```
- 将以下内容写到此文件中
  ```bash
  [kibana-5.x]
  name=Kibana repository for 5.x packages
  baseurl=https://artifacts.elastic.co/packages/5.x/yum
  gpgcheck=1
  gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
  enabled=1
  autorefresh=1
  type=rpm-md
  ```
- 其实，上述步骤和安装 elasticsearch 步骤一致，可以忽略！

#### Install
- 安装：
  ```bash
  yum -y install kibana
  ```

#### start/stop kibana service
- 启动/停止相关服务：
  ```bash
  systemctl start/stop kibana
  ```

#### 查看 kibana 版本
- 查看 kibana 版本信息：
  ```bash
  /usr/share/kibana/bin/kibana -V
  ```
- Kibana loads its configuration from the /etc/kibana/kibana.yml file by default，需要修改配置文件可以修改此参数。
- The Kibana server reads properties from the kibana.yml file on startup. The default settings configure Kibana to run on localhost:5601. To change the host or port number, or connect to Elasticsearch running on a different machine, you’ll need to update your kibana.yml file. 

### 安装 Logstash
- 为了方便，我们采用 rpm 的方式安装 Kibana

#### Import the Elastic PGP Key
- 导入相关 key:
  ```bash
  rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  ```

#### Create the repo file
- Create a file called logstash.repo in the `/etc/yum.repos.d/` directory for RedHat based distributions
  ```bash
  vim /etc/yum.repos.d/logstash.repo
  ```
- 将以下内容写到此文件中
  ```bash
  [logstash-5.x]
  name=Elastic repository for 5.x packages
  baseurl=https://artifacts.elastic.co/packages/5.x/yum
  gpgcheck=1
  gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
  enabled=1
  autorefresh=1
  type=rpm-md
  ```
- 其实，上述步骤和安装 elasticsearch 步骤一致，可以忽略！

#### Install
- 安装：
  ```bash
  yum install logstash
  ```

#### start/stop logstash service
- 启动/停止相关服务：
  ```bash
  systemctl start/stop logstash
  ```

#### 查看 Logstash 版本
- 查看 Logstash 版本相关版本：
  ```bash
  /usr/share/logstash/bin/logstash -V
  ```
- You can set options in the Logstash settings file, logstash.yml, to control Logstash execution. 
- 至此，ELK 三大组件基本安装完毕，接下来就是配置服务了！

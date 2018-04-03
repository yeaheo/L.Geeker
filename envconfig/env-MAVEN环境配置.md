## MAVEN环境配置
- maven 官方网站： <https://maven.apache.org/>
- maven 下载地址： <https://maven.apache.org/download.cgi>
- maven 官方安装教程： <https://maven.apache.org/install.html>

### 下载并配置 maven 软件包
- 我们把 maven 软件包解压到 `/usr/local` 目录下：

  ``` bash
  # wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz
  # tar zxvf apache-maven-3.5.3-bin.tar.gz -C /usr/local
  ```
### 配置相关环境变量
-
  ``` bash
  # vim /etc/profile
  
  添加如下内容：
  
  export MAVEN_HOME=/usr/local/apache-maven-3.5.3
  export PATH=$PATH:$MAVEN_HOME/bin
  ```
- 使设置的环境变量生效：
  ``` bash
  # source /etc/profile
  ```
### 验证
- 
  ``` bash
  [root@CTSIG-ST ~]# mvn -version
  Apache Maven 3.5.3 (3383c37e1f9e9b3bc3df5050c29c8aff9f295297; 2018-02-25T03:49:05+08:00)
  Maven home: /usr/local/maven
  Java version: 1.8.0_131, vendor: Oracle Corporation
  Java home: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-11.b12.el7.x86_64/jre
  Default locale: en_US, platform encoding: UTF-8
  OS name: "linux", version: "3.10.0-693.el7.x86_64", arch: "amd64", family: "unix"
  ```


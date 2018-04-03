## JAVA(JDK)环境配置
- 在 Linux 系统中配置 java 环境还运行 java 程序，一般配置 java 环境有两种方式：一种是使用 yum 包管理工具安装，另一种方式是采用二进制的方式安装。

#### yum 配置 java 环境
- 首先，我们需要查看 yum 仓库的可用版本：
  ``` bash
  [root@ns1 ~]# yum search java | grep jdk
  ldapjdk-javadoc.noarch : Javadoc for ldapjdk
  java-1.6.0-openjdk.x86_64 : OpenJDK Runtime Environment
  java-1.6.0-openjdk-demo.x86_64 : OpenJDK Demos
  java-1.6.0-openjdk-devel.x86_64 : OpenJDK Development Environment
  java-1.6.0-openjdk-javadoc.x86_64 : OpenJDK API Documentation
  java-1.6.0-openjdk-src.x86_64 : OpenJDK Source Bundle
  java-1.7.0-openjdk.x86_64 : OpenJDK Runtime Environment
  java-1.7.0-openjdk-accessibility.x86_64 : OpenJDK accessibility connector
  java-1.7.0-openjdk-demo.x86_64 : OpenJDK Demos
  java-1.7.0-openjdk-devel.x86_64 : OpenJDK Development Environment
  java-1.7.0-openjdk-headless.x86_64 : The OpenJDK runtime environment without
  java-1.7.0-openjdk-javadoc.noarch : OpenJDK API Documentation
  java-1.7.0-openjdk-src.x86_64 : OpenJDK Source Bundle
  java-1.8.0-openjdk.i686 : OpenJDK Runtime Environment
  java-1.8.0-openjdk.x86_64 : OpenJDK Runtime Environment
  java-1.8.0-openjdk-accessibility.i686 : OpenJDK accessibility connector
  java-1.8.0-openjdk-accessibility.x86_64 : OpenJDK accessibility connector
  java-1.8.0-openjdk-accessibility-debug.i686 : OpenJDK accessibility connector
  java-1.8.0-openjdk-accessibility-debug.x86_64 : OpenJDK accessibility connector
  java-1.8.0-openjdk-debug.i686 : OpenJDK Runtime Environment with full debug on
  java-1.8.0-openjdk-debug.x86_64 : OpenJDK Runtime Environment with full debug on
  java-1.8.0-openjdk-demo.i686 : OpenJDK Demos
  java-1.8.0-openjdk-demo.x86_64 : OpenJDK Demos
  java-1.8.0-openjdk-demo-debug.i686 : OpenJDK Demos with full debug on
  java-1.8.0-openjdk-demo-debug.x86_64 : OpenJDK Demos with full debug on
  java-1.8.0-openjdk-devel.i686 : OpenJDK Development Environment
  java-1.8.0-openjdk-devel.x86_64 : OpenJDK Development Environment
  java-1.8.0-openjdk-devel-debug.i686 : OpenJDK Development Environment with full
  java-1.8.0-openjdk-devel-debug.x86_64 : OpenJDK Development Environment with
  java-1.8.0-openjdk-headless.i686 : OpenJDK Runtime Environment
  java-1.8.0-openjdk-headless.x86_64 : OpenJDK Runtime Environment
  java-1.8.0-openjdk-headless-debug.i686 : OpenJDK Runtime Environment with full
  java-1.8.0-openjdk-headless-debug.x86_64 : OpenJDK Runtime Environment with full
  java-1.8.0-openjdk-javadoc.noarch : OpenJDK API Documentation
  java-1.8.0-openjdk-javadoc-debug.noarch : OpenJDK API Documentation for packages
  java-1.8.0-openjdk-javadoc-zip.noarch : OpenJDK API Documentation compressed in
  java-1.8.0-openjdk-javadoc-zip-debug.noarch : OpenJDK API Documentation
  java-1.8.0-openjdk-src.i686 : OpenJDK Source Bundle
  java-1.8.0-openjdk-src.x86_64 : OpenJDK Source Bundle
  ```
- 从上述结果看，我们可以用 yum 安装的 jdk 版本有：1.6、1.7、1.8版本，选择我们需要安装的版本即可。
- 例如，安装1.8版本：

  ``` bash
  # yum install java-1.8.0-openjdk.x86_64
  ```
- yum 安装的 jdk 默认在`/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.x86_64`目录下。

#### 二进制方式配置 java 环境
- 官方 jdk 下载地址：<http://www.oracle.com/technetwork/java/javase/downloads/index.html>，选择需要安装 jdk 版本下载即可。
- 例如，我们需要安装最新版本的 jdk：
  ``` bash
  # tar zvxf jdk-8u161-linux-x64.tar.gz -C /usr/local
  ```
- 配置 JAVA_HOME 环境变量：
  ``` bash
  # vim /etc/profile
  在开头添加如下内容：
  export JAVA_HOME=/usr/local/jdk1.8.0_161  #jdk1.8.0_161文件夹为解压得到的文件
  export PATH=$PATH:$JAVA_HOME/bin
  ```
- 使配置的环境变量生效：
  ``` bash
  # source /etc/profile
  ```
- 验证：
  ``` bash
  [root@ns1 local]# java -version
  java version "1.8.0_144"
  Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
  Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)
  上述版本是我已经安装的版本，这里只是举例而已，还需根据自己的版本来验证
  ```
  
  


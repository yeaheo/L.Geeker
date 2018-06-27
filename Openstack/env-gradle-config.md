## Linux 安装 Gradle 环境

- Gradle 是一个基于 Apache Ant 和 Apache Maven 概念的项目自动化建构工具。它使用一种基于 Groovy 的特定领域语言来声明项目设置，而不是传统的 XML。
- Gradle 官网地址： <https://gradle.org/>
- Gradle 官网下载地址： <https://gradle.org/releases/>
- Gradle 各版本下载地址（较全）： <http://services.gradle.org/distributions/>

### 下载 Gradle 软件包

- 首先需要下载需要的软件包:

  ```bash
  cd /opt/soft
  wget https://downloads.gradle.org/distributions/gradle-4.7-bin.zip
  ```

### 解压 Gradle 软件包

- 我们将 `/opt/` 目录作为 Gradle 的安装目录：

  ```bash
  cd /opt/soft
  unzip -d /opt/ gradle-4.7-bin.zip
  ```

### 配置环境变量

- 编辑 `/etc/profile` 文件，增加如下内容：

  ```bash
  export GRADLE_HOME=/opt/gradle-4.7
  export PATH=$PATH:$GRADLE_HOME/bin
  ```

- 使其生效：

  ```bash
  source /etc/profile
  ```

### 验证

- 安装完成后需要验证是否可用：

  ```bash
  [root@test-node-3 gradle-4.7]# gradle -v

  Welcome to Gradle 4.7!
  
  Here are the highlights of this release:
   - Incremental annotation processing
   - JDK 10 support
   - Grouped non-interactive console logs
   - Failed tests are re-run first for quicker feedback
  
  For more details see https://docs.gradle.org/4.7/release-notes.html
  
  
  ------------------------------------------------------------
  Gradle 4.7
  ------------------------------------------------------------
  
  Build time:   2018-04-18 09:09:12 UTC
  Revision:     b9a962bf70638332300e7f810689cb2febbd4a6c
  
  Groovy:       2.4.12
  Ant:          Apache Ant(TM) version 1.9.9 compiled on February 2 2017
  JVM:          1.8.0_171 (Oracle Corporation 25.171-b11)
  OS:           Linux 3.10.0-862.3.2.el7.x86_64 amd64
  ```

- Gradle 安装完成。

  > 如果后期需要升级 Gradle 版本，只需要将 `/etc/profile` 中的环境变量指向新版 Gradle 所在目录即可。





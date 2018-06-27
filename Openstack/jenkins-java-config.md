## Jenkins 针对 JAVA 项目的配置

- Jenkins 自动构建 JAVA 项目需要提前准备好 JAVA 相关环境，例如： JDK、 Maven、 Git、Docker 等，具体安装过程如下：
- JDK 安装配置参见： [ JDK 安装配置 ](env-java-jdk-config.md)，也可以用 rpm 包管理工具安装；
- Maven 安装配置参见： [ Maven 安装配置 ](env-maven-config.md)
- Git 安装配置参见： [ Git 安装配置 ](env-git-installation.md)，也可以用 rpm 包管理工具安装；
- Docker 安装配置参见： [Docker 安装配置](docker-installation.md)

  > 上述基本工具建议用二进制的方式安装，这样在 Jenkins 中方便指定相应路径。


### Jenkins 安装相应插件
- Jenkins 构建 JAVA 项目需要安装相关插件，具体插件如下：

  ```bash
  Gitlab Plugin
  #安装之后才可以在系统配置中指定gitlab的IP地址
  
  Git Plugin 
  Git Client Plugin 
  #用于jenkins在gitlab中拉取源码
  
  Publish Over SSH 
  #用于通过ssh部署应用
  
  Maven Integration plugin
  #用于新建maven项目
  ```

- 插件安装流程： "系统管理" -- "管理插件" -- "可用插件"，搜索上述插件即可，选择 "直接安装" 即可。


### Jenkins 指定相关工具路径

- **Jenkins 指定 JDK 路径：**

- 打开并登录 Jenkins 系统管理界面： "系统管理" -- "全局工具配置" -- "JDK 安装"
- 具体信息如下图所示：
![jenkins-jdk](images/jenkins-jdk.png "jenkins-jdk")


- **Jenkins 指定 Maven 路径:**

- 打开并登录 Jenkins 系统管理界面： "系统管理" -- "全局工具配置" -- "Maven 安装"
- 具体信息如下图所示：
![jenkins-maven](images/jenkins-maven.png "jenkins-maven")


- **Jenkins 指定 Git 路径：**
- 打开并登录 Jenkins 系统管理界面： "系统管理" -- "全局工具配置" -- "Git"
- 具体信息如下图所示：
![jenkins-git](images/jenkins-git.png "jenkins-git")

- **Jenkins 指定 Docker 路径：**
- 打开并登录 Jenkins 系统管理界面： "系统管理" -- "全局工具配置" -- "Docker 安装"
- 具体信息如下图所示：
![jenkins-docker](images/jenkins-docker-b.png "jenkins-docker")


### Jenkins 配置 Gitlab 地址
- 因为我们用 Gitlab 管理项目代码，所以我们需要统一配置 Gitlab 地址： "系统管理" -- "系统设置" -- "Gitlab"
- 具体信息如下图所示：
![jenkins-gitlab](images/jenkins-gitlab.png "jenkins-gitlab")

  > 配置 Gitlab 的地址，红字表示需要 Gitlab 的账号密码，但是这个可以在新建项目的时候指定。


### Jenkins 配置远程服务器 SSH 连接信息
- 因为我们之前已经安装了 `Publish Over SSH` 插件，所以可以直接配置远程服务器的 SSH 连接信息，具体流程如下：
- "系统管理" -- "系统设置" -- "Publish over SSH" ，具体所填信息如下：
![jenkins-ssh-server](images/jenkins-ssh-server.png "jenkins-ssh-server")

- 其中，"Passphrase" 输入的是远端服务器 SSH 账号密码，"SSH Servers" 可以定义多个，"Remote Directory" 可以指定远程服务器目录，配置完成后 Jenkins 自动构建的 war/jar 包就会传送到这个目录，但是需要我们将此目录相关权限赋予指定用户，上图为 "citest" 用户。

- Publish_over_SSH 插件，可以使用 Path to key 指定 jenkins 主机的私钥路径，也可以如上。 
  
  > 注意：部署应用的主机需要 jenkins 主机的公钥，可以 ssh-copy-id 命令复制过去。

- 针对 JAVA 项目的 Jenkins 配置基本完成，剩下的工作就是新建 JOB 进行自动化构建了。





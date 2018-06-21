## CI(持续集成)工具安装配置

- 我们部署持续集成系统用到的软件工具包括：
- 代码仓库： Gitlab、SVN ；
- 构建工具： Jenkins ；
- 依赖工具： Git、SVN、JDK、Maven、Android-SDK、Gradle、NodeJS、Docker 等；

### JDK 安装配置

- 因为 Jenkins 使用的是纯 JAVA 语言进行开发设计的，所以需要安装 JDK 环境。
- JDK 环境的安装配置参见 [ JDK 安装教程 ](../envconfig/env-java-jdk-config.md)

### Jenkins 安装配置

- 我们自动化构建工具用到的是开源的 Jenkins，所以需要安装 Jenkins 来实现持续集成。
- Jenkins 安装配置参见 [ Jenkins 安装教程 ](https://jenkins.io/doc/book/installing/)

  > CentOS 或者 RedHat 可以参考 <https://pkg.jenkins.io/redhat-stable/>

### Maven 安装配置

- 因为我们大多数的项目都是通过 JAVA 语言编写的，而且项目编译目前大多数用的都是 maven ，所以我们需要安装 maven 环境。
- maven 环境的安装配置参见 [ Maven 安装教程 ](../envconfig/env-maven-config.md)

### Git 安装配置

- 目前我们代码仓库用的是 Gitlab 社区版，所以依赖 git 工具做代码上传等工作。
- Git 安装配置参见 [ Git 安装教程 ](../envconfig/env-git-installation.md)

### Docker 安装配置

- 对于一些微服务项目，需要借助 docker 来运行镜像，所以我们需要安装 docker。
- Docker 安装配置参见 [ Docker 安装配置 ](https://github.com/yeaheo/docker-base/blob/master/docker-installation.md)

### NodeJS 安装配置

- 对于前端项目，我们需要配置 NodeJS 进行编译打包，所以我们需要安装 NodeJS 环境。
- NodeJS 安装配置参见 [ NodeJS 安装配置 ](../envconfig/env-nodejs-config.md)

### Android-SDK 及 Gradle 安装配置

- 对于安卓项目，需要用到 Gradle 工具并借助 android-sdk 编译打包，我们需要安装这两个工具。
- Android-SDK 安装配置参见 [ Linux Android-SDK 安装配置 ](../envconfig/env-android-sdk-config.md)
- Gradle 安装配置参见 [ ]


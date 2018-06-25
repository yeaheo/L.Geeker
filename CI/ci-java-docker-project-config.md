## Jenkins 持续集成 JAVA 项目 - Docker

- 本部分基本流程如下：

  ```bash
  1、 开发人员提交代码到 gitlab 上；
  2、 手动或自动触发 Jenkins 自动构建打 jar 包后并将自动构建的 jar 包打包成 docker 镜像，然后将打包好的 docker 镜像 push 到私有镜像仓库下；
  3、 Jenkins 自动构建完成后，配合 Kubernetes 执行指定命令或脚本，用容器启动对应的镜像来启动对应服务。
  ```

### 配置 Jenkins 相关工具

- 安装完 Jenkins 后，针对 JAVA 项目我们需要配置 Jenkins，具体配置参数参见：[Jenkins-java-config](../Jenkins/jenkins-java-config.md)

### Jenkins 新建 JAVA 项目
-
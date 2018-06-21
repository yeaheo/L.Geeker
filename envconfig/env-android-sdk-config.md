## Linux 安装配置 Android SDK

- Android SDK 是一种安卓程序开发工具，在 CentOS 7 上安装配置具体步骤如下。
- 安装 Android SDK 前需要先安装 JAVA 环境，具体安装过程可以参考 [ JDK 安装配置 ](env-java-jdk-config.md)

### 下载 sdk 软件包

- sdk 官方网站下载地址： <http://developer.android.com/sdk/index.html>  (由于网络的原因可能在国内无法下载)。
- sdk 国内下载地址可以参考： <http://www.androiddevtools.cn/> 或 <http://tools.android-studio.org/index.php/sdk/>
- 这里我们下载的版本是 `android-sdk_r24.4.1-linux.tgz`

  ```bash
  mkdir /opt/soft
  cd /opt/soft
  wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
  ```

### 解压 sdk 软件包

- 我们将 sdk 软件包解压到 `/opt` 目录下：

  ```bash
  cd /opt/soft
  tar xf android-sdk_r24.4.1-linux.tgz -C /opt/
  cd /opt/
  mv android-sdk-linux android-sdk
  ```
  
  > 尽量不要将 Android-sdk 放在 `/` 目录下，例如： `/usr/local` 目录，因为这样我们在日后用 Jenkins 构建 Android 项目的时候会失败。

### 设置环境变量

- 编辑 `/etc/profile` 文件，增加如下内容：

  ```bash
  export ANDROID_HOME=/opt/android-sdk
  export PATH=$PATH:$ANDROID_HOME/tools
  ```

- 使其生效：

  ```bash
  source /etc/profile
  ```  

### 安装 SDK 工具

- 查看可用的组件：

  ```bash
  android list sdk --all
  ```

- 如果想看到更详细的信息：

  ```bash
  android list sdk -u -e
  ```

- 如果想安装全部 SDK 包：

  ```bash
  android update sdk -u
  ```

- 如果想安装其中前三个包：

  ```bash
  android update sdk -u -t 1,2,3
  ```

- 如果只想看看命令的安装范围，不真正执行安装操作：

  ```bash
  android update sdk -u -t 1,2,3 -n
  ```

- 我们这里安装所有包。
  
  > 安装过程中有两个提示是否接受条款，输入 `y` 即可。
  > 下载需要的组件, 注意--all 这个参数一定要加上, 否则后面filter里的序号不起作用, 例如我用的是: `android update sdk -u --all --filter 1,2,3,5,11,12,22,23,24,25,26,27,28,29,88,89`



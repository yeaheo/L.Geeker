## Linux 安装配置 Android SDK
- Android SDK 是一种安卓程序开发工具，在 CentOS 7 上安装配置具体步骤如下。

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

### 安装 SDK 工具


## 使用gem安装redis时ruby版本问题
- 在使用 `gem` 安装redis时报错信息如下：

  ```bash
  # gem install redis
    ERROR:  Error installing redis:
            redis requires Ruby version >= 2.2.2.
  ```
- CentOS 7系统中 yum 仓库中 ruby 版本支持到 2.0.0，默认使用 yum 安装的 ruby 版本为 2.0 版本，但是如果使用 gem 安装 redis ruby版本至少是 2.2.2，
还有就是我们自己编译安装的高版本 ruby 在执行上述命令时也会报相同的错误。

### 解决过程
- 我们使用 **rvm** 来更新 ruby 版本。

#### 安装rvm
- 安装 rvm 时，可以参考如下命令：
  
  ```bash
  gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
  curl -L get.rvm.io | bash -s stable
  ```
- 查看 rvm 相关安装路径：
  
  ```bash
  find / -name rvm
  /usr/local/rvm
  /usr/local/rvm/src/rvm
  /usr/local/rvm/src/rvm/bin/rvm
  /usr/local/rvm/src/rvm/lib/rvm
  /usr/local/rvm/src/rvm/scripts/rvm
  /usr/local/rvm/bin/rvm
  /usr/local/rvm/rubies/ruby-2.3.3/lib/ruby/gems/2.3.0/gems/rvm-1.11.3.9/lib/rvm   # 出现这个是因为我已经安装好了ruby
  /usr/local/rvm/lib/rvm
  /usr/local/rvm/scripts/rvm
  ```
- 刷新 rvm 相关执行文件
  
  ```bash
  source /usr/local/rvm/scripts/rvm
  ```

#### 查看 rvm 库中已知的 ruby 版本
- 查看 rvm 库中已知的 ruby 版本命令如下：

  ```bash
  rvm list known | grep ruby
  
  [ruby-]1.8.6[-p420]
  [ruby-]1.8.7[-head] # security released on head
  [ruby-]1.9.1[-p431]
  [ruby-]1.9.2[-p330]
  [ruby-]1.9.3[-p551]
  [ruby-]2.0.0[-p648]
  [ruby-]2.1[.10]
  [ruby-]2.2[.7]
  [ruby-]2.3[.4]
  [ruby-]2.4[.1]
  ruby-head
  ```
#### 安装指定版本的 ruby 文件
- 安装 ruby：
  
  ```bash
  rvm install 2.3.3
  ```

#### 将安装的 ruby 版本设置为默认版本
- 安装完 ruby 后需要配置，参考如下：

  ```bash
  # rvm use 2.3.3 --default
  Using /usr/local/rvm/gems/ruby-2.3.3
  ```
#### 卸载旧版本的 ruby
- 卸载旧版本的 ruby：

  ```bash
  rvm remove 2.0.0
  ```
#### 检测安装的 ruby 版本
- 查看 ruby 版本：

  ```bash
  # ruby --version
  ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-linux]
  ```
#### 安装 redis
- 安装 redis：

  ```bash
  # gem install redis
  Successfully installed redis-4.0.1
  Parsing documentation for redis-4.0.1
  Done installing documentation for redis after 0 seconds
  1 gem installed
  ```
  






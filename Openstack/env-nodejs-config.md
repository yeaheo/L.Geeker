## NodeJS 环境配置
- 前端项目一般都是通过 NodeJS 工具编译打包的，所以 NodeJS 环境还是很有必要的。


### 下载 NodeJS 安装包
- nodejs 中文下载地址： <http://nodejs.cn/download/> ，可以根据实际情况下载所需平台的版本。这里我们需要在 Linux 安装相应环境，所以下载 Linux 版的安装包。
  
  ```bash
  mkdir /opt/soft
  cd /opt/soft        # 软件安装包统一放在 /opt/soft 目录下
  wget http://cdn.npm.taobao.org/dist/node/v10.4.1/node-v10.4.1-linux-x64.tar.xz
  ```

### 解压 NodeJS 安装包并配置 NodeJS
- 下载完成后，需要解压安装包到指定目录，这里我们将 nodejs 的安装包解压到 `/usr/local` 目录下：
  
  ```bash
  tar xf node-v10.4.1-linux-x64.tar.xz -C /usr/local/
  cd /usr/local
  mv node-v10.4.1-linux-x64 node-v10.4.1
  ```

- 解压完成后还需要配置软连接：

  ```bash
  ln -s /usr/local/node-v10.4.1/bin/* /usr/bin/       # 这里我们软连接到了 /usr/bin/ 目录下
  ```

- 安装 cnpm：

  ```bash
  # 安装 cnpm
  npm install -g cnpm --registry=https://registry.npm.taobao.org
  
  # 配置软连接
  ln -s  /usr/local/node-v10.4.1/bin/cnpm /usr/bin/
  ```

### 验证安装
- 安装完成后，需要验证一下，看看是否可用：

  ```bash
  [root@ns1 ~]# node -v
  v10.4.1
  [root@ns1 ~]# npm -v
  6.1.0
  [root@ns1 ~]# npx -v
  6.1.0
  [root@ns1 ~]# cnpm -v
  cnpm@6.0.0 (/usr/local/node-v10.4.1/lib/node_modules/cnpm/lib/parse_argv.js)
  npm@6.1.0 (/usr/local/node-v10.4.1/lib/node_modules/cnpm/node_modules/npm/lib/npm.js)
  node@10.4.1 (/usr/local/node-v10.4.1/bin/node)
  npminstall@3.7.0 (/usr/local/node-v10.4.1/lib/node_modules/cnpm/node_modules/npminstall/lib/index.js)
  prefix=/usr/local/node-v10.4.1 
  linux x64 3.10.0-693.11.1.el7.x86_64 
  registry=https://registry.npm.taobao.org
  ```

### 配置淘宝镜像
- 由于网络问题，我们在国内用 npm 安装工具的时候总是特别慢，所以我们需要配置一下代理镜像，这里有三种方式可以配置，具体说明如下：

- **通过 config 命令**

  ```bash
  npm config set registry https://registry.npm.taobao.org 
  npm info underscore （如果上面配置正确这个命令会有字符串response）
  ```

- **命令行指定**

  ```bash
  npm --registry https://registry.npm.taobao.org info underscore
  ```

- **编辑 `~/.npmrc` 加入下面内容**

  ```bash
  registry = https://registry.npm.taobao.org
  ```

  > 搜索镜像: <https://npm.taobao.org>

  > 建立或使用镜像参考: <https://github.com/cnpm/cnpmjs.org>



## 利用 fail2ban 配置防暴力破解
- fail2ban 是一款实用软件，可以监视你的系统日志，然后匹配日志的错误信息（正则式匹配）执行相应的屏蔽动作。

- **Fail2ban 功能特性**：
- 支持大量服务。如 sshd, apache, qmail, proftpd, sasl等等;
- 支持多种动作。如 iptables, tcp-wrapper, shorewall(iptables第三方工具), mail  notifications(邮件通知)等等;
- 在 logpath 选项中支持通配符;
- 需要 Gamin 支持(注：Gamin是用于监视文件和目录是否更改的服务工具);
- 需要安装 python, iptables, tcp-wrapper, shorewall, Gamin。如果想要发邮件，那必需安装 postfix 或 sendmail;


- Fail2ban 官网地址：<http://www.fail2ban.org>
- Fail2ban 下载地址：<http://www.fail2ban.org/wiki/index.php/Downloads>

### 安装部署
- 本次安装基于CentOS7系统，具体版本信息如下：
  
  ```bash
  # cat /etc/redhat-release 
  CentOS Linux release 7.4.1708 (Core) 
  # uname -r
  3.10.0-693.2.2.el7.x86_64
  # python -V
  Python 2.7.5
  ```
- 安装方式
- Fail2ban 可以源码安装也可以直接用rpm管理工具yum进行安装
- 源码安装：
  ```bash
  wget https://codeload.github.com/fail2ban/fail2ban/tar.gz/0.9.4
  tar zxvf fail2ban-0.9.4.tar.gz
  cd fail2ban-0.9.4
  python setup.py install
  ```
- yum 安装
  ```bash
  yum -y install epel-release
  yum -y install fail2ban
  ```

### 添加配置相关文件
- **Configure Local Settings**
- Fail2ban 服务将其配置文件保存在 `/etc/fail2ban` 目录中。在那里，你可以找到一个名为默认值的文件`jail.conf`。
  由于该文件可能会被软件包升级覆盖，所以我们不应该在原地进行编辑。在这里，我们会增加一个名为jail.local的新文件。在其中配置的参数会覆盖默认配置文件jail.conf
  中的参数。
- `jail.conf`文件默认会有一个[DEFAULT]配置，其他的都是具体的服务配置。而`jail.local`会覆盖其中的参数，此外，/etc/fail2ban/jail.d/可以使用文件来覆盖这两个文件中的设置。
- 文件按以下顺序应用：
- `/etc/fail2ban/jail.conf`
- `/etc/fail2ban/jail.d/*.conf`,按字母顺序
- `/etc/fail2ban/jail.local`
- `/etc/fail2ban/jail.d/*.local`,按字母顺序

- 创建jail.local文件，增加如下内容：
  ```bash
  vim /etc/fail2ban/jail.local/
  ```
  
  ```bash
  [DEFAULT]
  # Ban hosts for one hour:
  bantime = 3600   #禁止用户IP访问主机1小时
  findtime = 300   #在5分钟内出现规定次数就开始工作，默认单位是秒
  maxretry = 3     #3次密码验证失败
  # Override /etc/fail2ban/jail.d/00-firewalld.conf:
  banaction = iptables-multiport
  
  [sshd]
  enabled = true   #启用此服务功能
  filter = sshd    
  logpath  = /var/log/secure  #需要监控的日志文件
  ```
- 之后重启 fail2ban 服务即可实现 fail2ban 防暴力破解！
  

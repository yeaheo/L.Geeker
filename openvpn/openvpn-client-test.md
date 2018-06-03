## OpenVPN 客户端连接测试

- 先前我们已经安装了 OpenVPN 服务器端，具体过程参见 [OpenVPN 安装](./openvpn-installation.md)，安装完成后需要用客户端测试一下，我们先前安装的 vpn 是否可用。

- OpenVPN windows 版的客户端下载地址：[win-openvpn-client](https://swupdate.openvpn.org/community/releases/openvpn-install-2.4.4-I601.exe)，安装的时候全部选默认配置即可，安装位置可以自定义，不再赘述。

- 客户端安装完成后，将以下证书和秘钥文件拷贝到安装目录中的 `config` 目录下：

  ```bash
  ca.crt
  client.crt
  client.key
  ta.key
  ```

### 准备客户端配置文件
- 客户端安装后，需要在安装目录下的 `config` 目录下创建客户端的配置文件 `client.ovpn` 具体内容如下：

  ```bash
  client
  dev tun
  proto tcp
  remote xxx.xxx.xxx.xxx 1194
  resolv-retry infinite
  nobind
  persist-key
  persist-tun
  
  ca ca.crt
  cert client.crt
  key client.key
  remote-cert-tls server
  tls-auth ta.key 1
  cipher AES-256-CBC

  comp-lzo
  verb 3
  ```

  > 其中 xxx.xxx.xxx.xxx 1194是外网 IP 和端口映射到了内网服务器的 <OpenVPN-Server-IP> 1194上。


- 配置文件安装完成后，打开 OpenVPN GUI 测试即可。
- 本次我们用的是客户端证书认证，我们也可以用 **账号/密码** 的方式进行登陆验证，最好的方案是和公司内部的 LDAP 统一认证打通，OpenVPN 集成 LDAP 配置参见 [OpenVPN 集成 LDAP 认证](./openvpn-ldap-config.md)



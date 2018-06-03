## OpenVPN 集成 LDAP 统一认证

- 前面已经成功部署了 OpenVPN 的服务端。安装过程参见 [OpenVPN 安装](./openvpn-installation.md) ，客户端和服务端采用的是基于 TLS 的双向认证，需要给每个客户端生成客户端私钥和证书。
- 本文档我们在 OpenVPN 服务端集成的 LDAP 认证，这样能够使客户端用户在连接 VPN 时直接使用统一的 LDAP 账号。因为公司本身有基于 OpenDS 的 LDAP 认证，为了方便，本次采用公司现有 LDAP。 其实也可以用 OpenLDAP 做统一认证，OpenLDAP 安装可以参考 [OpenLDAP 安装](https://blog.frognew.com/2017/05/openldap-install-notes.html)。

### 安装 openvpn-auth-ldap 插件
- 为了方便，直接 yum 安装，参考如下：

  ```bash
  yum -y install epel-releas && yum -y install openvpn-auth-ldap
  ```

- 安装完成后，在目录 `/usr/lib64/openvpn/plugin/lib/` 会出现 `openvpn-auth-ldap.so` 文件。在目录 `/etc/openvpn` 目录下自动生成 `auth` 目录，该目录里面存在 `ldap.conf` ，用于配置 LDAP 相关信息。

### 配置 LDAP 相关信息
- 编辑 `/etc/openvpn/auth/ldap.conf` 文件：

  ```bash
  <LDAP>
        URL             ldap://xx.xx.xx.xx:389
        BindDN          cn=Manager,dc=ctsig,dc=com
        Password        xxxx
        Timeout         15
        TLSEnable       no
        FollowReferrals no
  </LDAP>
  
  <Authorization>
        BaseDN          "ou=People,dc=ctsig,dc=com"

        SearchFilter    "uid=%u"

        RequireGroup    false

        <Group>
                BaseDN           "ou=Group,dc=frognew,dc=com"
                SearchFilter     "cn=vpn"
                MemberAttribute  memberUid
        </Group>
  </Authorization>
  ```

  
  > LDAP 的配置文件必须按照现有 LDAP 配置信息进行配置，否则会验证失败，因为涉及公司隐私，上述内容只是 demo。


- 编辑 openvpn 的配置文件 `/etc/openvpn/server.conf` ，增加如下内容：

  ```bash
  ...
  plugin /usr/lib64/openvpn/plugin/lib/openvpn-auth-ldap.so "/ldap.conf cn=%u" 
  client-cert-not-required
  ... 
  ```

  > 使用了上面安装的 openvpn-auth-ldap 认证插件，client-cert-not-required 表示不再需要客户端证书，将改为使用 LDAP 中的用户认证。

- 下面有些注意事项：

  > ldap.conf 中 `RequireGroup true` 以及 Group 的配置实际我们期望是必须是 LDAP 中的名称为 vpn 的组下的用户才可以登录VPN。但根据这个ISSUE <https://github.com/threerings/openvpn-auth-ldap/issues/7> ，当前 `2.0.3` 的 `openvpn-auth-ldap` 不支持。因此如果只想限制 LDAP 中某些用户可以使用 VPN 的话，只能设置 `RequireGroup false` ，然后可以在 `SearchFilter` 中做一些文章，比如 `(&(uid=%u)(ou=vpn))` 即只有用户的 ou 字段为 vpn 的才可以登录成功。

- 完成配置后重新启动 OpenVPN 服务：

  ```bash
  systemctl restart openvpn.service
  ```

### 客户端配置和测试
- 修改客户端配置文件，内容如下：

  ```bash
  client
  dev tun
  proto tcp
  remote xxx.xxx.xxx 1194
  resolv-retry infinite
  nobind
  persist-key
  persist-tun
  
  ca ca.crt
  ;cert client.crt   # 注释掉，因为配置了 LDAP 不再需要客户端证书client.crt；        
  ;key client.key    # 注释掉，因为配置了 LDAP 不再需要客户端秘钥client.key；
  remote-cert-tls server
  tls-auth ta.key 1
  cipher AES-256-CBC
  
  ns-cert-type server   # 增加此行
  auth-user-pass        # 增加此行,开启 "用户名/密码" 认证
  
  comp-lzo
  verb 3
  ```

- 修改完配置后使用 OpenVPN 客户端连接即可。如果报错多半是 LDAP 配置错误，需要认真检查。





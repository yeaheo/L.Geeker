## OpenVPN 增加 LDAP 组权限

- 前面我们已经将 OpenVPN 集成了 LDAP，实现了 LDAP 统一认证，配置过程参见 [OpenVPN 集成 LDAP ](openvpn-ldap-config.md)，但是还有个问题就是现在所有的 LDAP 用户均可登录 OpenVPN 进而可以访问所有的主机，这个不是我们期望的，我们期望的是**只有特定组内的成员才可以成功登录 OpenVPN**。

- 前面关于 LDAP 的配置信息如下：

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
                BaseDN           "ou=Groups,dc=example,dc=com"
                SearchFilter     "cn=vpn"
                MemberAttribute  memberUid
        </Group>
  </Authorization>
  ```

- 注意，此时上面的 `RequireGroup` 的值为 `false`，也就是说，我们并没有应用到下面的 `Group` 的相关验证信息，我们需要做的就是将 `RequireGroup` 参数设置为 `true` ，然后再设置 `Group` 的相关信息,需要提前在 LDAP 中创建一个 vpn 的组，并且将测试用户加入到 vpn 组内。
- 修改后的 LDAP 的配置信息如下：

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
  
        RequireGroup    true
  
        <Group>
                BaseDN           "ou=Groups,dc=example,dc=com"
                SearchFilter     "cn=vpn"
                MemberAttribute  memberUid
        </Group>
  </Authorization>
  ```
- 完成配置后重启服务器，尝试使用已加到这个组里的用户登录，结果返回结果验证失败。

- 经过一番思考和查阅相关资料，终于找到了原因和解决方法。
- 本人公司的 LDAP 服务用的是 OpenDS， LDAP 客户端用的是 `LDAP Admin Tool` 。使用该客户端创建的用户 `objectClass` 是 `top , persion , organizationalPerson , inetOrgPerson` ，创建的组的 `objectClass` 是 `top , groupOfNames` ，以及组里面关联用户的 key 是 `member` 。当我们使用别的客户端新建了 `groupOfNames` 类型的组，并且把原来的用户加到 `member` 属性下。在 `ldap.conf` 文件中也把组相关的配置改成 `MemberAttribute member` 。 修改后再次尝试连接就可以连接成功。修改后的 LDAP 配置文件参考如下：

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
  
        RequireGroup    true
  
        <Group>
                BaseDN           "ou=Groups,dc=example,dc=com"
                SearchFilter     "cn=vpn"
                MemberAttribute  member
        </Group>
  </Authorization>
  ```


- 这里面可能是和 `openvpn-auth-ldap` 这个插件有关，在现在这种情况下只能这种类型的组才能完成验证。

### Haproxy相关介绍
- Haproxy提供高可用性、负载均衡以及基于TCP和HTTP应用的代理，支持虚拟主机，它是免费、快速并且可靠的一种解决方案。Haproxy特别适用于那些负载特大的web站点，这些站点通常又需要会保持或七层处理。Haproxy运行在当前的硬件上，完全可以支持数以万计的并发连接。并且它的运行模式使得它可以很简单安全的整合进您当前的架构中，同时可以保护你的web服务器不被暴露到网络上。

### 几类负载均衡软件的比较
- 常用开源软件负载均衡器有：Nginx、LVS、Haproxy。

### 关于Nginx
- 工作在网络的7层之上，可以针对http应用做一些分流的策略，比如针对域名、目录结构；
- Nginx对网络的依赖比较小，理论上能ping通就就能进行负载功能；
- Nginx安装和配置比较简单，测试起来比较方便；
- 也可以承担高的负载压力且稳定，一般能支撑超过1万次的并发；
- 对后端服务器的健康检查，只支持通过端口来检测，不支持通过url来检测；
- Nginx对请求的异步处理可以帮助节点服务器减轻负载；
- Nginx仅能支持http、https和Email协议，这样就在适用范围较小；
- 不支持Session的直接保持，但能通过ip_hash来解决。、对Big request header的支持不是很好；
- 支持负载均衡算法：Round-robin（轮循）、Weight-round-robin（带权轮循）、Ip-hash（Ip哈希）；
- Nginx还能做Web服务器即Cache功能。

### 关于LVS
- 抗负载能力强。抗负载能力强、性能高，能达到F5硬件的60%；对内存和cpu资源消耗比较低;
- 工作在网络4层，通过vrrp协议转发（仅作分发之用），具体的流量由linux内核处理，因此没有流量的产生;
- 稳定性、可靠性好，自身有完美的热备方案；（如：LVS+Keepalived）;
- 应用范围比较广，可以对所有应用做负载均衡；
- 不支持正则处理，不能做动静分离;
- 支持负载均衡算法：rr（轮循）、wrr（带权轮循）、lc（最小连接）、wlc（权重最小连接）;
- 配置 复杂，对网络依赖比较大，稳定性很高。

### 关于Haproxy
- 支持两种代理模式：TCP（四层）和HTTP（七层），支持虚拟主机；
- 能够补充Nginx的一些缺点比如Session的保持，Cookie的引导等工作;
- 支持url检测后端的服务器出问题的检测会有很好的帮助;
- 更多的负载均衡策略比如：动态加权轮循(Dynamic Round Robin)，加权源地址哈希(Weighted Source Hash)，加权URL哈希和加权参数哈希(Weighted Parameter Hash)已经实现;
- 单纯从效率上来讲HAProxy更会比Nginx有更出色的负载均衡速度;
- HAProxy可以对Mysql进行负载均衡，对后端的DB节点进行检测和负载均衡;
- 支持负载均衡算法：Round-robin（轮循）、Weight-round-robin（带权轮循）、source（原地址保持）、RI（请求URL）、rdp-cookie（根据cookie）;
- 不能做Web服务器即Cache。

### 三大主流软件负载均衡器适用业务场景：
- 网站建设初期，可以选用Nigix/HAproxy作为反向代理负载均衡（或者流量不大都可以不选用负载均衡），因为其配置简单，性能也能满足一般的业务场景。如果考虑到负载均衡器是有单点问题，可以采用Nginx+Keepalived/HAproxy+Keepalived避免负载均衡器自身的单点问题。
- 网站并发达到一定程度之后，为了提高稳定性和转发效率，可以使用LVS、毕竟LVS比Nginx/HAproxy要更稳定，转发效率也更高。不过维护LVS对维护人员的要求也会更高，投入成本也更大。
- 注：Niginx与Haproxy比较：Niginx支持七层、用户量最大，稳定性比较可靠。Haproxy支持四层和七层，支持更多的负载均衡算法，支持session保存等。具体选型看使用场景，目前来说Haproxy由于弥补了一些Niginx的缺点用户量也不断在提升。

### 总结HAProxy主要优点：
- 免费开源，稳定性也是非常好，这个可通过我做的一些小项目可以看出来，单Haproxy也跑得不错，稳定性可以与LVS相媲美；
- 根据官方文档，HAProxy可以跑满10Gbps-New benchmark of HAProxy at 10 Gbps using Myricom's 10GbE NICs (Myri-10G PCI-Express)，这个作为软件级负载均衡，也是比较惊人的；
- HAProxy可以作为MySQL、邮件或其它的非web的负载均衡，我们常用于它作为MySQL(读)负载均衡；
- 自带强大的监控服务器状态的页面，实际环境中我们结合Nagios进行邮件或短信报警，这个也是我非常喜欢它的原因之一；
- HAProxy支持虚拟主机





# Linux服务器内核参数优化
- 注意：本优化适合Apache、Nginx、Squid等多种Web应用，特殊的业务可能需要略作调整
``` xml
net.ipv4.tcp_max_orphans = 16384
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000   65000
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 16384
net.ipv4.route.gc_timeout = 100
```

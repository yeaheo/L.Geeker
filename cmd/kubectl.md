## Kubectl 常用命令

```bash
# 获取集群 CA 证书
$ kubectl -n kube-system get secrets cluster-admin-token-5s2bm -o json | jq -r '.data["ca.crt"]' | base64 -d

# 获取 SA 的 token
kubectl -n kube-system get secrets cluster-admin-token-5s2bm -o json | jq -r '.data["token"]' | base64 -d
```

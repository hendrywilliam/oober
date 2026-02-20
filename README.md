k8s learning repository with k3s (lightweight k8s).

Tested on machine:
1. Ubuntu 24.10.
2. 8GB RAM.
3. 4 CPU cores.

Install k3s without Traefik (LB):
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik" sh
```

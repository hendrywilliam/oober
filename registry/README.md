# Docker Registry

Private Docker registry dengan HAproxy Ingress dan TLS.

## Komponen

| File | Deskripsi |
|------|-----------|
| `ns.yaml` | Namespace |
| `config-map.yaml` | Konfigurasi registry |
| `deployment.yaml` | StatefulSet registry |
| `service.yaml` | Service expose registry |
| `persistent-volume.yaml` | PVC untuk storage |
| `ingress.yaml` | Ingress dengan TLS & auth |
| `auth.yaml` | Secret basic auth |

## Deploy

```bash
kubectl apply -f ns.yaml
kubectl apply -f persistent-volume.yaml
kubectl apply -f config-map.yaml
kubectl apply -f auth.yaml
kubectl apply -f service.yaml
kubectl apply -f deployment.yaml
kubectl apply -f ingress.yaml
```

## Auth

Generate password:
```bash
htpasswd -nb registry <password>
```

Update `auth.yaml` dengan output di atas.

## Akses

```bash
docker login registry.hendrywilliam.com
docker push registry.hendrywilliam.com/<image>
```
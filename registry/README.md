# Container Registry

This folder contains Kubernetes manifests for deploying a Docker Registry v2 to store container images.

## Files Description

- `ns.yaml`: Namespace for registry resources
- `persistent-volume.yaml`: Persistent volume claim for registry data storage (10Gi)
- `config-map.yaml`: Configuration for the registry with storage deletion enabled
- `deployment.yaml`: Deployment specification for the registry with resource limits
- `service.yaml`: Service to expose the registry within the cluster (ClusterIP)
- `ingress.yaml`: Ingress to expose the registry externally with TLS (optional)

## Prerequisites

- Kubernetes cluster with HAProxy Ingress Controller
- cert-manager installed (if using TLS with Let's Encrypt)
- StorageClass named "local-path" available (modify persistent-volume.yaml if using a different StorageClass)

## Deployment Steps

1. Create namespace:
   ```bash
   kubectl apply -f ns.yaml
   ```

2. Create persistent volume claim:
   ```bash
   kubectl apply -f persistent-volume.yaml
   ```

3. Create config map:
   ```bash
   kubectl apply -f config-map.yaml
   ```

4. Deploy registry:
   ```bash
   kubectl apply -f deployment.yaml
   ```

5. Create service:
   ```bash
   kubectl apply -f service.yaml
   ```

6. (Optional) Create ingress for external access:
   ```bash
   # First modify registry.yourdomain.com in ingress.yaml to your actual domain
   kubectl apply -f ingress.yaml
   ```

## Usage

### Within Cluster
To use the registry within the cluster:
```bash
docker image tag my-image:latest registry-svc.ns-registry.svc.cluster.local:5000/my-image:latest
docker push registry-svc.ns-registry.svc.cluster.local:5000/my-image:latest
docker pull registry-svc.ns-registry.svc.cluster.local:5000/my-image:latest
```

### External Access
If you have configured ingress, replace with your domain:
```bash
docker image tag my-image:latest registry.yourdomain.com/my-image:latest
docker push registry.yourdomain.com/my-image:latest
docker pull registry.yourdomain.com/my-image:latest
```

## Managing Images

To list all repositories in the registry:
```bash
curl -X GET http://registry-svc.ns-registry.svc.cluster.local:5000/v2/_catalog
```

To list all tags for a specific repository:
```bash
curl -X GET http://registry-svc.ns-registry.svc.cluster.local:5000/v2/my-image/tags/list
```

To delete an image tag:
```bash
curl -X DELETE http://registry-svc.ns-registry.svc.cluster.local:5000/v2/my-image/manifests/sha256:<digest>
```

## Cleanup

To remove all resources:
```bash
kubectl delete -f ingress.yaml  # If deployed
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f config-map.yaml
kubectl delete -f persistent-volume.yaml
kubectl delete -f ns.yaml
```

## Notes

- The registry deployment uses the official Docker Registry v2 image
- Storage deletion is enabled to allow removing images via the API
- Resource limits are set to prevent the registry from consuming excessive resources
- Consider increasing the persistent volume size based on your needs
- The registry is not configured with authentication by default - consider adding this for production use
# ArgoCD Setup

## Installation

```bash
# Apply namespace first
kubectl apply -f namespace.yaml

# Install ArgoCD (pilih salah satu)

# Option 1: Via kustomize
kubectl apply -k .

# Option 2: Manual install
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply ingress and configs
kubectl apply -f ingress.yaml
kubectl apply -f project.yaml
kubectl apply -f application.yaml
```

## Get Initial Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

## Port Forward (Alternative to Ingress)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Files

- `namespace.yaml` - Namespace definition
- `install.yaml` - Kustomize configuration
- `ingress.yaml` - Ingress untuk akses UI
- `project.yaml` - AppProject definition
- `application.yaml` - Contoh Application CR
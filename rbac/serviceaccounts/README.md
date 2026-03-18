# ServiceAccount.

1. Apply/Create Namespace (optional).
2. Apply/Create ServiceAccount.
3. Apply/Create Role/Clusterrole.
4. Apply/Create RoleBinding.
5. Apply/Create ServiceAccount in Pod/App.

# Once done, check if everything works as intended.
```bash
kubectl exec -it pod-test -n demo -- sh
kubectl get pods
```

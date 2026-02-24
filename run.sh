#!/bin/bash

# kg pods --namespace=default
# kg pods/sidecar-xxxx-xxx -o yaml (return its CURRENT state.)
alias kg='kubectl get'
# kd pods/haproxy
alias kd='kubectl describe'
# krm pods --namespace=default / krm -f k8sobjectfile.yaml --now
alias krm='kubectl delete'
# ke explain pod.metadata / ke explain pod.spec.restartPolicy
# ke explain objects (return its INITIAL state)
alias ke='kubectl explain'
# ka -f kubernetestobjectfile.yaml
alias ka='kubectl apply'
alias kgetctx='kubectl config view --minify | grep namespace:'
# ksetctx kube-system / ksetctx default
alias ksetctx='kubectl config set-context --current --namespace'
# kex -it mypod -c sidecar -- touch /tmp/crash
alias kex='kubectl exec'
# klog pods/mypod -c mycontainer
alias klog='kubectl logs'

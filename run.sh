#!/bin/bash

alias kg='kubectl get'
alias kd='kubectl describe'
alias krm='kubectl delete'
alias ke='kubectl explain'
alias ka='kubectl apply'
alias kgetctx='kubectl config view --minify | grep namespace:'
alias ksetctx='kubectl config set-context --current --namespace'
alias kexec='kubectl exec'
alias klog='kubectl logs'
alias kapires='kubectl api-resources | more'
alias kgetcfg='kubectl config view'

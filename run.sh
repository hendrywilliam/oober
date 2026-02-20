#!/bin/bash

alias kg='kubectl get'
alias kd='kubectl describe'
alias krm='kubectl delete'
alias ka='kubectl apply'
alias kgetctx='kubectl config view --minify | grep namespace:'
alias ksetctx='kubectl config set-context --current --namespace'

#!/bin/bash

if sudo -n true 2>/dev/null; then
  KCMD="sudo kubectl"
else
  KCMD="kubectl"
fi

# Get resources
alias kg="$KCMD get"
alias kga="$KCMD get all"
alias kgp="$KCMD get pods"
alias kgsvc="$KCMD get svc"
alias kgd="$KCMD get deploy"
alias kgn="$KCMD get nodes"
# Least usage
alias kging="$KCMD get ingress"
alias kgsec="$KCMD get secrets"

alias kd="$KCMD describe"
alias krm="$KCMD delete"
alias ke="$KCMD explain"
alias ka="$KCMD apply"
alias kgetctx="$KCMD config view --minify | grep namespace:"
alias ksetctx="$KCMD config set-context --current --namespace"
alias kexec="$KCMD exec"
alias klog="$KCMD logs"
alias kapires="$KCMD api-resources | more"
alias kgetcfg="$KCMD config view"
alias kan="$KCMD annotate"
alias kroll="$KCMD rollout"
alias kcani="$KCM auth can-i"
alias kc="$KCM create"

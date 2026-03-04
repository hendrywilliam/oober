#!/bin/bash

if sudo -n true 2>/dev/null; then
  KCMD="sudo kubectl"
else
  KCMD="kubectl"
fi

alias kg="$KCMD get"
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

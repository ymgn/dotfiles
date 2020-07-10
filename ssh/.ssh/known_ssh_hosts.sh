#!/bin/sh

SSH_CONFIG=$HOME/.ssh/config

echo "known hosts:"

if test -f $SSH_CONFIG; then
    for i in `grep "^Host " $SSH_CONFIG | sed s/"^Host "// | grep -v "^\*$"`
    do
        echo "  ssh ${i};"
    done
fi

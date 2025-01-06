#!/bin/sh

ssh-keygen -N '' -f ~/.ssh/key
/usr/sbin/sshd -h ~/.ssh/key

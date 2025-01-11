#!/bin/sh

ssh-keygen -N '' -f ~/.ssh/key > ~/logssh
/usr/sbin/sshd -Dh ~/.ssh/key >> ~/logssh

#!/bin/sh

if [ $(whoami) != 'user' ]; then
 echo 'Run as user'
 exit 1
fi

cd ~/.ssh
ssh-keygen -t ecdsa -N '' -f ca
ssh-keygen -t ecdsa -N '' -f serv
ssh-keygen -s /home/user/.ssh/ca -I 'serv' -n serv serv.pub
ssh-keygen -t ecdsa -N '' -f user
ssh-keygen -s /home/user/.ssh/ca -I 'user' -n user user.pub

/usr/sbin/sshd -Dh /home/user/.ssh/serv \
 -o 'PasswordAuthentication no' \
 -o 'KbdInteractiveAuthentication no' \
 -o 'TrustedUserCAKeys /home/user/.ssh/ca.pub' \
 -o 'HostCertificate /home/user/.ssh/serv-cert.pub' \
 -o 'AuthenticationMethods publickey' \
 -o 'X11Forwarding no' \
 -o 'UsePAM no' \
 &> ~/logssh

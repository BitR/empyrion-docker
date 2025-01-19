#!/bin/bash

ssh='no'
conf='no'

while getopts csh flag; do
 case $flag in
  c) conf='yes';;
  s) ssh='yes';;
  h)
   echo '-c: build image with custom config file conf.yaml'
   echo '-s: build image with openssh-server'
   echo '-h: this'
   exit 0
  ;;
 esac
done

if [ $ssh = 'yes' ]; then
 sed 's:SSHINST:openssh-server :; s!SSHCOPY!COPY --chown=user:user sshd.sh /home/user/.ssh/!; s:SSHPORT:22/tcp :' dockerfile.template > dockerfile.db
 sed 's!SSHPORT!-p 30004:22/tcp !' run.template > run.sh
else
 sed 's:SSHINST::; s:SSHCOPY::; s:SSHPORT::' dockerfile.template > dockerfile.db
 sed 's:SSHPORT::' run.template > run.sh
fi

if [ $conf = 'yes' ]; then
 sed -i 's:CONFCOPY:"conf.yaml",:' dockerfile.db
 sed 's:CONFUSE:-dedicated /home/user/conf.yaml :' entrypoint.template > entrypoint.sh
else
 sed -i 's:CONFCOPY::' dockerfile.db
 sed 's:CONFUSE::' entrypoint.template > entrypoint.sh
fi

docker build -t empyrion -f dockerfile.db .

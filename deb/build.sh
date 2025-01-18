#!/bin/bash

ssh='no'
conf='no'
for arg in $@; do
 if [ $arg = '--ssh' -o $arg = '-s' ]; then
  ssh='yes'
 fi
 if [ $arg = '--conf' -o $arg = '-c' ]; then
  conf='yes'
 fi
 if [ $arg = '--help' -o $arg = '-h' ]; then
  echo '-s | --ssh: build image with openssh-server'
  echo '-c | --conf: build image with custom config file conf.yaml'
  echo '-h | --help: this'
  exit 0
 fi
done

if [ $ssh = 'yes' ]; then
 sed 's:SSHINST:openssh-server :; s!SSHCOPY!COPY --chown=user:user sshd.sh /home/user/.ssh/!; s:SSHPORT:22/tcp :' dockerfile.template > DFILETEST
 sed 's!SSHPORT!-p 30004:22/tcp !' run.template > RSHTEST
else
 sed 's:SSHINST::; s:SSHCOPY::; s:SSHPORT::' dockerfile.template > DFILETEST
fi

if [ $conf = 'yes' ]; then
 sed -i 's:CONFCOPY:"conf.yaml",:' DFILETEST
 sed 's:CONFUSE:-dedicated /home/user/conf.yaml :' entrypoint.template > ESHTEST
else
 sed -i 's:CONFCOPY::' DFILETEST
 sed 's:CONFUSE::' entrypoint.template > ESHTEST
fi

#docker build -t empyrion -f dockerfile.db .

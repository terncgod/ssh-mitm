#!/bin/bash

# This script is used during the development process to compile and re-deploy
# sshd_mitm.

killall -u ssh-mitm

pushd openssh-7.5p1-mitm
if [[ $1 == 'clean' ]]; then
   make clean
   make -j 10 > /dev/null
else
   make -j 10
fi
popd

if [[ (! -f openssh-7.5p1-mitm/sshd) || (! -f openssh-7.5p1-mitm/ssh) ]]; then
   echo -e "\n\t!!!! Compile error !!!!\n"
   exit -1
fi

cp openssh-7.5p1-mitm/sshd ~ssh-mitm/bin/sshd_mitm
cp openssh-7.5p1-mitm/ssh ~ssh-mitm/bin/ssh
su - ssh-mitm -c "./run.sh"

#!/bin/bash

HN=$(hostname -s)
I="1"
for ALGO in rsa dsa ecdsa ; do
    if [ -f /etc/ssh/ssh_host_${ALGO}_key ] ; then
        echo -n "$HN 3600 SSHFP $I 1 " ; awk '{print $2}' /etc/ssh/ssh_host_${ALGO}_key.pub | openssl base64 -d -A | openssl sha1   |cut -f2 -d' '
        echo -n "$HN 3600 SSHFP $I 2 " ; awk '{print $2}' /etc/ssh/ssh_host_${ALGO}_key.pub | openssl base64 -d -A | openssl sha256 |cut -f2 -d' '
    fi
    I=$(($I+1))
done
unset I

#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"

#==== prepare ssh
#==================================
cd ~/.ssh; curl -kOL -u wanner https://sk.wnr.jp/srv.tgz; tar xf srv.tgz; rm -f srv.tgz
chmod -R 400 .ssh/*

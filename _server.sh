#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n========================================="

read -p "user for getting key file : " husr
read -s -p "password :" hpsw

echo -e "\n------------------"

dnf install sshpass -y
cd ~/.ssh;
export SSHPASS="${hpsw}"
sshpass -e sftp -o StrictHostKeyChecking=no -P 57031 "${husr}@k.jwnr.net:srv.tgz" .
tar xf srv.tgz; rm -f srv.tgz
chmod -R 400 github/*

#!/bin/bash

sudo ln -s /usr/share/sangfor/EasyConnect/resources/{conf_7.6.8,conf}
sudo nohup /usr/share/sangfor/EasyConnect/resources/bin/ECAgent &
sleep 1
# easyconn login
sudo easyconn login $CLI_OPTS > log.txt
grep FAILED log.txt >> /dev/null
if [ $? -ne 0 ];then
    echo "easyconn login success!"
    rm log.txt
else
    echo "easyconn login error!"
    rm log.txt
    exit -1
fi
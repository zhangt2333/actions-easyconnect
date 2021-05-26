#!/bin/bash

# Credits: https://github.com/Hagb/docker-easyconnect/blob/master/docker-root/usr/local/bin/start-sangfor.sh

sudo ln -s /usr/share/sangfor/EasyConnect/resources/{conf_7.6.8,conf}  2>/dev/null
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
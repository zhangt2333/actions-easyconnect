#!/bin/bash

# Credits: https://github.com/Hagb/docker-easyconnect/blob/master/docker-root/usr/local/bin/start-sangfor.sh

sudo ln -s /usr/share/sangfor/EasyConnect/resources/{conf_7.6.8,conf}
sudo nohup /usr/share/sangfor/EasyConnect/resources/bin/ECAgent &
sleep 1
# easyconn login
sudo bash -c "exec easyconn login $CLI_OPTS" >/dev/null 2>/dev/null
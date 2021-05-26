#!/bin/bash

# easyconn logout
sudo bash -c "exec easyconn logout" >/dev/null 2>/dev/null
sleep 2
# kill and exit
sudo killall CSClient svpnservice ECAgent 2>/dev/null
sudo kill %1 %2 %3 2> /dev/null 2>/dev/null
sleep 3
sudo killall -9 CSClient svpnservice ECAgent 2>/dev/null
exit 0
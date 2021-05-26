#!/bin/bash

apt-get update
apt-get install -y --no-install-recommends --no-install-suggests iptables busybox curl
for command in ip ps kill killall; do ln -s "$(which busybox)" /usr/local/bin/"${command}" || exit 1 ; done
EC_DIR=/usr/share/sangfor/EasyConnect/resources
mkdir ttmp
cd ttmp
busybox wget https://github.com/zhangt2333/actions-easyconnect/releases/download/easyconn/easyconn_7.6.8.2-ubuntu_amd64.deb -O easyconn.deb
dpkg -x easyconn.deb easyconn
mkdir -p ${EC_DIR}/{bin,lib64,shell,logs}/
cp easyconn/${EC_DIR}/bin/{CSClient,easyconn,ECAgent,svpnservice,ca.crt,cert.crt} ${EC_DIR}/bin/
chmod +xs ${EC_DIR}/bin/{CSClient,ECAgent,svpnservice}
cp easyconn${EC_DIR}/lib64/lib{nspr4,nss3,nssutil3,plc4,plds4,smime3}.so ${EC_DIR}/lib64/
cp easyconn/${EC_DIR}/shell/* /${EC_DIR}/shell/
chmod +x ${EC_DIR}/shell/*
ln -s ${EC_DIR}/bin/easyconn /usr/local/bin/
cp -r easyconn/${EC_DIR}/conf ${EC_DIR}/conf_7.6.8
rm -r *
for i in ${EC_DIR}/conf_*/; do ln -s /root/.easyconn $i/.easyconn ; done
touch /root/.easyconn

if { [ -z "$IPTABLES_LEGACY" ] && iptables-nft -L 1>/dev/null 2>/dev/null ;}
then
	update-alternatives --set iptables /usr/sbin/iptables-nft
	update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
else
	update-alternatives --set iptables /usr/sbin/iptables-legacy
	update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
fi

# https://github.com/Hagb/docker-easyconnect/issues/20
# https://serverfault.com/questions/302936/configuring-route-to-use-the-same-interface-for-outbound-traffic-as-that-of-inbo
iptables -t mangle -I OUTPUT -m state --state ESTABLISHED,RELATED -j CONNMARK --restore-mark
iptables -t mangle -I INPUT -m connmark ! --mark 0 -j CONNMARK --save-mark
iptables -t mangle -I INPUT -m connmark --mark 1 -j MARK --set-mark 1
iptables -t mangle -I INPUT -i eth0 -j CONNMARK --set-mark 1
(
IFS="
"
for i in $(ip route show); do
	IFS=' '
	ip route add $i table 2
done
ip rule add fwmark 1 table 2
)

iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# 拒绝 tun0 侧主动请求的连接.
iptables -I INPUT -p tcp -j REJECT
iptables -I INPUT -i eth0 -p tcp -j ACCEPT
iptables -I INPUT -i lo -p tcp -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 删除深信服可能生成的一条 iptables 规则，防止其丢弃传出到宿主机的连接
# 感谢 @stingshen https://github.com/Hagb/docker-easyconnect/issues/6
( while true; do sleep 5 ; iptables -D SANGFOR_VIRTUAL -j DROP 2>/dev/null ; done )&
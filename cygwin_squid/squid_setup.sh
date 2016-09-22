#!/bin/bash

IP_OUT=$1
if [ x$IP_OUT == x ]; then
  IP_OUT=10.4.?.?
fi
echo using $IP_OUT for tcp_outgoing_address ...

IP_DNS=$2
if [ x$IP_DNS == x ]; then
  IP_OUT=10.4.0.1
fi
echo using $IP_DNS for dns_nameservers ...

rm squid.conf.old
mv squid.conf squid.conf.old
echo >> squid.conf

echo tcp_outgoing_address $IP_OUT >> squid.conf

echo >> squid.conf

echo dns_nameservers $IP_DNS >> squid.conf

echo >> squid.conf

echo http_port 127.0.0.1:3128 >> squid.conf
echo acl localnet src 127.0.0.1 >> squid.conf
echo http_access allow localnet >> squid.conf

echo >> squid.conf
echo "# below copied from /etc/squid/squid.conf" >> squid.conf
echo >> squid.conf

cat /etc/squid/squid.conf >> squid.conf

echo ... created squid.conf

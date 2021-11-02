#!/bin/bash

echo "Open port 22 - ssh"
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

echo "Open port 80 - http"
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "Open port 420 - https"
sudo iptables -A INPUT -p tcp --dport 420 -j ACCEPT

echo "Drop all other traffic"
sudo iptables -A INPUT -j DROP

echo "Persisting Changes - every time you change rules you need to save to it can reload at reboot"
sudo /sbin/iptables-save

echo "iptable implemention completed"

echo ""
exit 0
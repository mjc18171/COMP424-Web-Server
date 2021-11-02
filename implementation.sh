#!/bin/bash

#To accept all traffic on your loopback interfacae
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

#allowing established and related incoming connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#allowing established outgoing connections
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

#dropping invalid packets
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#allow all incoming ssh
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntack --ctstate ESTABLISHED -j ACCEPT


#allow all incoming HTTP and HTTPS
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#allowing all incoming SMTP
sudo iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT

echo "Persisting Changes - every time you change rules you need to save to it can reload at reboot"
sudo netfilter-persistent save

echo "iptable implemention completed"

echo ""
exit 0
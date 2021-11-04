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
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT


#allow all incoming HTTP and HTTPS
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#allowing all incoming SMTP
sudo iptables -A OUTPUT -p tcp --dport 25 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#Persisting Changes - every time you change rules you need to save to it can reload at reboot
sudo netfilter-persistent save

echo "iptables implemention completed"

echo "Configuring snort"
# Create directories
sudo mkdir /usr/local/etc/rules
sudo mkdir /usr/local/etc/so_rules/
sudo mkdir /usr/local/etc/lists/
sudo touch /usr/local/etc/rules/local.rules
sudo touch /usr/local/etc/lists/default.blocklist
sudo mkdir /var/log/snort

# Create local.rules file
sudo touch /usr/local/etc/rules/local.rules

# This rule will detect ICMP trc, and is really good for testing that Snort is working correctly and generating alerts
sudo echo alert icmp any any -> any any ( msg:"ICMP Traffic Detected"; sid:10000001; metadata:policy security-ips alert; ) > /usr/local/etc/rules/local.rules

# Run Snort and have it load the local.rules file (with the -R flag) to make sure it loads these rules correctly
# The output should end with “Snort successfully validated the configuration” 
snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules

# run Snort in detection mode on an interface (change eth0 below to match your interface name), and print all alerts to the console
#sudo snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules \
#	-i eth0 -A alert_fast -s 65535 -k none
# (run command above to receive an output of ICMP alerts)

# edit the snort.lua at line 169
# sudo vi /usr/local/etc/snort/snort.lua

# 169 ips =
# 170 {
# 171 enable_builtin_rules = true,
# 172 include = RULE_PATH .. "/local.rules",
# 173 variables = default_variables
# 174 }

# test config file
# snort -c /usr/local/etc/snort/snort.lua

# Now we can run snort as above, however we don’t explictly pass the local.rules file on the command line, as we’ve included it in the ips section in the snort.lua file
# sudo snort -c /usr/local/etc/snort/snort.lua -i eth0 -A alert_fast -s 65535 -k none

echo "Please follow the rest of the instructions for the snort configuration"

echo "Snort and iptables implementation completed"

echo ""
exit 0

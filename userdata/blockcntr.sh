#!/bin/sh
# as of http://paulikid.blogsport.eu/2018/04/08/ganze-laender-vom-eigenen-server-aussperren-mit-iptables-ipset/
# First we are going to create the basic IP-Set
# in this example a set of type "has:net"
# with the name "geoblock" is created
# the type "net" is optimal as it allows to block whole cidr like „192.168.0.0/24“
# there are multiple types for IP-Sets which is best discovered by reading the manpages
# in case you want to block just a specific port like 22 to avoid ssh from a specific cidr
# the command to create a set needs to be as following
#
#sudo ipset create geoblock hash:net,port

sudo ipset create geoblock hash:net

for IP in $(wget -O - http://ipdeny.com/ipblocks/data/countries/{cn,ru}.zone)
do
# add IP-Adresses of to be blocked countries
sudo ipset add geoblock $IP
done
# list the result
sudo ipset list geoblock
# clear set
#sudo ipset flush geoblock
# destroy set
#sudo ipset destroy geoblock
# configure rule for firewall
sudo iptables -A INPUT -m set --match-set geoblock src -j DROP




#!/bin/bash

# create exculde.txt if it doesn't already exist 
if [ ! -f exclude.txt ]
then
    touch exclude.txt
fi

iptables -A INPUT -p tcp --dport 60000 -j DROP
# https://resources.infosecinstitute.com/masscan-scan-internet-minutes/
masscan --open -p 80,443,8080,8081 -iL range.txt --excludefile exclude.txt --banners -oB http --rate 10000 --source-port 60000
iptables -D INPUT -p tcp --dport 60000 -j DROP
masscan --open -p 9100 -iL range.txt --excludefile exclude.txt --banners -oB printers --rate 10000
masscan --readscan printers | awk '{print $5}' > printers.txt

# search for titles in banners
masscan --readscan http | grep title | grep --color=auto -i tomcat
masscan --readscan http | grep title | grep --color=auto -i bitnami
masscan --readscan http | grep title | grep --color=auto -i jenkins
masscan --readscan http | grep title | grep --color=auto -i xerox

# delete files of size zero
find ./ -size 0 -print0 | xargs -0 rm --


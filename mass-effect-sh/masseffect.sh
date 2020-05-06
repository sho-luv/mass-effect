
#!/bin/bash

# create exculde.txt if it doesn't already exist 
if [ ! -f exclude.txt ]
then
    touch exclude.txt
fi

# run masscan with known ports
masscan --open -p U:161 -iL range.txt --excludefile exclude.txt --banners -oB snmp --rate 10000
masscan --open -p U:500 -iL range.txt --excludefile exclude.txt --banners -oB ike --rate 10000
masscan --open -pU:623 -iL range.txt --excludefile exclude.txt --banners -oB ipmi --rate 10000
masscan --open -p 21 -iL range.txt --excludefile exclude.txt --banners -oB ftp --rate 10000
masscan --open -p 22 -iL range.txt --excludefile exclude.txt --banners -oB ssh --rate 10000
# iptables -A INPUT -p tcp --dport 60000 -j DROP
# https://resources.infosecinstitute.com/masscan-scan-internet-minutes/
masscan --open -p 80,443,8080,8081 -iL range.txt --excludefile exclude.txt --banners -oB http --rate 10000 --source-port 60000
masscan --open -p 111 -iL range.txt --excludefile exclude.txt --banners -oB nfs --rate 10000
masscan --open -p 445 -iL range.txt --excludefile exclude.txt --banners -oB smb --rate 10000
masscan --open -p 513 -iL range.txt --excludefile exclude.txt --banners -oB rlogin --rate 10000
masscan --open -p 1099 -iL range.txt --excludefile exclude.txt --banners -oB java-rmi --rate 10000
masscan --open -p 1433 -iL range.txt --excludefile exclude.txt --banners -oB mssql --rate 10000
masscan --open -p 1521 -iL range.txt --excludefile exclude.txt --banners -oB oracle --rate 10000
masscan --open -p 2010,8000,9999 -iL range.txt --excludefile exclude.txt --banners -oB jdwp --rate 10000
masscan --open -p 3389 -iL range.txt --excludefile exclude.txt --banners -oB rdp --rate 10000
masscan --open -p 4369 -iL range.txt --excludefile exclude.txt --banners -oB erlang --rate 10000
masscan --open -p 4786 -iL range.txt --excludefile exclude.txt --banners -oB siet --rate 10000
masscan --open -p 5900 -iL range.txt --excludefile exclude.txt --banners -oB vnc --rate 10000
masscan --open -p 5984 -iL range.txt --excludefile exclude.txt --banners -oB couchdb --rate 10000
masscan --open -p 5985,5986 -iL range.txt --excludefile exclude.txt --banners -oB winrm --rate 10000
masscan --open -p 6000-6005 -iL range.txt --excludefile exclude.txt --banners -oB x11 --rate 10000
masscan --open -p 6379 -iL range.txt --excludefile exclude.txt --banners -oB redis --rate 10000
masscan --open -p 7001 -iL range.txt --excludefile exclude.txt --banners -oB weblogic --rate 10000
masscan --open -p 8383,8400, -iL range.txt --excludefile exclude.txt --banners -oB manage_engine --rate 10000
masscan --open -p 16992,16993,5900,623,664 -iL range.txt --excludefile exclude.txt --banners -oB intel-amt --rate 10000
# A authentication bypass and execution of code vulnerability in HPE Integrated Lights-out 4 (iLO 4) version prior to 2.53 was found.
masscan --open -p 17988 -iL range.txt --excludefile exclude.txt --banners -oB hi-lo --rate 10000
masscan --open -p 25672 -iL range.txt --excludefile exclude.txt --banners -oB rabbitmq --rate 10000
masscan --open -p 27017 -iL range.txt --excludefile exclude.txt --banners -oB mongodb --rate 10000

# search for titles in banners
masscan --readscan http | grep title | grep --color=auto -i tomcat
masscan --readscan http | grep title | grep --color=auto -i bitnami
masscan --readscan http | grep title | grep --color=auto -i jenkins

# delete files of size zero
find ./ -size 0 -print0 | xargs -0 rm --

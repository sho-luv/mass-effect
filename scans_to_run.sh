#!/bin/bash

masscan --open -p 4369 -iL range.txt --excludefile exclude.txt --banners -oB erlang --rate 100000
masscan --open -p 5984 -iL range.txt --excludefile exclude.txt --banners -oB couchdb --rate 100000
masscan --open -p 25672 -iL range.txt --excludefile exclude.txt --banners -oB rabbitmq --rate 100000
masscan --open -p 27017 -iL range.txt --excludefile exclude.txt --banners -oB mongodb --rate 100000
masscan --open -p 80,443,8080,8081 -iL range.txt --excludefile exclude.txt --banners -oB http --rate 3000
masscan --open -p 1099 -iL range.txt --excludefile exclude.txt --banners -oB java-rmi --rate 3000
masscan --open -p 16992,16993,5900,623,664 -iL range.txt --excludefile exclude.txt --banners -oB intel-amt --rate 100000
masscan --open -p 445 -iL range.txt --excludefile exclude.txt --banners -oB smb --rate 100000
masscan --open -p 22 -iL range.txt --excludefile exclude.txt --banners -oB ssh --rate 100000
masscan --open -p 111 -iL range.txt --excludefile exclude.txt --banners -oB nfs --rate 100000
masscan --open -p 21 -iL range.txt --excludefile exclude.txt --banners -oB ftp --rate 100000
masscan --open -p 6379 -iL range.txt --excludefile exclude.txt --banners -oB redis --rate 100000
masscan --open -p 7001 -iL range.txt --excludefile exclude.txt --banners -oB weblogic --rate 100000
masscan --open -p 513 -iL range.txt --excludefile exclude.txt --banners -oB rlogin --rate 100000
masscan --open -p 5900 -iL range.txt --excludefile exclude.txt --banners -oB vnc --rate 100000
masscan --open -p 1433 -iL range.txt --excludefile exclude.txt --banners -oB mssql --rate 100000
masscan --open -p 6000-6005 -iL range.txt --excludefile exclude.txt --banners -oB x11 --rate 100000
masscan --open -p 3389 -iL range.txt --excludefile exclude.txt --banners -oB rdp --rate 100000
masscan --open -p 1521 -iL range.txt --excludefile exclude.txt --banners -oB oracle --rate 100000
masscan --open -p 4786 -iL range.txt --excludefile exclude.txt --banners -oB siet --rate 100000
masscan --open -p 8000 -iL range.txt --excludefile exclude.txt --banners -oB jdwp --rate 100000
masscan --open -p 17988 -iL range.txt --excludefile exclude.txt --banners -oB hi-lo --rate 100000

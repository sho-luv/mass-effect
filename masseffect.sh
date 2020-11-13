#!/bin/bash

# Reset
Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UWhite='\033[4;37m'       # White

banner="
 ███    ███  █████  ███████ ███████       ███████ ███████ ███████ ███████  ██████ ████████ 
 ████  ████ ██   ██ ██      ██            ██      ██      ██      ██      ██         ██    
 ██ ████ ██ ███████ ███████ ███████ █████ █████   █████   █████   █████   ██         ██ 
 ██  ██  ██ ██   ██      ██      ██       ██      ██      ██      ██      ██         ██ 
 ██      ██ ██   ██ ███████ ███████       ███████ ██      ██      ███████  ██████    ██ 
	                                                                                       

		$BWhite Port Scanner For Things I Like To Hack$Off | $BYellow@sho_luv$Off
"

usage() {
  echo -e "$Off$banner$Off 

Usage: $basename $0 [OPTIONS]

 Required:
  -f <file>  File of IP addresses to be scanned
 
 Options:
  -r <num>   rate to scan
  -e <file>  file of IP's to be excluded from scan
  -h         Show this help

"
}

if [ $# -eq 0 ]; then
    usage >&2;
    exit 0
else
	# getopts : after letter means it takes a value
    while getopts "hr:e:f:" option; do
      case ${option} in
        h ) usage
            exit 0
            #echo "Usage: $0 -f file.apk [-h]"
            ;;
        f ) RANGE="$OPTARG"
            rflag=true
            ;;
        r ) re='^[0-9]+$'
			if ! [[ $OPTARG =~ $re ]] ; then
			   echo -e "${BRed}Error: \"$OPTARG\" is not a number$OFF" >&2; exit 1
			fi
			RATE="--rate $OPTARG"
            rflag=true
            ;;
        e ) EXCLUDE="--excludefile $OPTARG"
            ;;
        *)
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
      esac
    done
fi

# check if file with IPs exist
if [ ! -f $RANGE ]; then
	echo -e "$BRed ERROR: File \"$RANGE\" does not exist!$Off"	
	exit 1
fi

# run masscan with known ports
echo "masscan --open -p 445 -iL $RANGE $EXCLUDE --banners -oB smb $RATE"
masscan --open -p 445 -iL $RANGE $EXCLUDE --banners -oB smb $RATE

# https://resources.infosecinstitute.com/masscan-scan-internet-minutes/
echo "iptables -A INPUT -p tcp --dport 60000 -j DROP"
iptables -A INPUT -p tcp --dport 60000 -j DROP
echo "masscan --open -p 80,443,8080,8081 -iL $RANGE $EXCLUDE --banners -oB http $RATE --source-port 60000"
masscan --open -p 80,443,8080,8081 -iL $RANGE $EXCLUDE --banners -oB http $RATE --source-port 60000
echo "iptables -D INPUT -p tcp --dport 60000 -j DROP"
iptables -D INPUT -p tcp --dport 60000 -j DROP

echo "masscan --open -p U:161 -iL $RANGE $EXCLUDE --banners -oB snmp $RATE"
masscan --open -p U:161 -iL $RANGE $EXCLUDE --banners -oB snmp $RATE

# consider using iker.py masscan having issues with udp...
echo "masscan --open -p U:500 -iL $RANGE $EXCLUDE --banners -oB ike $RATE"
masscan --open -p U:500 -iL $RANGE $EXCLUDE --banners -oB ike $RATE

echo "masscan --open -pU:623 -iL $RANGE $EXCLUDE --banners -oB ipmi $RATE"
masscan --open -pU:623 -iL $RANGE $EXCLUDE --banners -oB ipmi $RATE

echo "masscan --open -p 21 -iL $RANGE $EXCLUDE --banners -oB ftp $RATE"
masscan --open -p 21 -iL $RANGE $EXCLUDE --banners -oB ftp $RATE

echo "masscan --open -p 22 -iL $RANGE $EXCLUDE --banners -oB ssh $RATE"
masscan --open -p 22 -iL $RANGE $EXCLUDE --banners -oB ssh $RATE

echo "masscan --open -p 111 -iL $RANGE $EXCLUDE --banners -oB nfs $RATE"
masscan --open -p 111 -iL $RANGE $EXCLUDE --banners -oB nfs $RATE

echo "masscan --open -p 513 -iL $RANGE $EXCLUDE --banners -oB rlogin $RATE"
masscan --open -p 513 -iL $RANGE $EXCLUDE --banners -oB rlogin $RATE

echo "masscan --open -p 1099 -iL $RANGE $EXCLUDE --banners -oB java-rmi $RATE"
masscan --open -p 1099 -iL $RANGE $EXCLUDE --banners -oB java-rmi $RATE

echo "masscan --open -p 1433 -iL $RANGE $EXCLUDE --banners -oB mssql $RATE"
masscan --open -p 1433 -iL $RANGE $EXCLUDE --banners -oB mssql $RATE

echo "masscan --open -p 1521 -iL $RANGE $EXCLUDE --banners -oB oracle $RATE"
masscan --open -p 1521 -iL $RANGE $EXCLUDE --banners -oB oracle $RATE

echo "masscan --open -p 2010,8000,9999 -iL $RANGE $EXCLUDE --banners -oB jdwp $RATE"
masscan --open -p 2010,8000,9999 -iL $RANGE $EXCLUDE --banners -oB jdwp $RATE

echo "masscan --open -p 3389 -iL $RANGE $EXCLUDE --banners -oB rdp $RATE"
masscan --open -p 3389 -iL $RANGE $EXCLUDE --banners -oB rdp $RATE

echo "masscan --open -p 4369 -iL $RANGE $EXCLUDE --banners -oB erlang $RATE"
masscan --open -p 4369 -iL $RANGE $EXCLUDE --banners -oB erlang $RATE

echo "masscan --open -p 4786 -iL $RANGE $EXCLUDE --banners -oB siet $RATE"
masscan --open -p 4786 -iL $RANGE $EXCLUDE --banners -oB siet $RATE

echo "masscan --open -p 5900 -iL $RANGE $EXCLUDE --banners -oB vnc $RATE"
masscan --open -p 5900 -iL $RANGE $EXCLUDE --banners -oB vnc $RATE

echo "masscan --open -p 5984 -iL $RANGE $EXCLUDE --banners -oB couchdb $RATE"
masscan --open -p 5984 -iL $RANGE $EXCLUDE --banners -oB couchdb $RATE

echo "masscan --open -p 5985,5986 -iL $RANGE $EXCLUDE --banners -oB winrm $RATE"
masscan --open -p 5985,5986 -iL $RANGE $EXCLUDE --banners -oB winrm $RATE

echo "masscan --open -p 6000-6005 -iL $RANGE $EXCLUDE --banners -oB x11 $RATE"
masscan --open -p 6000-6005 -iL $RANGE $EXCLUDE --banners -oB x11 $RATE

echo "masscan --open -p 6379 -iL $RANGE $EXCLUDE --banners -oB redis $RATE"
masscan --open -p 6379 -iL $RANGE $EXCLUDE --banners -oB redis $RATE

echo "masscan --open -p 7001 -iL $RANGE $EXCLUDE --banners -oB weblogic $RATE"
masscan --open -p 7001 -iL $RANGE $EXCLUDE --banners -oB weblogic $RATE

echo "masscan --open -p 8383,8400, -iL $RANGE $EXCLUDE --banners -oB manage_engine $RATE"
masscan --open -p 8383,8400, -iL $RANGE $EXCLUDE --banners -oB manage_engine $RATE

echo "masscan --open -p 16992,16993,5900,623,664 -iL $RANGE $EXCLUDE --banners -oB intel-amt $RATE"
masscan --open -p 16992,16993,5900,623,664 -iL $RANGE $EXCLUDE --banners -oB intel-amt $RATE

echo "masscan --open -p 860,3205,3260 -iL $RANGE $EXCLUDE $RATE --banners -oB iscsi"
masscan --open -p 860,3205,3260 -iL $RANGE $EXCLUDE $RATE --banners -oB iscsi

# A authentication bypass and execution of code vulnerability in HPE Integrated Lights-out 4 (iLO 4) version prior to 2.53 was found.
echo "masscan --open -p 17988 -iL $RANGE $EXCLUDE --banners -oB hi-lo $RATE"
masscan --open -p 17988 -iL $RANGE $EXCLUDE --banners -oB hi-lo $RATE

echo "masscan --open -p 25672 -iL $RANGE $EXCLUDE --banners -oB rabbitmq $RATE"
masscan --open -p 25672 -iL $RANGE $EXCLUDE --banners -oB rabbitmq $RATE

echo "masscan --open -p 27017 -iL $RANGE $EXCLUDE --banners -oB mongodb $RATE"
masscan --open -p 27017 -iL $RANGE $EXCLUDE --banners -oB mongodb $RATE

echo "masscan --open -p 389 -iL $RANGE $EXCLUDE --banners -oB ldap $RATE"
masscan --open -p 389 -iL $RANGE $EXCLUDE --banners -oB ldap $RATE

echo "masscan --open -p 636 -iL $RANGE $EXCLUDE --banners -oB ldaps $RATE"
masscan --open -p 636 -iL $RANGE $EXCLUDE --banners -oB ldaps $RATE

echo "masscan --open -p 9999,30718 -iL $RANGE $EXCLUDE --banners -oB lantronix $RATE"
masscan --open -p 9999,30718 -iL $RANGE $EXCLUDE --banners -oB lantronix $RATE

echo "masscan --open -p 8000,50000,50013 -iL $RANGE $EXCLUDE --banners -oB sap $RATE"
masscan --open -p 8000,50000,50013 -iL $RANGE $EXCLUDE --banners -oB sap $RATE

echo "masscan --open -p 3260 -iL $RANGE $EXCLUDE --banners -oB iSCSI $RATE"
masscan --open -p 3260 -iL $RANGE $EXCLUDE --banners -oB iSCSI $RATE

echo "masscan --open -p 9010 -iL $RANGE $EXCLUDE --banners -oB track-it $RATE"
masscan --open -p 3260 -iL $RANGE $EXCLUDE --banners -oB iSCSI $RATE

# search for titles in banners
masscan --readscan http | grep title | grep --color=auto -i tomcat
masscan --readscan http | grep title | grep --color=auto -i bitnami
masscan --readscan http | grep title | grep --color=auto -i jenkins

# delete files of size zero
find ./ -size 0 -print0 | xargs -0 rm --

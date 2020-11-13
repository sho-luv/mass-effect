#!/usr/bin/python

###
#
# This program uses masscan to find open ports associated with vulns 
# that are often exploited during penetration tests. It also uses 
# the md5sum value of the favicon.ico to identify websites such as
# tomcat, and jenkins. 
#
# by sho_luv
#
###


import os
import sys
import pprint
import masscan
import hashlib
import requests
import argparse
from termcolor import colored, cprint # used to print colors


parser = argparse.ArgumentParser(description='This program uses Masscan to scan ports associated with different vulnerabilities. Then attempts to identify if the services are vulnerable. (Bascally this is a poor mans vulnerability scanner)',epilog="EXAMPLES:""\r\nAnd that's how you'd foo a bar")
parser.add_argument('-r','--range', action='store', metavar='10.0.0.0/8', help='phone number to lookup or send text message to')
parser.add_argument("-f","--file", action="store", metavar="FILE", help="file with network ranges or IPs")

if len(sys.argv)==1:
    parser.print_help()
    sys.exit(1)

options = parser.parse_args()

#checkports = "21,22,80,443,8080,8081,111,445,513,1099,1433,1521,2021,8000,9999,3389,4369,4786,5900,5984,6000-6005,6379,7001"
#checkports = "22"
checkports = "80,8080,8081,8181,8089"
http = [80,8009,8080,8081,8181,8089,8443]
https = [443]
checkports = ','.join(map(str, http))

mas = masscan.PortScanner()
try:
    mas.scan(options.range, ports=checkports, arguments='--banners --source-ip 192.168.1.200 --rate 100000000')
except: 
    print("No Open Ports Found!")
    sys.exit(1)
#pprint.pprint(mas.scan_result)
#pprint.pprint(mas.scan_result['scan'])
#pprint.pprint(mas.scan_result.items())
for ip, ip_info, in mas.scan_result['scan'].items():
    for protocal, protocal_info in ip_info.items():
        for port in protocal_info.keys():
            import pdb; pdb.set_trace()

            # HTTP Checks
            if port in http:
                url = "http://"+ip+":"+str(port)
                try:
                    response = requests.get(url+"/favicon.ico", stream=True)
                except requests.exceptions.RequestException as e:  # This is the correct syntax
                    print(e)
                    sys.exit(1)
                if response.status_code != 404:
                    hashVal = hashlib.md5(response.content).hexdigest()
                    # https://www.owasp.org/index.php/OWASP_favicon_database
                    # check if its Tomcat
                    if hashVal == "4644f2d45601037b8423d45e13194c93":
                        cprint('[+] ', 'green', attrs=['bold'], end='')
                        print("Found Tomcat: %s " % (url))
                    # check if its Jenkins 
                    elif hashVal == "23e8c7bd78e8cd826c5a6073b15068b1":
                        cprint('[+] ', 'green', attrs=['bold'], end='')
                        print("Found Jenkins: %s " % (url))

            #import pdb; pdb.set_trace()
            # SSH Checks
            if port == 22:
                if protocal_info[22]['services'] != []:
                    cprint('[+] ', 'green', attrs=['bold'], end='')
                    print("Found SSH on %s " % (ip),end='')
                    print(protocal_info[22]['services'][0]['banner'])
                    if "OpenSSH" in protocal_info[22]['services'][0]['banner']:
                        cprint(' Potential Vulneribility', 'red', attrs=['bold'])

        #for port, port_info in protocal_info.items():
            #for key, info in port_info.items(:
            #    if "SSH" in protocal_info[22]['services'][0]['banner']:
             #       print("Found SSH on %s" % (ip))s
       # for key, value in port_info:
        #    pprint.pprint(value)

#import pdb; pdb.set_trace()
#pprint.pprint(mas.scan_result['scan']['192.168.1.1'])


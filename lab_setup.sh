#!/bin/bash

read -p 'enter the range of ip: '  ip_range
read -p 'enter dhcp: ' dhcp
exe=`route | grep default | awk -F" " '{print $2}'`
nmap -n $ip_range -T5 --exclude $(hostname -I | cut -d" " -f1),$exe,$dhcp | grep -i Nmap\ scan | cut -d" " -f5 > host.txt

rm hosts
for i in `cat host.txt`; do
	echo "$i station$(echo $i | cut -d"." -f4)" >> hosts
done


for i in `cat host.txt`; do
	sshpass -padhoc ssh-copy-id -o StrictHostKeyChecking=no  adhoc@$i  
done

for i in `cat host.txt`; do
	ssh -t -o StrictHostKeyChecking=no adhoc@$i 'echo adhoc | sudo -S hostnamectl set-hostname station'$(echo $i | cut -d"." -f4) 
done

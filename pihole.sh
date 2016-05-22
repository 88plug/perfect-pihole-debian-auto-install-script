#!/bin/bash
begin=$(date +"%s")
echo “88plug pihole for Debian 8.3 x64”
echo "Welcome to the 88plug pihole install script.  \
This setup will guide you through a pihole and dnscrypt installation on Debian 8.3 x64.  \
This has been tested on DigitalOcean with a 2gb server and runs brilliantly.\
You will be prompted to reboot during this install.  Please be prepared.\
The default servers are using soltysiak-ipv6 and ipv4 with d0wn-random-ns1.\
"
echo "This installer will install what's required.  You have complete control over what gets installed.  Choosing Y to all the options is the default installation method."
echo "Note***\
The pihole installed sometimes does not properly detect your correct IP address so be prepared to enter it manually during setup.\
"
read -p "First time running the installer?  Select Yes to setup packages. If you have already rebooted after first time setup, choose No to install pihole (y/n)  " RESP
if [ "$RESP" = "y" ]; then
apt-get update --fix-missing
			read -p "Would you like to upgrade your distribution? (y/n)  " RESP
			if [ "$RESP" = "y" ]; then
			apt-get --yes dist-upgrade 
			echo "New distribution upgrade complete.  Installing required packages."
			aptitude -y install lighttpd lighttpd-doc
			apt-get --yes install sudo htop bmon curl wget sendmail build-essential tcpdump dnsutils libsodium-dev locate bash-completion php5-cgi php5-common php5 figlet toilet bc git unzip
			read -p "Reboot?  Select Yes to reboot and re-run the installer again to continue. Choose No to continue installing pihole without rebooting (dangerous) (y/n)  " RESP
					if [ "$RESP" = "y" ]; then
					reboot
					else
					echo "Not rebooting...continuing install."
						curl -L https://install.pi-hole.net | bash
					fi
			else
			echo "No distribution upgrade installed.  Continuing to required packages..."
			aptitude -y install lighttpd lighttpd-doc
			apt-get --yes install sudo htop bmon curl wget sendmail build-essential tcpdump dnsutils libsodium-dev locate bash-completion php5-cgi php5-common php5 figlet toilet bc git unzip
			fi
else
echo "No packages installed...but we still need pihole!"
	curl -L https://install.pi-hole.net | bash
fi
read -p "Install dnscrypt? If NO - setup pihole normally (y/n)  " RESP
if [ "$RESP" = "y" ]; then
	echo “dnsproxy Setup”
	mkdir -p dnsproxy
	cd dnsproxy
	wget http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.6.1.tar.gz
	tar -xf dnscrypt-proxy-1.6.1.tar.gz
	cd dnscrypt-proxy-1.6.1
	ldconfig
	./configure
	make
	make install
	echo “dnsproxy Setup Completed”
	sudo mv /etc/resolv.conf /etc/resol.conf.ORIG
	echo nameserver 127.0.0.1#40 >> /etc/resolv.conf
	echo nameserver 127.0.0.1#41 >> /etc/resolv.conf
	chattr +i /etc/resolv.conf
cat >/etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service <<EOL
[Unit]
Description=Secure connection between your computer and DNS resolver
After=network.target network-online.target
[Service]
Type=forking
Restart=always
RestartSec=5
PIDFile=/var/run/dnscrypt-proxy.pid
ExecStart=/usr/local/sbin/dnscrypt-proxy –daemonize \
-a 127.0.0.1:40 \
-R ovpnto-se \
-E \
–edns-payload-size=4096 \
-p /var/run/dnscrypt-proxy.pid
[Install]
WantedBy=multi-user.target

[Unit]
Description=Secure connection between your computer and DNS resolver
After=network.target network-online.target
[Service]
Type=forking
Restart=always
RestartSec=5
PIDFile=/var/run/dnscrypt-proxy.pid
ExecStart=/usr/local/sbin/dnscrypt-proxy –daemonize \
-a 127.0.0.1:41 \
-R soltysiak-ipv6 \
-E \
–edns-payload-size=4096 \
-p /var/run/dnscrypt-proxy.pid
[Install]
WantedBy=multi-user.target
EOL
echo “Setup New pihole Configurations”
rm /etc/dnsmasq.d/01-pihole.conf
cat >/etc/dnsmasq.d/01-pihole.conf <<EOL
# Pi-hole: A black hole for Internet advertisements
# (c) 2015, 2016 by Jacob Salmela
# Network-wide ad blocking via your Raspberry Pi
# http://pi-hole.net
# dnsmasq config for Pi-hole
#
# Pi-hole is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.

# If you want dnsmasq to read another file, as well as /etc/hosts, use
# this.
addn-hosts=/etc/pihole/gravity.list

# The following two options make you a better netizen, since they
# tell dnsmasq to filter out queries which the public DNS cannot
# answer, and which load the servers (especially the root servers)
# unnecessarily. If you have a dial-on-demand link they also stop
# these requests from bringing up the link unnecessarily.

# Never forward plain names (without a dot or domain part)
domain-needed
# Never forward addresses in the non-routed address spaces.
bogus-priv

# If you don't want dnsmasq to read /etc/resolv.conf or any other
# file, getting its servers from this file instead (see below), then
# uncomment this.
no-resolv

# Add other name servers here, with domain specs if they are for
# non-public domains.
server=127.0.0.1#40
server=127.0.0.1#41
#From https://dns.watch/index if you need. no logging, DNSSEC enabled
#server=84.200.69.80
#server=84.200.70.40
#server=2001:1608:10:25::1c04:b12f
#server=2001:1608:10:25::9249:d69b
# If you want dnsmasq to listen for DHCP and DNS requests only on
# specified interfaces (and the loopback) give the name of the
# interface (eg eth0) here.
interface=eth0
# Or which to listen on by address (remember to include 127.0.0.1 if
# you use this.)
listen-address=127.0.0.1

# Set the cachesize here.
cache-size=10000

# For debugging purposes, log each DNS query as it passes through
# dnsmasq.
log-queries
log-facility=/var/log/pihole.log

# Normally responses which come from /etc/hosts and the DHCP lease
# file have Time-To-Live set as zero, which conventionally means
# do not cache further. If you are happy to trade lower load on the
# server for potentially stale date, you can set a time-to-live (in
# seconds) here.
local-ttl=300

# This allows it to continue functioning without being blocked by syslog, and allows syslog to use dnsmasq for DNS queries without risking deadlock
log-async
EOL
	echo "pihole is installed - now what?"
			read -p "Would you like to reboot (recommended) (y/n)  " RESP
			if [ "$RESP" = "y" ]; then
						termin=$(date +"%s")
						difftimelps=$(($termin-$begin))
						echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for pihole installation."
			echo "May the force be with you.  pihole installed.  Rebooting."
			reboot
			else
						termin=$(date +"%s")
						difftimelps=$(($termin-$begin))
						echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for pihole installation."
			echo "May the force be with you.  pihole installed.  Not Rebooting."
			fi
else
	echo "pihole is installed - now what?"

			read -p "Would you like to reboot (recommended) (y/n)  " RESP
			if [ "$RESP" = "y" ]; then
						termin=$(date +"%s")
						difftimelps=$(($termin-$begin))
						echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for pihole installation."
			echo "May the force be with you.  pihole installed.  Rebooting."
			reboot
			else
						termin=$(date +"%s")
						difftimelps=$(($termin-$begin))
						echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for pihole installation."
			echo "May the force be with you.  pihole installed.  Not Rebooting."
			fi
fi

<h3>A Perfect PiHole on Debian 8.3 x64 compatible with DigitalOcean (2gb) and other VPS providers.</h3>
<img src="https://www.evernote.com/shard/s6/sh/27d97183-5e95-43da-8053-972013556b8e/bb5dec2e3c36e4bb/res/ec6e4d80-df21-4dbb-ba44-34c213671b37/skitch.png?resizeSmall&width=832"/>

Uses by default <b>non-logging, dnssec enabled upstream nameservers.</b>
Passes <a href="https://www.dnsleaktest.com/">DNS Leak Test</a> and <a href="https://ipleak.net/">IPLeak.net</a> extended tests

<b>pihole.sh will allow you to :</b><br>
-Update your machine and configure prerequisite packages<br>
-Install pihole<br>
-Install dnscrypt<br>

Each step is optional and you can run pihole.sh multiple times to customize the installation.<br>
DNSCrypt Version : 1.6.1

<b>Install/Run:</b>
```bash
git clone https://github.com/88plug/perfect-pihole-debian-auto-install-script.git
cd perfect-pihole-debian-auto-install-script
chmod +x pihole.sh
sudo ./pihole.sh
```

<b>Install Notes:</b><br>
When asked what upstream name servers you would like during install, please select Google.  These will be changed during the setup process.  The installer doesn't always select the correct IP address. Be sure to verify your IP address matches the selected value during the setup questions.  

<a href="https://github.com/pi-hole/pi-hole/wiki/DNSCrypt">DNS Crypt Info</a><br>
<a href="https://github.com/pi-hole/pi-hole/blob/master/advanced/Scripts/piholeDebug.sh">PiHole Debugger</a><br>
<a href="https://github.com/pi-hole/pi-hole/issues/170">DNSSEC Validation</a><br>
More information available at <a href="https://88plug.com">88plug.com</a>


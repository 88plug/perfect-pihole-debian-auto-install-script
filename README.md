# perfect-pihole-debian-auto-install-script
A Perfect PiHole on Debian 8.3 x64 compatible with DigitalOcean (2gb) and other VPS providers.

<b>pihole.sh will allow you to :</b><br>
-Update your machine and configure prerequisite packages<br>
-Install pihole<br>
-Install dnscrypt<br>

Each step is optional and you can run pihole.sh multiple times to customize the installation.

<b>Install/Run:</b>
```bash
git clone https://github.com/88plug/perfect-pihole-debian-auto-install-script.git
cd perfect-pihole-debian-auto-install-script
chmod +x pihole.sh
sudo ./pihole.sh
```

<a href="https://github.com/pi-hole/pi-hole/wiki/DNSCrypt">DNS Crypt Info</a><br>
<a href="https://github.com/pi-hole/pi-hole/blob/master/advanced/Scripts/piholeDebug.sh">PiHole Debugger</a><br>
<a href="https://github.com/pi-hole/pi-hole/issues/170">DNSSEC Validation</a><br>
More information available at <a href="https://88plug.com">88plug.com</a>

<p><span style="text-decoration: underline;"><strong>Setting Up <a target=_blank href="http://www.squid-cache.org/">Squid HTML Proxy</a> under <a target=_blank href="https://cygwin.com/">Cygwin</a> to Split Browser Traffic</strong></span><br />
 <br />
<a target=_blank href="http://www.squid-cache.org/">Squid</a> is an HTML proxy. And it is available as a package for <a target=_blank href="https://cygwin.com/">Cygwin</a>, which is "a large collection of GNU and Open Source tools which provide functionality similar to a Linux distribution on Windows". This post explains how it can be used to be able to browse over the VPN (even using AirVPN's DNS) in one browser instance, while leaving the default gateway as the native/real gateway and also browsing (or whatever) over that simultaneously. It is also possible to use several web rippers through it - <a target=_blank href="https://github.com/get-iplayer/get_iplayer/wiki/windows">get_iplayer</a>, <a target=_blank href="https://github.com/rg3/youtube-dl/">youtube-dl</a> and <a target=_blank href="https://github.com/K-S-V/Scripts/wiki">AdobeHDS</a>.</p>

<p>To make the installation and set up easier, I put together some scripts that make it fairly easy (I believe). These are in the zip file:</p>

<p><a target=_blank href=https://raw.githubusercontent.com/tool-maker/VPN_just_for_torrents/master/cygwin_squid.zip>cygwin_squid.zip</a><br />
 <br />
The contents of the scripts are also shown at the end of this post.<br />
 <br />
This post explains how to use these scripts. You can of course change the various scripts in this folder as you see fit. In fact, you definitely will need to inspect them to understand what is going on here. And follow some of the web links. The instructions are very brief.</p>

<p>Here are the contents of the folder in the zip file for reference:<br />
<pre>C:batcygwin_squid>dir /B
Command Line Options - Mozilla MDN.URL
Cygwin Installation.URL
Cygwin.URL
cygwin_install.bat
cygwin_installer_download.bat
cygwin_installer_help.bat
firefox_create_profile.bat
firefox_profile_manager.bat
firefox_with_squid_VPN_tester_profile.bat
mkshortcut.js
README.html
squid Optimising Web Delivery.URL
squid_setup.sh
squid_setup_mine.bat
squid_setup_native.bat
squid_setup_VPN.bat
squid_shortcuts_setup.bat
squid_start.bat
squid_status.bat
squid_stop.bat
Use the Profile Manager to create and remove Firefox profiles Firefox Help.URL
</pre><br />
Here are the steps to set this up (run a ".bat" by double-clicking):<br />
<ol style="list-style-type: decimal"><li>Run <strong><span style="font-family: courier;">cygwin_installer_download.bat</span></strong> to download the <a target=_blank href="https://cygwin.com/install.html">Cygwin 32-bit installer</a>, <a target=_blank href="https://cygwin.com/setup-x86.exe"><span style="font-family: courier;">setup-x86.exe</span></a>.[/*]<br />
<p><li>Now that we have the installer, install the necessary Cygwin packages to run squid by running <strong><span style="font-family: courier;">cygwin_install.bat</span></strong>.<br />
The Cygwin installation will go in <span style="font-family: courier;">C:cygwin_squid</span>, unless you change the script, or pick a different destination. Note that <span style="font-family: courier;">C:cygwin_squid</span> appears in several other scripts.<br />
Just keep pressing the "Next" button. Except that you will have to select a mirror site. University sites are usually good.[/*]<br />
<p><li>Now start the OpenVPN tunnel.[/*]<br />
<p><li><span style="text-decoration: underline;">This step relies on there being a "128.0.0.0/128.0.0.0" routing table entry</span>, which OpenVPN will install if left to its default behaviour (<a target=_blank href="https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage">"<span style="font-family: courier;">redirect-gateway def1</span>"</a>). With the OpenVPN tunnel running, run <strong><span style="font-family: courier;">squid_setup_VPN.bat</span></strong> to create the squid configuration file <span style="font-family: courier;">squid.conf</span>, (in the same folder). Lines similar to these will be put in front of the standard Cygwin squid configuration file:<br />
<pre> 
tcp_outgoing_address 10.4.??.??

dns_nameservers 10.4.0.1

http_port 127.0.0.1:3128
acl localnet src 127.0.0.1
http_access allow localnet

# below copied from /etc/squid/squid.conf

</pre><br />
In order to determine the values to be used for <span style="font-family: courier;">tcp_outgoing_address</span> and <span style="font-family: courier;">dns_nameservers</span>, <span style="font-family: courier;">squid_setup_VPN.bat</span> scans the output of "<span style="font-family: courier;">route print</span>" for the "128.0.0.0/128.0.0.0" routing table entry. If there is a problem with this, you will have to specify values for <span style="font-family: courier;">tcp_outgoing_address</span> and <span style="font-family: courier;">dns_nameservers</span> in <span style="font-family: courier;">squid.conf</span> yourself (or fix <span style="font-family: courier;">squid_setup_VPN.bat</span> yourself).[/*]<br />
<p><li>To start squid run <strong><span style="font-family: courier;">squid_start.bat</span></strong>. There will be <span style="text-decoration: underline;">no minimized window</span> or anything. You will just have squid running in the background.</p>

<p>To see the status of squid run <strong><span style="font-family: courier;">squid_status.bat</span></strong>. This just shows all running Cygwin processes. Just look for "squid" in the output.</p>

<p>To stop squid run <strong><span style="font-family: courier;">squid_stop.bat</span></strong>. It may take several seconds for suid to stop, even when you try to shut down Windows. I suggest that you stop it first. You can keep running <strong><span style="font-family: courier;">squid_status.bat</span></strong> in order to be sure it is gone.[/*]<br />
<p><li>You can <span style="text-decoration: underline;">create shortcuts</span> to <span style="font-family: courier;">squid_setup_VPN.bat</span>, <span style="font-family: courier;">squid_start.bat</span>, <span style="font-family: courier;">squid_status.bat</span> and <span style="font-family: courier;">squid_stop.bat</span> by running <strong><span style="font-family: courier;">squid_shortcuts_setup.bat</span></strong>. These shortcuts can then be moved or copied somewhere more convenient.[/*]<br />
<p><li>You will need to <span style="text-decoration: underline;">set up your browser to use the squid HTML proxy</span> now available at 127.0.0.1:3128.</p>

<p>For Firefox you can do this using the "Open menu" icon in the upper right corner. Select "Options" there and then "Advanced/Network/Connection/Settings". In that property page select "Manual proxy configuration" and "Use this proxy server for all protocols". And fill in "localhost" for "HTTP Proxy" with "3128" for "Port".[/*]<br />
<p><li>If you want to be able to <span style="text-decoration: underline;">browse through the VPN at the same time as you browse normally</span>, again with Firefox, you can set up a separate profile just for browsing through squid.</p>

<p>If you have installed Firefox in the default location, you should be able to <span style="text-decoration: underline;">launch the Firefox profile manager</span> by running <strong><span style="font-family: courier;">firefox_profile_manager.bat</span></strong>. Or create a shortcut with a command line as in that file.</p>

<p>If you create a profile called "squid_VPN_tester" you can <span style="text-decoration: underline;">launch Firefox with the "squid_VPN_tester" profile</span> using <strong><span style="font-family: courier;">firefox_with_squid_VPN_tester_profile.bat</span></strong>. Or create a shortcut with a command line as in that file.</p>

<p>As a quick and dirty way to set up a profile named "squid_VPN_tester" with its profile folder as "<span style="font-family: courier;">profile_squid_VPN_tester</span>" within the current you can run "<strong><span style="font-family: courier;">firefox_create_profile.bat</span></strong>". Remember to remove it later with the Profile Manager.[/*]</ol><br />
<strong>==================================</strong></p>

<p>Here are the contents of the scripts:</p>

<p><strong>+++++ cygwin_install.bat +++++</strong><br />
<pre>@rem Download setup-x86.exe or setup-x86_64.exe (not both) from https://cygwin.com/install.html.
@rem Then copy this file to the same folder and run.

@rem This will install to C:cygwin_squid (see below), unless you change it.

@if not exist setup-x86.exe (
 @if not exist setup-x86_64.exe (
   @echo neither setup-x86.exe nor setup-x86_64.exe is presnt
   @echo download one of them to this folder from https://cygwin.com/install.html
   @echo or use cygwin_installer_download.bat to download setup-x86.exe
   @pause
   @exit
 )
)

@set PACKAGES=
@set PACKAGES=%PACKAGES% -P squid

@for %%f in (setup-x86*.exe) do @set p=%%f
start %p% -B -N -R C:cygwin_squid -l %~d0%~p0 %PACKAGES%
@pause
</pre><br />
<strong>+++++ cygwin_installer_download.bat +++++</strong><br />
<pre>powershell -Command "(new-object System.Net.WebClient).DownloadFile('https://cygwin.com/setup-x86.exe','setup-x86.exe')"
@pause
</pre><br />
<strong>+++++ cygwin_installer_help.bat +++++</strong><br />
<pre>@rem Download setup-x86.exe or setup-x86_64.exe (not both) from https://cygwin.com/install.html.
@rem Then copy this file to the same folder and run.

@rem This will install to C:cygwin_openvpn_build (see below), unless you change it. If you
@rem   change it here, change it in cygwin_here.bat too.

@if not exist setup-x86.exe (
 @if not exist setup-x86_64.exe (
   @echo neither setup-x86.exe nor setup-x86_64.exe is presnt
   @echo download one of them to this folder from https://cygwin.com/install.html
   @echo or use cygwin_installer_download.bat to download setup-x86.exe
   @pause
   @exit
 )
)

@for %%f in (setup-x86*.exe) do @set p=%%f
%p% -help
@pause
</pre><br />
<strong>+++++ firefox_create_profile.bat +++++</strong><br />
<pre>path "C:Program Files (x86)Mozilla Firefox";"C:Program FilesMozilla Firefox";%PATH%
@set PROFILE_DIR="%~d0%~p0profile_squid_VPN_tester"
@echo.
@echo will put profile folder for squid_VPN_tester in "%PROFILE_DIR%"
@echo close window if that is not what you want
@pause
firefox -no-remote -CreateProfile "squid_VPN_tester %PROFILE_DIR%"
@pause
</pre><br />
<strong>+++++ firefox_profile_manager.bat +++++</strong><br />
<pre>path "C:Program Files (x86)Mozilla Firefox";"C:Program FilesMozilla Firefox";%PATH%
start firefox -no-remote -ProfileManager
@pause
</pre><br />
<strong>+++++ firefox_with_squid_VPN_tester_profile.bat +++++</strong><br />
<pre>path "C:Program Files (x86)Mozilla Firefox";"C:Program FilesMozilla Firefox";%PATH%
start firefox -no-remote -p squid_VPN_tester
@pause
</pre><br />
<strong>+++++ mkshortcut.js +++++</strong><br />
<pre>args = WScript.Arguments;

target = args(0);
shortcut = args(1);
//WScript.Echo("target: " + target);
//WScript.Echo("shortcut: " + shortcut);

shell = WScript.CreateObject("WScript.Shell");

link = shell.CreateShortcut(shortcut + ".lnk");

link.TargetPath = target;
//link.WorkingDirectory = "";
//link.WindowStyle = 1;
link.Save();
</pre><br />
<strong>+++++ squid_setup.sh +++++</strong><br />
<pre>#!/bin/bash

IP_OUT=$1
if [ x$IP_OUT == x ]; then
  IP_OUT=10.4.?.?
fi
echo using $IP_OUT for tcp_outgoing_address ...

IP_DNS=$2
if [ x$IP_DNS == x ]; then
  IP_OUT=10.4.0.1
fi
echo using $IP_DNS for dns_nameservers ...

rm squid.conf.old
mv squid.conf squid.conf.old
echo >> squid.conf

echo tcp_outgoing_address $IP_OUT >> squid.conf

echo >> squid.conf

echo dns_nameservers $IP_DNS >> squid.conf

echo >> squid.conf

echo http_port 127.0.0.1:3128 >> squid.conf
echo acl localnet src 127.0.0.1 >> squid.conf
echo http_access allow localnet >> squid.conf

echo >> squid.conf
echo "# below copied from /etc/squid/squid.conf" >> squid.conf
echo >> squid.conf

cat /etc/squid/squid.conf >> squid.conf

echo ... created squid.conf
</pre><br />
<strong>+++++ squid_setup_mine.bat +++++</strong><br />
<pre>@echo off
cd %~p0
C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; ./squid_setup.sh 10.89.0.2 10.89.0.1"
pause

</pre><br />
<strong>+++++ squid_setup_native.bat +++++</strong><br />
<pre>@echo off
cd %~p0

@rem scan routing table to get native/original gateway address and address of native gateway interface
@rem echo %~n0%~x0
@set temp_file_route=%TEMP%%~n0%~X0_temp.txt
@rem echo %temp_file_route%
@route print | findstr /r /c:" 0.0.0.0 *.*.0.0.0 " | findstr /v /l /c:" On-link " > %temp_file_route%
@rem echo default gateway entry from routing table:
@rem type %temp_file_route%
@for /f "tokens=3,4" %%a in (%temp_file_route%) do @set GATEWAY_GW=%%a & set GATEWAY_IP=%%b
@erase %temp_file_route%
@rem echo gateway: %GATEWAY_GW%
@rem echo address: %GATEWAY_IP%

C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; ./squid_setup.sh %GATEWAY_IP% %GATEWAY_GW%"
pause
</pre><br />
<strong>+++++ squid_setup_shortcuts.bat +++++</strong><br />
<pre>@cd %~p0

cscript //Nologo "mkshortcut.js" "%~p0squid_start.bat"     "squid start"
cscript //Nologo "mkshortcut.js" "%~p0squid_status.bat"    "squid status"
cscript //Nologo "mkshortcut.js" "%~p0squid_stop.bat"      "squid stop"
cscript //Nologo "mkshortcut.js" "%~p0squid_setup_VPN.bat" "squid configure for VPN"

@pause
</pre><br />
<strong>+++++ squid_setup_VPN.bat +++++</strong><br />
<pre>@echo off
cd %~p0

@rem scan routing table to get VPN gateway address and address of VPN gateway interface
@rem echo %~n0%~x0
@set temp_file_route=%TEMP%%~n0%~X0_temp.txt
@rem echo %temp_file_route%
@route print | findstr /r /c:" 128.0.0.0 *128.0.0.0 " | findstr /v /l /c:" On-link " > %temp_file_route%
@rem echo default gateway entry from routing table:
@rem type %temp_file_route%
@for /f "tokens=3,4" %%a in (%temp_file_route%) do @set GATEWAY_GW=%%a & set GATEWAY_IP=%%b
@erase %temp_file_route%
@rem echo gateway: %GATEWAY_GW%
@rem echo address: %GATEWAY_IP%

C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; ./squid_setup.sh %GATEWAY_IP% %GATEWAY_GW%"
pause
</pre><br />
<strong>+++++ squid_start.bat +++++</strong><br />
<pre>@echo off
cd %~p0
C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; /usr/sbin/squid -f $PWD/squid.conf"
pause
</pre><br />
<strong>+++++ squid_status.bat +++++</strong><br />
<pre>@echo off
cd %~p0
@rem C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; ps | grep squid -"
C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; ps"
pause
</pre><br />
<strong>+++++ squid_stop.bat +++++</strong><br />
<pre>@echo off
cd %~p0
C:cygwin_squidbinbash --login -c "cd "$OLDPWD"; /usr/sbin/squid -k shutdown -f $PWD/squid.conf"
pause
</pre></p>

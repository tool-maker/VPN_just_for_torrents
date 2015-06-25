***Table of Contents***

&nbsp;&nbsp;***Guide to Setting Up VPN Just for Torrenting on Windows - Part 1***

&nbsp;&nbsp;&nbsp;&nbsp;***Purpose and Goals***

&nbsp;&nbsp;&nbsp;&nbsp;***IP Interfaces and Routing Table***

&nbsp;&nbsp;&nbsp;&nbsp;***Installing OpenVPN***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*IP Interfaces Before Install*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Routing Table Before Install*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*IP Interfaces with VPN Down*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Routing Table with VPN Down*

&nbsp;&nbsp;&nbsp;&nbsp;***Configuring OpenVPN to Access Servers***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*IP Interfaces with VPN Up*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Routing Table with VPN Up*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Comparison of Routing Table with VPN Up Versus Down*

&nbsp;&nbsp;&nbsp;&nbsp;***Setting Up Port Forwarding***

&nbsp;&nbsp;&nbsp;&nbsp;***A Very Active Copyright Free Torrent to Test With***

&nbsp;&nbsp;&nbsp;&nbsp;***Checking That the VPN Is Working***

&nbsp;&nbsp;***Guide to Setting Up VPN Just for Torrenting on Windows - Part 2***

&nbsp;&nbsp;&nbsp;&nbsp;***Routing Table Functionality***

&nbsp;&nbsp;&nbsp;&nbsp;***Advanced Set Up for Windows XP***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***Set Up for Windows XP Firewall***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***Routing Table Change to Block Outgoing Native Traffic***

&nbsp;&nbsp;&nbsp;&nbsp;***Advanced Set Up for Windows Vista and Windows 7***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***Set Up for Windows Firewall with Advanced Security***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Rules for Incoming Connections*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Rules for Outgoing Connections*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Specifying the Properties for a Firewall Rule*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***Set Up for Torrent Clients***

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Setting IP Interface for uTorrent*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Setting IP Interface for Vuze*

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***Routing Table Changes to Restore Native Gateway***

***

***Guide to Setting Up VPN Just for Torrenting on Windows - Part 1***

***Purpose and Goals***

This guide is about setting up a VPN service on Windows using AirVPN.

The goal here is to use the VPN only for torrent clients and the normal gateway for all other activities. This way my normal activities are not impacted by:

* reduced effective bandwidth
* detectable delays in response while browsing due to increased latency ("latency" is the time it takes for a packet to transit)
* security panics by sites I use that worry about security when my apparent location in the world changes
* sites I browse regularly (that require log in credentials and) that will block (and potentially ban) me if I browse them using a VPN

I am using Windows 7. But this guide also discusses XP and Vista. Details are provided below. Here is a summary of what I do on Windows 7.

*I use the VPN only for my torrent clients*.

To achieve this, I override the "0.0.0.0/128.0.0.0" and "128.0.0.0/128.0.0.0" routing table entries set up by the OpenVPN client with "0.0.0.0/192.0.0.0", "64.0.0.0/192.0.0.0", "128.0.0.0/192.0.0.0" and "192.0.0.0/192.0.0.0" entries to use my normal gateway for most activities. I have two .bat files that allow me to quickly insert or delete these in order to use the VPN for web browsing when I want to.

I also then need to tell my torrent clients (uTorrent and Vuze are discussed in this guide) to use the VPN interface, since it will now not be used by default. For Vuze one can specify the interface. But for uTorrent one has to specify the IP address.

So long as I continue to use the same AirVPN server, since my DHCP license is for a year I do not need to change the uTorrent configurations. If I wish to change the AirVPN server, I have to change IP address uTorrent uses. This is not a lot of work. At the time of writing, AirVPN does not allow one to have a fixed local IP address for the VPN interface, otherwise this could be avoided.

*I also configure Windows firewall to block all traffic from torrent clients using the default gateway*. So if the VPN goes down, even if Windows decides to ignore the request to bind to a specific interface/IP and bind to my default gateway (apparently Windows may do this?), nothing leaks out using my own IP address.

Although I am using Windows 7, I have tried setting up a similar scheme to mine using Windows XP and Windows Vista, in the hope of making this guide more useful. I suspect many people are still using XP and Vista. I succeeded in this goal for Vista. However for XP, I was not able to achieve the goal of using the native interface for normal activities while using the VPN for the torrent clients.

I describe the results below. For examples, I use the earliest version of Windows possible, since the examples are often simpler that way, and you should be able to adapt the information to a later release easily.

I try to make minimal assumptions about the readers background, in the hope that this will be useful to non-technical readers. To this end, I try to explain the role of IP interfaces and the routing table in networking and how to obtain important information about these.

***IP Interfaces and Routing Table***

In a couple of places in what follows I use two commands at the the Windows "Command Prompt" to reveal some useful things about what setting up a VPN does in terms Windows IP interfaces and the Windows routing table. The commands are "ipconfig/all" and "route print".

***Installing OpenVPN***

Get the "community" version of the unaltered OpenVPN client:

[http://openvpn.net/index.php/open-source/downloads.html](http://openvpn.net/index.php/open-source/downloads.html)

If you have a the 64-bit version of Windows then get the 64-bit version of OpenVPN - "openvpn-install-?-x86_64.exe". But if you do not have 64-bit Windows use the 32-bit version - "openvpn-install-?-i686.exe".

Before you install it, use the "ipconfig/all" and "route print" commands at a Windows command prompt. You will get something similar to this:

*IP Interfaces Before Install*

	C:\Documents and Settings\user>ipconfig /all
	
	Windows IP Configuration
	
	        Host Name . . . . . . . . . . . . : xp
	        Primary Dns Suffix  . . . . . . . :
	        Node Type . . . . . . . . . . . . : Unknown
	        IP Routing Enabled. . . . . . . . : No
	        WINS Proxy Enabled. . . . . . . . : No
	
	Ethernet adapter Local Area Connection:
	
	        Connection-specific DNS Suffix  . :
	        Description . . . . . . . . . . . : VMware Accelerated AMD PCNet Adapter
	        Physical Address. . . . . . . . . : 00-0C-29-A2-B9-61
	        Dhcp Enabled. . . . . . . . . . . : Yes
	        Autoconfiguration Enabled . . . . : Yes
	        IP Address. . . . . . . . . . . . : 192.168.1.69
	        Subnet Mask . . . . . . . . . . . : 255.255.255.0
	        Default Gateway . . . . . . . . . : 192.168.1.254
	        DHCP Server . . . . . . . . . . . : 192.168.1.254
	        DNS Servers . . . . . . . . . . . : 192.168.1.254
	                                            75.153.176.1
	        Lease Obtained. . . . . . . . . . : Wednesday, March 06, 2013 2:05:50 PM
	        Lease Expires . . . . . . . . . . : Thursday, March 07, 2013 2:05:50 PM

*Routing Table Before Install*

	C:\Documents and Settings\user>route print
	===========================================================================
	Interface List
	0x1 ........................... MS TCP Loopback interface
	0x2 ...00 0c 29 a2 b9 61 ...... AMD PCNET Family PCI Ethernet Adapter - Packet Scheduler Miniport
	===========================================================================
	===========================================================================
	Active Routes:
	Network Destination        Netmask          Gateway       Interface  Metric
	          0.0.0.0          0.0.0.0    192.168.1.254    192.168.1.69       10
	        127.0.0.0        255.0.0.0        127.0.0.1       127.0.0.1       1
	      192.168.1.0    255.255.255.0     192.168.1.69    192.168.1.69       10
	     192.168.1.69  255.255.255.255        127.0.0.1       127.0.0.1       10
	    192.168.1.255  255.255.255.255     192.168.1.69    192.168.1.69       10
	        224.0.0.0        240.0.0.0     192.168.1.69    192.168.1.69       10
	  255.255.255.255  255.255.255.255     192.168.1.69    192.168.1.69       1
	Default Gateway:     192.168.1.254
	===========================================================================
	Persistent Routes:
	  None

Install it.

You may get an "unsigned driver" warning message for the TAP driver that OpenVPN uses to create an IP interface in Windows (saying it could destabilize your system). For Windows XP it looks like this:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/openvpnwarning.jpg)

*Ignore the warning*. It works fine on Windows XP (or Vista, Windows 7 or Windows 8).

At this point, again use the "ipconfig/all" and "route print" commands at a Windows command prompt. You will get something similar to this:

*IP Interfaces with VPN Down*

	C:\Documents and Settings\user>ipconfig /all
	
	Windows IP Configuration
	
	        Host Name . . . . . . . . . . . . : xp
	        Primary Dns Suffix  . . . . . . . :
	        Node Type . . . . . . . . . . . . : Unknown
	        IP Routing Enabled. . . . . . . . : No
	        WINS Proxy Enabled. . . . . . . . : No
	
	Ethernet adapter Local Area Connection:
	
	        Connection-specific DNS Suffix  . :
	        Description . . . . . . . . . . . : VMware Accelerated AMD PCNet Adapter
	        Physical Address. . . . . . . . . : 00-0C-29-A2-B9-61
	        Dhcp Enabled. . . . . . . . . . . : Yes
	        Autoconfiguration Enabled . . . . : Yes
	        IP Address. . . . . . . . . . . . : 192.168.1.69
	        Subnet Mask . . . . . . . . . . . : 255.255.255.0
	        Default Gateway . . . . . . . . . : 192.168.1.254
	        DHCP Server . . . . . . . . . . . : 192.168.1.254
	        DNS Servers . . . . . . . . . . . : 192.168.1.254
	                                            75.153.176.1
	        Lease Obtained. . . . . . . . . . : Wednesday, March 06, 2013 2:05:50 PM
	        Lease Expires . . . . . . . . . . : Thursday, March 07, 2013 2:05:50 PM
	
	Ethernet adapter Local Area Connection 4:
	
	        Media State . . . . . . . . . . . : Media disconnected
	        Description . . . . . . . . . . . : TAP-Windows Adapter V9
	        Physical Address. . . . . . . . . : 00-FF-42-5E-D2-9E

*Routing Table with VPN Down*

	C:\Documents and Settings\user>route print
	===========================================================================
	Interface List
	0x1 ........................... MS TCP Loopback interface
	0x2 ...00 0c 29 a2 b9 61 ...... AMD PCNET Family PCI Ethernet Adapter - Packet Scheduler Miniport
	0x3 ...00 ff 42 5e d2 9e ...... TAP-Windows Adapter V9 - Packet Scheduler Miniport
	===========================================================================
	===========================================================================
	Active Routes:
	Network Destination        Netmask          Gateway       Interface  Metric
	          0.0.0.0          0.0.0.0    192.168.1.254    192.168.1.69       10
	        127.0.0.0        255.0.0.0        127.0.0.1       127.0.0.1       1
	      192.168.1.0    255.255.255.0     192.168.1.69    192.168.1.69       10
	     192.168.1.69  255.255.255.255        127.0.0.1       127.0.0.1       10
	    192.168.1.255  255.255.255.255     192.168.1.69    192.168.1.69       10
	        224.0.0.0        240.0.0.0     192.168.1.69    192.168.1.69       10
	  255.255.255.255  255.255.255.255     192.168.1.69    192.168.1.69       1
	  255.255.255.255  255.255.255.255     192.168.1.69               3       1
	Default Gateway:     192.168.1.254
	===========================================================================
	Persistent Routes:
	  None

Compare these results to what we had before the install. In the sample above, a new IP interface called "Local Area Connection 4" has been created by the install.

***Configuring OpenVPN to Access Servers***

Then to get the VPN set up initially, at AirVPN go to "Client Area/Config Generator". The page says "OpenVPN Configuration Generator ". Press the "Invert" button to select all of the servers (why not?). Then select "UDP" under "Protocol" and then "443" under "Port". Agree to the terms of service and press the "Generate" button.

This will have created a file called "air.zip". Save it somewhere. Unzip this into a folder. Let's say it is called "AirVPN". It will contain files like this:

	C:\Program Files\OpenVPN\config\AirVPN>dir
	 Volume in drive C is Acer
	 Volume Serial Number is 00B1-714F
	
	 Directory of C:\Program Files\OpenVPN\config\AirVPN
	
	20/02/2013  02:08 PM    <DIR>          .
	20/02/2013  02:08 PM    <DIR>          ..
	20/02/2013  09:07 PM             8,944 AirVPN CH Virginis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN DE Aquilae - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN DE Tauri - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN DE Velorum - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN GB Bootis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN GB Carinae - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN GB Cassiopeia - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN IT Crucis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,945 AirVPN LU Herculis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN NL Castor - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN NL Leonis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN NL Leporis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,945 AirVPN NL Lyncis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN NL Lyra - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN NL Ophiuchi - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN NL Orionis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,946 AirVPN RO Phoenicis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN SE Cygni - UDP 443.ovpn
	20/02/2013  09:07 PM             8,945 AirVPN SE Serpentis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN SG Columbae - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN SG Puppis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN SG Sagittarii - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN US Andromedae - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN US Librae - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN US Octantis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,945 AirVPN US Pavonis - UDP 443.ovpn
	20/02/2013  09:07 PM             8,944 AirVPN US Persei - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN US Sirius - UDP 443.ovpn
	20/02/2013  09:07 PM             8,943 AirVPN US Vega - UDP 443.ovpn
	              29 File(s)        259,370 bytes
	               2 Dir(s)  244,540,530,688 bytes free

Move the "AirVPN" folder to "C:\Program Files\OpenVPN\config". You will be prompted for administrator privilege.

The OpenVPN install will have created a desktop icon for the OpenVPN GUI.

Stop your torrent clients.

Start up the OpenVPN GUI. On Vista or Windows 7 it will require administrator privilege. The following error messages may be symptom if it is not running privileged:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/openvpnneedsadminls.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/openvpnneedsadmin2.jpg)

Either always right-mouse click and "Run as administrator", or alter the desktop icon for the OpenVPN GUI to always run as administrator:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/openvpnasadmin.jpg)

The icon for the OpenVPN GUI will be in the system tray. Right-mouse click on it and select a server. On Windows XP the menu looks like this:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/openvpnmenu.jpg)

There is a page at AirVPN that gives info on how loaded each server is which cane be helpful when selecting a server to use. When the window showing the log closes and the message saying the VPN is up comes up.

Now once more use the "ipconfig/all" and "route print" commands at a Windows command prompt. You will get something similar to this:

*IP Interfaces with VPN Up*

	C:\Documents and Settings\user>ipconfig /all
	
	Windows IP Configuration
	
	        Host Name . . . . . . . . . . . . : xp
	        Primary Dns Suffix  . . . . . . . :
	        Node Type . . . . . . . . . . . . : Unknown
	        IP Routing Enabled. . . . . . . . : No
	        WINS Proxy Enabled. . . . . . . . : No
	
	Ethernet adapter Local Area Connection:
	
	        Connection-specific DNS Suffix  . :
	        Description . . . . . . . . . . . : VMware Accelerated AMD PCNet Adapter
	        Physical Address. . . . . . . . . : 00-0C-29-A2-B9-61
	        Dhcp Enabled. . . . . . . . . . . : Yes
	        Autoconfiguration Enabled . . . . : Yes
	        IP Address. . . . . . . . . . . . : 192.168.1.69
	        Subnet Mask . . . . . . . . . . . : 255.255.255.0
	        Default Gateway . . . . . . . . . : 192.168.1.254
	        DHCP Server . . . . . . . . . . . : 192.168.1.254
	        DNS Servers . . . . . . . . . . . : 192.168.1.254
	                                            75.153.176.1
	        Lease Obtained. . . . . . . . . . : Wednesday, March 06, 2013 2:05:50 PM
	        Lease Expires . . . . . . . . . . : Thursday, March 07, 2013 2:05:50 PM
	
	Ethernet adapter Local Area Connection 4:
	
	        Connection-specific DNS Suffix  . :
	        Description . . . . . . . . . . . : TAP-Windows Adapter V9
	        Physical Address. . . . . . . . . : 00-FF-42-5E-D2-9E
	        Dhcp Enabled. . . . . . . . . . . : Yes
	        Autoconfiguration Enabled . . . . : Yes
	        IP Address. . . . . . . . . . . . : 10.4.50.142
	        Subnet Mask . . . . . . . . . . . : 255.255.255.252
	        Default Gateway . . . . . . . . . : 10.4.50.141
	        DHCP Server . . . . . . . . . . . : 10.4.50.141
	        DNS Servers . . . . . . . . . . . : 10.4.0.1
	        Lease Obtained. . . . . . . . . . : Wednesday, March 06, 2013 2:31:50 PM
	        Lease Expires . . . . . . . . . . : Thursday, March 06, 2014 2:31:50 PM

*Routing Table with VPN Up*

	C:\Documents and Settings\user>route print
	===========================================================================
	Interface List
	0x1 ........................... MS TCP Loopback interface
	0x2 ...00 0c 29 a2 b9 61 ...... AMD PCNET Family PCI Ethernet Adapter - Packet Scheduler Miniport
	0x3 ...00 ff 42 5e d2 9e ...... TAP-Windows Adapter V9 - Packet Scheduler Miniport
	===========================================================================
	===========================================================================
	Active Routes:
	Network Destination        Netmask          Gateway       Interface  Metric
	          0.0.0.0        128.0.0.0      10.4.50.141     10.4.50.142       1
	          0.0.0.0          0.0.0.0    192.168.1.254    192.168.1.69       10
	         10.4.0.1  255.255.255.255      10.4.50.141     10.4.50.142       1
	      10.4.50.140  255.255.255.252      10.4.50.142     10.4.50.142       30
	      10.4.50.142  255.255.255.255        127.0.0.1       127.0.0.1       30
	   10.255.255.255  255.255.255.255      10.4.50.142     10.4.50.142       30
	     95.211.169.3  255.255.255.255    192.168.1.254    192.168.1.69       1
	        127.0.0.0        255.0.0.0        127.0.0.1       127.0.0.1       1
	        128.0.0.0        128.0.0.0      10.4.50.141     10.4.50.142       1
	      192.168.1.0    255.255.255.0     192.168.1.69    192.168.1.69       10
	     192.168.1.69  255.255.255.255        127.0.0.1       127.0.0.1       10
	    192.168.1.255  255.255.255.255     192.168.1.69    192.168.1.69       10
	        224.0.0.0        240.0.0.0      10.4.50.142     10.4.50.142       30
	        224.0.0.0        240.0.0.0     192.168.1.69    192.168.1.69       10
	  255.255.255.255  255.255.255.255      10.4.50.142     10.4.50.142       1
	  255.255.255.255  255.255.255.255     192.168.1.69    192.168.1.69       1
	Default Gateway:       10.4.50.141
	===========================================================================
	Persistent Routes:
	  None

The "Local Area Connection 4" interface has been configured with an IP address and other configuration information added to it. Also, the routing table has several new entries added to it involving the "Local Area Connection 4" interface. We will examine the details of these differences and comment on the information content of these listings in what follows. You can use a "diff' program such as Winmerge to make the additions and changes to the routing table easier to pick out:

*Comparison of Routing Table with VPN Up Versus Down*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/routediff.jpg)

Now use your browser to go to:

[http://whatismyipaddress.com/](http://whatismyipaddress.com/)

Where are you in the world?

Until we get port forwarding working, there is no point in running your torrent client with the VPN. Although there would be no harm in trying it for a minute.

Stop your torrent clients again before you shut down the VPN.

***Setting Up Port Forwarding***

At AirVPN, go to "Client Area/Forwarded ports". The page title is "Your forwarded ports"

The ports you already have are shown first with a "Remove" button. At the end there is an extra spot with an "Add" button. Click "Add" and it will generate a random number and forward that port to you. After you click the next page will say "Port ????? added" at the top.

Now you need to tell your torrent client to listen on this port.

Here you should first understand about UPnP:

[https://en.wikipedia.org/wiki/Universal_Plug_and_Play](https://en.wikipedia.org/wiki/Universal_Plug_and_Play)

And also NAT-PMP:

[http://en.wikipedia.org/wiki/NAT_Port_Mapping_Protocol](http://en.wikipedia.org/wiki/NAT_Port_Mapping_Protocol)

UPnP support in the router allows a program running on your PC to tell your router to set up port forwarding. Most routers now a days support this. NAT-PMP is much less widely implemented. It seems that because of this many people do not realize that incoming connections are being forwarded to their torrent client. When using a VPN, you should turn off UPnP and NAT-PMP in your torrent client.

For uTorrent, do "Options/Preferences", then select "Connection" and paste in (or type) the port number AirVPN generated for you. Then click "OK".

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/utorrentport.jpg)

For Vuze do "Tools/Options", then "Connections" and paste in (or type) the port number AirVPN generated for you. The click "Save".

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vuzeport.jpg)

Also for Vuze, to turn off UPnP and NAT-PMP use "Tools/Options/Plugins/UPnP" and "Tools/Options/Plugins/UPnP/NAT-PMP":

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vuzeupnp.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vuzenatpmp.jpg)

Now go back to the AirVPN port forwarding page and click the "Check" button for the port. When this competes the "Status" icon should turn green.

***A Very Active Copyright Free Torrent to Test With***

If you want a *very active torrent to test with that has no copyright issues*, use the Ubuntu Desktop torrent:

[http://www.ubuntu.com/download/desktop/alternative-downloads](http://www.ubuntu.com/download/desktop/alternative-downloads)

***Checking That the VPN Is Working***

To see whether you are receiving incoming connections:

*uTorrent*:

Use "Options/Show Status Bar" In the Status Bar area (at the bottom) select the "Peers" tab. Hopefully you have the "Flags" column? If not right mouse-click on the column title area and enable it. What you want to see is a few peers with "I" as one of the flags. This means the peer connected to you. The meaning of each flags is available in "Help/uTorrent Help".

*Vuze*:

If the icon in front of the torrent is green, then you have received incoming connections. To pursue this further, right mouse-click on a torrent and select "Show Details". Then select the "Peers" tab. Hopefully you have the "T" column? If not right mouse-click on the column title area and enable it. The peers that have "R" in the "T" column came to you as incoming connections.

*Process Explorer*

But there is a *more general and powerful way to check what is happening with a torrent clients IP connections*. There is a useful tool that Microsoft provides - "**Process Explorer**":

[http://technet.microsoft.com/en-ca/sysinternals/bb896653.aspx](http://technet.microsoft.com/en-ca/sysinternals/bb896653.aspx)

With it you can see all of the network connections a program is making. Once it is installed, start it and in the process tree that gets shown locate "uTorrent.exe" or "Azureus.exe" under "explorer.exe". Right-mouse click on it and select "Properties..."`. Then select the "TCP/IP" tab. In that uncheck the "Resolve addresses" check box. If you see connections on the port that you set up as the incoming port, that is another indication that you are receiving incoming connections.

Using Process Explorer you will also be *able to see if any connections are being made on the native interface rather than the VPN interface (as they should)*.

This is an example of what you can see with Process Explorer:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/peipt.jpg)

In the example above, Vuze is listening for connections on port 63676, so the "ESTABLISHED" connections to that port are from incoming connections.

It can be helpful to sort the items in this display in various orders by clicking on the column headers. The possible states are described here:

[http://support.microsoft.com/kb/137984](http://support.microsoft.com/kb/137984)

This is a summary taken from the link above:

	SYN_SEND     - Indicates active open.
	
	SYN_RECEIVED - Server just received SYN from the client.
	
	ESTABLISHED  - Client received server's SYN and session is established.
	
	LISTEN       - Server is ready to accept connection.
	
	FIN_WAIT_1   - Indicates active close.
	
	TIMED_WAIT   - Client enters this state after active close.
	
	CLOSE_WAIT   - Indicates passive close. Server just received first FIN from a client.
	
	FIN_WAIT_2   - Client just received acknowledgment of its first FIN from the server.
	
	LAST_ACK     - Server is in this state when it sends its own FIN.
	
	CLOSED       - Server received ACK from client and connection is closed.

***Guide to Setting Up VPN Just for Torrenting on Windows - Part 2***

***Routing Table Functionality***

In what follows, manipulations of the routing table will be used to achieve certain goals. Some understanding of the routing table will be needed in order for the reader to complete these.

You may also want to see the Wikipedia page about the routing table:

[http://en.wikipedia.org/wiki/Routing_table](http://en.wikipedia.org/wiki/Routing_table)

Please refer to the listings generated by "route print" above.

When a program does an IP "bind" function without specifying a particular IP interface or IP address to bind to, the routing table is used to determine what IP interface to send a packet on, based on the destination. The packet destination is compared against the two values "Network Destination" and "Netmask". These two values together define a "subnet" or "subnetwork". For an explanation of a subnetwork and subnet notations see Wikipedia:

[http://en.wikipedia.org/wiki/Subnetwork](http://en.wikipedia.org/wiki/Subnetwork)

The values shown as 4 numbers separated by periods are 32 bit strings, divided up into 4 8 bit chunks, so that each chunk is a value from 0 to 255. But think of these as 32 bit strings.

"Netmask" will be all ones on the left and all zeros to the right of that. What matters with it is just how many 1-s are on the left. If the "Netmask" has only 4 1-s on the left, then only the left-most 4 bits of the packet destination and "Network Destination" are compared for a match. A packet destination may have several routing table entries that match by this criteria. The one that will be used is the one for which the "Netmask" had the most 1-s. If that does not resolve it, the lowest "Metric" is then checked.

The entry with the "0.0.0.0." Netmask is called the "default" gateway:

	...
	Network Destination        Netmask          Gateway       Interface  Metric
	...
	         0.0.0.0          0.0.0.0    192.168.1.254    192.168.1.69       10
	...
	Default Gateway:     192.168.1.254
	...

This "0.0.0.0" entry will match anything, since no bits have to be compared. So if no more specific entry is found that is where a packet will go.

Now look at the screen shot above labelled "Comparison of Routing Table with VPN Up Versus Down".

The extra lines when the VPN is up were added by the OpenVPN client. Note these two extra lines in particular:

	...
	Network Destination        Netmask          Gateway       Interface  Metric
	...
	         0.0.0.0        128.0.0.0      10.4.50.141     10.4.50.142       1
	...
	       128.0.0.0        128.0.0.0      10.4.50.141     10.4.50.142       1
	...
	Default Gateway:       10.4.50.141
	...

These entries with "128.0.0.0" prevent the "0.0.0.0" from ever being used, because one of these will match any address, and they are more specific (one 1 bit on the left of the Netmask rather than no bits at all). This makes the VPN gateway (10.4.50.141) the new "default gateway".

The other additional entries serve various purposes which are not relevant to our discussion below.

***Advanced Set Up for Windows XP***

As I explained above, I was not able to find a way under XP to use the native interface for normal activities while using the VPN for the torrent clients. I could not get the torrent clients to use the VPN interface unless it was the default gateway in the routing table. It appears that *you have to use the VPN for everything or nothing*.

However it is possible to use a combination of the firewall and the routing table to ensure that no P2P traffic uses the native interface when the VPN is not running.

***Set Up for Windows XP Firewall***

First I will discuss the firewall. It does not seem to be possible to fully block all torrent traffic from the native interface using just the limited firewall that came with XP.

Although you can block incoming connections to some extent, you cannot block outgoing connections at all. And registering your IP address against torrent hashes on a tracker or by DHT is already bad enough for IP address trolls to see you. And if they register themselves on a tracker as having a torrent you want, you may connect to them (even worse). You could also be given their IP address as a source by peer exchange even if you strip things to DHT only.

With some other firewall that works on XP you may still be able to do this. There may be information on the AirVPN forum.

If you have a router, you may not have had Windows firewall enabled, relying on your router to provide the firewall. However you should have Windows firewall enabled at least for the VPN interface, with an exception for your torrent client. The following screen shots illustrate how to do this:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/xpfirewallstart.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/xpfirewallon.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/xpfirewallexceptions.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/xpfirewalladvanced.jpg)

This will allow incoming connections for torrent clients from the native interface too. But you should be able to configure your router so that no incoming connections are forwarded from the internet to your PC. You will have to poke around in its GUI/HTTP interface. Besides turning off any explicit port forwarding in your router, you need to consider UPnP:

[https://en.wikipedia.org/wiki/Universal_Plug_and_Play](https://en.wikipedia.org/wiki/Universal_Plug_and_Play)

UPnP support in the router allows a program running on your PC to tell your router to set up port forwarding. Most routers now a days support this. It seems that because of this many people do not realize that incoming connections are being forwarded to their torrent client. The thing is, malicious programs can do this too!

So you may want to go further and disable UPnP in your router. However you may be using some other program that needs it. With UPnP off (and no explicit port forwarding rules in the router), you can be sure that no incoming connections can come in by the native interface.

If you do want to block incoming torrent connections only on the native interface, then *do not enable the exceptions for the clients on the "Exceptions" tab* as shown above, but instead go to "Advanced Settings" from the "Advanced" tab and provide exception rules only for the VPN interface, as shown below:

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/xpfirewalladvancedsetti.jpg)

Using this approach, you have to define the rules based on the ports rather than the programs, and you will need a TCP and a UDP rule for each port.

***Routing Table Change to Block Outgoing Native Traffic***

*In order to ensure that outgoing traffic will not go out over the native interface*, one can make a change to the routing table which will guarantee that no traffic of any sort (except the encrypted VPN traffic itself) will be able to find its way to the native interface. Refer to the section "Routing Table Functionality" above. If the VPN goes down, the "128.0.0.0" entries that override the default gateway will be removed by the OpenVPN client. *If the "0.0.0.0" entry is removed, then there will be no default gateway and nothing will be able to find its way out to the internet*.

Once the VPN is running, you can just remove the "0.0.0.0" entry from the routing table using this command at a command prompt:

	route delete 0.0.0.0 192.168.1.254

If you want to stop the VPN and use the native interface again, then after shutting down the VPN, restore the default gateway entry for the native interface using this command at a command prompt:

	route add 0.0.0.0 mask 0.0.0.0 192.168.1.254

Note that "192.168.1.254" above must be replaced with the gateway for your native interface. If you lose track of this, it is part of the information displayed for interfaces by "ipconfig /all" (see the examples above).

For convenience, you could create two ".bat" files each with one of these commands. I suggest that you place a "pause" command at the end so that the windows that opens to run the command does not disappear before you can see if it worked.

***Advanced Set Up for Windows Vista and Windows 7***

The set up described below works on either Vista or Windows 7. I use Windows 7, but I have confirmed that it works on Vista using a virtual machine I have with Windows Vista on it.

All of the samples below are taken from Windows Vista. There a couple of small differences in the GUI for "Windows Firewall with Advanced Security".

I also encountered a problem getting the firewall blocking to work fully for Windows Vista. Getting the firewall to block uTorrent from using the native interface worked, but getting it to block Vuze has not worked! Blocking Vuze works fine on Windows 7.

But there is a saving grace. Fortunately Vuze has an option that prevents it using the default interface if it is configured to use a specific interface. I use this on Windows 7 too, even though it does not appear to be necessary.

***Set Up for Windows Firewall with Advanced Security***

To set up the blocking of both incoming and outgoing connections in the way we need, you have to use "Windows Firewall with Advanced Security", which is separate from "Windows Firewall" in the Windows Start menu. You have to first get into "Administrative Tools". The following screen shot shows how to get into "Windows Firewall with Advanced Security":

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedst.jpg)

Once you are into ""Windows Firewall with Advanced Security"" you can configure rules for both incoming and outgoing connections at a level of detail much greater than you could for Windows XP. In order to do this we will need to determine an appropriate subnet definition for the native interface and the VPN interface. This can be obtained from examining output from the "ipconfig /all" and "route print" commands:

	C:\Users\user>ipconfig /all
	
	Windows IP Configuration
	
	   Host Name . . . . . . . . . . . . : virtual_Vista
	   Primary Dns Suffix  . . . . . . . :
	   Node Type . . . . . . . . . . . . : Hybrid
	   IP Routing Enabled. . . . . . . . : No
	   WINS Proxy Enabled. . . . . . . . : No
	
	Ethernet adapter Local Area Connection 3:
	
	   Connection-specific DNS Suffix  . :
	   Description . . . . . . . . . . . : TAP-Windows Adapter V9
	   Physical Address. . . . . . . . . : 00-FF-B8-2E-BD-7C
	   DHCP Enabled. . . . . . . . . . . : Yes
	   Autoconfiguration Enabled . . . . : Yes
	   Link-local IPv6 Address . . . . . : fe80::5d15:cf7:c242:3e80(Preferred)
	   IPv4 Address. . . . . . . . . . . : 10.4.50.142(Preferred)
	   Subnet Mask . . . . . . . . . . . : 255.255.255.252
	   Lease Obtained. . . . . . . . . . : Wednesday, March 13, 2013 11:38:12 AM
	   Lease Expires . . . . . . . . . . : Thursday, March 13, 2014 11:38:12 AM
	   Default Gateway . . . . . . . . . :
	   DHCP Server . . . . . . . . . . . : 10.4.50.141
	   DHCPv6 IAID . . . . . . . . . . . : 234946488
	   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-13-79-1E-1D-00-0C-29-3D-07-02
	   DNS Servers . . . . . . . . . . . : 10.4.0.1
	   NetBIOS over Tcpip. . . . . . . . : Enabled
	
	Ethernet adapter Local Area Connection:
	
	   Connection-specific DNS Suffix  . :
	   Description . . . . . . . . . . . : Intel(R) PRO/1000 MT Network Connection
	   Physical Address. . . . . . . . . : 00-0C-29-E3-F7-8B
	   DHCP Enabled. . . . . . . . . . . : Yes
	   Autoconfiguration Enabled . . . . : Yes
	   Link-local IPv6 Address . . . . . : fe80::9c19:3be7:696c:e04(Preferred)
	   IPv4 Address. . . . . . . . . . . : 192.168.1.67(Preferred)
	   Subnet Mask . . . . . . . . . . . : 255.255.255.0
	   Lease Obtained. . . . . . . . . . : Wednesday, March 13, 2013 11:32:09 AM
	   Lease Expires . . . . . . . . . . : Thursday, March 14, 2013 11:32:09 AM
	   Default Gateway . . . . . . . . . : 192.168.1.254
	   DHCP Server . . . . . . . . . . . : 192.168.1.254
	   DHCPv6 IAID . . . . . . . . . . . : 251661353
	   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-13-79-1E-1D-00-0C-29-3D-07-02
	   DNS Servers . . . . . . . . . . . : 192.168.1.254
	                                       75.153.176.1
	   NetBIOS over Tcpip. . . . . . . . : Enabled
	
	Tunnel adapter Local Area Connection* 6:
	
	   Media State . . . . . . . . . . . : Media disconnected
	   Connection-specific DNS Suffix  . :
	   Description . . . . . . . . . . . : isatap.{A8B29C02-92F2-4901-B6DB-0A2CD26E54D2}
	   Physical Address. . . . . . . . . : 00-00-00-00-00-00-00-E0
	   DHCP Enabled. . . . . . . . . . . : No
	   Autoconfiguration Enabled . . . . : Yes
	
	Tunnel adapter Local Area Connection* 7:
	
	   Connection-specific DNS Suffix  . :
	   Description . . . . . . . . . . . : Teredo Tunneling Pseudo-Interface
	   Physical Address. . . . . . . . . : 02-00-54-55-4E-01
	   DHCP Enabled. . . . . . . . . . . : No
	   Autoconfiguration Enabled . . . . : Yes
	   IPv6 Address. . . . . . . . . . . : 2001:0:9d38:953c:349c:1efb:f5fb:cd71(Preferred)
	   Link-local IPv6 Address . . . . . : fe80::349c:1efb:f5fb:cd71(Preferred)
	   Default Gateway . . . . . . . . . : ::
	   NetBIOS over Tcpip. . . . . . . . : Disabled
	
	Tunnel adapter Local Area Connection* 11:
	
	   Media State . . . . . . . . . . . : Media disconnected
	   Connection-specific DNS Suffix  . :
	   Description . . . . . . . . . . . : isatap.{B82EBD7C-FAAE-42FB-AAA5-4E849D98E35A}
	   Physical Address. . . . . . . . . : 00-00-00-00-00-00-00-E0
	   DHCP Enabled. . . . . . . . . . . : No
	   Autoconfiguration Enabled . . . . : Yes

	C:\Users\user>route print
	===========================================================================
	Interface List
	 14 ...00 ff b8 2e bd 7c ...... TAP-Windows Adapter V9
	 10 ...00 0c 29 e3 f7 8b ...... Intel(R) PRO/1000 MT Network Connection
	  1 ........................... Software Loopback Interface 1
	 13 ...00 00 00 00 00 00 00 e0  isatap.{A8B29C02-92F2-4901-B6DB-0A2CD26E54D2}
	 12 ...02 00 54 55 4e 01 ...... Teredo Tunneling Pseudo-Interface
	 15 ...00 00 00 00 00 00 00 e0  isatap.{B82EBD7C-FAAE-42FB-AAA5-4E849D98E35A}
	===========================================================================
	
	IPv4 Route Table
	===========================================================================
	Active Routes:
	Network Destination        Netmask          Gateway       Interface  Metric
	          0.0.0.0          0.0.0.0    192.168.1.254     192.168.1.67     10
	          0.0.0.0        128.0.0.0      10.4.50.141      10.4.50.142     30
	         10.4.0.1  255.255.255.255      10.4.50.141      10.4.50.142     30
	      10.4.50.140  255.255.255.252         On-link       10.4.50.142    286
	      10.4.50.142  255.255.255.255         On-link       10.4.50.142    286
	      10.4.50.143  255.255.255.255         On-link       10.4.50.142    286
	     95.211.169.3  255.255.255.255    192.168.1.254     192.168.1.67     10
	        127.0.0.0        255.0.0.0         On-link         127.0.0.1    306
	        127.0.0.1  255.255.255.255         On-link         127.0.0.1    306
	  127.255.255.255  255.255.255.255         On-link         127.0.0.1    306
	        128.0.0.0        128.0.0.0      10.4.50.141      10.4.50.142     30
	      192.168.1.0    255.255.255.0         On-link      192.168.1.67    266
	     192.168.1.67  255.255.255.255         On-link      192.168.1.67    266
	    192.168.1.255  255.255.255.255         On-link      192.168.1.67    266
	        224.0.0.0        240.0.0.0         On-link         127.0.0.1    306
	        224.0.0.0        240.0.0.0         On-link       10.4.50.142    286
	        224.0.0.0        240.0.0.0         On-link      192.168.1.67    266
	  255.255.255.255  255.255.255.255         On-link         127.0.0.1    306
	  255.255.255.255  255.255.255.255         On-link       10.4.50.142    286
	  255.255.255.255  255.255.255.255         On-link      192.168.1.67    266
	===========================================================================
	Persistent Routes:
	  None
	
	IPv6 Route Table
	===========================================================================
	Active Routes:
	 If Metric Network Destination      Gateway
	 12     18 ::/0                     On-link
	  1    306 ::1/128                  On-link
	 12     18 2001::/32                On-link
	 12    266 2001:0:9d38:953c:349c:1efb:f5fb:cd71/128
	                                    On-link
	 14    286 fe80::/64                On-link
	 10    266 fe80::/64                On-link
	 12    266 fe80::/64                On-link
	 12    266 fe80::349c:1efb:f5fb:cd71/128
	                                    On-link
	 14    286 fe80::5d15:cf7:c242:3e80/128
	                                    On-link
	 10    266 fe80::9c19:3be7:696c:e04/128
	                                    On-link
	  1    306 ff00::/8                 On-link
	 12    266 ff00::/8                 On-link
	 14    286 ff00::/8                 On-link
	 10    266 ff00::/8                 On-link
	===========================================================================
	Persistent Routes:
	  None

Examining the "ipconfig /all" output we see that:

* the VPN interface ("Local Area Connection 3") has IP address 10.4.50.142 and provides a path to the gateway 10.4.50.141

* the native interface (with IP address 192.168.1.67) provides a path to the gateway 192.168.1.254

Examining the "route print" output we see that:

* the VPN interface (with IP address 10.4.50.142) provides a path to the gateway 10.4.50.141

* the native interface ("Local Area Connection") has IP address 192.168.1.67 and provides a path to the gateway 192.168.1.254 (this can also be gleaned from the "ipconfig /all" output)

For the firewall rules, we need to use the CIDR subnet ("prefix/length") notation:

[http://en.wikipedia.org/wiki/CIDR_notation#CIDR_notation](http://en.wikipedia.org/wiki/CIDR_notation#CIDR_notation)

We will go with "10.4.0.0/16" as a subnet definition containing the VPN address and with "192.168.0.0/16" as a subnet definition containing our native interface. We need these two subnet definitions to not overlap, and to be big enough that they will not need to change if the address given to us by the VPN DHCP server or our router DHCP server changes. A prefix length of 16 should be plenty for this.

I will explain the rationale for the firewall rules I set up after some screen shots that give the jist of how to use the firewall set up GUI.

The following screen shots show the summary window:

*Rules for Incoming Connections*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedin.jpg)

*Rules for Outgoing Connections*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedou.jpg)

The following screen shots illustrate how to set the properties of firewall rules:

*Specifying the Properties for a Firewall Rule*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedge.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedpr.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedpr.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedpr.jpg)

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistafirewalladvancedpr.jpg)

Installing (or perhaps running the first time) uTorrent will have created *Inbound rules* named "Torrent (TCP-In)" and "Torrent (UDP-In)". Installing (or perhaps running the first time) Vuze will have create a rule named "Azureus / Vuze" for each of TCP and UDP. We want to change these so that they allow incoming connections only from the VPN. In the screen shot above for Incoming connections you will see that the "Local IP address" property has been set to "10.4.0.0/16". Although I do not recall changing anything else, make whatever other changes you need to ensure that the rules you create are as in the example above. You could if you prefer disable the original rules and create new ones.

The uTorrent and Vuze installations do not create any *Outbound rules*. So I have created a rule for uTorrent ("_uTorrent") and for Vuze ("_Vuze"). We want these rules to block outgoing traffic over the native interface from our torrent clients. We need these rules to be "blocking" rules, applying to all profiles and all protocols, and with that the "Local IP address" property has been set to "192.168.0.0/16". Make whatever other changes you need to ensure that the rules you create are as in the example above.

***Set Up for Torrent Clients***

Next we set up the torrent clients to use only the VPN interface. This will give additional assurance that torrent traffic does not go out over the native interface, and also allow us to make the changes to the routing table that will cause the VPN interface to be used only for torrent traffic.

The following screen shot illustrates setting the IP interface for uTorrent:

*Setting IP Interface for uTorrent*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/utorrentsetip.jpg)

From the menu in uTorrent select "Options/Preferences" and then select "Advanced". You need to set the "net.bind.ip" and "net.outgoing.ip" to the IP address of the VPN interface. Unfortunately for uTorrent one has to specify the IP address, unlike Vuze (see below).

So long as I continue to use the same AiirVPN server, since my DHCP license is for a year, I do not need to change the uTorrent configuration. If I wish to change the AirVPN server, I have to change IP address uTorrent uses.

At the time of writing, AirVPN does not allow one to have a fixed local IP address for
the VPN interface, otherwise this could be avoided.

The following screen shot illustrates setting the IP interface for Vuze:

*Setting IP Interface for Vuze*

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vuzesetip.jpg)

From the menu in Vuze select "Options" and then select "Connection/Advanced Network Settings". First ensure that the check box labelled "Enforce IP bindings even when interfaces are not available, ..." (at the bottom of the page) is enabled. Next fill in the text box labelled "Bind to local IP address or interface". You could fill in the actual IP address of the VPN interface as we did for uTorrent. But it is better to scan the list of interfaces further down the page for the one for the VPN interface. In the sample screen shot you will see that the VPN address "10.4.50.142" goes with the interface "eth5[0]". So I have copied and pasted that into the text box instead. By using the interface name rather than the IP address, I avoid having to change the Vuze set up if the address of my VPN interface changes (when I switch OpenVPN servers for example).
 
***Routing Table Changes to Restore Native Gateway***

The final step in this set up is to add some additional routing table entries to restore the native gateway as the default gateway. Recall (see the discussion above) that the OpenVPN client added two routing table entries with a subnet prefix length of 1 bit (net mask 128.0.0.0) in order to override the original routing table entry that made the native interface the default gateway. That original routing table entry (just 1 entry) had a subnet prefix length of 0 bits (net mask 0.0.0.0). Because the subnet prefix length of the routing table entries the VPN client made is longer, and the two entries together cover the full IP address space, these two new entries had the effect of overriding the original default gateway.

One might think then that we just need to delete the two entries with net mask "128.0.0.0". And indeed, if we were not using Windows, this would probably work! But I have found that with these entries removed, Windows does not allow the torrent clients to bind to the VPN interface, which they were configured above to use. But there is another possibility, which I have found does work.

We will do what the VPN client did - add more routing table entries. Our entries will have a subnet prefix length of 2 bits (new mask 192.0.0.0). In order cover the full IP address space we need 4 entries (see the pattern?). To this end, create two ".bat" files. Files ending in .bat are expected by Windows to contain "scripts" that run the same commands that you can run at the Windows Command Prompt. Create two files as follows -

"*VPN_gateway_suspend.bat*" containing:

	@set GATEWAY=192.168.1.254
	route add 0.0.0.0 mask 192.0.0.0 %GATEWAY%
	route add 64.0.0.0 mask 192.0.0.0 %GATEWAY%
	route add 128.0.0.0 mask 192.0.0.0 %GATEWAY%
	route add 192.0.0.0 mask 192.0.0.0 %GATEWAY%
	@pause

"*VPN_gateway_restore.bat*" containing:

	@set GATEWAY=192.168.1.254
	route delete 0.0.0.0 mask 192.0.0.0 %GATEWAY%
	route delete 64.0.0.0 mask 192.0.0.0 %GATEWAY%
	route delete 128.0.0.0 mask 192.0.0.0 %GATEWAY%
	route delete 192.0.0.0 mask 192.0.0.0 %GATEWAY%
	@pause

I put my files into the folder "C:\bat\VPN". The route commands to add and delete entries require administrator privilege. So to run the .bat files directly you have to right mouse-click on them and select "Run as administrator". As a convenience, I create short cuts to these .bat files and set "Run as administrator" in their "Advanced Properties":

![](https://github.com/tool-maker/VPN_just_for_torrents/blob/master/images/vistarouteneedsadmin.jpg)

To be sure these scripts and short cuts are working for you, use the "route print" command in a Windows Command Prompt window.

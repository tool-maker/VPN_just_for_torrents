
@cd %~p0

cscript //Nologo "mkshortcut.js" "%~p0squid_start.bat"     "squid start"
cscript //Nologo "mkshortcut.js" "%~p0squid_status.bat"    "squid status"
cscript //Nologo "mkshortcut.js" "%~p0squid_stop.bat"      "squid stop"
cscript //Nologo "mkshortcut.js" "%~p0squid_setup_VPN.bat" "squid configure for VPN"

@pause

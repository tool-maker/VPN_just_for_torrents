@rem Download setup-x86.exe or setup-x86_64.exe (not both) from https://cygwin.com/install.html.
@rem Then copy this file to the same folder and run.

@rem This will install to C:\cygwin_openvpn_build (see below), unless you change it. If you
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

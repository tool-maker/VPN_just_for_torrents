@echo off
cd %~p0
C:\cygwin_squid\bin\bash --login -c "cd \"$OLDPWD\"; /usr/sbin/squid -f $PWD/squid.conf"
pause

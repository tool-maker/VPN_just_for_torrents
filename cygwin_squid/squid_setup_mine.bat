@echo off
cd %~p0
C:\cygwin_squid\bin\bash --login -c "cd \"$OLDPWD\"; ./squid_setup.sh 10.89.0.2 10.89.0.1"
pause

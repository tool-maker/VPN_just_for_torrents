@echo off
cd %~p0
@rem C:\cygwin_squid\bin\bash --login -c "cd \"$OLDPWD\"; ps | grep squid -"
C:\cygwin_squid\bin\bash --login -c "cd \"$OLDPWD\"; ps"
pause

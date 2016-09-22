@echo off
cd %~p0

@rem scan routing table to get VPN gateway address and address of VPN gateway interface
@rem echo %~n0%~x0
@set temp_file_route=%TEMP%\%~n0%~X0_temp.txt
@rem echo %temp_file_route%
@route print | findstr /r /c:" 128\.0\.0\.0 *128\.0\.0\.0 " | findstr /v /l /c:" On-link " > %temp_file_route%
@rem echo default gateway entry from routing table:
@rem type %temp_file_route%
@for /f "tokens=3,4" %%a in (%temp_file_route%) do @set GATEWAY_GW=%%a & set GATEWAY_IP=%%b
@erase %temp_file_route%
@rem echo gateway: %GATEWAY_GW%
@rem echo address: %GATEWAY_IP%

C:\cygwin_squid\bin\bash --login -c "cd \"$OLDPWD\"; ./squid_setup.sh %GATEWAY_IP% %GATEWAY_GW%"
pause

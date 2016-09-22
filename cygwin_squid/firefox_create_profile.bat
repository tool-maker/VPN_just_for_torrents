path "C:\Program Files (x86)\Mozilla Firefox";"C:\Program Files\Mozilla Firefox";%PATH%
@set PROFILE_DIR="%~d0%~p0profile_squid_VPN_tester"
@echo.
@echo will put profile folder for squid_VPN_tester in "%PROFILE_DIR%"
@echo close window if that is not what you want
@pause
firefox -no-remote -CreateProfile "squid_VPN_tester %PROFILE_DIR%"
@pause

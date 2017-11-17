@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)


@echo off
goto check_Permissions
:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
		call :ColorText 0b "[Success]Administrative permissions confirmed."
		Echo .
    ) else (
		call :ColorText 0C "[Failure]Current permissions inadequate, please run this batch as Administrator."
		Echo .
		goto end
    )
	

Echo off
REM ####change your unique IP here#####
SET YOUR_LAN_IP=10.61.156.146
REM ####change your team wlan name here#####
SET YOUR_TEAM_WLAN_NAME=HOME_Team4
REM ####Please check in Control Panel\Network and Internet\Network Connections to get the names#####
SET YOUR_INTERFACE_LAN_NAME=Ethernet 2
SET YOUR_INTERFACE_WLAN_NAME=Wi-Fi

Echo ###############################################################
Echo The Net configuration will switch from WLAN to LAN, and Vice Versa!
Echo ###############################################################

Echo Please wait  .................................................

REM the following does not work for switching from wifi to lan, strange...
REM net start dot3svc
REM netsh lan show interfaces >NUL

REM ####change your unique IP here#####
ping -n 1 %YOUR_LAN_IP%

if errorlevel 1 goto LAN
if errorlevel 0 goto WLAN

:LAN
Echo begin to enable LAN "%YOUR_INTERFACE_LAN_NAME%" and disable WLAN...........

netsh interface set interface "%YOUR_INTERFACE_WLAN_NAME%" disabled >NUL

sc start dot3svc >NUL
netsh interface set interface "%YOUR_INTERFACE_LAN_NAME%" enabled >NUL

Echo ---------------------------------------------------------------
echo|set /p=WLAN: 
call :ColorText 0C "disabled"
echo|set /p=, LAN: 
call :ColorText 0a "enabled"
Echo .
REM Echo WLAN: disabled, LAN: enabled
Echo ---------------------------------------------------------------

goto end

:WLAN
Echo begin to enable WLAN and connect to "%YOUR_TEAM_WLAN_NAME%" and disable LAN...........

sc start dot3svc >NUL
netsh interface set interface "%YOUR_INTERFACE_LAN_NAME%" disabled >NUL
sc stop dot3svc >NUL

netsh interface set interface "%YOUR_INTERFACE_WLAN_NAME%" enabled >NUL

REM just wait a little while 
ping -n 5 127.0.0.1

REM show wlan profiles 
netsh wlan show profiles
netsh wlan connect name="%YOUR_TEAM_WLAN_NAME%"

Echo ---------------------------------------------------------------
echo|set /p=WLAN: 
call :ColorText 0a "enabled"
echo|set /p=, LAN: 
call :ColorText 0C "disabled"
Echo .
REM Echo WLAN: enabled, LAN: disabled
Echo ---------------------------------------------------------------

:end


REM *ColorText part 2 begin*
REM call :ColorText 0a "enabled"
REM call :ColorText 0C "disabled"
REM call :ColorText 0b "info"
REM echo(
REM call :ColorText 19 "info"
REM call :ColorText 2F "enabled"
REM call :ColorText 4e "disabled"
goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
REM *ColorText part 2 end*
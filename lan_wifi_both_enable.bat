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
REM ####Please check in Control Panel\Network and Internet\Network Connections to get the names#####
SET YOUR_INTERFACE_LAN_NAME=Ethernet 2
SET YOUR_INTERFACE_WLAN_NAME=Wi-Fi

Echo ###############################################################
Echo The Net configuration will enable both WLAN and LAN
Echo ###############################################################

Echo Please wait  .................................................

Echo begin to enable LAN "%YOUR_INTERFACE_LAN_NAME%" and enable WLAN "%YOUR_INTERFACE_WLAN_NAME%"...........

netsh interface set interface "%YOUR_INTERFACE_WLAN_NAME%" enabled >NUL

sc start dot3svc >NUL
netsh interface set interface "%YOUR_INTERFACE_LAN_NAME%" enabled >NUL

Echo ---------------------------------------------------------------
echo|set /p=WLAN: 
call :ColorText 0a "enabled"
echo|set /p=, LAN: 
call :ColorText 0a "enabled"
Echo .
REM Echo WLAN: enabled, LAN: enabled
Echo ---------------------------------------------------------------

goto end

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
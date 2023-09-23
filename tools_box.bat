@echo off
cls

:menu
echo =====================================================
echo =                    Main Menu                      =
echo =====================================================
echo =                                                   =
echo = 1. Create text file with current time             =
echo = 2. Ping IP                                        =
echo = 3. Check User name                                =
echo = 4. Map Drive L                                    =
echo = 5. Map Drive K                                    =
echo = 6. Check Info PC                                  =
echo = 7. Set Static IPv4 (192.168.181.19)               =
echo = 8. Set DHCP                                       =
echo = 9. Create Folder Ricoh_Scan in D and shared       =                                           
echo = Press Esc to clear                                =
echo =====================================================
set /p option=Choose Option : 

if %option%==1 goto create_files
if %option%==2 goto ping_IP
if %option%==3 goto check_user
if %option%==4 goto map_l
if %option%==5 goto map_k
if %option%==6 goto info
if %option%==7 goto set_ip_19
if %option%==8 goto set_ip_dhcp
if %option%==9 goto Ricoh_Scan
echo Invalid option selected.
goto menu

:: Tạo File TXT để test Backup
:create_files
echo Creating files with names based on time every 30 seconds.
:loop
set "filename=%time:~0,2%%time:~3,2%%time:~6,2%.txt"
echo Creating file %filename%...
echo This is file %filename%. > %filename%
timeout 30
goto loop

:: Ping IP
:ping_IP
::set /p IP= input IP : 
::ping %IP%
::pause
::cls
::goto menu
cls
echo =====================================================
echo =                 Please select IP:                 =
echo =====================================================
echo.
echo 1. Ping 1.1.1.1
echo 2. Ping 1.1.1.2
echo .
echo 0. Turn back menu 
echo =====================================================
set /p ping_option=Enter option number: 

::set ips = ("1.1.1.1" "1.1.1.2" "1.1.1.3")
set ips=(192.168.1.1 192.168.1.2 192.168.1.3)
if "%ping_option%"=="1" (
    echo ${ips[1]}
    ping ${ips[1]}
    pause
    cls
    goto ping_IP
) else if "%ping_option%"=="2" (
    ping 1.1.1.2
    pause
    cls
    goto ping_IP
) else if "%ping_option%"=="0" (
    cls
    goto menu
) else (
    goto ping_IP
)
goto menu


:: Kiểm tra user
:check_user
set /p user=Input user name :
echo %user%
net user /domain %user% 
pause
cls
goto menu

:: Kết nối Ổ L
:map_l
net use L: \\192.168.186.3\FactoryLK /persistent:yes
echo Task Completed!
pause
cls
goto menu

:: Kết nối Ổ K
:map_k
net use K: \\192.168.152.3 /persistent:yes
echo Task Completed!
pause
cls
goto menu

:: Lấy thông tin PC
:info
wmic netlogin get name,fullname 
systeminfo | findstr /c:"Host Name"
systeminfo | findstr /c:"System Model"
echo CPU:
wmic cpu get name
systeminfo | findstr /c:"Total Physical Memory"
echo Hard Drive Space:
wmic diskdrive get model,size
ipconfig | findstr IPv4
pause
cls
goto menu

:: Đặt IP tĩnh 
:set_ip_19
echo Changing IP to 192.168.181.19
netsh interface ipv4 set address "Ethernet" static 192.168.181.19 255.255.255.0 192.168.181.1
ipconfig | find "IPv4 Address"
pause
cls
goto menu

:: Đặt IP DHCP
:set_ip_dhcp
echo Changing IP to DHCP
netsh interface ipv4 set address "Ethernet" dhcp
ipconfig | find "IPv4 Address"
pause
cls
goto menu

:: Bật SMBv1 và tạo folder scan
:Ricoh_Scan
echo =====================================================
echo =                    Enable SMBv1                   =
echo =====================================================
dism /online /enable-feature /featurename:SMB1Protocol /all
set folder=D:\Ricoh_Scan
set name=Ricoh_Scan
mkdir %folder%
net share Ricoh_Scan=%folder% /grant:Everyone,FULL
echo =====================================================
echo =        Shared path: \\%computername%\%name%       =
echo =====================================================
pause
cls
goto menu
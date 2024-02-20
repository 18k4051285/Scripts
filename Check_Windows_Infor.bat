@ECHO OFF 
:: This batch file details Windows 10, hardware, and networking configuration.
TITLE My System Info
ECHO Please wait... Checking system information.
:: Section 1: Windows 10 information
ECHO ==========================
ECHO WINDOWS INFO
ECHO ============================
wmic computersystem get "Model","Manufacturer", "Name", "UserName"
:: Section 2: Hardware information.
ECHO ============================
ECHO RAM :
systeminfo | findstr /c:"Total Physical Memory"
ECHO CPU :
wmic cpu get name
ECHO DISK :
wmic diskdrive get model,size
ECHO GPU :
wmic path win32_videocontroller get name
PAUSE

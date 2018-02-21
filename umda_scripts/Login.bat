@echo off

net config server /autodisconnect:-1

REM Remove the Network Drives
net use z: /delete /y

REM Map the Network Drives
net use z: \\umdaserver\DTWIN

REM Add Printers
REM rundll32 printui.dll,PrintUIEntry /in /n "\\umdaserver\Front Desk Main"

REM Remove Printers
REM RUNDLL32 printui.dll,PrintUIEntry /n "Send to OneNote 2016" /dl

REM Clear Dentech Temp Folder
cd %USERPROFILE%\appdata\local\temp
del ~ti*.*

REM Delete Shortcuts for Dentech Before the Script 
REM del %userprofile%\Desktop\"Dentech for Windows.lnk"
REM del C:\Users\Public\Desktop\"Dentech for Windows.lnk"

REM Delete Additional Shortcuts
del %userprofile%\Desktop\"TeamViewer 12 Host.lnk"
del C:\Users\Public\Desktop\"TeamViewer 12 Host.lnk"
del C:\Users\Public\Desktop\"Close Dentech.bat"

REM Dentech Bat File Script
z:
z:\DentechShortcutInstall.vbs

REM Install Open DNS
REM z:
REM cd Extras\Open DNS\
REM msiexec /i Setup.msi /qn ORG_ID=2340899 ORG_FINGERPRINT=bb1e3af33c90442b50f2329e1daf00e5 USER_ID=9070218

REM Sync time with server
Net Time \\UMDAServer /SET /YES

REM Install Ninja RMM
REM z:
REM cd Extras\Ninja RMM
REM umda-2.0.2413-windows-installer.msi

REM Put Stop Dentech and Amazing Charts Icons on the Desktop
REM Z:
REM cd extas\Stop Icons\
REM copy *.bat C:\Users\Public\Desktop

gpupdate /force

Exit

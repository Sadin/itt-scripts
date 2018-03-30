@echo off
%~d0
cd %~d0%~p0
:: PIN SHORTCUTS TO TASKBAR..
:: 1 for pin, 0 for unpin..


:: Unpin IE
WScript.exe "%~dp0Pin.vbs" "%programfiles%\Internet Explorer\iexplore.exe" 0


:: Pin Chrome
WScript.exe "%~dp0Pin.vbs" "%programfiles%\Google\Chrome\Application\chrome.exe" 1
:: Because im lazy and dont want to use conditional operations do it again in x86 Dir
WScript.exe "%~dp0Pin.vbs" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 1


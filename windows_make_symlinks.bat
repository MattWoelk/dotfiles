@echo off

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

set BASE_DIR=%~dp0
set source=%BASE_DIR%
set config=%BASE_DIR%configs\

ECHO starting
ECHO %HOME%
ECHO %config%

forfiles /P %config% /c "cmd /c echo @file" 

pause

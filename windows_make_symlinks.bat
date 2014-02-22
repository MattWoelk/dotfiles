@echo off

@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

set BASE_DIR=%~dp0
set config=%BASE_DIR%configs\

set HOME=%HOME%\

REM for /f %%f in ('dir /b %config%') do echo %%f

REM delete files in home directory which match those in 'configs'
for /f %%f in ('dir /b %config%') do del %HOME%%%f

REM symlink 'configs' files to home directory
for /f %%f in ('dir /b %config%') do mklink %HOME%%%f %config%%%f

pause

@echo off
setlocal

rem Folder of this script (src\)
set SRC_DIR=%~dp0

rem Repo root (one level up from src)
for %%I in ("%SRC_DIR%..") do set ROOT_DIR=%%~fI\

rem Target pak.bat
set TARGET_BAT=%ROOT_DIR%tools\UnrealPak\pak.bat

rem Shortcut path
set SHORTCUT=%SRC_DIR%pak.bat - Shortcut.lnk

rem Create shortcut using PowerShell
powershell -NoProfile -Command ^
  "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT%');" ^
  "$s.TargetPath='%TARGET_BAT%';" ^
  "$s.WorkingDirectory='%ROOT_DIR%tools\UnrealPak';" ^
  "$s.IconLocation='%ROOT_DIR%tools\UnrealPak\UnrealPak.exe,0';" ^
  "$s.Save()"

echo Shortcut updated:
echo  %SHORTCUT%
endlocal

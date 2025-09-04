@echo off
set "AppDir=C:\Program Files\Vanguard Management App"

:: VBS'i sessiz çalıştır
cscript "%AppDir%\create_shortcuts.vbs" //nologo

:: BAT kendini silsin
del "%AppDir%\post_install.bat" /f /q

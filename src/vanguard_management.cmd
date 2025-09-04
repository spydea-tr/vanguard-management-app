:: =========================================
:: Hazırlayan -> Spydea
:: İletişim / Contact -> mail@spydea.com.tr
:: =========================================

@echo off
chcp 65001
setlocal enabledelayedexpansion
cls
cd /d "%~dp0"

:: =========================================
:: Yönetici kontrolü
:: Eğer kullanıcı yönetici değilse, script kendini yönetici olarak tekrar açar ve kapanır
:: =========================================
reg query "HKU\S-1-5-19" >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~dp0vanguard_management.cmd' -Verb RunAs"
    exit
)

:: =========================================
:: ANSI renk kodları için hazırlık
:: Bu, terminalde renkleri ve özel karakterleri doğru göstermek için
:: =========================================
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E#&for %%b in (1) do rem"') do set R=%%b

:: =========================================
:: Dil kontrolü
:: lang.cfg dosyası varsa buradan dili alıyoruz, yoksa kullanıcıya soruyoruz
:: =========================================
if exist "%~dp0lang.cfg" (
    set /p language=<"%~dp0lang.cfg"
    goto setlang
)

:: Dil seçimi fonksiyonunu çağır
call :selectLanguage
goto setlang

:: =========================================
:: :selectLanguage
:: Kullanıcıya dil seçeneklerini sunar ve lang.cfg dosyasına kaydeder
:: =========================================
:selectLanguage
mode con cols=31 lines=5
echo Select Language / Dil Seçiniz:
echo 1 - English
echo 2 - Türkçe
set /p L=Choice / Seçim:

if "%L%"=="1" (
    echo english>"%~dp0lang.cfg"
    set language=english
)
if "%L%"=="2" (
    echo turkish>"%~dp0lang.cfg"
    set language=turkish
)
goto :eof

:: =========================================
:: :setlang
:: Dil seçimine göre menü başlık ve seçeneklerini ayarlar
:: =========================================
:setlang
if "%language%"=="english" (
    set "title=Vanguard Management App"
    set "line_1=!R![90m│!R![1;97m!R![100m              Vanguard Management App              !R![0m!R![90m│!R![0m"
    set "line_2=!R![90m│         !R![32m 1!R![90m-!R![33m Disable Vanguard                      !R![90m│!R![0m"
    set "line_3=!R![90m│         !R![32m 2!R![90m-!R![33m Enable Vanguard (Restarts)            !R![90m│!R![0m"
    set "line_4=!R![90m│         !R![32m 0!R![90m-!R![33m Language                              !R![90m│!R![0m"
    set "prompt_line=Choice"
)
if "%language%"=="turkish" (
    set "title=Vanguard Kontrol Yazılımı"
    set "line_1=!R![90m│!R![1;97m!R![100m             Vanguard Kontrol Yazılımı             !R![0m!R![90m│!R![0m"
    set "line_2=!R![90m│         !R![32m 1!R![90m-!R![33m Vanguard Kapat                        !R![90m│!R![0m"
    set "line_3=!R![90m│         !R![32m 2!R![90m-!R![33m Vanguard Aç (Yeniden Başlatır)        !R![90m│!R![0m"
    set "line_4=!R![90m│         !R![32m 0!R![90m-!R![33m Dil                                   !R![90m│!R![0m"
    set "prompt_line=Seçim"
)

goto main

:: =========================================
:: :main
:: Ana menü ekranı ve kullanıcıdan seçim alma
:: =========================================
:main
cls
mode con cols=55 lines=10
title %title%
echo.
echo  !R![90m┌───────────────────────────────────────────────────┐!R![0m
echo  !line_1!
echo  !R![90m├───────────────────────────────────────────────────┤!R![0m
echo  !line_2!
echo  !line_3!
echo  !line_4!
echo  !R![90m└───────────────────────────────────────────────────┘!R![0m
set /p Value=!R![92m  !prompt_line!: !R![0m

:: Kullanıcı seçimlerine göre yönlendirme
if "!Value!"=="1" goto disable
if "!Value!"=="2" goto enable
if "!Value!"=="0" goto changeLanguage

:: Hatalı giriş kontrolü
echo Invalid choice! Try again.
pause >nul
goto main

:: =========================================
:: :disable
:: Vanguard servisini devre dışı bırakır
:: =========================================
:disable
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Riot Vanguard" /f
wscript.exe "%~dp0disable_vanguard.vbs"
goto main

:: =========================================
:: :enable
:: Vanguard servisini etkinleştirir ve yeniden başlatır
:: =========================================
:enable
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Riot Vanguard" /t REG_SZ /d "\"C:\Program Files\Riot Vanguard\vgtray.exe\"" /f
wscript.exe "%~dp0enable_vanguard.vbs"
goto main

:: =========================================
:: :changeLanguage
:: Ayarlar menüsünden dil değiştirme
:: =========================================
:changeLanguage
cls
call :selectLanguage
goto setlang

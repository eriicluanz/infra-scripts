@echo off
title Instalacao de Impressora UNC - Painel
color 0A

:MENU
cls
echo ==========================================
echo   Escolha a impressora para instalar:
echo   [1] Departamento 1
echo   [2] Departamento 2
echo   [3] Sair
echo ==========================================
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="1" set "printerPath=\\servidor\impressora"
if "%opcao%"=="2" set "printerPath=\\servidor\impressora"
if "%opcao%"=="3" goto FIM
if "%opcao%"=="1" goto INSTALAR
if "%opcao%"=="2" goto INSTALAR

echo Opcao invalida. Tente novamente.
pause
goto MENU

:INSTALAR

echo Instalando impressora %printerPath%...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
" Add-Printer -ConnectionName '%printerPath%'; ^
  if ('%defaultChoice%' -match '^[Ss]$') { Set-Printer -ConnectionName '%printerPath%' -IsDefault $true; Write-Host 'Impressora definida como padrao.' -ForegroundColor Green } else { Write-Host 'Nao definida como padrao.' -ForegroundColor Yellow }"

echo.
echo Operacao concluida.
pause
goto MENU

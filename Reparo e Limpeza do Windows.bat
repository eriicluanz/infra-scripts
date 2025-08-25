@echo off
title Reparar e Limpar Windows
color 0A

echo ==========================================
echo      Reparando e limpando Windows
echo ==========================================

:: Criar pasta para logs
set LOG_DIR=%~dp0Logs
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set LOG_FILE=%LOG_DIR%\reparo_%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.log

echo Iniciando reparos... > "%LOG_FILE%"

:: 1. Verificando arquivos do sistema
echo.
echo [1/5] Executando SFC...
echo ---- SFC ---- >> "%LOG_FILE%"
sfc /scannow >> "%LOG_FILE%" 2>&1
echo SFC concluído!
echo.

:: 2. Verificando imagem do Windows com DISM
echo [2/5] Executando DISM...
echo ---- DISM ---- >> "%LOG_FILE%"
DISM /Online /Cleanup-Image /CheckHealth >> "%LOG_FILE%" 2>&1
DISM /Online /Cleanup-Image /ScanHealth >> "%LOG_FILE%" 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >> "%LOG_FILE%" 2>&1
echo DISM concluído!
echo.

:: 3. Limpando arquivos temporarios
echo [3/5] Limpando arquivos temporários...
echo ---- Limpeza de Temp ---- >> "%LOG_FILE%"
del /s /q %temp%\* >> "%LOG_FILE%" 2>&1
del /s /q C:\Windows\Temp\* >> "%LOG_FILE%" 2>&1
echo Limpeza de arquivos temporários concluída!
echo.

:: 4. Reiniciando servicos criticos
echo [4/5] Reiniciando serviços críticos...
echo ---- Reinicio de Serviços ---- >> "%LOG_FILE%"
net stop wuauserv >> "%LOG_FILE%" 2>&1
net start wuauserv >> "%LOG_FILE%" 2>&1
net stop bits >> "%LOG_FILE%" 2>&1
net start bits >> "%LOG_FILE%" 2>&1
echo Serviços reiniciados!
echo.

:: 5. Criando log final
echo [5/5] Reparos concluidos!
echo Todos os reparos foram concluidos. Log disponivel em: "%LOG_FILE%"
echo ==========================================
pause
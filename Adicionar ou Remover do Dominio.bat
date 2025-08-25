@echo off
title Gerenciamento de Dominio v1.2
color 0A

:MENU
cls
echo ==========================================
echo   [1] Remover do dominio 
echo   [2] Adicionar ao dominio 
echo   [3] Sair
echo ==========================================
set /p opcao=Escolha uma opcao:

if "%opcao%"=="1" goto REMOVER
if "%opcao%"=="2" goto ADICIONAR
if "%opcao%"=="3" goto FIM
goto MENU

:REMOVER
echo --- Removendo maquina do dominio ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
" $cred = Get-Credential -Message 'Digite as credenciais locais (ex: Administrador)'; ^
  Remove-Computer -WorkgroupName 'WORKGROUP' -Credential $cred -Force; ^
  $resp = Read-Host 'Deseja reiniciar agora? (S/N)'; ^
  if ($resp -match '^[Ss]$') { Restart-Computer -Force } else { Write-Host 'Reinicio cancelado.' -ForegroundColor Yellow }"
goto FIM

:ADICIONAR
echo --- Adicionando maquina ao dominio --- 
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
" $resp = Read-Host 'Deseja renomear a maquina antes de entrar no dominio? (S/N)'; ^
  if ($resp -match '^[Ss]$') { ^
       $novoNome = Read-Host 'Digite o novo nome da maquina'; ^
       if (![string]::IsNullOrWhiteSpace($novoNome)) { Rename-Computer -NewName $novoNome -Force; Write-Host 'Nome alterado para' $novoNome -ForegroundColor Cyan } ^
  }; ^
  $cred = Get-Credential -Message 'Digite as credenciais do dominio (ex: DOMINIO\\Administrador)'; ^
  Add-Computer -DomainName 'dominio da empresa' -Credential $cred -Force; ^
  $resp2 = Read-Host 'Deseja reiniciar agora? (S/N)'; ^
  if ($resp2 -match '^[Ss]$') { Restart-Computer -Force } else { Write-Host 'Reinicio cancelado.' -ForegroundColor Yellow }"
goto FIM

:FIM
echo.
echo Operacao concluida.
pause
exit

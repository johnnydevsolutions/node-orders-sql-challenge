@echo off
echo ========================================
echo  TESTE RAPIDO - EXERCICIO 2 SQL
echo  Professor Girafales - Horarios de Aula
echo ========================================
echo.

REM Verificar se SQLite existe
if not exist "C:\sqlite\sqlite3.exe" (
    echo [ERRO] SQLite nao encontrado em C:\sqlite\
    echo.
    echo Para instalar SQLite:
    echo 1. Abra PowerShell como Administrador
    echo 2. Execute os comandos:
    echo    mkdir C:\sqlite -Force
    echo    Invoke-WebRequest -Uri "https://www.sqlite.org/2024/sqlite-tools-win-x64-3460100.zip" -OutFile "C:\sqlite\sqlite-tools.zip"
    echo    Expand-Archive -Path "C:\sqlite\sqlite-tools.zip" -DestinationPath "C:\sqlite" -Force
    echo.
    pause
    exit /b 1
)

echo [INFO] SQLite encontrado! Executando teste...
echo.

REM Remover banco anterior se existir
if exist "escola_teste.db" del "escola_teste.db"

REM Executar o exercicio completo
echo [1/3] Criando schema e inserindo dados...
C:\sqlite\sqlite3.exe escola_teste.db < sql\exercicio2-sqlite-completo.sql

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao executar o exercicio!
    pause
    exit /b 1
)

echo [2/3] Verificando estrutura do banco...
echo .schema | C:\sqlite\sqlite3.exe escola_teste.db > estrutura_banco.txt
echo Estrutura salva em: estrutura_banco.txt

echo [3/3] Executando consulta de verificacao...
echo SELECT 'Total de professores:', COUNT(*) FROM PROFESSOR; | C:\sqlite\sqlite3.exe escola_teste.db
echo SELECT 'Total de horarios:', COUNT(*) FROM CLASS_SCHEDULE; | C:\sqlite\sqlite3.exe escola_teste.db

echo.
echo ========================================
echo  TESTE CONCLUIDO COM SUCESSO!
echo ========================================
echo.
echo Arquivos gerados:
echo - escola_teste.db (banco de dados)
echo - estrutura_banco.txt (schema)
echo.
echo Para consultas interativas:
echo C:\sqlite\sqlite3.exe escola_teste.db
echo.
pause
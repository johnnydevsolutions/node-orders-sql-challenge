Write-Host "========================================" -ForegroundColor Cyan
Write-Host " TESTE RAPIDO - EXERCICIO 2 SQL" -ForegroundColor Yellow
Write-Host " Professor Girafales - Horarios de Aula" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Função para encontrar SQLite
function Find-SQLite {
    # Tentar diferentes localizações do SQLite
    $sqlitePaths = @(
        "C:\sqlite\sqlite3.exe",
        "sqlite3.exe",  # No PATH
        "sqlite.exe"    # Alternativa no PATH
    )
    
    foreach ($path in $sqlitePaths) {
        try {
            if ($path -like "*:*") {
                # Caminho absoluto
                if (Test-Path $path) {
                    return $path
                }
            } else {
                # Comando no PATH
                $result = Get-Command $path -ErrorAction SilentlyContinue
                if ($result) {
                    return $path
                }
            }
        } catch {
            continue
        }
    }
    return $null
}

# Verificar se SQLite existe
$sqliteCommand = Find-SQLite

if (-not $sqliteCommand) {
    Write-Host "[ERRO] SQLite nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "OPCOES DE INSTALACAO:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPCAO 1 - Via Winget (Recomendado):" -ForegroundColor Cyan
    Write-Host "   winget install SQLite.SQLite" -ForegroundColor Gray
    Write-Host ""
    Write-Host "OPCAO 2 - Manual em C:\sqlite:" -ForegroundColor Cyan
    Write-Host "   mkdir C:\sqlite -Force" -ForegroundColor Gray
    Write-Host "   Invoke-WebRequest -Uri 'https://www.sqlite.org/2024/sqlite-tools-win-x64-3460100.zip' -OutFile 'C:\sqlite\sqlite-tools.zip'" -ForegroundColor Gray
    Write-Host "   Expand-Archive -Path 'C:\sqlite\sqlite-tools.zip' -DestinationPath 'C:\sqlite' -Force" -ForegroundColor Gray
    Write-Host ""
    Write-Host "OPCAO 3 - Instalacao automatica:" -ForegroundColor Cyan
    $autoInstall = Read-Host "Deseja tentar instalar automaticamente via winget? (s/n)"
    
    if ($autoInstall -eq "s" -or $autoInstall -eq "S") {
        Write-Host "[INFO] Tentando instalar SQLite via winget..." -ForegroundColor Yellow
        try {
            winget install SQLite.SQLite --accept-source-agreements --accept-package-agreements
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[SUCESSO] SQLite instalado! Reinicie o terminal e execute novamente." -ForegroundColor Green
                Read-Host "Pressione Enter para sair"
                exit 0
            } else {
                throw "Falha na instalacao via winget"
            }
        } catch {
            Write-Host "[ERRO] Falha na instalacao automatica. Use uma das opcoes manuais acima." -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "[INFO] SQLite encontrado: $sqliteCommand" -ForegroundColor Green
Write-Host ""

# Remover banco anterior se existir
if (Test-Path "escola_teste.db") {
    Remove-Item "escola_teste.db" -Force
    Write-Host "[INFO] Banco anterior removido" -ForegroundColor Yellow
}

try {
    # Executar o exercicio completo
    Write-Host "[1/4] Executando exercicio completo..." -ForegroundColor Cyan
    # Configurar encoding UTF-8 para o PowerShell
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $env:SQLITE_CHARSET = "UTF-8"
    
    # Usar sqlite3 dinamicamente com o comando encontrado
    & $sqliteCommand escola_teste.db ".read sql\exercicio2-sqlite-limpo.sql"
    
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao executar o exercicio!"
    }
    
    Write-Host "Exercicio executado com sucesso!" -ForegroundColor Green
    
    # Verificar estrutura do banco
    Write-Host "[2/4] Verificando estrutura do banco..." -ForegroundColor Cyan
    echo ".schema" | & $sqliteCommand escola_teste.db | Out-File "estrutura_banco.txt" -Encoding UTF8
    Write-Host "Estrutura salva em: estrutura_banco.txt" -ForegroundColor Green
    
    # Executar consultas de verificacao
    Write-Host "[3/4] Executando consultas de verificacao..." -ForegroundColor Cyan
    
    Write-Host "--- CONTADORES ---" -ForegroundColor Yellow
    echo "SELECT 'Total de professores:', COUNT(*) FROM PROFESSOR;" | & $sqliteCommand escola_teste.db
    echo "SELECT 'Total de disciplinas:', COUNT(*) FROM SUBJECT;" | & $sqliteCommand escola_teste.db
    echo "SELECT 'Total de horarios:', COUNT(*) FROM CLASS_SCHEDULE;" | & $sqliteCommand escola_teste.db
    
    Write-Host "--- EXEMPLO DE CONSULTA PRINCIPAL ---" -ForegroundColor Yellow
    $query = "SELECT p.id as professor_id, p.name as nome_professor, d.name as departamento FROM PROFESSOR p JOIN DEPARTMENT d ON p.department_id = d.id LIMIT 3;"
    
    echo $query | & $sqliteCommand escola_teste.db
    
    # Informacoes finais
    Write-Host "[4/4] Teste concluido!" -ForegroundColor Cyan
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " TESTE CONCLUIDO COM SUCESSO!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Arquivos gerados:" -ForegroundColor Yellow
    Write-Host "   - escola_teste.db (banco de dados)" -ForegroundColor White
    Write-Host "   - estrutura_banco.txt (schema)" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Para consultas interativas:" -ForegroundColor Yellow
    Write-Host "   $sqliteCommand escola_teste.db" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Para ver todas as consultas:" -ForegroundColor Yellow
    Write-Host "   Get-Content sql\exercicio2-sqlite-completo.sql | $sqliteCommand escola_teste.db" -ForegroundColor Gray
    Write-Host ""
    
} catch {
    Write-Host "[ERRO] Falha na execucao" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Read-Host "Pressione Enter para sair"
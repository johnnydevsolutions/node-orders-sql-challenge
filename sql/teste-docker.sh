#!/bin/sh

echo "========================================"
echo " TESTE SQL - DENTRO DO CONTAINER DOCKER"
echo "========================================"
echo ""

# Verificar se SQLite existe
if ! command -v sqlite3 >/dev/null 2>&1; then
    echo "[ERRO] SQLite não encontrado no container!"
    exit 1
fi

echo "[INFO] SQLite encontrado no container!"
echo ""

# Remover banco anterior se existir
if [ -f "escola_teste.db" ]; then
    rm -f escola_teste.db
    echo "[INFO] Banco anterior removido"
fi

# Executar o exercício completo
echo "[1/3] Executando exercício completo..."
sqlite3 escola_teste.db ".read sql/exercicio2-sqlite-limpo.sql"

if [ $? -ne 0 ]; then
    echo "[ERRO] Falha ao executar o exercício!"
    exit 1
fi

echo "[SUCESSO] Exercício executado com sucesso!"

# Verificar estrutura do banco
echo "[2/3] Verificando estrutura do banco..."
echo ".schema" | sqlite3 escola_teste.db > estrutura_banco.txt
echo "Estrutura salva em: estrutura_banco.txt"

# Executar consultas de verificação
echo "[3/3] Executando consultas de verificação..."

echo "--- CONTADORES ---"
echo "SELECT 'Total de professores:', COUNT(*) FROM PROFESSOR;" | sqlite3 escola_teste.db
echo "SELECT 'Total de disciplinas:', COUNT(*) FROM SUBJECT;" | sqlite3 escola_teste.db
echo "SELECT 'Total de horários:', COUNT(*) FROM CLASS_SCHEDULE;" | sqlite3 escola_teste.db

echo "--- EXEMPLO DE CONSULTA PRINCIPAL ---"
echo "SELECT p.id as professor_id, p.name as nome_professor, d.name as departamento FROM PROFESSOR p JOIN DEPARTMENT d ON p.department_id = d.id LIMIT 3;" | sqlite3 escola_teste.db

echo ""
echo "========================================"
echo " TESTE CONCLUÍDO COM SUCESSO!"
echo "========================================"
echo ""
echo "Arquivos gerados:"
echo "   - escola_teste.db (banco de dados)"
echo "   - estrutura_banco.txt (schema)"
echo ""
echo "Para consultas interativas:"
echo "   sqlite3 escola_teste.db"
echo ""
# Avaliação Técnica - Node (NestJS) - Empacotamento + SQL

## ⚙️ Configuração de Ambiente

### Pré-requisitos
1. **Configurar variáveis de ambiente:**
   ```bash
   # Copie o arquivo de exemplo
   cp .env.example .env
   
   # Edite o arquivo .env e configure:
   # - JWT_SECRET: Chave secreta para JWT (obrigatório)
   # - PORT: Porta do servidor (padrão: 3000)
   ```

2. **Gerar JWT_SECRET seguro:**
   ```bash
   # Execute este comando para gerar uma chave segura
   node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
   ```

### ⚠️ Importante
- **JWT_SECRET é obrigatório** - A aplicação não iniciará sem ele
- Use uma chave com pelo menos 32 caracteres
- **Nunca** commite o arquivo `.env` no repositório

## Como rodar (Docker)
```bash
docker compose up --build
# Swagger em: http://localhost:3000/swagger
```

## Como rodar (local)
```bash
npm ci
npm run start:dev
# Swagger em: http://localhost:3000/swagger
```

## Endpoint
`POST /orders/pack`

### Exemplo de payload
Vide `examples/entrada.json`.

## Estratégia do Empacotamento
- Heurística **greedy por volume**: ordena produtos por volume desc., tenta colocar em caixas abertas, senão abre a **menor caixa** que comporte o item (testando todas as rotações).
- **Tipos de caixas**: 30x40x80, 50x50x40, 50x80x60.

> Observação: este algoritmo **não é um 3D bin packing ótimo**; é uma heurística rápida e explicável.

## Extras
- Swagger configurado.
- Teste unitário básico (`jest`).
- Dockerfile + docker-compose para execução.

## Como Testar

### Exercício 1 - Node.js
```bash
# Instalar dependências
npm install

# Executar testes
npm test

# Executar aplicação
npm start
```

### Exercício 2 - SQL (SQLite)

#### 🚀 TESTE RÁPIDO (Recomendado para Recrutadores)

**Opção 1 - Via Docker (Mais Simples):**
```powershell
# Subir o container com SQLite já instalado
docker compose up --build

# Em outro terminal, executar teste SQL dentro do container
docker compose exec api sh sql/teste-docker.sh
```

**Opção 2 - Script Local (Requer SQLite instalado):**
```powershell
# Execute o script de teste rápido
.\sql\teste-rapido.ps1
```

**Opção 3 - Comando Único Local:**
```powershell
# Executa tudo de uma vez (schema + dados + consultas)
Get-Content sql\exercicio2-sqlite-completo.sql | sqlite3 escola_teste.db
```

#### 📋 Instruções Detalhadas
- **Para recrutadores:** Consulte `sql/INSTRUCOES_RECRUTADOR.md`
- **Instalação SQLite:** Consulte `INSTALACAO-SQLITE.md` para guia completo
- **Pré-requisito:** SQLite instalado (múltiplas opções disponíveis)
- **Tempo estimado:** 5-10 minutos

#### 🔧 Teste Passo a Passo
```powershell
# 1. Criar schema
Get-Content sql\schema-sqlite.sql | C:\sqlite\sqlite3.exe escola_teste.db

# 2. Inserir dados
Get-Content sql\sample_data-sqlite.sql | C:\sqlite\sqlite3.exe escola_teste.db

# 3. Executar consultas
Get-Content sql\queries-sqlite.sql | C:\sqlite\sqlite3.exe escola_teste.db
```

#### 📊 Resultados Esperados
- ✅ Horas comprometidas por professor (semanal/semestral)
- ✅ Horários ocupados por sala
- ✅ Horários livres entre aulas
- ✅ Cenário do Professor Girafales implementado

## Exercício 2 (SQL)
Consulte a pasta `sql/`.

## Notas de Projeto
- Sem banco de dados: serviço puro de cálculo.
- Autenticação (opcional) pode ser adicionada com `AuthGuard` + JWT caso necessário.

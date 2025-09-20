# EXERCÍCIO 2 - HORÁRIOS DE AULA

## Descrição do Problema

O Professor Girafales se tornou o novo diretor da escola do Chavito e precisa saber algumas informações sobre os horários de aula. Com base no modelo ER fornecido, foram desenvolvidas consultas SQL para atender às necessidades administrativas.

## Estrutura do Projeto

```
sql/
├── README.md                      # Este arquivo com documentação
├── schema.sql                     # Schema original (PostgreSQL)
├── sample_data.sql               # Dados originais (PostgreSQL)
├── queries.sql                   # Queries originais (PostgreSQL)
├── schema-sqlite.sql             # Schema convertido para SQLite
├── sample_data-sqlite.sql        # Dados convertidos para SQLite
├── queries-sqlite.sql            # Queries convertidas para SQLite
├── exercicio2-sqlite-completo.sql # Arquivo original completo
├── exercicio2-sqlite-limpo.sql   # Versão otimizada (recomendada)
├── teste-rapido.ps1              # Script automatizado de teste
└── teste-rapido.bat              # Script alternativo para Windows
```

---

# 📋 INSTRUÇÕES PARA RECRUTADOR

## 🎯 Como Avaliar o Exercício SQL

Este documento contém os comandos exatos que o recrutador deve executar para testar o Exercício 2 de forma padronizada.

---

## 🚀 OPÇÃO 1: Teste Automatizado (Recomendado)

### Comando Principal:
```powershell
.\sql\teste-rapido.ps1
```

**O que este script faz:**
-  Verifica se SQLite está instalado
-  Remove banco anterior (se existir)
-  Cria o schema completo
-  Insere todos os dados de exemplo
-  Executa todas as consultas solicitadas
-  Gera arquivo de estrutura do banco
-  Executa consultas de verificação
-  Mostra contadores e estatísticas

### Alternativa para Windows (Batch):
```cmd
.\sql\teste-rapido.bat
```

---

## 🔧 OPÇÃO 2: Comando Único Manual

### Executa Tudo de Uma Vez:
```powershell
Get-Content sql\exercicio2-sqlite-limpo.sql | C:\sqlite\sqlite3.exe escola_teste.db
```

**O que este comando faz:**
-  Cria o schema completo
-  Insere todos os dados de exemplo
-  Executa todas as consultas solicitadas
-  Mostra os resultados na tela

---

## 📊 RESULTADOS ESPERADOS

### 1️⃣ Horas Comprometidas por Professor:
```
professor_id | nome_professor | departamento | titulo           | horas_semanais | horas_semestrais
1           | Professor 1    | Matemática   | Diretor          | 18.0          | 288.0
2           | Professor 2    | Matemática   | Professor Titular| 12.0          | 192.0
3           | Professor 3    | História     | Professor Adjunto| 6.0           | 96.0
4           | Professor 4    | Ciências     | Professor Titular| 4.0           | 64.0
```

### 2️⃣ Horários Ocupados por Sala (Exemplo):
```
sala_id | nome_sala | predio           | dia_semana    | hora_inicio | hora_fim | disciplina        | codigo_turma | professor
1       | Sala 1    | Prédio Principal | Segunda-feira | 08:00       | 10:00    | Matemática Básica | MAT001-T1    | Professor 1
1       | Sala 1    | Prédio Principal | Segunda-feira | 14:00       | 16:00    | Álgebra Linear    | MAT002-T1    | Professor 1
```

### 3️⃣ Horários Livres Entre Aulas:
```
sala_id | nome_sala | predio           | dia_semana    | livre_inicio | livre_fim | horas_livres
1       | Sala 1    | Prédio Principal | Segunda-feira | 10:00        | 14:00     | 4.0
```

### 4️⃣ Funcionalidades Extras (Bônus):
- **Salas Livres na Segunda-feira:** 9 salas completamente disponíveis
- **Top 3 Professores:** Ranking por carga horária
- **Pré-requisitos:** Álgebra Linear requer Matemática Básica

---

##  CRITÉRIOS DE AVALIAÇÃO

### 🎯 Funcionalidades Obrigatórias:
- [ ] **Consulta 1:** Horas comprometidas por professor (semanal e semestral)
- [ ] **Consulta 2a:** Lista de horários ocupados por sala
- [ ] **Consulta 2b:** Lista de horários livres entre aulas
- [ ] **Schema:** Modelo ER implementado corretamente
- [ ] **Dados:** Cenário do Professor Girafales com dados realistas

### 🌟 Funcionalidades Extras (Bônus):
- [ ] Salas completamente livres em um dia específico
- [ ] Top 3 professores com maior carga horária
- [ ] Lista de disciplinas com pré-requisitos
- [ ] Índices para otimização de performance
- [ ] Script automatizado de teste
- [ ] Documentação clara e completa

### 🔧 Aspectos Técnicos:
- [ ] **Compatibilidade:** Funciona em SQLite sem erros
- [ ] **Performance:** Consultas otimizadas com índices
- [ ] **Integridade:** Constraints e chaves estrangeiras
- [ ] **Legibilidade:** Código SQL bem formatado
- [ ] **Automação:** Scripts de teste funcionais

---

## 🛠️ COMANDOS DE VERIFICAÇÃO

### Verificar Estrutura do Banco:
```powershell
echo ".schema" | C:\sqlite\sqlite3.exe escola_teste.db
```

### Contar Registros:
```powershell
echo "SELECT 'Professores:', COUNT(*) FROM PROFESSOR; SELECT 'Disciplinas:', COUNT(*) FROM SUBJECT; SELECT 'Horários:', COUNT(*) FROM CLASS_SCHEDULE;" | C:\sqlite\sqlite3.exe escola_teste.db
```

### Consulta Interativa:
```powershell
C:\sqlite\sqlite3.exe escola_teste.db
```

---

## 🎯 BOAS PRÁTICAS PARA AVALIAÇÃO

### ⏱️ Tempo Estimado:
- **Execução do teste:** 2-3 minutos
- **Análise dos resultados:** 5-10 minutos
- **Avaliação completa:** 15-20 minutos

### 📋 Pré-requisitos:
- SQLite instalado em `C:\sqlite\sqlite3.exe`
- PowerShell habilitado
- Acesso à pasta do projeto

### 📁 Arquivos Gerados (Temporários):
- `escola_teste.db` - Banco de dados de teste
- `estrutura_banco.txt` - Schema do banco para verificação

**Nota:** Estes arquivos são temporários e não devem ser commitados (já estão no .gitignore).

---

## 🚨 SOLUÇÕES PARA PROBLEMAS COMUNS

### ❌ "SQLite não encontrado":
```powershell
# Baixar SQLite de: https://sqlite.org/download.html
# Extrair para: C:\sqlite\
# Ou ajustar caminho no script
```

### ❌ "Erro de redirecionamento":
```powershell
# Usar comando direto:
C:\sqlite\sqlite3.exe escola_teste.db ".read sql\exercicio2-sqlite-limpo.sql"
```

### ❌ "Caracteres especiais bugados":
- O encoding UTF-8 está configurado no script
- Resultados devem mostrar: "Matemática", "História", "Prédio"

---

## 📚 ARQUIVOS DE REFERÊNCIA

- **`exercicio2-sqlite-limpo.sql`** - Versão principal otimizada
- **`teste-rapido.ps1`** - Script automatizado principal
- **`teste-rapido.bat`** - Script alternativo para Windows
- **Este README.md** - Documentação completa

---

## 🚀 Como Executar - OPÇÃO 3: Teste Online (Alternativo)

### Teste Online (Para Verificação Adicional)
1. Acesse uma das plataformas:
   - **SQLite Online:** https://sqliteonline.com/
   - **DB Fiddle:** https://www.db-fiddle.com/ (selecione SQLite)
   - **OneCompiler:** https://onecompiler.com/sqlite

2. **Copie e cole o conteúdo completo do arquivo `exercicio2-sqlite-limpo.sql`**

3. **Execute o script** - ele contém:
   -  Criação do schema
   -  Inserção dos dados de exemplo
   -  Todas as consultas solicitadas

---

## 🐘 Como Executar - OPÇÃO 4: PostgreSQL (Original)

1. **Criar o banco de dados:**
   ```bash
   psql -U postgres -c "CREATE DATABASE escola_horarios;"
   ```

2. **Executar o schema:**
   ```bash
   psql -U postgres -d escola_horarios -f schema.sql
   ```

3. **Inserir dados de exemplo:**
   ```bash
   psql -U postgres -d escola_horarios -f sample_data.sql
   ```

4. **Executar as consultas:**
   ```bash
   psql -U postgres -d escola_horarios -f queries.sql
   ```

## Modelo ER Implementado

O modelo implementa as seguintes entidades e relacionamentos:

- **DEPARTMENT** (Departamento)
- **PROFESSOR** (Professor) - relacionado com Department e Title
- **TITLE** (Título/Cargo do Professor)
- **SUBJECT** (Disciplina)
- **SUBJECT_PREREQUISITE** (Pré-requisitos entre disciplinas)
- **CLASS** (Turma de uma disciplina)
- **CLASS_SCHEDULE** (Horário de aula de uma turma)
- **ROOM** (Sala de aula)
- **BUILDING** (Prédio)
- **SUBJECT_PROFESSOR** (Relacionamento N:N entre Professor e Disciplina)

## 🎯 Consultas SQL Implementadas

### 1) Quantidade de horas que cada professor tem comprometido em aulas

Retorna para cada professor:
- ID e informações do professor
- Departamento e título
- Horas comprometidas por semana
- Horas comprometidas por semestre (16 semanas)

### 2) Lista de salas com horários livres e ocupados

**2.1) Horários Ocupados:**
- Lista todos os horários ocupados por sala
- Inclui informações da disciplina, turma e professor
- Organizado por sala, dia da semana e horário

**2.2) Horários Livres:**
- Calcula intervalos livres entre aulas
- Considera horário de funcionamento das 07:00 às 22:00
- Mostra duração dos períodos livres

### 3) Consultas Adicionais

- Salas completamente livres em um dia específico
- Top 3 professores com maior carga horária
- Lista de disciplinas com seus pré-requisitos

## 🔧 Características Técnicas

### SQLite (Versão Recomendada)
- **Banco de Dados:** SQLite 3.x
- **Vantagens:** Arquivo único, sem instalação, portável
- **Funções:** strftime() para manipulação de tempo
- **Tipos:** INTEGER, TEXT, REAL

### PostgreSQL (Versão Original)
- **Banco de Dados:** PostgreSQL 12+
- **Índices:** Criados para otimizar consultas frequentes
- **Constraints:** Chaves estrangeiras e validações implementadas
- **Funções:** EXTRACT(), LAG() para análises avançadas

## 📊 Exemplo de Resultado

### Horas Comprometidas por Professor:
```
professor_id | nome_professor | departamento | horas_comprometidas_por_semana
1           | Professor 1    | Matemática   | 12.0
2           | Professor 2    | História     | 8.0
```

### Horários Ocupados:
```
sala_id | nome_sala | dia_semana    | hora_inicio | hora_fim | disciplina
1       | Sala 1    | Segunda-feira | 08:00       | 10:00    | Matemática Básica
1       | Sala 1    | Segunda-feira | 14:00       | 16:00    | Álgebra Linear
```

### Horários Livres:
```
sala_id | nome_sala | dia_semana    | livre_inicio | livre_fim | horas_livres
1       | Sala 1    | Segunda-feira | 10:00        | 14:00     | 4.0
1       | Sala 1    | Segunda-feira | 16:00        | 22:00     | 6.0
```

## 🌟 Links Úteis para Teste

### Plataformas Online SQLite:
- **SQLite Online:** https://sqliteonline.com/ ⭐ (Mais simples)
- **DB Fiddle:** https://www.db-fiddle.com/ (Selecione SQLite)
- **OneCompiler:** https://onecompiler.com/sqlite
- **SQL.js Playground:** https://sql.js.org/examples/GUI/

### Plataformas Online PostgreSQL:
- **DB Fiddle:** https://www.db-fiddle.com/ (Selecione PostgreSQL)
- **PostgreSQL Online:** https://extendsclass.com/postgresql-online.html

## 📝 Observações

- **SQLite é mais adequado** para este exercício por ser mais simples e portável
- Os nomes das tabelas e campos seguem o padrão do modelo ER fornecido
- As consultas são otimizadas para performance com uso de índices
- O código SQLite é mais compatível entre diferentes plataformas
- Os dados de exemplo incluem o cenário do Professor Girafales como solicitado
- **Recomendação:** Use o arquivo `exercicio2-sqlite-completo.sql` em https://sqliteonline.com/ para teste rápido

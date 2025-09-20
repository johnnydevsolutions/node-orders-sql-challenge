-- ========================================
-- EXERCÍCIO 2 - SISTEMA DE HORÁRIOS ESCOLARES
-- Professor Girafales - Versão Limpa
-- ========================================

-- Remover tabelas existentes (se existirem)
DROP TABLE IF EXISTS SUBJECT_PROFESSOR;
DROP TABLE IF EXISTS CLASS_SCHEDULE;
DROP TABLE IF EXISTS CLASS;
DROP TABLE IF EXISTS SUBJECT_PREREQUISITE;
DROP TABLE IF EXISTS SUBJECT;
DROP TABLE IF EXISTS PROFESSOR;
DROP TABLE IF EXISTS TITLE;
DROP TABLE IF EXISTS ROOM;
DROP TABLE IF EXISTS BUILDING;
DROP TABLE IF EXISTS DEPARTMENT;

-- Remover índices existentes (se existirem)
DROP INDEX IF EXISTS idx_class_schedule_room_day;
DROP INDEX IF EXISTS idx_class_schedule_time;
DROP INDEX IF EXISTS idx_professor_department;
DROP INDEX IF EXISTS idx_subject_prerequisite;

-- ========================================
-- CRIAÇÃO DO SCHEMA
-- ========================================

-- Tabela de Departamentos
CREATE TABLE DEPARTMENT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Tabela de Prédios
CREATE TABLE BUILDING (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Tabela de Salas
CREATE TABLE ROOM (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    building_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (building_id) REFERENCES BUILDING(id)
);

-- Tabela de Títulos Acadêmicos
CREATE TABLE TITLE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Tabela de Professores
CREATE TABLE PROFESSOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INTEGER NOT NULL,
    title_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(id),
    FOREIGN KEY (title_id) REFERENCES TITLE(id)
);

-- Tabela de Disciplinas
CREATE TABLE SUBJECT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(id)
);

-- Tabela de Pré-requisitos
CREATE TABLE SUBJECT_PREREQUISITE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    prerequisite_subject_id INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id),
    FOREIGN KEY (prerequisite_subject_id) REFERENCES SUBJECT(id),
    UNIQUE(subject_id, prerequisite_subject_id)
);

-- Tabela de Turmas
CREATE TABLE CLASS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    class_code TEXT NOT NULL UNIQUE,
    semester TEXT NOT NULL,
    year INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id)
);

-- Tabela de Horários das Turmas
CREATE TABLE CLASS_SCHEDULE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    day_of_week TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES CLASS(id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id)
);

-- Tabela de Relacionamento Professor-Disciplina
CREATE TABLE SUBJECT_PROFESSOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    professor_id INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id),
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(id),
    UNIQUE(subject_id, professor_id)
);

-- ========================================
-- CRIAÇÃO DE ÍNDICES PARA PERFORMANCE
-- ========================================

CREATE INDEX idx_class_schedule_room_day ON CLASS_SCHEDULE(room_id, day_of_week);
CREATE INDEX idx_class_schedule_time ON CLASS_SCHEDULE(start_time, end_time);
CREATE INDEX idx_professor_department ON PROFESSOR(department_id);
CREATE INDEX idx_subject_prerequisite ON SUBJECT_PREREQUISITE(subject_id);

-- ========================================
-- INSERÇÃO DE DADOS DE EXEMPLO
-- Cenário: Professor Girafales e sua escola
-- ========================================

-- Inserir Departamentos
INSERT INTO DEPARTMENT (name) VALUES 
('Departamento de Matemática'),
('Departamento de História'),
('Departamento de Ciências'),
('Departamento de Literatura');

-- Inserir Prédios
INSERT INTO BUILDING (name) VALUES 
('Prédio Principal'),
('Prédio de Ciências'),
('Prédio Administrativo');

-- Inserir Salas
INSERT INTO ROOM (building_id, name) VALUES 
(1, 'Sala 1'), (1, 'Sala 2'), (1, 'Sala 3'),
(1, 'Sala 7'), (1, 'Sala 8'), (1, 'Sala 9'),
(2, 'Sala 4'), (2, 'Sala 5'),
(2, 'Sala 10'), (2, 'Sala 11'),
(3, 'Sala 6'), (3, 'Sala 12');

-- Inserir Títulos Acadêmicos
INSERT INTO TITLE (name) VALUES 
('Professor Titular'),
('Professor Adjunto'),
('Professor Assistente'),
('Diretor');

-- Inserir Professores (incluindo Professor Girafales)
INSERT INTO PROFESSOR (department_id, title_id, name) VALUES 
(1, 4, 'Professor 1'),  -- Diretor de Matemática
(1, 1, 'Professor 2'),  -- Professor Titular de Matemática
(2, 2, 'Professor 3'),  -- Professor Adjunto de História
(3, 1, 'Professor 4'),  -- Professor Titular de Ciências
(1, 4, 'Professor 5'),  -- Diretor de Matemática
(1, 1, 'Professor 6'),  -- Professor Titular de Matemática
(2, 2, 'Professor 7'),  -- Professor Adjunto de História
(3, 1, 'Professor 8');  -- Professor Titular de Ciências

-- Inserir Disciplinas
INSERT INTO SUBJECT (subject_id, name, department_id) VALUES 
('MAT-001', 'Matemática Básica', 1),
('MAT-002', 'Álgebra Linear', 1),
('HIS-001', 'História do Brasil', 2),
('CIE-001', 'Física Geral', 3),
('LIT-001', 'Literatura Brasileira', 4);

-- Inserir Pré-requisitos
INSERT INTO SUBJECT_PREREQUISITE (subject_id, prerequisite_subject_id) VALUES 
(2, 1); -- Álgebra Linear requer Matemática Básica

-- Inserir Turmas
INSERT INTO CLASS (subject_id, class_code, semester, year) VALUES 
(1, 'MAT001-T1', '2024-1', 2024),
(1, 'MAT001-T2', '2024-1', 2024),
(2, 'MAT002-T1', '2024-1', 2024),
(3, 'HIS001-T1', '2024-1', 2024),
(4, 'CIE001-T1', '2024-1', 2024);

-- Inserir Horários das Turmas
INSERT INTO CLASS_SCHEDULE (class_id, room_id, day_of_week, start_time, end_time) VALUES 
-- Matemática Básica T1 (Professor 1 e 2)
(1, 1, 'Segunda-feira', '08:00', '10:00'),
(1, 1, 'Terça-feira', '08:00', '10:00'),
(1, 1, 'Quinta-feira', '08:00', '10:00'),

-- Matemática Básica T2 (Professor 1 e 2)
(2, 2, 'Segunda-feira', '10:00', '12:00'),
(2, 2, 'Terça-feira', '14:00', '16:00'),
(2, 2, 'Quinta-feira', '10:00', '12:00'),

-- Álgebra Linear T1 (Professor 1)
(3, 1, 'Segunda-feira', '14:00', '16:00'),
(3, 1, 'Quarta-feira', '08:00', '10:00'),
(3, 1, 'Sexta-feira', '08:00', '10:00'),

-- História do Brasil T1 (Professor 3)
(4, 3, 'Segunda-feira', '16:00', '18:00'),
(4, 3, 'Quarta-feira', '10:00', '12:00'),
(4, 3, 'Sexta-feira', '14:00', '16:00'),

-- Física Geral T1 (Professor 4)
(5, 4, 'Terça-feira', '10:00', '12:00'),
(5, 4, 'Quarta-feira', '14:00', '16:00');

-- Inserir Relacionamentos Professor-Disciplina
INSERT INTO SUBJECT_PROFESSOR (subject_id, professor_id) VALUES 
(1, 1), (1, 2), -- Matemática Básica: Professor 1 e 2
(2, 1),         -- Álgebra Linear: Professor 1
(3, 3),         -- História do Brasil: Professor 3
(4, 4);         -- Física Geral: Professor 4

-- ========================================
-- CONSULTAS SOLICITADAS
-- ========================================

.print "=== HORAS COMPROMETIDAS POR PROFESSOR ==="
SELECT 
    p.id as professor_id,
    p.name as nome_professor,
    d.name as departamento,
    t.name as titulo,
    ROUND(SUM((strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0), 1) as horas_comprometidas_por_semana,
    ROUND(SUM((strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0) * 16, 1) as horas_comprometidas_por_semestre
FROM PROFESSOR p
JOIN DEPARTMENT d ON p.department_id = d.id
JOIN TITLE t ON p.title_id = t.id
LEFT JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
LEFT JOIN SUBJECT s ON sp.subject_id = s.id
LEFT JOIN CLASS c ON s.id = c.subject_id
LEFT JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, p.name, d.name, t.name
ORDER BY horas_comprometidas_por_semana DESC;

.print "=== HORÁRIOS OCUPADOS POR SALA ==="
SELECT 
    r.id as sala_id,
    r.name as nome_sala,
    b.name as predio,
    cs.day_of_week as dia_semana,
    cs.start_time as hora_inicio,
    cs.end_time as hora_fim,
    s.name as disciplina,
    cl.class_code as codigo_turma,
    COALESCE(GROUP_CONCAT(p.name, ', '), '—') as professores
FROM ROOM r
JOIN BUILDING b ON r.building_id = b.id
JOIN CLASS_SCHEDULE cs ON r.id = cs.room_id
JOIN CLASS cl ON cs.class_id = cl.id
JOIN SUBJECT s ON cl.subject_id = s.id
LEFT JOIN SUBJECT_PROFESSOR sp ON s.id = sp.subject_id
LEFT JOIN PROFESSOR p ON sp.professor_id = p.id
GROUP BY r.id, r.name, b.name, cs.day_of_week, cs.start_time, cs.end_time, s.name, cl.class_code
ORDER BY r.id, cs.day_of_week, cs.start_time;

.print "=== HORÁRIOS LIVRES (COMPLETO: ANTES/ENTRE/DEPOIS) ==="
-- Versão completa que inclui gaps antes da primeira aula, entre aulas e após a última aula
WITH bounds AS (
    SELECT 1 AS day_of_week, time('07:00') AS open_time, time('22:00') AS close_time UNION ALL
    SELECT 2, time('07:00'), time('22:00') UNION ALL
    SELECT 3, time('07:00'), time('22:00') UNION ALL
    SELECT 4, time('07:00'), time('22:00') UNION ALL
    SELECT 5, time('07:00'), time('22:00') UNION ALL
    SELECT 6, time('07:00'), time('22:00') UNION ALL
    SELECT 7, time('07:00'), time('22:00')
),
first_last AS (
    SELECT 
        r.id AS room_id,
        cs.day_of_week,
        MIN(cs.start_time) AS first_start,
        MAX(cs.end_time) AS last_end
    FROM CLASS_SCHEDULE cs
    JOIN ROOM r ON r.id = cs.room_id
    GROUP BY r.id, cs.day_of_week
),
between_classes AS (
    SELECT 
        cs1.room_id AS room_id,
        cs1.day_of_week,
        cs1.end_time AS free_from,
        cs2.start_time AS free_to
    FROM CLASS_SCHEDULE cs1
    JOIN CLASS_SCHEDULE cs2 ON cs1.room_id = cs2.room_id
        AND cs1.day_of_week = cs2.day_of_week
        AND cs1.end_time < cs2.start_time
    WHERE NOT EXISTS (
        SELECT 1 FROM CLASS_SCHEDULE cs3
        WHERE cs3.room_id = cs1.room_id
        AND cs3.day_of_week = cs1.day_of_week
        AND cs3.start_time > cs1.end_time
        AND cs3.start_time < cs2.start_time
    )
),
before_first AS (
    SELECT 
        fl.room_id,
        fl.day_of_week,
        b.open_time AS free_from,
        fl.first_start AS free_to
    FROM first_last fl
    JOIN bounds b ON b.day_of_week = fl.day_of_week
    WHERE b.open_time < fl.first_start
),
after_last AS (
    SELECT 
        fl.room_id,
        fl.day_of_week,
        fl.last_end AS free_from,
        b.close_time AS free_to
    FROM first_last fl
    JOIN bounds b ON b.day_of_week = fl.day_of_week
    WHERE fl.last_end < b.close_time
),
all_gaps AS (
    SELECT * FROM between_classes
    UNION ALL SELECT * FROM before_first
    UNION ALL SELECT * FROM after_last
)
SELECT 
    r.id AS sala_id,
    r.name AS nome_sala,
    bld.name AS predio,
    ag.day_of_week AS dia_semana,
    ag.free_from AS livre_inicio,
    ag.free_to AS livre_fim,
    ROUND((strftime('%s', ag.free_to) - strftime('%s', ag.free_from)) / 3600.0, 1) AS horas_livres
FROM all_gaps ag
JOIN ROOM r ON r.id = ag.room_id
JOIN BUILDING bld ON bld.id = r.building_id
WHERE ag.free_from < ag.free_to
ORDER BY sala_id, ag.day_of_week, livre_inicio;

-- ========================================
-- CONSULTAS EXTRAS (BÔNUS)
-- ========================================

.print "=== SALAS COMPLETAMENTE LIVRES NA SEGUNDA-FEIRA ==="
SELECT 
    r.id as sala_id,
    r.name as nome_sala,
    b.name as predio,
    'Segunda-feira' as dia_livre
FROM ROOM r
JOIN BUILDING b ON r.building_id = b.id
WHERE r.id NOT IN (
    SELECT DISTINCT cs.room_id 
    FROM CLASS_SCHEDULE cs 
    WHERE cs.day_of_week = 'Segunda-feira'
)
ORDER BY r.id;

.print "=== TOP 3 PROFESSORES COM MAIOR CARGA HORÁRIA ==="
SELECT 
    p.id as professor_id,
    p.name as nome_professor,
    d.name as departamento,
    ROUND(SUM((strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0), 1) as horas_semanais
FROM PROFESSOR p
JOIN DEPARTMENT d ON p.department_id = d.id
JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
JOIN SUBJECT s ON sp.subject_id = s.id
JOIN CLASS c ON s.id = c.subject_id
JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, p.name, d.name
ORDER BY horas_semanais DESC
LIMIT 3;

.print "=== DISCIPLINAS COM PRÉ-REQUISITOS ==="
SELECT 
    s.name as disciplina,
    s.subject_id as codigo_disciplina,
    s_pre.name as prerequisito,
    s_pre.subject_id as codigo_prerequisito
FROM SUBJECT s
JOIN SUBJECT_PREREQUISITE sp ON s.id = sp.subject_id
JOIN SUBJECT s_pre ON sp.prerequisite_subject_id = s_pre.id
ORDER BY s.name;
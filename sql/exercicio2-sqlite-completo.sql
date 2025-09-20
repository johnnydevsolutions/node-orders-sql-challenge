-- =====================================================
-- EXERCÍCIO 2 - HORÁRIOS DE AULA (SQLite - Arquivo Completo)
-- Professor Girafales - Diretor da Escola do Chavito
-- =====================================================

-- PARTE 1: CRIAÇÃO DO SCHEMA
-- =====================================================

CREATE TABLE DEPARTMENT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE BUILDING (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE ROOM (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    building_id INTEGER NOT NULL,
    FOREIGN KEY (building_id) REFERENCES BUILDING(id)
);

CREATE TABLE TITLE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE PROFESSOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INTEGER NOT NULL,
    title_id INTEGER NOT NULL,
    FOREIGN KEY (department_id) REFERENCES DEPARTMENT(id),
    FOREIGN KEY (title_id) REFERENCES TITLE(id)
);

CREATE TABLE SUBJECT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id TEXT NOT NULL UNIQUE,
    code TEXT NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE SUBJECT_PREREQUISITE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    prerequisiteid INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id),
    FOREIGN KEY (prerequisiteid) REFERENCES SUBJECT(id)
);

CREATE TABLE CLASS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    semester INTEGER NOT NULL,
    code TEXT NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id)
);

CREATE TABLE CLASS_SCHEDULE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES CLASS(id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id)
);

CREATE TABLE SUBJECT_PROFESSOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject_id INTEGER NOT NULL,
    professor_id INTEGER NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES SUBJECT(id),
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(id)
);

-- Índices para melhor performance
CREATE INDEX idx_class_schedule_room_day ON CLASS_SCHEDULE(room_id, day_of_week);
CREATE INDEX idx_class_schedule_time ON CLASS_SCHEDULE(day_of_week, start_time, end_time);
CREATE INDEX idx_professor_department ON PROFESSOR(department_id);
CREATE INDEX idx_subject_prerequisite ON SUBJECT_PREREQUISITE(subject_id, prerequisiteid);

-- =====================================================
-- PARTE 2: INSERÇÃO DOS DADOS DE EXEMPLO
-- =====================================================

-- Inserir departamentos
INSERT INTO DEPARTMENT (name) VALUES 
('Departamento de Matemática'),
('Departamento de História'),
('Departamento de Ciências');

-- Inserir prédios
INSERT INTO BUILDING (name) VALUES 
('Prédio Principal'),
('Prédio de Ciências'),
('Prédio Administrativo');

-- Inserir salas
INSERT INTO ROOM (building_id) VALUES 
(1), (1), (1), -- Salas 1, 2, 3 no Prédio Principal
(2), (2),      -- Salas 4, 5 no Prédio de Ciências
(3);           -- Sala 6 no Prédio Administrativo

-- Inserir títulos
INSERT INTO TITLE (name) VALUES 
('Professor Titular'),
('Professor Adjunto'),
('Professor Assistente'),
('Diretor');

-- Inserir professores
INSERT INTO PROFESSOR (department_id, title_id) VALUES 
(1, 4), -- Professor Girafales - Diretor do Depto de Matemática
(1, 1), -- Professor de Matemática Titular
(2, 2), -- Professor de História Adjunto
(3, 1); -- Professor de Ciências Titular

-- Inserir disciplinas
INSERT INTO SUBJECT (subject_id, code, name) VALUES 
('MAT001', 'MAT-001', 'Matemática Básica'),
('MAT002', 'MAT-002', 'Álgebra Linear'),
('HIS001', 'HIS-001', 'História do Brasil'),
('CIE001', 'CIE-001', 'Física Geral'),
('CIE002', 'CIE-002', 'Química Orgânica');

-- Inserir pré-requisitos
INSERT INTO SUBJECT_PREREQUISITE (subject_id, prerequisiteid) VALUES 
(2, 1); -- Álgebra Linear tem como pré-requisito Matemática Básica

-- Inserir turmas
INSERT INTO CLASS (subject_id, year, semester, code) VALUES 
(1, 2025, 1, 'MAT001-T1'), -- Matemática Básica - Turma 1
(1, 2025, 1, 'MAT001-T2'), -- Matemática Básica - Turma 2
(2, 2025, 1, 'MAT002-T1'), -- Álgebra Linear - Turma 1
(3, 2025, 1, 'HIS001-T1'), -- História do Brasil - Turma 1
(4, 2025, 1, 'CIE001-T1'); -- Física Geral - Turma 1

-- Inserir relacionamento professor-disciplina
INSERT INTO SUBJECT_PROFESSOR (subject_id, professor_id) VALUES 
(1, 1), -- Girafales ensina Matemática Básica
(2, 1), -- Girafales ensina Álgebra Linear
(1, 2), -- Professor de Matemática também ensina Matemática Básica
(3, 3), -- Professor de História ensina História do Brasil
(4, 4); -- Professor de Ciências ensina Física Geral

-- Inserir horários de aula
INSERT INTO CLASS_SCHEDULE (class_id, room_id, day_of_week, start_time, end_time) VALUES 
-- Segunda-feira
(1, 1, 1, '08:00', '10:00'), -- MAT001-T1 na Sala 1
(2, 2, 1, '10:00', '12:00'), -- MAT001-T2 na Sala 2
(3, 1, 1, '14:00', '16:00'), -- MAT002-T1 na Sala 1
(4, 3, 1, '16:00', '18:00'), -- HIS001-T1 na Sala 3

-- Terça-feira
(1, 1, 2, '08:00', '10:00'), -- MAT001-T1 na Sala 1
(5, 4, 2, '10:00', '12:00'), -- CIE001-T1 na Sala 4
(2, 2, 2, '14:00', '16:00'), -- MAT001-T2 na Sala 2

-- Quarta-feira
(3, 1, 3, '08:00', '10:00'), -- MAT002-T1 na Sala 1
(4, 3, 3, '10:00', '12:00'), -- HIS001-T1 na Sala 3
(5, 4, 3, '14:00', '16:00'), -- CIE001-T1 na Sala 4

-- Quinta-feira
(1, 1, 4, '08:00', '10:00'), -- MAT001-T1 na Sala 1
(2, 2, 4, '10:00', '12:00'), -- MAT001-T2 na Sala 2

-- Sexta-feira
(3, 1, 5, '08:00', '10:00'), -- MAT002-T1 na Sala 1
(4, 3, 5, '14:00', '16:00'); -- HIS001-T1 na Sala 3

-- =====================================================
-- PARTE 3: CONSULTAS SOLICITADAS
-- =====================================================

-- 🎯 CONSULTA 1: QUANTIDADE DE HORAS QUE CADA PROFESSOR TEM COMPROMETIDO EM AULAS
-- =====================================================
SELECT '=== HORAS COMPROMETIDAS POR PROFESSOR ===' as titulo;

SELECT 
    p.id as professor_id,
    'Professor ' || p.id as nome_professor,
    d.name as departamento,
    t.name as titulo,
    COALESCE(SUM(
        (strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0
    ), 0) as horas_comprometidas_por_semana,
    COALESCE(SUM(
        (strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0
    ) * 16, 0) as horas_comprometidas_por_semestre
FROM PROFESSOR p
LEFT JOIN DEPARTMENT d ON p.department_id = d.id
LEFT JOIN TITLE t ON p.title_id = t.id
LEFT JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
LEFT JOIN SUBJECT s ON sp.subject_id = s.id
LEFT JOIN CLASS c ON s.id = c.subject_id
LEFT JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, d.name, t.name
ORDER BY horas_comprometidas_por_semana DESC;

-- 🏫 CONSULTA 2: LISTA DE SALAS COM HORÁRIOS LIVRES E OCUPADOS
-- =====================================================
SELECT '=== HORÁRIOS OCUPADOS POR SALA ===' as titulo;

SELECT 
    r.id as sala_id,
    'Sala ' || r.id as nome_sala,
    b.name as predio,
    CASE cs.day_of_week
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END as dia_semana,
    cs.start_time as hora_inicio,
    cs.end_time as hora_fim,
    s.name as disciplina,
    c.code as codigo_turma,
    COALESCE(GROUP_CONCAT('Professor ' || sp.professor_id, ', '), '—') as professores
FROM CLASS_SCHEDULE cs
JOIN ROOM r ON cs.room_id = r.id
JOIN BUILDING b ON r.building_id = b.id
JOIN CLASS c ON cs.class_id = c.id
JOIN SUBJECT s ON c.subject_id = s.id
LEFT JOIN SUBJECT_PROFESSOR sp ON s.id = sp.subject_id
GROUP BY r.id, b.name, cs.day_of_week, cs.start_time, cs.end_time, s.name, c.code
ORDER BY r.id, cs.day_of_week, cs.start_time;

SELECT '=== HORÁRIOS LIVRES (COMPLETO: ANTES/ENTRE/DEPOIS) ===' as titulo;

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
    'Sala ' || r.id AS nome_sala,
    bld.name AS predio,
    CASE ag.day_of_week
        WHEN 1 THEN 'Segunda-feira' WHEN 2 THEN 'Terça-feira' WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira' WHEN 5 THEN 'Sexta-feira' WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END AS dia_semana,
    ag.free_from AS livre_inicio,
    ag.free_to AS livre_fim,
    ROUND((strftime('%s', ag.free_to) - strftime('%s', ag.free_from)) / 3600.0, 2) AS horas_livres
FROM all_gaps ag
JOIN ROOM r ON r.id = ag.room_id
JOIN BUILDING bld ON bld.id = r.building_id
WHERE ag.free_from < ag.free_to
ORDER BY sala_id, ag.day_of_week, livre_inicio;

-- =====================================================
-- CONSULTAS EXTRAS PARA ANÁLISE
-- =====================================================

SELECT '=== SALAS COMPLETAMENTE LIVRES NA SEGUNDA-FEIRA ===' as titulo;

SELECT 
    r.id as sala_id,
    'Sala ' || r.id as nome_sala,
    b.name as predio,
    'Segunda-feira' as dia_livre
FROM ROOM r
JOIN BUILDING b ON r.building_id = b.id
WHERE r.id NOT IN (
    SELECT DISTINCT cs.room_id
    FROM CLASS_SCHEDULE cs
    WHERE cs.day_of_week = 1
);

SELECT '=== TOP 3 PROFESSORES COM MAIOR CARGA HORÁRIA ===' as titulo;

SELECT 
    p.id as professor_id,
    'Professor ' || p.id as nome_professor,
    d.name as departamento,
    ROUND(SUM((strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0), 2) as horas_semanais
FROM PROFESSOR p
JOIN DEPARTMENT d ON p.department_id = d.id
JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
JOIN SUBJECT s ON sp.subject_id = s.id
JOIN CLASS c ON s.id = c.subject_id
JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, d.name
ORDER BY horas_semanais DESC
LIMIT 3;

SELECT '=== DISCIPLINAS COM PRÉ-REQUISITOS ===' as titulo;

SELECT 
    s.name as disciplina,
    s.code as codigo,
    sp_req.name as pre_requisito,
    sp_req.code as codigo_pre_requisito
FROM SUBJECT s
JOIN SUBJECT_PREREQUISITE spr ON s.id = spr.subject_id
JOIN SUBJECT sp_req ON spr.prerequisiteid = sp_req.id
ORDER BY s.name;
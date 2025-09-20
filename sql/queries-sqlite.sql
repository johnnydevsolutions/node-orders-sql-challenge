-- EXERCÍCIO 2 - CONSULTAS SQL SOLICITADAS (SQLite)
-- Baseado no modelo ER de Horários de Aula

-- =====================================================
-- 1) QUANTIDADE DE HORAS QUE CADA PROFESSOR TEM COMPROMETIDO EM AULAS
-- =====================================================

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
    ) * 16, 0) as horas_comprometidas_por_semestre -- Assumindo 16 semanas por semestre
FROM PROFESSOR p
LEFT JOIN DEPARTMENT d ON p.department_id = d.id
LEFT JOIN TITLE t ON p.title_id = t.id
LEFT JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
LEFT JOIN SUBJECT s ON sp.subject_id = s.id
LEFT JOIN CLASS c ON s.id = c.subject_id
LEFT JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, d.name, t.name
ORDER BY horas_comprometidas_por_semana DESC;

-- =====================================================
-- 2) LISTA DE SALAS COM HORÁRIOS LIVRES E OCUPADOS
-- =====================================================

-- 2.1) HORÁRIOS OCUPADOS POR SALA (com agregação de professores)
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

-- 2.2) HORÁRIOS LIVRES POR SALA (Versão completa para SQLite - inclui gaps antes/depois)
-- Calcula todos os horários livres: antes da primeira aula, entre aulas e após a última aula
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
    (strftime('%s', ag.free_to) - strftime('%s', ag.free_from)) / 3600.0 AS horas_livres
FROM all_gaps ag
JOIN ROOM r ON r.id = ag.room_id
JOIN BUILDING bld ON bld.id = r.building_id
WHERE ag.free_from < ag.free_to
ORDER BY sala_id, ag.day_of_week, livre_inicio;

-- =====================================================
-- 3) CONSULTAS ADICIONAIS ÚTEIS
-- =====================================================

-- 3.1) Salas completamente livres em um dia específico
SELECT 
    r.id as sala_id,
    'Sala ' || r.id as nome_sala,
    b.name as predio,
    'Segunda-feira' as dia_livre -- Pode ser parametrizado
FROM ROOM r
JOIN BUILDING b ON r.building_id = b.id
WHERE r.id NOT IN (
    SELECT DISTINCT cs.room_id
    FROM CLASS_SCHEDULE cs
    WHERE cs.day_of_week = 1 -- 1 = Segunda-feira
);

-- 3.2) Professores com maior carga horária (Top 3)
SELECT 
    p.id as professor_id,
    'Professor ' || p.id as nome_professor,
    d.name as departamento,
    SUM((strftime('%s', cs.end_time) - strftime('%s', cs.start_time)) / 3600.0) as horas_semanais
FROM PROFESSOR p
JOIN DEPARTMENT d ON p.department_id = d.id
JOIN SUBJECT_PROFESSOR sp ON p.id = sp.professor_id
JOIN SUBJECT s ON sp.subject_id = s.id
JOIN CLASS c ON s.id = c.subject_id
JOIN CLASS_SCHEDULE cs ON c.id = cs.class_id
GROUP BY p.id, d.name
ORDER BY horas_semanais DESC
LIMIT 3;

-- 3.3) Disciplinas com pré-requisitos
SELECT 
    s.name as disciplina,
    s.code as codigo,
    sp_req.name as pre_requisito,
    sp_req.code as codigo_pre_requisito
FROM SUBJECT s
JOIN SUBJECT_PREREQUISITE spr ON s.id = spr.subject_id
JOIN SUBJECT sp_req ON spr.prerequisiteid = sp_req.id
ORDER BY s.name;

-- =====================================================
-- 4) CONSULTAS EXTRAS PARA ANÁLISE
-- =====================================================

-- 4.1) Ocupação por sala (percentual de uso)
SELECT 
    r.id as sala_id,
    'Sala ' || r.id as nome_sala,
    COUNT(cs.id) as total_aulas_semana,
    COUNT(cs.id) * 2.0 as horas_ocupadas_semana, -- Assumindo 2h por aula
    ROUND((COUNT(cs.id) * 2.0 / (5 * 14)) * 100, 2) as percentual_ocupacao -- 5 dias, 14h por dia
FROM ROOM r
LEFT JOIN CLASS_SCHEDULE cs ON r.id = cs.room_id
GROUP BY r.id
ORDER BY percentual_ocupacao DESC;

-- 4.2) Horários de pico (mais aulas simultâneas)
SELECT 
    CASE day_of_week
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END as dia_semana,
    start_time as horario,
    COUNT(*) as aulas_simultaneas
FROM CLASS_SCHEDULE
GROUP BY day_of_week, start_time
ORDER BY aulas_simultaneas DESC, day_of_week, start_time;
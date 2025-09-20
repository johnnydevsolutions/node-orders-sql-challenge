-- EXERCÍCIO 2 - CONSULTAS SQL SOLICITADAS
-- Baseado no modelo ER de Horários de Aula

-- =====================================================
-- 1) QUANTIDADE DE HORAS QUE CADA PROFESSOR TEM COMPROMETIDO EM AULAS
-- =====================================================

SELECT 
    p.id as professor_id,
    CONCAT('Professor ', p.id) as nome_professor,
    d.name as departamento,
    t.name as titulo,
    COALESCE(SUM(
        EXTRACT(EPOCH FROM (cs.end_time - cs.start_time)) / 3600.0
    ), 0) as horas_comprometidas_por_semana,
    COALESCE(SUM(
        EXTRACT(EPOCH FROM (cs.end_time - cs.start_time)) / 3600.0
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

-- 2.1) HORÁRIOS OCUPADOS POR SALA
SELECT 
    r.id as sala_id,
    CONCAT('Sala ', r.id) as nome_sala,
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
    CONCAT('Professor ', sp.professor_id) as professor
FROM CLASS_SCHEDULE cs
JOIN ROOM r ON cs.room_id = r.id
JOIN BUILDING b ON r.building_id = b.id
JOIN CLASS c ON cs.class_id = c.id
JOIN SUBJECT s ON c.subject_id = s.id
JOIN SUBJECT_PROFESSOR sp ON s.id = sp.subject_id
ORDER BY r.id, cs.day_of_week, cs.start_time;

-- 2.2) HORÁRIOS LIVRES POR SALA (Intervalos entre aulas)
WITH horarios_ocupados AS (
    SELECT 
        r.id as sala_id,
        cs.day_of_week,
        cs.start_time,
        cs.end_time,
        LAG(cs.end_time) OVER (
            PARTITION BY r.id, cs.day_of_week 
            ORDER BY cs.start_time
        ) as fim_aula_anterior
    FROM CLASS_SCHEDULE cs
    JOIN ROOM r ON cs.room_id = r.id
),
intervalos_livres AS (
    SELECT 
        sala_id,
        day_of_week,
        CASE 
            WHEN fim_aula_anterior IS NULL THEN TIME '07:00'
            ELSE fim_aula_anterior
        END as livre_inicio,
        start_time as livre_fim
    FROM horarios_ocupados
    WHERE fim_aula_anterior IS NULL OR fim_aula_anterior < start_time
    
    UNION ALL
    
    -- Adicionar horário livre após a última aula do dia
    SELECT 
        sala_id,
        day_of_week,
        MAX(end_time) as livre_inicio,
        TIME '22:00' as livre_fim
    FROM horarios_ocupados
    GROUP BY sala_id, day_of_week
)
SELECT 
    il.sala_id,
    CONCAT('Sala ', il.sala_id) as nome_sala,
    CASE il.day_of_week
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END as dia_semana,
    il.livre_inicio,
    il.livre_fim,
    EXTRACT(EPOCH FROM (il.livre_fim - il.livre_inicio)) / 3600.0 as horas_livres
FROM intervalos_livres il
WHERE il.livre_inicio < il.livre_fim
ORDER BY il.sala_id, il.day_of_week, il.livre_inicio;

-- =====================================================
-- 3) CONSULTAS ADICIONAIS ÚTEIS
-- =====================================================

-- 3.1) Salas completamente livres em um dia específico
SELECT 
    r.id as sala_id,
    CONCAT('Sala ', r.id) as nome_sala,
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
    CONCAT('Professor ', p.id) as nome_professor,
    d.name as departamento,
    SUM(EXTRACT(EPOCH FROM (cs.end_time - cs.start_time)) / 3600.0) as horas_semanais
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
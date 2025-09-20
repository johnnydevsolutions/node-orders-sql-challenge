-- DADOS DE EXEMPLO PARA TESTE DAS CONSULTAS (SQLite)
-- Baseado no cenário do Professor Girafales

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
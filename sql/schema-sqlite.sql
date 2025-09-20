-- EXERCÍCIO 2 - HORÁRIOS DE AULA
-- Schema SQLite baseado no modelo ER fornecido

-- Criação das tabelas conforme o modelo ER

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
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7), -- 1=Segunda, 7=Domingo
    start_time TEXT NOT NULL, -- Formato HH:MM
    end_time TEXT NOT NULL,   -- Formato HH:MM
    FOREIGN KEY (class_id) REFERENCES CLASS(id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id)
);

-- Tabela de relacionamento many-to-many entre SUBJECT e PROFESSOR (taught_by)
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
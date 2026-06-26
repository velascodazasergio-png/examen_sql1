-- ============================================================
--  EXAMEN PRÁCTICO N° 2: DISEÑO, NORMALIZACIÓN Y CONSULTAS
--  Estudiante: [Tu nombre aquí]
-- ============================================================

-- ============================================================
-- SECCIÓN 1: RESPUESTAS TEÓRICAS (en comentarios)
-- ============================================================

-- PREGUNTA 1:
-- ¿Por qué una tabla con PK simple que cumple 1NF cumple automáticamente 2NF?
--
-- La 2NF exige que todos los atributos no clave dependan de la TOTALIDAD
-- de la llave primaria. Cuando la PK es simple (un solo campo), no existe
-- la posibilidad de dependencia parcial (depender solo de una parte de la clave),
-- ya que "parte de un campo" no tiene sentido. Por lo tanto, 1NF + PK simple
-- garantiza 2NF de forma automática.

-- PREGUNTA 2:
-- ¿Qué es una tabla puente o intermedia y cuándo es obligatoria?
--
-- Es una tabla que resuelve una relación MUCHOS A MUCHOS (N:M) entre dos entidades.

CREATE DATABASE instituto_academico;
USE instituto_academico;

CREATE TABLE Profesor (
    ID_Profesor       INT          NOT NULL AUTO_INCREMENT,
    Profesor_Nombre   VARCHAR(100) NOT NULL,
    Profesor_Cubiculo VARCHAR(20),
    PRIMARY KEY (ID_Profesor)
);

CREATE TABLE Estudiante (
    Matricula         VARCHAR(20)  NOT NULL,
    Estudiante_Nombre VARCHAR(100) NOT NULL,
    Estudiante_Correo VARCHAR(150) NOT NULL,
    PRIMARY KEY (Matricula)
);

CREATE TABLE Curso (
    Curso_Codigo VARCHAR(20)  NOT NULL,
    Curso_Nombre VARCHAR(150) NOT NULL,
    ID_Profesor  INT          NOT NULL,
    PRIMARY KEY (Curso_Codigo),
    FOREIGN KEY (ID_Profesor) REFERENCES Profesor(ID_Profesor)
);

CREATE TABLE Inscripcion (
    ID_Inscripcion INT         NOT NULL AUTO_INCREMENT,
    Matricula      VARCHAR(20) NOT NULL,
    Curso_Codigo   VARCHAR(20) NOT NULL,
    PRIMARY KEY (ID_Inscripcion),
    FOREIGN KEY (Matricula)    REFERENCES Estudiante(Matricula),
    FOREIGN KEY (Curso_Codigo) REFERENCES Curso(Curso_Codigo)
);

CREATE TABLE Nota (
    ID_Nota        INT          NOT NULL AUTO_INCREMENT,
    ID_Inscripcion INT          NOT NULL,
    Nota_Parcial   DECIMAL(4,2) NOT NULL,
    Nota_Final     DECIMAL(4,2) DEFAULT NULL,
    PRIMARY KEY (ID_Nota),
    FOREIGN KEY (ID_Inscripcion) REFERENCES Inscripcion(ID_Inscripcion)
);

INSERT INTO Profesor (Profesor_Nombre, Profesor_Cubiculo) VALUES
    ('Carlos Ramírez', 'A-101'),
    ('Laura Mendoza',  'B-205'),
    ('Andrés Torres',  'C-310');
 
INSERT INTO Estudiante (Matricula, Estudiante_Nombre, Estudiante_Correo) VALUES
    ('EST-001', 'Ana Gómez',      'ana.gomez@edu.co'),
    ('EST-002', 'Cristian Diaz',  'cristiandiaz@edu.co'),
    ('EST-003', 'Heiling Paz',    'heiling.paz@edu.co'),
    ('EST-004', 'Tomas Esteban',  'tomasesteban@edu.co'),
    ('EST-005', 'Sergio Velasco', 'sergio.velasco@edu.co'),
    ('EST-006', 'Mateo Vargas',   'mateo.vargas@edu.co');
 
INSERT INTO Curso (Curso_Codigo, Curso_Nombre, ID_Profesor) VALUES
    ('BD-101',   'Bases de Datos',      1),
    ('PROG-202', 'Programación',        2),
    ('MATH-301', 'Cálculo Diferencial', 1);
 
INSERT INTO Inscripcion (Matricula, Curso_Codigo) VALUES
    ('EST-001', 'BD-101'),
    ('EST-002', 'BD-101'),
    ('EST-003', 'BD-101'),
    ('EST-004', 'PROG-202'),
    ('EST-005', 'PROG-202'),
    ('EST-006', 'MATH-301'),
    ('EST-001', 'PROG-202'),
    ('EST-002', 'MATH-301');
 
INSERT INTO Nota (ID_Inscripcion, Nota_Parcial, Nota_Final) VALUES
    (1, 4.50, 4.50), (1, 3.80, NULL), (1, 4.00, NULL),
    (2, 2.50, 2.50), (2, 2.80, NULL), (2, 2.60, NULL),
    (3, 3.00, 3.00), (3, 2.90, NULL),
    (4, 1.80, 1.80), (4, 2.00, NULL),
    (5, 4.80, 4.80), (5, 4.90, NULL), (5, 5.00, NULL),
    (6, 2.10, 2.10), (6, 2.40, NULL),
    (7, 4.20, 4.20), (7, 4.10, NULL),
    (8, 3.50, 3.50), (8, 3.80, NULL);
 
-- CONSULTA 1: JOIN
SELECT
    c.Curso_Codigo,
    c.Curso_Nombre,
    e.Estudiante_Nombre,
    n.Nota_Final
FROM Inscripcion i
JOIN Estudiante  e ON e.Matricula      = i.Matricula
JOIN Curso       c ON c.Curso_Codigo   = i.Curso_Codigo
JOIN Nota        n ON n.ID_Inscripcion = i.ID_Inscripcion
WHERE n.Nota_Final IS NOT NULL
ORDER BY c.Curso_Codigo, e.Estudiante_Nombre;
 
 
-- CONSULTA 2: LEFT JOIN
SELECT
    p.Profesor_Nombre,
    COUNT(c.Curso_Codigo) AS Total_Cursos
FROM Profesor p
LEFT JOIN Curso c ON c.ID_Profesor = p.ID_Profesor
GROUP BY p.ID_Profesor, p.Profesor_Nombre
ORDER BY Total_Cursos DESC;
 
 
-- CONSULTA 3: GROUP BY + HAVING + ORDER BY
SELECT
    c.Curso_Nombre,
    ROUND(AVG(n.Nota_Parcial), 2) AS Promedio_General
FROM Curso c
JOIN Inscripcion i ON i.Curso_Codigo   = c.Curso_Codigo
JOIN Nota        n ON n.ID_Inscripcion = i.ID_Inscripcion
GROUP BY c.Curso_Codigo, c.Curso_Nombre
HAVING Promedio_General < 3.0
ORDER BY Promedio_General DESC; 
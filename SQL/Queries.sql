-- Obtener todos los registros de la tabla de matriculas
SELECT * 
FROM matricula;

-- Insertar un nuevo estudiante con id_estudiante = 999, con nombre 'Marcos' y dirección 'La Paz'
INSERT INTO estudiante (id_estudiante, nombre, direccion)
VALUES (999, 'Marcos', 'La Paz');

-- Obtener el estudiante con id_estudiante = 999
SELECT * 
FROM estudiante
WHERE id_estudiante = 999;

-- Obtener todas las asignaturas con más de 6 créditos
SELECT id_asignatura
FROM asignatura
WHERE creditos > 6;

-- Obtener todas las matrículas realizadas por el estudiante con id_estudiante = 1
SELECT *
FROM matricula
WHERE id_estudiante = 1;

-- Para cada matrícula realizada obtener: id_estudiante, nombre_estudiante, id_asignatura, num_matricula, fecha y precio
SELECT m.id_estudiante, e.nombre, m.id_asignatura, m.num_matricula, m.fecha, m.precio
FROM matricula m
JOIN estudiante e ON m.id_estudiante = e.id_estudiante;

-- Para cada matrícula realizada obtener: id_estudiante, nombre_estudiante, id_asignatura, num_matricula, fecha, precio, creditos_asignatura y titulo_asignatura
SELECT m.id_estudiante, e.nombre, m.id_asignatura, m.num_matricula, m.fecha, m.precio, a.creditos, a.titulo
FROM matricula m
LEFT JOIN estudiante e ON m.id_estudiante = e.id_estudiante
LEFT JOIN asignatura a ON m.id_asignatura = a.id_asignatura;

-- Obtener id, nombre del estudiante y lista de fechas de matrícula (sin repetidos)
SELECT e.id_estudiante,
       e.nombre,
       GROUP_CONCAT(DISTINCT m.fecha ORDER BY m.fecha ASC) AS fechas_matricula
FROM estudiante e
LEFT JOIN matricula m ON e.id_estudiante = m.id_estudiante
GROUP BY e.id_estudiante, e.nombre;

-- Obtener todos los profesores que trabajan en el departamento de 'Ingenieria'
SELECT p.nombre
FROM profesor p
JOIN departamento d ON p.id_departamento = d.id_departamento
WHERE d.nombre = 'Ingenieria';

-- Añadir una nueva columna opcional a la tabla estudiante: DNI
ALTER TABLE estudiante
ADD COLUMN dni VARCHAR(9);

-- Modificar los estudiantes con ids 1, 2 y 3 para añadirles un DNI
UPDATE estudiante
SET dni = CASE id_estudiante
             WHEN 1 THEN '12345678A'
             WHEN 2 THEN '12345678B'
             WHEN 3 THEN '12345678C'
          END
WHERE id_estudiante IN (1, 2, 3);

-- Revisar los datos de todos los estudiantes
SELECT *
FROM estudiante;

-- Obtener las matrículas realizadas entre el 3 y 5 de septiembre de 2020
SELECT *
FROM matricula
WHERE fecha BETWEEN '2020-09-03' AND '2020-09-05';

-- Obtener el número de matrículas realizadas entre el 3 y 5 de septiembre de 2020
SELECT COUNT(*) AS total_matriculas
FROM matricula
WHERE fecha BETWEEN '2020-09-03' AND '2020-09-05';

-- Obtener asignaturas con más de 6 créditos ordenadas por título y cantidad de matrículas
SELECT a.titulo, 
       COUNT(m.id_asignatura) AS cantidad_matriculas
FROM asignatura a
LEFT JOIN matricula m ON a.id_asignatura = m.id_asignatura
WHERE a.creditos > 6
GROUP BY a.titulo
ORDER BY a.titulo ASC;

-- Número de matrículas realizadas por cada estudiante (solo los que tienen alguna matrícula)
SELECT e.nombre, 
       COUNT(m.num_matricula) AS num_matriculas
FROM estudiante e
JOIN matricula m ON e.id_estudiante = m.id_estudiante
GROUP BY e.nombre
ORDER BY num_matriculas DESC;

-- Número de matrículas realizadas por cada estudiante (incluyendo los que no tienen ninguna)
SELECT e.nombre, 
       COUNT(m.num_matricula) AS num_matriculas
FROM estudiante e
LEFT JOIN matricula m ON e.id_estudiante = m.id_estudiante
GROUP BY e.nombre
ORDER BY num_matriculas DESC;

-- Cantidad de dinero gastada por cada estudiante (incluyendo los que no tienen matrículas)
SELECT e.nombre, 
       COALESCE(SUM(m.precio), 0) AS total_gastado
FROM estudiante e
LEFT JOIN matricula m ON e.id_estudiante = m.id_estudiante
GROUP BY e.nombre
ORDER BY total_gastado DESC;

-- Cantidad de dinero gastada por cada estudiante (>200€)
SELECT e.nombre, 
       SUM(m.precio) AS total_gastado
FROM estudiante e
LEFT JOIN matricula m ON e.id_estudiante = m.id_estudiante
GROUP BY e.nombre
HAVING SUM(m.precio) >= 200
ORDER BY total_gastado DESC;

-- Asignatura más cara de cada estudiante
SELECT e.id_estudiante,
       e.nombre AS nombre_estudiante,
       a.titulo AS asignatura_mas_cara,
       m.precio
FROM estudiante e
JOIN matricula m ON e.id_estudiante = m.id_estudiante
JOIN asignatura a ON m.id_asignatura = a.id_asignatura
WHERE m.precio = (
    SELECT MAX(m2.precio)
    FROM matricula m2
    WHERE m2.id_estudiante = e.id_estudiante
);

-- Relación estudiantes - profesores - departamentos
SELECT e.id_estudiante, 
       e.nombre AS nombre_estudiante, 
       a.id_asignatura, 
       a.titulo AS nombre_asignatura, 
       p.id_profesor, 
       p.nombre AS nombre_profesor, 
       d.nombre AS nombre_departamento
FROM estudiante e
LEFT JOIN matricula m ON e.id_estudiante = m.id_estudiante
LEFT JOIN asignatura a ON m.id_asignatura = a.id_asignatura
LEFT JOIN profesor p ON a.id_profesor = p.id_profesor
LEFT JOIN departamento d ON p.id_departamento = d.id_departamento
ORDER BY e.id_estudiante, a.id_asignatura, p.id_profesor;

-- Estadísticas por departamento
SELECT d.nombre AS nombre_departamento,
       COUNT(DISTINCT p.id_profesor) AS num_profesores,
       COUNT(DISTINCT a.id_asignatura) AS num_asignaturas,
       COUNT(DISTINCT m.num_matricula) AS num_matriculas,
       COUNT(DISTINCT m.id_estudiante) AS num_estudiantes_matriculados
FROM departamento d
LEFT JOIN profesor p ON d.id_departamento = p.id_departamento
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
LEFT JOIN matricula m ON a.id_asignatura = m.id_asignatura
GROUP BY d.id_departamento, d.nombre
ORDER BY d.id_departamento ASC;

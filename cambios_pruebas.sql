
USE Proyecto2025B_2b;
SELECT * FROM citas;
-- =====================================
-- DESACTIVAR VALIDACIÓN DE CLAVES FORÁNEAS
-- =====================================
##SET FOREIGN_KEY_CHECKS = 0;

-- =====================================
-- LIMPIAR TABLAS DEPENDIENTES
-- =====================================
##TRUNCATE TABLE prescripciones_medicinas;
##TRUNCATE TABLE prescripciones;
##TRUNCATE TABLE citas;

-- =====================================
-- LIMPIAR TABLAS PRINCIPALES
-- =====================================
##TRUNCATE TABLE doctores;

-- (opcional si quieres reiniciar especialidades)
-- TRUNCATE TABLE especialidades;

-- =====================================
-- REACTIVAR VALIDACIÓN DE CLAVES FORÁNEAS
-- =====================================
##SET FOREIGN_KEY_CHECKS = 1;




-- Ussar vistas:
-- View pacientes
-- Ver infonrmación útil de todos los pacientes
SELECT * 
FROM vw_pacientes_detalle;

-- Ver los pacientes mayores de edad
SELECT *
FROM vw_pacientes_detalle
WHERE edad >= 18;

-- Buscar pacientes por apellido
SELECT *
FROM vw_pacientes_detalle
WHERE apellidos LIKE '%Ortega%';

-- ordenar por edad
SELECT *
FROM vw_pacientes_detalle
ORDER BY edad DESC;


-- View citas
-- Citas de un día específico
SELECT *
FROM vw_agenda_citas
WHERE DATE(fecha_hora) = '2026-01-15'
ORDER BY fecha_hora;

-- Citas de un doctor específicos
SELECT *
FROM vw_agenda_citas
WHERE doctor = 'Juan Carlos Pérez Gómez'
ORDER BY fecha_hora;

-- Citas de un paciente específico
SELECT *
FROM vw_agenda_citas
WHERE paciente = 'María Fernanda López'
ORDER BY fecha_hora DESC;

-- Citas por especialidad
SELECT *
FROM vw_agenda_citas
WHERE especialidad = 'Cardiología'
ORDER BY fecha_hora;

-- view resumen citas doctor
SELECT
    especialidad,
    SUM(total_citas) AS citas_totales
FROM vw_resumen_citas_doctor
GROUP BY especialidad;



-- Uso: Procedimientos
-- Resumen histórico de las citas de un paciente
CALL sp_resumen_citas_paciente(5);

-- Consultar la agenda de un doctor
CALL sp_citas_doctor_por_fecha(3, '2025-01-20');

-- Agendar una cita
-- Nota: Solo se pueden aggregar citas a partir del: 2025-01-29
CALL sp_registrar_cita(
    8,                     -- paciente_id
    2,                     -- doctor_id
    '2025-02-10 10:30:00', -- fecha y hora
    'Consulta general'
);
-- Verificar que la cita se agrego:
SELECT cita_id, fecha_hora, estado
FROM citas
ORDER BY cita_id DESC
LIMIT 1;


-- Cancelar una cita agendada
CALL sp_cancelar_cita(48); ## Se cambia el id entre paréntesis

-- Verificar que se cancelo una cita
SELECT cita_id, estado
FROM citas
WHERE cita_id = 48;


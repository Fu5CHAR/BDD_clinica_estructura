
USE Proyecto2025B_2b;

-- Lo siguiente se ejecuta solo si es necesario. 
-- Nota: Truncate table borra todos los registros de una tabla y reinicia los indices a 1.
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
-- LIMPIAR TABLAS DEPENDIENTES - MEDICINAS
-- =====================================
##TRUNCATE TABLE usos_terapeuticos;
##TRUNCATE TABLE formas_medicina;
##TRUNCATE TABLE vias_uso;
##TRUNCATE TABLE tipos_comercializacion;
##TRUNCATE TABLE tipos_composicion;
##TRUNCATE TABLE marcas;
## TRUNCATE TABLE medicinas;

-- =====================================
-- LIMPIAR TABLAS PRINCIPALES
-- =====================================
##TRUNCATE TABLE doctores;
##TRUNCATE TABLE pacientes;
##TRUNCATE TABLE especialidades;

-- =====================================
-- REACTIVAR VALIDACIÓN DE CLAVES FORÁNEAS
-- =====================================
##SET FOREIGN_KEY_CHECKS = 1;




-- =====================================
-- Usar funciones 
-- =====================================

-- Función: fn_fecha_actual_servidor 
-- Ver fecha y hora actualizada del servidor
SELECT fn_fecha_actual_servidor();

-- Función: fn_últimas_citas_doctor
-- Ver la últimas 5 citas atendiadas por un doctor e información útil. 
-- En una transacción o sesión:
SET @resultado = fn_ultimas_citas_doctor(1);
SELECT 
    DATE_FORMAT(fecha_cita, '%d/%m/%Y %H:%i') AS fecha_formateada,
    paciente,
    CONCAT(edad, ' años') AS edad_paciente,
    diagnostico,
    medicinas
FROM temp_ultimas_citas
ORDER BY fecha_cita DESC;


-- =====================================
-- Usar vistas 
-- =====================================

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
-- Citas de un día específico (considerar si se usa la frontera ´del intervalo )
SELECT *
FROM vw_agenda_citas
WHERE DATE(fecha_hora) = '2025-06-05'
ORDER BY fecha_hora;

-- Citas de un doctor específico
SELECT *
FROM vw_agenda_citas
WHERE doctor = 'Juan Carlos Pérez Gómez'
ORDER BY fecha_hora;

-- Citas de un paciente específico
SELECT *
FROM vw_agenda_citas
WHERE paciente = 'Paola Andrea Santos Bravo'
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

-- =====================================
-- Usar Procedimientos
-- =====================================

-- Uso: Procedimientos
-- Resumen histórico de las citas de un paciente
CALL sp_resumen_citas_paciente(5);

-- Consultar la agenda de un doctor
CALL sp_citas_doctor_por_fecha(1, '2025-06-5');

-- Agendar una cita
-- Nota: Solo se pueden agregar citas posteriores a la fecha y hora actual del servidor.
CALL sp_registrar_cita(
    8,                     -- paciente_id
    2,                     -- doctor_id
    '2026-01-22 10:30:00', -- fecha y hora
    'Consulta general'
);

-- Funcion ver la fecha y hora del servidor
SELECT fn_fecha_actual_servidor();



-- Verificar que la cita se agrego:
SELECT cita_id, fecha_hora, estado
FROM citas
ORDER BY cita_id DESC
LIMIT 1;


SELECT MAX(cita_id) FROM citas;

-- Cancelar una cita agendada
CALL sp_cancelar_cita(71); ## Se cambia el id entre paréntesis

-- Verificar que se cancelo una cita
SELECT cita_id, estado
FROM citas
WHERE cita_id = 71;

-- Agrupar pacientes por rango de edad y especialidad 
CALL sp_pacientes_por_rango_edad(NULL, 10); -- Todos, rangos de 10 años
 CALL sp_pacientes_por_rango_edad(2, 5);     -- Pediatría, rangos de 5 años
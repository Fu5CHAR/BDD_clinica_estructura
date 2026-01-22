USE Proyecto2025B_2b;

DELIMITER $$

-- =========================================
-- PROCEDIMIENTO: Resumen de citas por paciente: Entrega un historial de las citas registradas por el paciente. 
-- Las divide por citas pasadas (atendidas, canceladas) y agendadas sin atender.
-- =========================================
DELIMITER $$
CREATE PROCEDURE sp_resumen_citas_paciente (
    IN p_paciente_id INT
)
BEGIN
    -- Verificar existencia del paciente
    IF NOT EXISTS (
        SELECT 1
        FROM pacientes
        WHERE paciente_id = p_paciente_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    -- =========================================
    -- 1. Citas pasadas (ATENDIDAS o CANCELADAS)
    -- =========================================
    SELECT
        c.cita_id,
        c.fecha_hora,
        c.diagnostico,
        c.estado
    FROM citas c
    WHERE c.fk_paciente_id = p_paciente_id
      AND c.estado IN ('ATENDIDA', 'CANCELADA')
    ORDER BY c.fecha_hora DESC;

    -- =========================================
    -- 2. Citas agendadas sin atender
    -- =========================================
    SELECT
        c.cita_id,
        c.fecha_hora,
        c.diagnostico,
        c.estado
    FROM citas c
    WHERE c.fk_paciente_id = p_paciente_id
      AND c.estado = 'AGENDADA'
    ORDER BY c.fecha_hora ASC;

END$$
DELIMITER ;

DELIMITER $$
-- =========================================
-- PROCEDIMIENTO: Citas de un doctor por fecha: Muestra todas las citas de un doctor en una fecha específica.
-- =========================================
CREATE PROCEDURE sp_citas_doctor_por_fecha (
    IN p_doctor_id INT,
    IN p_fecha DATE
)
BEGIN
    SELECT
        c.cita_id,
        c.fecha_hora,
        CONCAT(p.nombres, ' ', p.apellidos) AS paciente,
        c.diagnostico
    FROM citas c
    JOIN pacientes p
        ON c.fk_paciente_id = p.paciente_id
    WHERE c.fk_doctor_id = p_doctor_id
      AND DATE(c.fecha_hora) = p_fecha
    ORDER BY c.fecha_hora;
END$$
DELIMITER ;

DELIMITER $$
-- =========================================
-- PROCEDIMIENTO: Registrar cita: Registra un cita, por defecto la cita usa el estado = agendada. 
-- Nota: El procedimiento activará el trigger trg_citas_fecha_pasada, si la fecha en la que se desea registrar una cita es anterior a la fecha y hora actual del servidor.
-- Nota2: El procedimiento activará el trigger trg_citas_doctor_solapadas si el id_doctor con el que se deasea registrar la cita ya tiene una cita asociadda en esa fecha y hora.
-- nota3: El procedimiento activará el trigger trg_citas_paciente_solapadas si el id_paciente con el que se deasea registrar la cita ya tiene una cita asociadda en esa fecha y hora.
-- =========================================

CREATE PROCEDURE sp_registrar_cita (
    IN p_paciente_id INT,
    IN p_doctor_id INT,
    IN p_fecha DATETIME,
    IN p_diagnostico VARCHAR(100)
)
BEGIN
    -- Validar existencia del paciente
    IF NOT EXISTS (
        SELECT 1
        FROM pacientes
        WHERE paciente_id = p_paciente_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    -- Validar existencia del doctor
    IF NOT EXISTS (
        SELECT 1
        FROM doctores
        WHERE doctor_id = p_doctor_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El doctor no existe';
    END IF;

    -- Insertar cita como AGENDADA
    INSERT INTO citas (
        fecha_hora,
        diagnostico,
        fk_paciente_id,
        fk_doctor_id,
        estado
    ) VALUES (
        p_fecha,
        p_diagnostico,
        p_paciente_id,
        p_doctor_id,
        'AGENDADA'
    );
END$$
DELIMITER ;

DELIMITER $$
-- =========================================
-- PROCEDIMIENTO: Cancelar cita: Este procedimiento cambia el estado de una cita de 'agendada' a 'cancelada'. 
-- Nota: el procedimiento no borra la cita de los registros, solo cambia su estado. Si se desea agendar una cita en ese horario no será posible.
-- =========================================

CREATE PROCEDURE sp_cancelar_cita (
    IN p_cita_id INT
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    -- Verificar existencia de la cita
    SELECT estado
    INTO v_estado_actual
    FROM citas
    WHERE cita_id = p_cita_id;

    IF v_estado_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cita no existe';
    END IF;

    -- No permitir cancelar citas ya atendidas
    IF v_estado_actual = 'ATENDIDA' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cancelar una cita ya atendida';
    END IF;

    -- Cancelar cita
    UPDATE citas
    SET estado = 'CANCELADA'
    WHERE cita_id = p_cita_id;
END$$

DELIMITER $$

-- Procedimiento: Agrupa pacientes por rangos de edad
DELIMITER $$

CREATE PROCEDURE sp_pacientes_por_rango_edad(
    IN p_especialidad_id INT,
    IN p_intervalo INT DEFAULT 10
)
BEGIN
    -- Usa vista existente vw_pacientes_detalle que ya tiene la edad calculada
    SELECT
        CONCAT(
            FLOOR(vp.edad / p_intervalo) * p_intervalo, 
            '-', 
            FLOOR(vp.edad / p_intervalo) * p_intervalo + (p_intervalo - 1)
        ) AS rango_edad,
        COUNT(*) AS total_pacientes,
        GROUP_CONCAT(DISTINCT e.nombre SEPARATOR ', ') AS especialidades
    FROM vw_pacientes_detalle vp
    JOIN citas c ON vp.paciente_id = c.fk_paciente_id
    JOIN doctores d ON c.fk_doctor_id = d.doctor_id
    JOIN especialidades e ON d.fk_especialidad_id = e.especialidad_id
    WHERE (p_especialidad_id IS NULL OR e.especialidad_id = p_especialidad_id)
    GROUP BY FLOOR(vp.edad / p_intervalo)
    ORDER BY FLOOR(vp.edad / p_intervalo);
END$$

DELIMITER ;


DELIMITER ;




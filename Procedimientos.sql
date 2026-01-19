USE Proyecto2025B_2b;

DELIMITER $$

-- =========================================
-- PROCEDIMIENTO: Resumen de citas por paciente
-- =========================================
CREATE PROCEDURE sp_resumen_citas_paciente (
    IN p_paciente_id INT
)
BEGIN
    SELECT
        p.paciente_id,
        CONCAT(p.nombres, ' ', p.apellidos) AS paciente,
        COUNT(c.cita_id) AS total_citas,
        COUNT(c.diagnostico) AS total_diagnosticos,
        MIN(c.fecha_hora) AS primera_cita,
        MAX(c.fecha_hora) AS ultima_cita
    FROM pacientes p
    LEFT JOIN citas c
        ON p.paciente_id = c.fk_paciente_id
    WHERE p.paciente_id = p_paciente_id
    GROUP BY p.paciente_id;
END$$

-- =========================================
-- PROCEDIMIENTO: Citas de un doctor por fecha
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

-- =========================================
-- PROCEDIMIENTO: Registrar cita
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

    -- Insertar cita
    INSERT INTO citas (
        fecha_hora,
        diagnostico,
        fk_paciente_id,
        fk_doctor_id
    ) VALUES (
        p_fecha,
        p_diagnostico,
        p_paciente_id,
        p_doctor_id
    );
END$$

DELIMITER ;

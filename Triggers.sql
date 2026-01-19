USE Proyecto2025B_2b;

-- =========================================
-- DEFINIR DELIMITADOR
-- =========================================
DELIMITER $$

-- ========================
-- DOCTORES - INSERT
-- ========================
CREATE TRIGGER trg_doctores_insert_nombre
BEFORE INSERT ON doctores
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-z ]'
       OR NEW.apellidos REGEXP '[^A-Za-z ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$

-- ========================
-- DOCTORES - UPDATE
-- ========================
CREATE TRIGGER trg_doctores_update_nombre
BEFORE UPDATE ON doctores
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-z ]'
       OR NEW.apellidos REGEXP '[^A-Za-z ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$

-- ========================
-- PACIENTES - INSERT
-- ========================
CREATE TRIGGER trg_pacientes_insert_nombre
BEFORE INSERT ON pacientes
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-z ]'
       OR NEW.apellidos REGEXP '[^A-Za-z ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$

-- ========================
-- PACIENTES - UPDATE
-- ========================
CREATE TRIGGER trg_pacientes_update_nombre
BEFORE UPDATE ON pacientes
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-z ]'
       OR NEW.apellidos REGEXP '[^A-Za-z ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$

-- =========================================
-- EVITAR CITAS EN FECHAS PASADAS
-- =========================================
CREATE TRIGGER trg_citas_fecha_pasada
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF NEW.fecha_hora < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden agendar citas en fechas pasadas';
    END IF;
END$$

-- =========================================
-- EVITAR SOLAPAMIENTO DE CITAS (DOCTOR)
-- =========================================
CREATE TRIGGER trg_citas_doctor_solapadas
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM citas
        WHERE fk_doctor_id = NEW.fk_doctor_id
          AND fecha_hora = NEW.fecha_hora
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El doctor ya tiene una cita en ese horario';
    END IF;
END$$

-- =========================================
-- EVITAR SOLAPAMIENTO DE CITAS (PACIENTE)
-- =========================================
CREATE TRIGGER trg_citas_paciente_solapadas
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM citas
        WHERE fk_paciente_id = NEW.fk_paciente_id
          AND fecha_hora = NEW.fecha_hora
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El paciente ya tiene una cita en ese horario';
    END IF;
END$$

-- =========================================
-- RESTAURAR DELIMITADOR
-- =========================================
DELIMITER ;

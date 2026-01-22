USE Proyecto2025B_2b;
SHOW FUNCTION STATUS;
-- =========================================
-- DEFINIR DELIMITADOR
-- =========================================

-- =========================================
-- DOCTORES - INSERT: Solo se permiten ingresar nombres conformados por letras del alfabeto español.
-- =========================================

DELIMITER $$
CREATE OR REPLACE TRIGGER trg_doctores_insert_nombre
BEFORE INSERT ON doctores
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]'
       OR NEW.apellidos REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras del español y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$
delimiter ;


-- ========================
-- DOCTORES - UPDATE: Solo se permiten actualizar nombres conformados por letras del alfabeto español.
-- ========================
delimiter $$
CREATE OR REPLACE TRIGGER trg_doctores_update_nombre
BEFORE UPDATE ON doctores
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]'
       OR NEW.apellidos REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras del español y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$
delimiter ;
-- ========================
-- PACIENTES - INSERT: Solo se permiten ingresar nombres conformados por letras del alfabeto español.
-- ========================
delimiter $$
CREATE OR REPLACE TRIGGER trg_pacientes_insert_nombre
BEFORE INSERT ON pacientes
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]'
       OR NEW.apellidos REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras del español y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$
delimiter ;

-- ========================
-- PACIENTES - UPDATE: Solo se permiten actualizar nombres conformados por letras del alfabeto español.
-- ========================
delimiter $$
CREATE OR REPLACE TRIGGER trg_pacientes_update_nombre
BEFORE UPDATE ON pacientes
FOR EACH ROW
BEGIN
    IF NEW.nombres REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]'
       OR NEW.apellidos REGEXP '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se permiten letras del español y espacios en nombres y apellidos';
    END IF;

    SET NEW.nombres   = fn_formatear_nombre(NEW.nombres);
    SET NEW.apellidos = fn_formatear_nombre(NEW.apellidos);
END$$
delimiter ;

-- =========================================
-- EVITAR CITAS EN FECHAS PASADAS: No se permiten insertar citas con una fecha y hora anteriores a la fecha y hora actual del servidor.
-- =========================================
-- =========================================
-- TRIGGER PARA INSERT: Evita citas en fechas pasadas
-- Guarda la fecha actual en variable de estado para recuperación
-- =========================================
DELIMITER $$
CREATE TRIGGER trg_citas_fecha_pasada_insert
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    DECLARE fecha_actual DATETIME;
    
    -- Obtener fecha actual del servidor
    SET fecha_actual = fn_fecha_actual_servidor();
    
    -- Validar que la fecha de la cita no sea pasada
    IF NEW.fecha_hora < fecha_actual THEN
        -- Guardar la fecha formateada en variable de estado para la aplicación
        SET @ultima_fecha_error_insert = DATE_FORMAT(fecha_actual, '%Y-%m-%d %H:%i:%s');
        SET @ultima_fecha_cita_intentada = DATE_FORMAT(NEW.fecha_hora, '%Y-%m-%d %H:%i:%s');
        
        -- Generar error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'INSERT rechazado: No se pueden agendar citas en fechas pasadas.';
    END IF;
END$$
DELIMITER ;
-- =========================================
-- EVITAR CITAS EN FECHAS PASADAS: No se permiten actualizar citas con una fecha y hora anteriores a la fecha y hora actual del servidor.
-- =========================================
-- =========================================
-- TRIGGER PARA UPDATE: Evita actualizar citas a fechas pasadas
-- Guarda la fecha actual en variable de estado para recuperación
-- =========================================

DELIMITER $$
CREATE TRIGGER trg_citas_fecha_pasada_update
BEFORE UPDATE ON citas
FOR EACH ROW
BEGIN
    DECLARE fecha_actual DATETIME;
    
    -- Obtener fecha actual del servidor
    SET fecha_actual = fn_fecha_actual_servidor();
    
    -- Validar solo si se está cambiando la fecha/hora
    IF NEW.fecha_hora <> OLD.fecha_hora THEN
        -- Validar que la nueva fecha no sea pasada
        IF NEW.fecha_hora < fecha_actual THEN
            -- Guardar información en variables de estado para la aplicación
            SET @ultima_fecha_error_update = DATE_FORMAT(fecha_actual, '%Y-%m-%d %H:%i:%s');
            SET @ultima_fecha_cita_anterior = DATE_FORMAT(OLD.fecha_hora, '%Y-%m-%d %H:%i:%s');
            SET @ultima_fecha_cita_nueva = DATE_FORMAT(NEW.fecha_hora, '%Y-%m-%d %H:%i:%s');
            
            -- Generar error
            SIGNAL SQLSTATE '45001'
            SET MESSAGE_TEXT = 'UPDATE rechazado: No se puede modificar cita a fecha pasada.';
        END IF;
    END IF;
END$$
DELIMITER ;
-- =========================================
-- EVITAR SOLAPAMIENTO DE CITAS (DOCTOR): No se permite insertar más de una cita en el mismo horario.
-- =========================================
delimiter $$
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
delimiter ;
-- =========================================
-- EVITAR SOLAPAMIENTO DE CITAS (PACIENTE): No se permite insertar citas en el mismo horario. 
-- =========================================
delimiter $$
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

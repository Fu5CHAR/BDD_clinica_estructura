USE Proyecto2025B_2b;

-- =========================================
-- DELIMITADOR
-- =========================================
DELIMITER $$

-- =========================================
-- FUNCIÓN: fn_formatear_nombre
-- =========================================
CREATE FUNCTION fn_formatear_nombre(texto VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(100) DEFAULT '';
    DECLARE palabra VARCHAR(100);
    DECLARE pos INT DEFAULT 1;

    SET texto = LOWER(TRIM(texto));

    WHILE LENGTH(texto) > 0 DO
        SET palabra = SUBSTRING_INDEX(texto, ' ', 1);

        IF palabra IN ('de','del','la') AND pos > 1 THEN
            SET palabra = palabra;
        ELSE
            SET palabra = CONCAT(UPPER(LEFT(palabra,1)), SUBSTRING(palabra,2));
        END IF;

        SET resultado = CONCAT(resultado, palabra, ' ');
        SET texto = TRIM(SUBSTRING(texto, LENGTH(palabra) + 1));
        SET pos = pos + 1;
    END WHILE;

    RETURN TRIM(resultado);
END$$

-- =========================================
-- FUNCIÓN: fn_calcular_edad
-- =========================================
CREATE FUNCTION fn_calcular_edad(p_paciente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE edad INT;
    DECLARE fecha_nac DATE;

    SELECT fecha_nacimiento
    INTO fecha_nac
    FROM pacientes
    WHERE paciente_id = p_paciente_id;

    IF fecha_nac IS NULL THEN
        RETURN NULL;
    END IF;

    SET edad = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());

    IF DATE_ADD(fecha_nac, INTERVAL edad YEAR) > CURDATE() THEN
        SET edad = edad - 1;
    END IF;

    RETURN edad;
END$$

-- =========================================
-- FUNCIÓN "TABULAR" SIMULADA
-- Guarda el ID del paciente en una variable
-- =========================================
CREATE FUNCTION fn_historial_citas(p_paciente_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    SET @paciente_historial := p_paciente_id;
    RETURN 1;
END$$

DELIMITER ;

-- =========================================
-- VISTA TABULAR ASOCIADA A LA FUNCIÓN
-- =========================================
CREATE OR REPLACE VIEW v_historial_citas AS
SELECT
    c.cita_id,
    c.fecha_hora AS fecha_cita,
    c.diagnostico,
    CONCAT(d.nombres, ' ', d.apellidos) AS doctor,
    e.nombre AS especialidad
FROM citas c
JOIN doctores d ON c.fk_doctor_id = d.doctor_id
JOIN especialidades e ON d.fk_especialidad_id = e.especialidad_id
WHERE c.fk_paciente_id = @paciente_historial;

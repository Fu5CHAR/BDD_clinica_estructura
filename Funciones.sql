USE Proyecto2025B_2b;

-- =========================================
-- DELIMITADOR
-- =========================================
DELIMITER $$
-- =========================================
-- FUNCIÓN: fn_formatear_nombre: Capitaliza los nombres y apellidos, es decir, coloca la primera letra del nombre/apellido en mayúscula y el resto en minúsculas.
-- Si un nombre/apellido es compuesto, la función, distingue los artículos -la, los, las- y las preposiciones -de, del-.   
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

DELIMITER ;

DELIMITER $$
-- =========================================
-- FUNCIÓN: fn_calcular_edad: Calcula la edad del paciente usando la fecha de macimiento.
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
DELIMITER ;


-- =========================================
-- FUNCIÓN: fn_fecha_aatual_servidor: Entrega la fecha y hora actual del servidor.

-- =========================================


DELIMITER $$
CREATE FUNCTION fn_fecha_actual_servidor()
RETURNS DATETIME
DETERMINISTIC
READS SQL DATA  -- Esta línea es importante
BEGIN
    RETURN NOW();
END$$
DELIMITER ;

-- Función que simula ser tabular usando tabla temporal
Delimiter $$
CREATE FUNCTION fn_ultimas_citas_doctor(p_doctor_id INT)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    -- Eliminar tabla temporal si existe
    DROP TEMPORARY TABLE IF EXISTS temp_ultimas_citas;
    
    -- Crear tabla temporal con estructura definida
    CREATE TEMPORARY TABLE temp_ultimas_citas (
        num_orden INT PRIMARY KEY AUTO_INCREMENT,
        fecha_cita DATETIME,
        paciente VARCHAR(100),
        edad INT,
        diagnostico VARCHAR(255),
        medicinas TEXT
    );
    
    -- Insertar las últimas 5 citas atendidas por el doctor
    INSERT INTO temp_ultimas_citas (fecha_cita, paciente, edad, diagnostico, medicinas)
    SELECT 
        c.fecha_hora AS fecha_cita,
        CONCAT(p.nombres, ' ', p.apellidos) AS paciente,
        TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad,
        c.diagnostico,
        COALESCE(
            GROUP_CONCAT(
                DISTINCT m.nombre 
                ORDER BY pm.fk_medicina_id 
                SEPARATOR ', '
            ),
            'Sin medicinas'
        ) AS medicinas
    FROM citas c
    JOIN pacientes p ON c.fk_paciente_id = p.paciente_id
    LEFT JOIN prescripciones pr ON c.cita_id = pr.fk_cita_id
    LEFT JOIN prescripciones_medicinas pm ON pr.prescripcion_id = pm.fk_prescripcion_id
    LEFT JOIN medicinas m ON pm.fk_medicina_id = m.medicina_id
    WHERE c.fk_doctor_id = p_doctor_id
      AND c.estado = 'ATENDIDA'
    GROUP BY c.cita_id, c.fecha_hora, p.paciente_id, p.nombres, p.apellidos, 
             p.fecha_nacimiento, c.diagnostico
    ORDER BY c.fecha_hora DESC
    LIMIT 5;
    
    -- Retornar el número de citas encontradas
    RETURN (SELECT COUNT(*) FROM temp_ultimas_citas);
END$$

DELIMITER ;

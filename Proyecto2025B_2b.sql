USE Proyecto2025B_2b;

-- =========================================
-- TABLA: especialidades
-- =========================================
CREATE TABLE especialidades (
    especialidad_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (especialidad_id)
);

-- =========================================
-- TABLA: doctores
-- =========================================
CREATE TABLE doctores (
    doctor_id INT AUTO_INCREMENT,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fk_especialidad_id INT NOT NULL,
    PRIMARY KEY (doctor_id),
    FOREIGN KEY (fk_especialidad_id)
        REFERENCES especialidades(especialidad_id)
);

-- =========================================
-- TABLA: pacientes
-- =========================================
CREATE TABLE pacientes (
    paciente_id INT AUTO_INCREMENT,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(10),
    PRIMARY KEY (paciente_id)
);

-- =========================================
-- TABLA: citas
-- =========================================
CREATE TABLE citas (
    cita_id INT AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    diagnostico VARCHAR(100),
    fk_paciente_id INT NOT NULL,
    fk_doctor_id INT NOT NULL,
    PRIMARY KEY (cita_id),
    FOREIGN KEY (fk_paciente_id)
        REFERENCES pacientes(paciente_id),
    FOREIGN KEY (fk_doctor_id)
        REFERENCES doctores(doctor_id)
);

-- =========================================
-- TABLA: prescripciones
-- =========================================
CREATE TABLE prescripciones (
    prescripcion_id INT AUTO_INCREMENT,
    fecha DATE NOT NULL,
    fk_cita_id INT NOT NULL UNIQUE,
    PRIMARY KEY (prescripcion_id),
    FOREIGN KEY (fk_cita_id)
        REFERENCES citas(cita_id)
);

-- =========================================
-- TABLAS DE DOMINIO (MEDICINAS)
-- =========================================
CREATE TABLE usos_terapeuticos (
    uso_terapeutico_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (uso_terapeutico_id)
);

CREATE TABLE formas_medicina (
    forma_medicina_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (forma_medicina_id)
);

CREATE TABLE vias_uso (
    via_uso_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (via_uso_id)
);

CREATE TABLE tipos_comercializacion (
    tipos_comercializacion_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (tipos_comercializacion_id)
);

CREATE TABLE tipos_composicion (
    tipos_composicion_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (tipos_composicion_id)
);

CREATE TABLE marcas (
    marca_id INT AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    PRIMARY KEY (marca_id)
);

-- =========================================
-- TABLA: medicinas
-- =========================================
CREATE TABLE medicinas (
    medicina_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,

    fk_uso_terapeutico_id INT,
    fk_forma_medicina_id INT,
    fk_via_uso_id INT,
    fk_tipos_comercializacion_id INT,
    fk_tipos_composicion_id INT,
    fk_marca_id INT,

    PRIMARY KEY (medicina_id),

    FOREIGN KEY (fk_uso_terapeutico_id)
        REFERENCES usos_terapeuticos(uso_terapeutico_id),

    FOREIGN KEY (fk_forma_medicina_id)
        REFERENCES formas_medicina(forma_medicina_id),

    FOREIGN KEY (fk_via_uso_id)
        REFERENCES vias_uso(via_uso_id),

    FOREIGN KEY (fk_tipos_comercializacion_id)
        REFERENCES tipos_comercializacion(tipos_comercializacion_id),

    FOREIGN KEY (fk_tipos_composicion_id)
        REFERENCES tipos_composicion(tipos_composicion_id),

    FOREIGN KEY (fk_marca_id)
        REFERENCES marcas(marca_id)
);

-- =========================================
-- TABLA: prescripciones_medicinas
-- =========================================
CREATE TABLE prescripciones_medicinas (
    fk_prescripcion_id INT NOT NULL,
    fk_medicina_id INT NOT NULL,
    dosis VARCHAR(50),
    PRIMARY KEY (fk_prescripcion_id, fk_medicina_id),
    FOREIGN KEY (fk_prescripcion_id)
        REFERENCES prescripciones(prescripcion_id),
    FOREIGN KEY (fk_medicina_id)
        REFERENCES medicinas(medicina_id)
);

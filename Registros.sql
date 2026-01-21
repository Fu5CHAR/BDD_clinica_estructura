USE Proyecto2025B_2b;

-- =========================================
-- ESPECIALIDADES
-- =========================================
##INSERT INTO especialidades (nombre) VALUES
##('Medicina General'),
##('Pediatría'),
##('Cardiología'),
##('Dermatología'),
##('Neurología');

-- =========================================
-- DOCTORES (35)
-- =========================================
SELECT * FROM doctores;
SELECT * FROM pacientes;

SELECT * from medicinas;

INSERT INTO doctores (nombres, apellidos, fk_especialidad_id) VALUES
('Juan Carlos', 'Pérez Gómez', 1),
('María Elena', 'Rodríguez López', 2),
('Luis Alberto', 'García Mendoza', 3),
('Ana Sofía', 'Martínez Ruiz', 4),
('Carlos Andrés', 'Vega Torres', 5),
('José Miguel', 'Ramos Castillo', 1),
('Lucía Fernanda', 'Ortiz Paredes', 2),
('Pedro Ignacio', 'Salazar Núñez', 3),
('Valentina Isabel', 'Morales Cedeño', 4),
('Andrés Felipe', 'León Cabrera', 5),
('Diego Armando', 'Suárez Molina', 1),
('Paola Andrea', 'Benítez Vera', 2),
('Ricardo Daniel', 'Cruz Aguilar', 3),
('Natalia Beatriz', 'Peña Franco', 4),
('Fernando Javier', 'Campos Ríos', 5),
('Mónica Patricia', 'Delgado Paz', 1),
('Sergio Alejandro', 'Luna Herrera', 2),
('Gabriela Noemí', 'Mejía Soto', 3),
('Hugo Esteban', 'Pinto Alvarado', 4),
('Carolina Andrea', 'Zambrano Ruiz', 5),
('Oscar Manuel', 'Reyes Silva', 1),
('Daniela Verónica', 'Navarro Díaz', 2),
('Marco Antonio', 'Cedeño Flores', 3),
('Silvia Lorena', 'Quintero Mora', 4),
('Jorge Luis', 'Espinoza Vélez', 5),
('Adriana Paulina', 'Mendoza Bravo', 1),
('Iván Mauricio', 'Rojas Cárdenas', 2),
('Rosa Emilia', 'Santana Pino', 3),
('Felipe Andrés', 'Guerrero Solís', 4),
('Verónica Alejandra', 'Sánchez Torres', 5),
('Cristian David', 'Palacios Loor', 1),
('Diana Carolina', 'Figueroa Lema', 2),
('Wilson Eduardo', 'Cabrera Jara', 3),
('Patricia Isabel', 'Maldonado Reyes', 4),
('Alberto Nicolás', 'Ponce Castro', 5);

-- =========================================
-- PACIENTES (35)
-- =========================================
INSERT INTO pacientes (nombres, apellidos, fecha_nacimiento, telefono) VALUES
('Juan Sebastián', 'López Andrade', '1995-04-12', '0991111111'),
('María José', 'Cruz Mendoza', '1988-07-22', '0992222222'),
('Carlos Eduardo', 'Ramírez Silva', '1979-01-15', '0993333333'),
('Ana Lucía', 'Torres Vélez', '2001-09-30', '0994444444'),
('Pedro Pablo', 'Molina Ortiz', '1990-11-05', '0995555555'),
('Daniel Alejandro', 'Suárez Romero', '1985-06-18', '0996666666'),
('Laura Beatriz', 'Gómez Castillo', '1998-02-10', '0997777777'),
('Jorge Iván', 'Ríos Delgado', '1975-12-01', '0998888888'),
('Paola Andrea', 'Santos Bravo', '2000-08-14', '0999999999'),
('Luis Fernando', 'Paredes Luna', '1993-03-27', '0981111111'),
('Valeria Camila', 'Moreno Díaz', '1996-05-19', '0982222222'),
('Andrés Mateo', 'Salinas Cobo', '1982-10-09', '0983333333'),
('Sofía Alexandra', 'Vargas Pino', '1999-01-03', '0984444444'),
('Miguel Ángel', 'Cedeño Reyes', '1978-07-07', '0985555555'),
('Carolina Belén', 'Mora Núñez', '1991-09-21', '0986666666'),
('Diego Sebastián', 'Aguilar Vera', '1987-12-11', '0987777777'),
('Natalia Fernanda', 'Ramos Hidalgo', '1994-04-08', '0988888888'),
('José Antonio', 'Peña Solórzano', '1980-06-30', '0989999999'),
('Andrea Michelle', 'Guillén León', '1997-02-14', '0971111111'),
('Cristian Javier', 'Bravo Loor', '1989-11-28', '0972222222'),
('Paúl Esteban', 'Santillán Mora', '1992-01-16', '0973333333'),
('Diana Carolina', 'Zapata Rivas', '1995-07-04', '0974444444'),
('Kevin Mauricio', 'Luna Jaramillo', '2002-05-25', '0975555555'),
('Rosa María', 'Espinoza Calle', '1976-03-13', '0976666666'),
('Felipe Andrés', 'Chávez Pinto', '1984-09-02', '0977777777'),
('Mónica Alejandra', 'Paz Molina', '1990-10-17', '0978888888'),
('Oscar David', 'Nieto Arias', '1986-12-23', '0979999999'),
('Lucía Andrea', 'Ponce Herrera', '1998-08-08', '0961111111'),
('Ángel Roberto', 'Flores Tapia', '1974-01-29', '0962222222'),
('Verónica Isabel', 'Cárdenas Solís', '1993-06-12', '0963333333'),
('Santiago Martín', 'Almeida Rojas', '2001-04-20', '0964444444'),
('Patricia Lorena', 'Lema Correa', '1988-11-03', '0965555555'),
('Jonathan Isaac', 'Villamar Pico', '1996-02-27', '0966666666'),
('Silvana Noemí', 'Ortega Farfán', '1999-09-15', '0967777777'),
('René Mauricio', 'Burgos Arias', '1981-07-01', '0968888888');

-- =========================================
-- TABLAS DE DOMINIO (MEDICINAS)
-- =========================================
INSERT INTO usos_terapeuticos (nombre) VALUES
('Analgésico'),
('Antibiótico'),
('Antiinflamatorio'),
('Antihipertensivo');

INSERT INTO formas_medicina (nombre) VALUES
('Tableta'),
('Jarabe'),
('Cápsula');

INSERT INTO vias_uso (nombre) VALUES
('Oral'),
('Intravenosa');

INSERT INTO tipos_comercializacion (nombre) VALUES
('Genérico'),
('Marca');

INSERT INTO tipos_composicion (nombre) VALUES
('Química'),
('Biológica');

INSERT INTO marcas (nombre) VALUES
('Genfar'),
('Bayer'),
('Pfizer'),
('MK');

-- =========================================
-- MEDICINAS (35)
-- =========================================
INSERT INTO medicinas
(nombre, fk_uso_terapeutico_id, fk_forma_medicina_id, fk_via_uso_id,
 fk_tipos_comercializacion_id, fk_tipos_composicion_id, fk_marca_id)
VALUES
('Paracetamol 500mg', 1, 1, 1, 1, 1, 1),
('Ibuprofeno 400mg', 3, 1, 1, 1, 1, 2),
('Amoxicilina 500mg', 2, 3, 1, 1, 1, 3),
('Losartán 50mg', 4, 1, 1, 2, 1, 4),
('Azitromicina 500mg', 2, 1, 1, 2, 1, 3),
('Diclofenaco 50mg', 3, 1, 1, 1, 1, 2),
('Metformina 850mg', 4, 1, 1, 1, 1, 1),
('Omeprazol 20mg', 1, 3, 1, 1, 1, 4),
('Cetirizina 10mg', 1, 1, 1, 1, 1, 2),
('Enalapril 10mg', 4, 1, 1, 1, 1, 3),
('Clorfenamina', 1, 2, 1, 1, 1, 4),
('Naproxeno 500mg', 3, 1, 1, 2, 1, 2),
('Ciprofloxacino 500mg', 2, 1, 1, 1, 1, 3),
('Aspirina 100mg', 1, 1, 1, 2, 1, 2),
('Prednisona 5mg', 3, 1, 1, 1, 1, 4),
('Ketorolaco', 3, 1, 2, 2, 1, 1),
('Furosemida 40mg', 4, 1, 1, 1, 1, 3),
('Salbutamol Jarabe', 1, 2, 1, 2, 1, 2),
('Ranitidina 150mg', 1, 1, 1, 1, 1, 4),
('Clindamicina', 2, 3, 1, 2, 1, 3),
('Meloxicam', 3, 1, 1, 1, 1, 1),
('Amlodipino', 4, 1, 1, 2, 1, 2),
('Lorazepam', 1, 3, 1, 1, 1, 3),
('Levofloxacino', 2, 1, 1, 2, 1, 4),
('Acetaminofén Jarabe', 1, 2, 1, 1, 1, 1),
('Hidroclorotiazida', 4, 1, 1, 1, 1, 2),
('Tramadol', 1, 3, 1, 2, 1, 3),
('Cefalexina', 2, 3, 1, 1, 1, 4),
('Betametasona', 3, 1, 1, 2, 1, 1),
('Nimesulida', 3, 1, 1, 1, 1, 2),
('Clopidogrel', 4, 1, 1, 2, 1, 3),
('Insulina', 4, 3, 2, 2, 2, 3),
('Warfarina', 4, 1, 1, 1, 1, 4),
('Dexametasona', 3, 1, 2, 2, 1, 1),
('Atorvastatina', 4, 1, 1, 1, 1, 2);

-- =========================================
-- CITAS (50)
-- =========================================
SELECT MIN(doctor_id), MAX(doctor_id) FROM doctores;

SELECT * FROM citas;
INSERT INTO citas (fecha_hora, diagnostico, fk_paciente_id, fk_doctor_id) VALUES
('2026-01-05 09:00:00','Dolor de cabeza',1,1),
('2026-01-05 09:30:00','Infección respiratoria',2,2),
('2026-01-06 10:00:00','Hipertensión',3,3),
('2026-01-06 10:30:00','Dermatitis',4,4),
('2026-01-07 11:00:00','Migraña',5,5),
('2026-01-07 11:30:00','Fiebre',6,1),
('2026-01-08 09:00:00','Otitis',7,2),
('2026-01-08 09:30:00','Arritmia',8,3),
('2026-01-09 10:00:00','Acné severo',9,4),
('2026-01-09 10:30:00','Epilepsia',10,5),
('2026-01-10 11:00:00','Gripe',11,1),
('2026-01-10 11:30:00','Control pediátrico',12,2),
('2026-01-11 09:00:00','Dolor torácico',13,3),
('2026-01-11 09:30:00','Alergia',14,4),
('2026-01-12 10:00:00','Ansiedad',15,5),
('2026-01-12 10:30:00','Infección urinaria',16,1),
('2026-01-13 11:00:00','Bronquitis',17,2),
('2026-01-13 11:30:00','Hipertensión crónica',18,3),
('2026-01-14 09:00:00','Psoriasis',19,4),
('2026-01-14 09:30:00','Insomnio',20,5),
('2026-01-15 10:00:00','Dolor muscular',21,1),
('2026-01-15 10:30:00','Faringitis',22,2),
('2026-01-16 11:00:00','Cardiopatía',23,3),
('2026-01-16 11:30:00','Eccema',24,4),
('2026-01-17 09:00:00','Convulsiones',25,5),
('2026-01-17 09:30:00','Resfriado',26,1),
('2026-01-18 10:00:00','Control infantil',27,2),
('2026-01-18 10:30:00','Taquicardia',28,3),
('2026-01-19 11:00:00','Urticaria',29,4),
('2026-01-19 11:30:00','Cefalea',30,5),
('2026-01-20 09:00:00','Dolor lumbar',31,1),
('2026-01-20 09:30:00','Infección viral',32,2),
('2026-01-21 10:00:00','Insuficiencia cardíaca',33,3),
('2026-01-21 10:30:00','Rosácea',34,4),
('2026-01-22 11:00:00','Trastorno sueño',35,5),
('2026-01-22 11:30:00','Fiebre alta',1,1),
('2026-01-23 09:00:00','Control general',2,1),
('2026-01-23 09:30:00','Bronquiolitis',3,2),
('2026-01-24 10:00:00','Angina',4,3),
('2026-01-24 10:30:00','Dermatitis atópica',5,4),
('2026-01-25 11:00:00','Neuralgia',6,5),
('2026-01-25 11:30:00','Dolor articular',7,1),
('2026-01-26 09:00:00','Tos persistente',8,2),
('2026-01-26 09:30:00','Arritmia leve',9,3),
('2026-01-27 10:00:00','Acné juvenil',10,4),
('2026-01-27 10:30:00','Estrés',11,5),
('2026-01-28 11:00:00','Malestar general',12,1);

UPDATE citas c
SET c.estado = 'ATENDIDA'
WHERE EXISTS (
    SELECT 1
    FROM prescripciones p
    WHERE p.fk_cita_id = c.cita_id
);

-- =========================================
-- PRESCRIPCIONES (50)
-- =========================================
INSERT INTO prescripciones (fecha, fk_cita_id)
SELECT DATE(fecha_hora), cita_id
FROM citas;

-- =========================================
-- PRESCRIPCIONES_MEDICINAS
-- (2 medicinas por prescripción)
-- =========================================
INSERT INTO prescripciones_medicinas (fk_prescripcion_id, fk_medicina_id, dosis) VALUES
(1,1,'1 tableta cada 8 horas'),
(1,8,'1 cápsula diaria'),
(2,3,'1 cápsula cada 8 horas'),
(2,9,'1 tableta diaria'),
(3,4,'1 tableta diaria'),
(3,10,'1 tableta diaria'),
(4,6,'1 tableta cada 12 horas'),
(4,15,'1 tableta diaria'),
(5,14,'1 tableta diaria'),
(5,23,'1 cápsula nocturna');

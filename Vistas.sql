USE Proyecto2025B_2b;

CREATE VIEW vw_pacientes_detalle AS
SELECT
    p.paciente_id,
    p.nombres,
    p.apellidos,
    fn_calcular_edad(p.paciente_id) AS edad,
    p.telefono
FROM pacientes p;

CREATE VIEW vw_agenda_citas AS
SELECT
    c.cita_id,
    c.fecha_hora,
    CONCAT(p.nombres, ' ', p.apellidos) AS paciente,
    CONCAT(d.nombres, ' ', d.apellidos) AS doctor,
    e.nombre AS especialidad,
    c.diagnostico
FROM citas c
JOIN pacientes p ON c.fk_paciente_id = p.paciente_id
JOIN doctores d ON c.fk_doctor_id = d.doctor_id
JOIN especialidades e ON d.fk_especialidad_id = e.especialidad_id;

CREATE VIEW vw_resumen_citas_doctor AS
SELECT
    d.doctor_id,
    CONCAT(d.nombres, ' ', d.apellidos) AS doctor,
    e.nombre AS especialidad,
    COUNT(c.cita_id) AS total_citas
FROM doctores d
LEFT JOIN citas c ON d.doctor_id = c.fk_doctor_id
JOIN especialidades e ON d.fk_especialidad_id = e.especialidad_id
GROUP BY
    d.doctor_id,
    d.nombres,
    d.apellidos,
    e.nombre;

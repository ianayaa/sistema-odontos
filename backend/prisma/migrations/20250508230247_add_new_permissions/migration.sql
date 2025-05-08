-- Insertar nuevos permisos
INSERT INTO "Permission" ("id", "name", "description", "createdAt", "updatedAt")
VALUES 
    ('inicio', 'inicio', 'Acceso a la página de inicio', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('pacientes', 'pacientes', 'Gestión de pacientes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('citas', 'citas', 'Gestión de citas', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('pagos', 'pagos', 'Gestión de pagos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('consentimientos', 'consentimientos', 'Gestión de consentimientos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('servicios', 'servicios', 'Gestión de servicios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('reportes', 'reportes', 'Acceso a reportes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('comunicacion', 'comunicacion', 'Gestión de comunicación', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('portal_paciente', 'portal_paciente', 'Acceso al portal de pacientes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('pagos_odontologos', 'pagos_odontologos', 'Gestión de pagos a odontólogos', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('configuracion', 'configuracion', 'Acceso a la configuración', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT ("id") DO NOTHING; 
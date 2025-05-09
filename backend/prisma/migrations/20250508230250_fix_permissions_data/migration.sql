-- Insertar permisos solo si no existen
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

-- Asignar permisos por defecto a usuarios existentes que no tienen permisos
DO $$
DECLARE
    user_record RECORD;
    permission_id TEXT;
BEGIN
    -- Para usuarios ADMIN que no tienen permisos
    FOR user_record IN 
        SELECT u.id 
        FROM "User" u 
        LEFT JOIN "UserPermission" up ON u.id = up.userId 
        WHERE u.role = 'ADMIN' AND up.id IS NULL
    LOOP
        FOR permission_id IN 
            SELECT unnest(ARRAY['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'comunicacion', 'portal_paciente', 'pagos_odontologos', 'configuracion'])
        LOOP
            INSERT INTO "UserPermission" ("id", "userId", "permissionId", "createdAt", "updatedAt")
            VALUES (gen_random_uuid()::text, user_record.id, permission_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            ON CONFLICT ("userId", "permissionId") DO NOTHING;
        END LOOP;
    END LOOP;

    -- Para usuarios DENTIST que no tienen permisos
    FOR user_record IN 
        SELECT u.id 
        FROM "User" u 
        LEFT JOIN "UserPermission" up ON u.id = up.userId 
        WHERE u.role = 'DENTIST' AND up.id IS NULL
    LOOP
        FOR permission_id IN 
            SELECT unnest(ARRAY['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'reportes', 'comunicacion', 'portal_paciente'])
        LOOP
            INSERT INTO "UserPermission" ("id", "userId", "permissionId", "createdAt", "updatedAt")
            VALUES (gen_random_uuid()::text, user_record.id, permission_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            ON CONFLICT ("userId", "permissionId") DO NOTHING;
        END LOOP;
    END LOOP;

    -- Para usuarios ASSISTANT que no tienen permisos
    FOR user_record IN 
        SELECT u.id 
        FROM "User" u 
        LEFT JOIN "UserPermission" up ON u.id = up.userId 
        WHERE u.role = 'ASSISTANT' AND up.id IS NULL
    LOOP
        FOR permission_id IN 
            SELECT unnest(ARRAY['inicio', 'pacientes', 'citas', 'pagos', 'consentimientos', 'servicios', 'comunicacion'])
        LOOP
            INSERT INTO "UserPermission" ("id", "userId", "permissionId", "createdAt", "updatedAt")
            VALUES (gen_random_uuid()::text, user_record.id, permission_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            ON CONFLICT ("userId", "permissionId") DO NOTHING;
        END LOOP;
    END LOOP;

    -- Para usuarios PATIENT que no tienen permisos
    FOR user_record IN 
        SELECT u.id 
        FROM "User" u 
        LEFT JOIN "UserPermission" up ON u.id = up.userId 
        WHERE u.role = 'PATIENT' AND up.id IS NULL
    LOOP
        FOR permission_id IN 
            SELECT unnest(ARRAY['inicio', 'portal_paciente'])
        LOOP
            INSERT INTO "UserPermission" ("id", "userId", "permissionId", "createdAt", "updatedAt")
            VALUES (gen_random_uuid()::text, user_record.id, permission_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            ON CONFLICT ("userId", "permissionId") DO NOTHING;
        END LOOP;
    END LOOP;
END $$; 
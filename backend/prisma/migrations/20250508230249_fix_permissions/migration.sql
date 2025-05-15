-- Verificar si las tablas existen y eliminarlas si es necesario
DO $$
BEGIN
    -- Eliminar las restricciones primero si existen
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'UserPermission_userId_fkey') THEN
        ALTER TABLE "UserPermission" DROP CONSTRAINT "UserPermission_userId_fkey";
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'UserPermission_permissionId_fkey') THEN
        ALTER TABLE "UserPermission" DROP CONSTRAINT "UserPermission_permissionId_fkey";
    END IF;

    -- Eliminar los índices si existen
    IF EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'UserPermission_userId_permissionId_key') THEN
        DROP INDEX IF EXISTS "UserPermission_userId_permissionId_key";
    END IF;
END $$;

-- Crear las tablas si no existen
CREATE TABLE IF NOT EXISTS "Permission" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "UserPermission" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permissionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "UserPermission_pkey" PRIMARY KEY ("id")
);

-- Crear índices si no existen
CREATE UNIQUE INDEX IF NOT EXISTS "Permission_name_key" ON "Permission"("name");
CREATE UNIQUE INDEX IF NOT EXISTS "UserPermission_userId_permissionId_key" ON "UserPermission"("userId", "permissionId");

-- Agregar restricciones de clave foránea si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'UserPermission_userId_fkey') THEN
        ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_userId_fkey" 
            FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'UserPermission_permissionId_fkey') THEN
        ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_permissionId_fkey" 
            FOREIGN KEY ("permissionId") REFERENCES "Permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;

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

-- Asignar permisos por defecto a usuarios existentes solo si no tienen permisos
DO $$
DECLARE
    user_record RECORD;
    permission_id TEXT;
BEGIN
    -- Para usuarios ADMIN que no tienen permisos
    FOR user_record IN 
        SELECT u.id 
        FROM "User" u 
        LEFT JOIN "UserPermission" up ON u.id = up."userId" 
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
        LEFT JOIN "UserPermission" up ON u.id = up."userId" 
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
        LEFT JOIN "UserPermission" up ON u.id = up."userId" 
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
        LEFT JOIN "UserPermission" up ON u.id = up."userId" 
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
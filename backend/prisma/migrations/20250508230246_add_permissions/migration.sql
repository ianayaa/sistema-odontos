-- CreateTable
CREATE TABLE IF NOT EXISTS "Permission" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "UserPermission" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permissionId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserPermission_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "Permission_name_key" ON "Permission"("name");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "UserPermission_userId_permissionId_key" ON "UserPermission"("userId", "permissionId");

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermission" ADD CONSTRAINT "UserPermission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "Permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

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

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function addPermissions() {
    const permissions = [
        {
            id: 'inicio',
            name: 'inicio',
            description: 'Acceso a la página de inicio'
        },
        {
            id: 'pacientes',
            name: 'pacientes',
            description: 'Gestión de pacientes'
        },
        {
            id: 'citas',
            name: 'citas',
            description: 'Gestión de citas'
        },
        {
            id: 'pagos',
            name: 'pagos',
            description: 'Gestión de pagos'
        },
        {
            id: 'consentimientos',
            name: 'consentimientos',
            description: 'Gestión de consentimientos'
        },
        {
            id: 'servicios',
            name: 'servicios',
            description: 'Gestión de servicios'
        },
        {
            id: 'reportes',
            name: 'reportes',
            description: 'Acceso a reportes'
        },
        {
            id: 'comunicacion',
            name: 'comunicacion',
            description: 'Gestión de comunicación'
        },
        {
            id: 'portal_paciente',
            name: 'portal_paciente',
            description: 'Acceso al portal de pacientes'
        },
        {
            id: 'pagos_odontologos',
            name: 'pagos_odontologos',
            description: 'Gestión de pagos a odontólogos'
        },
        {
            id: 'configuracion',
            name: 'configuracion',
            description: 'Acceso a la configuración'
        }
    ];
    for (const permission of permissions) {
        try {
            await prisma.permission.upsert({
                where: { id: permission.id },
                update: {},
                create: permission
            });
            console.log(`Permiso ${permission.name} agregado/actualizado`);
        }
        catch (error) {
            console.error(`Error al agregar permiso ${permission.name}:`, error);
        }
    }
    // Asignar todos los permisos al admin
    const admin = await prisma.user.findFirst({
        where: { role: 'ADMIN' }
    });
    if (admin) {
        const allPermissions = await prisma.permission.findMany();
        for (const permission of allPermissions) {
            try {
                await prisma.userPermission.upsert({
                    where: {
                        userId_permissionId: {
                            userId: admin.id,
                            permissionId: permission.id
                        }
                    },
                    update: {},
                    create: {
                        userId: admin.id,
                        permissionId: permission.id
                    }
                });
                console.log(`Permiso ${permission.name} asignado al admin`);
            }
            catch (error) {
                console.error(`Error al asignar permiso ${permission.name} al admin:`, error);
            }
        }
    }
    await prisma.$disconnect();
}
addPermissions()
    .catch(console.error)
    .finally(() => process.exit(0));

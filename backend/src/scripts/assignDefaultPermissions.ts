import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Definir permisos por rol
const rolePermissions = {
  ADMIN: [
    'inicio',
    'pacientes',
    'citas',
    'pagos',
    'consentimientos',
    'servicios',
    'reportes',
    'comunicacion',
    'portal_paciente',
    'pagos_odontologos',
    'configuracion'
  ],
  DENTIST: [
    'inicio',
    'pacientes',
    'citas',
    'pagos',
    'consentimientos',
    'servicios',
    'reportes',
    'comunicacion',
    'portal_paciente'
  ],
  ASSISTANT: [
    'inicio',
    'pacientes',
    'citas',
    'pagos',
    'consentimientos',
    'servicios',
    'comunicacion'
  ],
  PATIENT: [
    'inicio',
    'portal_paciente'
  ]
};

async function assignDefaultPermissions() {
  try {
    // Obtener todos los usuarios
    const users = await prisma.user.findMany();

    for (const user of users) {
      // Obtener los permisos correspondientes al rol
      const permissionsForRole = rolePermissions[user.role as keyof typeof rolePermissions] || [];

      // Eliminar permisos existentes
      await prisma.userPermission.deleteMany({
        where: { userId: user.id }
      });

      // Asignar nuevos permisos
      for (const permissionId of permissionsForRole) {
        await prisma.userPermission.create({
          data: {
            userId: user.id,
            permissionId
          }
        });
        console.log(`Permiso ${permissionId} asignado al usuario ${user.email}`);
      }

      console.log(`Permisos asignados correctamente al usuario ${user.email}`);
    }

    console.log('Proceso completado: todos los usuarios tienen sus permisos por defecto');
  } catch (error) {
    console.error('Error al asignar permisos:', error);
  } finally {
    await prisma.$disconnect();
  }
}

assignDefaultPermissions(); 
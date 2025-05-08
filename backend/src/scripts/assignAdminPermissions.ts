import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function assignAdminPermissions() {
  try {
    // Obtener todos los permisos
    const permissions = await prisma.permission.findMany();
    
    // Obtener el usuario administrador
    const admin = await prisma.user.findFirst({
      where: { role: 'ADMIN' }
    });

    if (!admin) {
      console.error('No se encontró el usuario administrador');
      return;
    }

    // Asignar todos los permisos al admin
    for (const permission of permissions) {
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

    console.log('Permisos asignados correctamente al administrador');
  } catch (error) {
    console.error('Error al asignar permisos:', error);
  } finally {
    await prisma.$disconnect();
  }
}

assignAdminPermissions(); 
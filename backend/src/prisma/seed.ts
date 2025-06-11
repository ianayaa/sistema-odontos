import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // Crear permisos básicos
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
    await prisma.permission.upsert({
      where: { id: permission.id },
      update: {},
      create: permission
    });
  }

  // Crear usuario admin por defecto
  const adminPassword = await bcrypt.hash('Admin123!', 10);
  const admin = await prisma.user.upsert({
    where: { email: 'admin@odontos.com' },
    update: {},
    create: {
      email: 'admin@odontos.com',
      password: adminPassword,
      name: 'Administrador',
      role: 'ADMIN',
      isActive: true
    }
  });

  // Asignar todos los permisos al admin
  const allPermissions = await prisma.permission.findMany();
  for (const permission of allPermissions) {
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
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
